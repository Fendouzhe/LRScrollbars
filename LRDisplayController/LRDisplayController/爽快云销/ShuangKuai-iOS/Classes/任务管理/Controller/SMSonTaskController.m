//
//  SMSonTaskController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSonTaskController.h"
#import "SMTaskContentCell.h"
#import "SMParticipantCell.h"
#import "SMParticipantController.h"
#import "SMDeadLineCell.h"
#import "CuiPickerView.h"
#import "SMFriend.h"
#import "SMParticipant.h"

@interface SMSonTaskController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,SMParticipantControllerDelegate,CuiPickViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *rightBtn;/**< 右上角保存按钮 */

@property (nonatomic ,strong)UITextView *inputView;/**< <#注释#> */

@property (nonatomic ,strong)UILabel *holderLabel;/**< <#注释#> */

@property (nonatomic ,strong)SMParticipantCell *participantCell;/**< <#注释#> */

@property (nonatomic ,strong)UILabel *deadLineLabel;/**< <#注释#> */

@property (nonatomic ,strong)CuiPickerView *cuiPickerView;/**< <#注释#> */

@end

@implementation SMSonTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    SMLog(@"self.fatherId    %@   self.list       %@",self.fatherId,self.list);
    [self setupTableView];
    
}

- (void)setupTableView{
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SMTaskContentCell *cell = [SMTaskContentCell cellWithTableView:tableView];
        cell.inputView.delegate = self;
        self.inputView = cell.inputView;
        self.holderLabel = cell.holderLabel;
        if (self.list) {
            cell.list = self.list;
        }
        return cell;
    }else if (indexPath.row == 1){
        SMParticipantCell *cell = [SMParticipantCell cellWithTableView:tableView];
        self.participantCell = cell;
        if (self.list) {
            cell.list = self.list;
        }
        
        return cell;
    }else if (indexPath.row == 2){
        SMDeadLineCell *cell = [SMDeadLineCell cellWithTableView:tableView];
        self.deadLineLabel = cell.rightLabel;
        if (self.list) {
            cell.list = self.list;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 207 *SMMatchHeight;
    }else if (indexPath.row == 1){
        return 45 *SMMatchHeight;
    }else if (indexPath.row == 2){
        return 45 *SMMatchHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        SMParticipantController *vc = [SMParticipantController new];
        vc.delegate = self;
        vc.arrHaveChoosed = self.participantCell.arrIconStrs;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        SMLog(@"self.cuiPickerView  %@",self.cuiPickerView);
        if (self.cuiPickerView) {
            return;
        }
        [self setupChooseTimeMenu];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)removePickerView{
    self.cuiPickerView = nil;
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
}

- (void)haveSelectedPerson:(NSArray *)array{
    self.participantCell.arrIconStrs = array;
}


- (void)setupNav{
    self.title = @"编辑子任务";
    
    self.rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [self.rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn.width = 30;
//    self.rightBtn.height = 22;
    [self.rightBtn sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = KControllerBackGroundColor;
}

- (void)rightItemClick{
    SMLog(@"点击了 保存。");
    
    if ([self.inputView.text isEqualToString:@""]) {
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
#pragma mark -- 到这里可以保存了
    
    if (self.isBeingUpdating) { //如果处于被修改状态
        [self updateTask];
    }else{
        [self crearNewTask];
    }
    
    
}

- (void)updateTask{
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
    }else if (self.list.childUser.count > 0){  //在修改子任务的时候，一进去就直接返回，返回到主任务界面时，参与人全部是空的，下面这段代码是为了防止这个bug
        
        for (SMParticipant *p in self.list.childUser) {
            [arrUserIds addObject:p.userid];
        }
        
    }else{
        // 如果没有选择参与人,直接传一个空数组过去
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = self.list.childSchedule.id;
    dict[@"title"] = @"";
    dict[@"remark"] = self.inputView.text;
    dict[@"schTime"] = timeNum;
    dict[@"users"] = arrUserIds;
    dict[@"fatherId"] = self.fatherId;
    SMLog(@"self.fatherId    %@",self.fatherId);
    
    [[SKAPI shared] updateMission:dict block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  updateMission   %@",result);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];

}

- (void)crearNewTask{
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
    }else if (self.list.childUser.count > 0){  //在修改子任务的时候，一进去就直接返回，返回到主任务界面时，参与人全部是空的，下面这段代码是为了防止这个bug
        
        for (SMParticipant *p in self.list.childUser) {
            [arrUserIds addObject:p.userid];
        }
        
    }else{
        // 如果没有选择参与人,直接传一个空数组过去
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"title"] = @"";
    dict[@"remark"] = self.inputView.text;
    dict[@"schTime"] = timeNum;
    dict[@"users"] = arrUserIds;
    dict[@"fatherId"] = self.fatherId;
    SMLog(@"self.fatherId    %@",self.fatherId);
    [[SKAPI shared] addMission:dict block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   addMission   sonTask  %@",result);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error  %@",error);
        }
    }];

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
    
    //    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    //    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    //时间转时间戳的方法:
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSInteger timeStamp = (long)[date timeIntervalSince1970];
    SMLog(@"timeSp:%zd",timeStamp); //时间戳的值
    return timeStamp;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.holderLabel.text = @"   请输入任务内容";
    }else{
        self.holderLabel.text = @"";
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
