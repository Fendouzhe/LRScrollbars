//
//  SMDetailScheduleViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailScheduleViewController.h"
#import "SMEditScheduleViewController.h"
#import "SMCustomerDetailTableViewCell2.h"
#import "NSString+Extension.h"
#import "SMScheduleBottomView.h"
#import <MagicalRecord/MagicalRecord.h>
#import "LocalSchedule+CoreDataProperties.h"
#import "LocalScheduleCompose+CoreDataProperties.h"
#import "SMNewScheduleViewController.h"
#import "SMScheduleDetailTableViewCell1.h"
#import "SMscheduleDetailTableViewCell2.h"
#import "SMScheduleDetailTableViewCell3.h"
#import "SMScheduleDetailTableViewCell4.h"
#import "AppDelegate.h"
#import "SMScheduleDetailTableViewCell5.h"
#import "SMMyTeamController.h"

@interface SMDetailScheduleViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SMScheduleBottomViewDelegate>
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  对勾按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/**
 *  时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
/**
 *  提醒时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *remindTimeBtn;

/**
 *  仅仅为了设置灰色背景颜色 才拉过来的属性
 */
@property (weak, nonatomic) IBOutlet UIView *grayView;


@property (weak, nonatomic) IBOutlet UIView *commentTitleView;

/**
 *  输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputFiled;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

/**
 *  用户评论占据的size大小
 */
@property (nonatomic ,assign)CGSize commentSize;

//后面还需要添加件哦安，加号，表情按钮的连线

/**
 *  已完成按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *alreadyDoneBtn;
/**
 *  发表评论
 */
@property (weak, nonatomic) IBOutlet UIButton *composeBtn;
/**
 *  蒙板
 */
@property (nonatomic ,strong)UIView *maskView;
/**
 *  弹出来的  下面的选择框
 */
@property (nonatomic ,strong)SMScheduleBottomView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewConstraint;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,copy)NSMutableArray * dataArray;


@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,strong)Schedule * schedule;

//存除了模型以外的数据
@property(nonatomic,copy)NSMutableDictionary * dataDic;

//记录到进来时候的status  如果改变了 就执行更新的代码
@property(nonatomic,assign)NSInteger initialStatus;

//评论的数组
@property(nonatomic,copy)NSMutableArray * contentArray;
@end

@implementation SMDetailScheduleViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNav];
    
    [self setupUI];
    
    [self addNotification];
    
    [self setupStatus];
    
    [self setupBtns];
    
    //[self refreshUI];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"KScheduleRefresh" object:nil];
    
}

- (void)setupBtns{

    //设置已完成按钮的不同状态颜色。 通过切换按钮的状态来现实不同的颜色
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[NSFontAttributeName] = KDefaultFontBig;
    dict1[NSForegroundColorAttributeName] = SMColor(128, 129, 130);
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict1];
    [self.alreadyDoneBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = KDefaultFontBig;
    dict2[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"已完成" attributes:dict2];
    [self.alreadyDoneBtn setAttributedTitle:str2 forState:UIControlStateSelected];
    
}

- (void)setupStatus{
    [self.composeBtn setBackgroundColor:KRedColor];
    self.composeBtn.layer.cornerRadius = SMCornerRadios;
    self.composeBtn.clipsToBounds = YES;
    self.grayView.backgroundColor = KControllerBackGroundColor;
}

- (void)addNotification{
    // 监听键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

-(void)keyboardWillChange:(NSNotification *)note{
    
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘弹出后或隐藏后的frame
    CGRect keyboardFrame =[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获得键盘的y值
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获得屏幕的高度
    CGFloat screenH =[UIScreen mainScreen].bounds.size.height;
    //
    //    SMLog(@"note = %@",note);
    // 获得键盘执行动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    /*
     [UIView animateWithDuration:duration animations:^{
     self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
     }];
     */
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
    } completion:nil];
}

- (void)setupNav{
    self.title = @"任务详情";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"gengduoRed"] forState:UIControlStateNormal];
    rightBtn.width = 30;
    rightBtn.height = 30;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)requestData{
    
    [[SKAPI shared] queryMission:self.schId block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            self.schedule = [Schedule mj_objectWithKeyValues:result[@"schedule"]];
            
            self.initialStatus = self.schedule.status;
            
            [self.dataDic setObject:result[@"usersList"] forKey:@"usersList"];
            [self.dataDic setObject:result[@"ScheduleDetailList"] forKey:@"ScheduleDetailList"];
            
            [self.contentArray removeAllObjects];
            
            for (NSDictionary * dic in result[@"ScheduleDetailList"]) {
                ScheduleDetail * schedule = [ScheduleDetail mj_objectWithKeyValues:dic];
                [self.contentArray addObject:schedule];
            }
            
            
            [self.commentTableView reloadData];
            
            SMLog(@"     sdkn   %ld",self.schedule.remindTime );
        }else{
            SMLog(@"%@",error);
        }
        
        
    }];
}
- (void)setupUI{
    
    self.view.backgroundColor = KControllerBackGroundColor;
    self.contentTextView.editable = NO;
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    //self.commentTableView.scrollEnabled = NO;
    
    [self.commentTableView registerNib:[UINib nibWithNibName:@"SMScheduleDetailTableViewCell1" bundle:nil] forCellReuseIdentifier:@"ScheludeCell1"];
    [self.commentTableView registerNib:[UINib nibWithNibName:@"SMscheduleDetailTableViewCell2" bundle:nil] forCellReuseIdentifier:@"ScheludeCell2"];
    [self.commentTableView registerNib:[UINib nibWithNibName:@"SMScheduleDetailTableViewCell3" bundle:nil] forCellReuseIdentifier:@"ScheludeCell3"];
    [self.commentTableView registerNib:[UINib nibWithNibName:@"SMScheduleDetailTableViewCell4" bundle:nil] forCellReuseIdentifier:@"ScheludeCell4"];
    [self.commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.commentTableView registerClass:[SMScheduleDetailTableViewCell5 class] forCellReuseIdentifier:@"Cell5"];
    
}


#pragma mark -- 点击事件
- (void)rightItemDidClick{
    SMLog(@"点击了右上角的 点点点 按钮");
    //生成萌版  并弹出选择框
    UIWindow * window = [[UIApplication sharedApplication].windows firstObject];
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = self.view.bounds;
    [window addSubview:maskView];
    maskView.backgroundColor = [UIColor grayColor];
    maskView.alpha = 0.4;
    self.maskView = maskView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [maskView addGestureRecognizer:tap];
    
    [self createBottomViewWithView:window];
}

- (IBAction)editBtnClick {
    SMLog(@"点击了编辑按钮");
    //跳转到编辑界面  需要判断是否为修改 还是新建
    
    SMNewScheduleViewController *newVc = [[SMNewScheduleViewController alloc] init];
    newVc.localSchedule = self.localSchedule;
    [self.navigationController pushViewController:newVc animated:YES];
}

- (void)createBottomViewWithView:(UIWindow *)window{
    self.bottomView = [SMScheduleBottomView scheduleBottomView];
    self.bottomView.delegate = self;
    [window addSubview:self.bottomView];
    CGFloat bottomViewH = 150;
    self.bottomView.frame = CGRectMake(0, KScreenHeight - bottomViewH, KScreenWidth, bottomViewH);
}

- (void)tapClick{
    SMLog(@"点击了 蒙板");
    [self.maskView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        
        [self ComposeBtnAction:self.composeBtn];
        
        [self.inputFiled resignFirstResponder];

    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //在这里可以拿出 textField.text 加入到模型数组中去，然后下面刷新tableView 重新加载数据
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 2;
    
    return self.contentArray.count+7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        SMScheduleDetailTableViewCell1 * cell0 = [tableView dequeueReusableCellWithIdentifier:@"ScheludeCell1"];
//        cell0.localSchedule = self.localSchedule;
        cell0.schedule = self.schedule;
        cell0.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell0;
    }else if(indexPath.row == 1){
        SMscheduleDetailTableViewCell2 * cell1 = [tableView dequeueReusableCellWithIdentifier:@"ScheludeCell2"];
//        cell1.localSchedule = self.localSchedule;
        NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
        if (!level2 || !self.isTeamSchedule) {
            //1级
            cell1.editBtn.hidden = NO;
        }else{
            //2级
            cell1.editBtn.hidden = YES;
        }
        cell1.schedule = self.schedule;
        cell1.editblock = ^{
            //点击编辑按钮触发的代码块
            SMNewScheduleViewController *newVc = [[SMNewScheduleViewController alloc] init];
           // newVc.localSchedule = self.localSchedule;
            newVc.schedule = self.schedule;
            //newVc.participantArray = [self.dataDic[@"usersList"] copy];
            for (NSDictionary * dic in self.dataDic[@"usersList"]) {
                User * user = [User mj_objectWithKeyValues:dic];
                [newVc.participantArray addObject:user];
            }
            
            newVc.isModify = YES;
            newVc.isTeamSchedule = self.isTeamSchedule;
            [self.navigationController pushViewController:newVc animated:YES];
        };
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }else if (indexPath.row == 2){
        SMScheduleDetailTableViewCell3 * cell2 = [tableView dequeueReusableCellWithIdentifier:@"ScheludeCell3"];
       
        //cell2.localSchedule = self.localSchedule;
        cell2.schedule = self.schedule;
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }else if (indexPath.row == 3){
        SMScheduleDetailTableViewCell4 * cell3 = [tableView dequeueReusableCellWithIdentifier:@"ScheludeCell4"];
        cell3.titleLabel.text = @"执行时间:";
        [cell3.timeBtn setTitle:[self StringWithdate:self.schedule.schTime] forState:UIControlStateNormal];
        cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell3;
    }else if(indexPath.row == 4){
        
         NSArray *  remindArray = @[@"到达截止时间时",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"2小时前",@"1天前(下午6:00)",@"2天前（下午6:00）",@"1周前（下午6:00）"];
        
        SMScheduleDetailTableViewCell4 * cell4 = [tableView dequeueReusableCellWithIdentifier:@"ScheludeCell4"];
        cell4.titleLabel.text = @"提醒:";
        //
        [cell4.timeBtn setTitle:remindArray[self.schedule.remindType] forState:UIControlStateNormal];
        cell4.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell4;
    }else if (indexPath.row==5){
        //参与人的cell
        SMScheduleDetailTableViewCell5 * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isTeamSchedule) {
          [cell refreshUI:self.dataDic];
        }
        
       // cell.textLabel.text = @"参与人";
        return cell;
    }else if(indexPath.row == 6){
        UITableViewCell * cell5 = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell5.textLabel.text = @"评论:";
        cell5.textLabel.font = KDefaultFontBig;
        cell5.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell5;
    }else{
        SMCustomerDetailTableViewCell2 *cell = [SMCustomerDetailTableViewCell2 cellWithTableView:tableView];
        cell.scheduleDetail = self.contentArray[indexPath.row-7];
        
//        cell.localScheduleCompose = self.dataArray[self.dataArray.count-1-(indexPath.row-7)];
//        
//        CGFloat width = KScreenWidth - 20;
//        
//        self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        self.commentSize = [cell.comment textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(width, MAXFLOAT)];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        //点击了参与人
        SMMyTeamController * team = [SMMyTeamController new];
        team.type = 2;
        for (NSDictionary * dic in self.dataDic[@"usersList"]) {
            User * user = [User mj_objectWithKeyValues:dic];
            [team.showArray addObject:user];
        }
        [self.navigationController pushViewController:team animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据评论文字的多少返回不同的高度
    CGFloat height = 0.0;
    CGFloat height1 = 0.0;
    if (isIPhone5) {
        height = 46;
        height1 = 178;
    }else if (isIPhone6){
        height = 46* KMatch6Height;
        height1 = 178*KMatch6Height;
    }else if (isIPhone6p){
        height = 46* KMatch6pHeight;
        height1 = 178*KMatch6pHeight;
    }
    if (indexPath.row == 0) {
        return height;
    }else if(indexPath.row == 1){
       
        return height;
    }else if (indexPath.row == 2){
        
        return height1;
    }else if (indexPath.row == 3){
        
        return height;
    }else if(indexPath.row == 4){
        return height;
    }else if(indexPath.row == 5){
        if (self.isTeamSchedule) {
            return height;
        }
        return 0;
    }else if(indexPath.row==6){
        return height;
    }else{
        return 10 + 45 + 10 + self.commentSize.height + 30;
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //执行删除代码
        
//        LocalScheduleCompose * schedule = self.dataArray [self.dataArray.count-1-(indexPath.row-6)];
//        [schedule MR_deleteEntity];
//        [[NSManagedObjectContext MR_defaultContext ] MR_saveToPersistentStoreAndWait];
//        
//        [self loadSqlite];
        
        //[self.commentTableView reloadData];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>=7) {
        return YES;
    }
    return NO;
}

#pragma mark -- SMScheduleBottomViewDelegate   选择框点击 代理
- (void)scheduleBtnDidClick:(UIButton *)btn{
    
    SMLog(@"点击了 选择框  %zd",btn.tag);
    if (btn.tag == 0) {
        SMLog(@"选择了 已完成");
        [self.maskView removeFromSuperview];
        [self.bottomView removeFromSuperview];
        
        self.alreadyDoneBtn.selected = YES;
//        _localSchedule.isProgress = [NSNumber numberWithBool:YES];
        self.schedule.status = 1;
        [self.commentTableView reloadData];
       
    }else if (btn.tag == 1){
        SMLog(@"选择了 未完成");
        [self.maskView removeFromSuperview];
        [self.bottomView removeFromSuperview];
        self.alreadyDoneBtn.selected = NO;
        
//        _localSchedule.isProgress = [NSNumber numberWithBool:NO];
        self.schedule.status = 0;
        [self.commentTableView reloadData];
        
    }else if (btn.tag == 2){
        SMLog(@"选择了 取消");
        [self.maskView removeFromSuperview];
        [self.bottomView removeFromSuperview];
    }
    
//    NSArray * arr = [LocalSchedule MR_findByAttribute:@"title" withValue:_localSchedule.title inContext:[NSManagedObjectContext MR_defaultContext]];
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        for (LocalSchedule *local in arr) {
//            local.title = _localSchedule.title;
//            local.remark = _localSchedule.remark;
//            local.remindTime = _localSchedule.remindTime;
//            local.schTime =  _localSchedule.schTime;
//            local.isProgress = _localSchedule.isProgress;
//        }
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//    }];
    
    //上传至服务器呀
    
}

-(void)setLocalSchedule:(LocalSchedule *)localSchedule
{
    _localSchedule = localSchedule;
}

//-(void)refreshUI
//{
//    self.titleLabel.text = _localSchedule.title;
//    self.contentTextView.text = _localSchedule.remark;
//    
//    [self.timeBtn setTitle:[self StringWithdate:_localSchedule.schTime] forState:UIControlStateNormal];
//    [self.remindTimeBtn setTitle:_localSchedule.remindTime forState:UIControlStateNormal];
//    
//    self.alreadyDoneBtn.selected = [_localSchedule.isProgress boolValue];
//    
//    [self loadSqlite];
//}

-(NSString *)StringWithdate:(NSInteger )time
{
    
    NSDateFormatter * frm = [[NSDateFormatter alloc]init];
    frm.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [frm stringFromDate:date];
}


- (IBAction)ComposeBtnAction:(UIButton *)sender {
    SMLog(@"点击了  发表日志按钮");
    
//    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
//    fmr.dateFormat = [NSString stringWithFormat:@"yy年MM月dd日 HH:mm"];
//    NSString * str = [fmr stringFromDate:[NSDate date]];
//    
//    if (![self.inputFiled.text isEqualToString:@""]) {
//        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//            LocalScheduleCompose * localScheduleCompose = [LocalScheduleCompose MR_createEntityInContext:localContext];
//            localScheduleCompose.id = self.localSchedule.id;
//            localScheduleCompose.createAt = str;
//            localScheduleCompose.content = self.inputFiled.text;
//            localScheduleCompose.title = self.localSchedule.title;
//            
//            //[self.dataArray addObject:localScheduleCompose];
//            
//        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//            
//        }];
//    }
   
    [[SKAPI shared] addMissionComment:self.schId andContent:self.inputFiled.text andType:self.isTeamSchedule block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [self requestData];
        }else{
            SMLog(@"%@",error);
        }
    }];
    
    [self.inputFiled resignFirstResponder];
    self.inputFiled.text = nil;
//
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self loadSqlite];
//        
//        //[self.commentTableView reloadData];
//        
//        self.commentTableView.scrollsToTop = YES;
//    });
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self refreshUI];
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //判断是否状态改变了  状态改变需要刷新数据
    if (self.initialStatus != self.schedule.status) {
        NSDictionary * dic = @{@"id":self.schedule.id,@"title":self.schedule.title,@"remark":self.schedule.remark,@"schTime":[NSString stringWithFormat:@"%zd",self.schedule.schTime],@"remindTime":[NSString stringWithFormat:@"%zd",self.schedule.remindTime],@"status":[NSString stringWithFormat:@"%zd",self.schedule.status],@"remindType":[NSString stringWithFormat:@"%ld",self.schedule.remindType],@"type":[NSString stringWithFormat:@"%zd",self.schedule.type],@"users":self.schedule.users};
        
        [[SKAPI shared] updateMission:dic block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"%@",result);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KRefreshStatus" object:nil];
            }else{
                SMLog(@"%@",error);
            }
        }];
        
        
    }
    
    
}
-(void)loadSqlite
{
    [self.dataArray removeAllObjects];
    
    NSArray * arr = [LocalScheduleCompose MR_findByAttribute:@"title" withValue:self.localSchedule.title inContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalScheduleCompose * compose in arr) {
        [self.dataArray addObject:compose];
    }
    
    [self.commentTableView reloadData];

}

@end
