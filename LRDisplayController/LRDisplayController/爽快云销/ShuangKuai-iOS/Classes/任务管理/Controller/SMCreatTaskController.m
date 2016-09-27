//
//  SMCreatTaskController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCreatTaskController.h"
#import "SMTaskTitleCell.h"
#import "SMTaskContentCell.h"
#import "SMParticipantCell.h"
#import "SMDeadLineCell.h"
#import "SMAddSonTaskCell.h"
#import "CuiPickerView.h"
#import "SMParticipantController.h"
#import "SMSonTaskController.h"
#import "SMFriend.h"
#import "SMFatherTask.h"
#import "SMParticipant.h"
#import "SMSonTask.h"
#import "SMSonTaskList.h"
#import "SMSonTaskListFrame.h"
#import "SMSonTaskList.h"
#import "SMPersonInfoViewController.h"

#define KBEditPen 32
@interface SMCreatTaskController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,CuiPickViewDelegate,SMAddSonTaskCellDelegate,SMParticipantControllerDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UIButton *rightBtn;/**< 右上角 */

@property (nonatomic ,strong)UITableView *tableView;/**<  */

@property (nonatomic ,strong)UITextField *inputField;/**< <#注释#> */

@property (nonatomic ,strong)UITextView *inputView;/**< <#注释#> */

@property (nonatomic ,assign)CGFloat margin; /**< 键盘误差控制margin */

@property (nonatomic, strong) CuiPickerView *cuiPickerView;

@property (nonatomic ,strong)UILabel *deadLineLabel;/**< <#注释#> */

@property (nonatomic ,strong)SMParticipantCell *participantCell;/**< 参与人那一行的cell */

@property (nonatomic ,strong)UILabel *holderLabel;/**< 输入框里的假placeHolder */

@property (nonatomic ,strong)SMFatherTask *fatherTask;/**< 父任务模型 */

@property (nonatomic ,strong)NSMutableArray *arrParticipant;/**< 父任务的参与人。第一个默认是任务创建者，可以把第一个移除，剩下的才是真正的参与者 */

@property (nonatomic ,assign)BOOL fatherChoosedParticipant; /**< 判断父任务是否去选择了参与人，如果父任务选择了参与人，在返回的时候，父任务界面的参与人显示的数据就是通过代理传过来的，而不是从服务器获取的 */

@property (nonatomic ,strong)NSArray *arrSonLists;/**< 子任务列表数据，SMSonTaskList  */

@property (nonatomic ,strong)NSArray *arrListFames;/**< frame    SMSonTaskListFrame */

@property (nonatomic ,assign)NSInteger fatherStatus; /**<  //0 未发布，1未完成，2已完成,且所有子任务默认都是未完成状态（1）. */

@property (nonatomic ,strong)UIAlertView *alert;/**< <#注释#> */
@end

@implementation SMCreatTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self setupMargin];  //键盘若太高，就让整个屏幕往上移
    
//    [self addNotifications];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotifications];
    
    if (self.fatherChoosedParticipant == YES) {  //如果父任务选择了参与人，在返回的时候，父任务界面的参与人显示的数据就是通过代理传过来的，而不是从服务器获取的。
        return;
    }
    if (self.fatherId) {
        [self refreshTableView];
    }
}

#pragma mark -- Notifications

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSonTask:) name:KGotoSonTaskVc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"finishDeleteRefreshTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cannotUpdateSonTask1) name:@"cannotUpdateSonTask1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cannotUpdateSonTask2) name:@"cannotUpdateSonTask2" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cannotDeleteSonTask1) name:@"cannotDeleteSonTask1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cannotDeleteSonTask2) name:@"cannotDeleteSonTask1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sonTaskParticipantIconClick:) name:KSonTaskParticipantIconClick object:nil];
}

- (void)sonTaskParticipantIconClick:(NSNotification *)noti{
    SMParticipant *p = noti.userInfo[KSonTaskParticipantIconClickKey];
    [[SKAPI shared] queryUserProfile:p.userid block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  %@",result);
            SMPersonInfoViewController *vc = [SMPersonInfoViewController new];
            vc.user = (User *)result;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)cannotDeleteSonTask1{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)cannotDeleteSonTask2{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)cannotUpdateSonTask1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法编辑" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (void)cannotUpdateSonTask2{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法编辑" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)refreshTableView{
    [[SKAPI shared] queryMission:self.fatherId block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  queryMission  %@ ",result);
            
            self.fatherTask = [SMFatherTask mj_objectWithKeyValues:[result objectForKey:@"schedule"]];
            self.fatherStatus = self.fatherTask.status;
            self.arrParticipant = [SMParticipant mj_objectArrayWithKeyValuesArray:[result objectForKey:@"usersList"]];
            [self.arrParticipant removeObjectAtIndex:0];
            SMLog(@"self.arrParticipant.count   %zd",self.arrParticipant.count);
            
            //                for (SMParticipant *p in self.arrParticipant) {
            //                    if ([p.id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
            //                        [self.arrParticipant removeObject:p];
            //                    }
            //                }
            
            self.arrSonLists = [SMSonTaskList mj_objectArrayWithKeyValuesArray:[result objectForKey:@"childScheduleList"]];
            self.arrListFames = [self getFrameModelFromeModel:self.arrSonLists];
            
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error  queryMission  %@",error);
        }
    }];
    
}

- (void)gotoSonTask:(NSNotification *)noti{
    
//    SMSonTask *sonTask = noti.userInfo[KGotoSonTaskVcKey];
    SMSonTaskList *list = noti.userInfo[KGotoSonTaskVcKey];
    
    SMLog(@"sonTask gotoSonTask  %@ ",list);
    SMSonTaskController *vc = [SMSonTaskController new];
//    vc.sonTask = sonTask;
    vc.list = list;
    vc.fatherId = self.fatherId;
    vc.isBeingUpdating = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)getFrameModelFromeModel:(NSArray *)arrModel{
    
    NSMutableArray *frames = [NSMutableArray array];
    for (SMSonTaskList *list in arrModel) {
        SMSonTaskListFrame *listF = [[SMSonTaskListFrame alloc] init];
        listF.list = list;
        [frames addObject:listF];
    }
    return (NSArray *)frames;
}


//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [objDateformat stringFromDate: date];
}

- (void)setupMargin{
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = [textField convertRect:textField.bounds toView:self.view];
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset + 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = [textView convertRect:textView.bounds toView:self.view];
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset + 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.holderLabel.text = @" 请输入任务内容";
    }else{
        self.holderLabel.text = @"";
    }
}


#pragma mark -- tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        SMTaskTitleCell *cell = [SMTaskTitleCell cellWithTableView:tableView];
        cell.inputField.delegate = self;
        self.inputField = cell.inputField;
        if (self.fatherTask) {
            cell.fatherTask = self.fatherTask;
        }
        return cell;
    }else if (indexPath.row == 1){
        SMTaskContentCell *cell = [SMTaskContentCell cellWithTableView:tableView];
        cell.inputView.delegate = self;
        self.inputView = cell.inputView;
        self.holderLabel = cell.holderLabel;
        if (self.fatherTask) {
            cell.fatherTask = self.fatherTask;
        }
        return cell;
    }else if (indexPath.row == 2){
        SMParticipantCell *cell = [SMParticipantCell cellWithTableView:tableView];
        self.participantCell = cell;
        
        if (self.arrParticipant.count > 0) {
            cell.arrParticipant = self.arrParticipant;
        }else{
            [cell haveNoParticipant];
        }
        return cell;
    }else if (indexPath.row == 3){
        SMDeadLineCell *cell = [SMDeadLineCell cellWithTableView:tableView];
        self.deadLineLabel = cell.rightLabel;
        if (self.fatherTask) {
            cell.fatherTask = self.fatherTask;
        }
        return cell;
    }else if (indexPath.row == 4){
        SMAddSonTaskCell *cell = [SMAddSonTaskCell cellWithTableView:tableView];
        cell.fatherStatus = self.fatherStatus;
        if (self.arrSonLists.count > 0) {
            cell.arrSonLists = self.arrSonLists;
        }
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"didSelectRowAtIndexPath   %zd ",indexPath.row);
    
    if (indexPath.row == 2) {
        SMParticipantController *vc = [SMParticipantController new];
        vc.delegate = self;
        self.fatherChoosedParticipant = YES;
//        vc.arrHaveChoosed = self.participantCell.arrIconStrs;
        
        if (self.participantCell.arrIconStrs.count > 0) {
            vc.arrHaveChoosed = self.participantCell.arrIconStrs;
        }else{
            SMLog(@"self.arrParticipant.count   %zd",self.arrParticipant.count);
            vc.arrHaveChoosedPushedByFather = self.arrParticipant;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        if (self.cuiPickerView) {
            return;
        }
        [self setupChooseTimeMenu];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 45 *SMMatchHeight;
    }else if (indexPath.row == 1){
        return 207 *SMMatchHeight;
    }else if (indexPath.row == 2){
        return 45 *SMMatchHeight;
    }else if (indexPath.row == 3){
        return 45 *SMMatchHeight;
    }else if (indexPath.row == 4){
//        return 5 + 30 *SMMatchHeight + 80 *SMMatchHeight;
        
        CGFloat tableViewHeight = 0;
        for (SMSonTaskListFrame *frame in self.arrListFames) {
    
            tableViewHeight += frame.cellHeight;
        }
        
        return 5 + 30 *SMMatchHeight + tableViewHeight;
    }
    
    return 0;
}


#pragma mark -- SMParticipantControllerDelegate
- (void)haveSelectedPerson:(NSArray *)array{
    
    if (self.fatherChoosedParticipant == YES) {   //如果父任务选择了参与人，在返回的时候，父任务界面的参与人显示的数据就是通过代理传过来的，而不是从服务器获取的
        self.participantCell.arrIconStrs = array;
        for (NSString *str in array) {
            SMLog(@"str   haveSelectedPerson   %@ ",str);
        }
        
        self.fatherChoosedParticipant = NO;
    }
    
}

#pragma mark -- SMAddSonTaskCellDelegate
- (void)addSonTaskAction{
    SMLog(@"点击了 添加子任务");
#pragma mark -- 这边的逻辑是： 在添加子任务的时候，先创建父任务。然后在写子任务的时候，把父任务的id 传过去。
//    SMSonTaskController *vc = [SMSonTaskController new];
//    [self.navigationController pushViewController:vc animated:YES];
    
    // 8ad1048143a3449b9e2407b059ccc91d
    //时间
//    NSNumber *time
//    if (self.deadLineLabel.) {
//        <#statements#>
//    }
    
    
    if (!self.fatherId) {  //如果fatherId为空，证明还没有创建父任务，这时，先创建父任务，再去下个界面创建小任务
        SMLog(@"还没有父任务，需要先创建一个父任务");
        NSNumber *timeNum;
        if ([self.deadLineLabel.text isEqualToString:@"请选择任务截止时间"]) {
            timeNum = @0;
        }else{
            timeNum = [NSNumber numberWithFloat:[self getTimeStampFromeTimeStr:self.deadLineLabel.text]];
        }
        
        NSMutableArray *arrUserIds = [NSMutableArray array];
        if (self.participantCell.arrIconStrs.count > 0) {  //如果有选择的参与人，就将选择的参与人id 装到一个数组传过去
            for (SMFriend *f in self.participantCell.arrIconStrs) {
                [arrUserIds addObject:f.user.id];
            }
        }else{
            // 如果没有选择参与人,直接传一个空数组过去
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = self.inputField.text;
        dict[@"remark"] = self.inputView.text;
        dict[@"schTime"] = timeNum;
        dict[@"users"] = arrUserIds;
        [[SKAPI shared] addMission:dict block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  addMission  %@",result);//返回结果就是一个父任务的id
                self.fatherId = [result objectForKey:@"result"]; //请求成功后，将返回的 fatherId 赋值给自己属性里的fatherId
                SMSonTaskController *vc = [SMSonTaskController new];
                vc.fatherId = self.fatherId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                SMLog(@"error   %@",error);
            }
        }];
    }else{  //如果 fatherId 不为空，证明已有父任务，直接去创建子任务
        SMLog(@"已存在父任务  直接进入下个界面创建子任务");
        SMSonTaskController *vc = [SMSonTaskController new];
        vc.fatherId = self.fatherId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//时间str转时间戳
- (NSInteger)getTimeStampFromeTimeStr:(NSString *)timeStr{
    //设置时间显示格式:
//    NSString* timeStr = @"2011-01-26 17:40:50";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSInteger timeStamp = (long)[date timeIntervalSince1970];
    SMLog(@"timeSp:%zd",timeStamp); //时间戳的值
    return timeStamp;
}

- (void)setupChooseTimeMenu{
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    
    [_cuiPickerView showInView:self.view];
}

//赋值给textField
-(void)didFinishPickView:(NSString *)date{
    SMLog(@"date  didFinishPickView  %@",date);
    if (date != nil && ![date isEqualToString:@""]) {
        self.deadLineLabel.text = date;
    }
    self.cuiPickerView = nil;
}

- (void)setupTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

- (void)setupNav{
    
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"编辑任务";
    
    self.rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [self.rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn.width = 30;
//    self.rightBtn.height = 22;
    [_rightBtn sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = KControllerBackGroundColor;
}

- (void)rightItemClick{
    SMLog(@"点击了 右上角保存");
    if ([self.inputField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写标题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if ([self.inputView.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写任务内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (self.participantCell.rightLabel.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择任务参与人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if ([self.deadLineLabel.text isEqualToString:@"请选择任务截止时间"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择任务截止时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

#pragma mark --到这里才能真正的保存
    
    if (self.isBeingUpdating) {  //如果是修改任务
        self.holderLabel.text = @"";
        [self saveTask];
    }else{   //执行的是新建任务
        [self creatTask];
    }
    
}

- (void)creatTask{
    //到这里才能真正的保存
    if (self.fatherId) { //如果已经有主任务 直接保存
        [self saveFatherTask:YES];
    }else{  //如果主任务还没创建，就先创建住任务，再保存
        SMLog(@"还没有父任务，需要先创建一个父任务");
        NSNumber *timeNum;
        if ([self.deadLineLabel.text isEqualToString:@"请选择任务截止时间"]) {
            timeNum = @0;
        }else{
            timeNum = [NSNumber numberWithFloat:[self getTimeStampFromeTimeStr:self.deadLineLabel.text]];
        }
        
        NSMutableArray *arrUserIds = [NSMutableArray array];
        if (self.participantCell.arrIconStrs.count > 0) {  //如果有选择的参与人，就将选择的参与人id 装到一个数组传过去
            for (SMFriend *f in self.participantCell.arrIconStrs) {
                [arrUserIds addObject:f.user.id];
            }
        }else{
            // 如果没有选择参与人,直接传一个空数组过去
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = self.inputField.text;
        dict[@"remark"] = self.inputView.text;
        dict[@"schTime"] = timeNum;
        dict[@"users"] = arrUserIds;
        [[SKAPI shared] addMission:dict block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  addMission  %@",result);//返回结果就是一个父任务的id
                self.fatherId = [result objectForKey:@"result"]; //请求成功后，将返回的 fatherId 赋值给自己属性里的fatherId
                [self saveFatherTask:(YES)];
                
            }else{
                SMLog(@"error   %@",error);
            }
        }];
        
    }

}

- (void)saveTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = self.fatherId;
    dict[@"title"] = self.inputField.text;
    dict[@"remark"] = self.inputView.text;
    NSNumber *timeNum;
    if ([self.deadLineLabel.text isEqualToString:@"请选择任务截止时间"]) {
        timeNum = @0;
    }else{
        timeNum = [NSNumber numberWithFloat:[self getTimeStampFromeTimeStr:self.deadLineLabel.text]];
    }
    dict[@"schTime"] = timeNum;
    NSMutableArray *arrUserIds = [NSMutableArray array];
    if (self.participantCell.arrIconStrs.count > 0) {  //如果有选择的参与人，就将选择的参与人id 装到一个数组传过去
        for (SMFriend *f in self.participantCell.arrIconStrs) {
            [arrUserIds addObject:f.user.id];
        }
    }else{
        // 如果没有选择参与人,直接传一个空数组过去
    }
    
    dict[@"users"] = arrUserIds;
    dict[@"fatherId"] = self.fatherId;
    [[SKAPI shared] updateMission:dict block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result  %@",result);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];

}

//pop ： 是否需要在保存成功后返回到上一个界面
- (void)saveFatherTask:(BOOL)pop{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = self.fatherId;
    dict[@"title"] = self.inputField.text;
    dict[@"remark"] = self.inputView.text;
    dict[@"schTime"] = [NSNumber numberWithInteger:[self getTimeStampFromeTimeStr:self.deadLineLabel.text]];
    
    NSMutableArray *arrUsers = [NSMutableArray array];
    for (SMFriend *f in self.participantCell.arrIconStrs) {
        [arrUsers addObject:f.user.id];
    }
    dict[@"users"] = arrUsers;
    dict[@"fatherId"] = self.fatherId;
    
    [[SKAPI shared] updateMission:dict block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result updateMission  %@ ",result);
            if (pop) {
                
                //在这里提示框是否直接发布
                self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否发布此任务" delegate:self cancelButtonTitle:@"保存返回" otherButtonTitles:@"立即发布", nil];
                [self.alert show];
                
                
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.alert) { //直击返回，不发布
        if (buttonIndex == 0) {
            [self callDelegate];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1){  //先发布，后返回
            [self callDelegate];
            [[SKAPI shared] publishMission:self.fatherId block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"result   %@",result);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    SMLog(@"error   %@",error);
                }
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)dealloc{
//    SMLog(@"dealloc");
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cannotUpdateSonTask1" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cannotUpdateSonTask2" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cannotDeleteSonTask1" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cannotDeleteSonTask2" object:nil];
//}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KControllerBackGroundColor;
    }
    return _tableView;
}

- (NSMutableArray *)arrParticipant{
    if (_arrParticipant == nil) {
        _arrParticipant = [NSMutableArray array];
    }
    return _arrParticipant;
}

- (void)callDelegate{
    if ([self.delegate respondsToSelector:@selector(editTaskSuccess)]) {
        [self.delegate editTaskSuccess];
    }
}

@end
