//
//  SMNewScheduleViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewScheduleViewController.h"
#import "LocalSchedule+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"
#import "SMMyTeamController.h"

@interface SMNewScheduleViewController ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
/**
 *  输入栏 textView
 */
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/**
 *  输入栏textField
 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


/**
 *  请选择时间 的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
/**
 *  提醒 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;

@property(nonatomic,strong)UIAlertView * alertView;

@property(nonatomic,strong)UIDatePicker * datePicker;

@property(nonatomic,strong)UIPickerView * pickerView;

@property(nonatomic,copy)NSArray * remindArray;

@property(nonatomic,assign)BOOL isWhat;

/**
 *  一个承载pickerView  和  datePicker 的view
 */

@property(nonatomic,strong)UIView * loadPickerView;

@property(nonatomic,strong)UIView * loadDatePickerView;

//参与人员的View
@property (strong, nonatomic) IBOutlet UIView *participantView;

@property (strong, nonatomic) IBOutlet UIView *participantLine;
@end

@implementation SMNewScheduleViewController

-(NSMutableArray *)participantArray{
    if(!_participantArray){
        _participantArray = [NSMutableArray array];
    }
    return _participantArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setSchedule:self.schedule];
    [self setupNav];
    //[self setLocalSchedule:self.localSchedule];
   
    self.inputTextView.delegate = self;
    self.inputTextField.delegate = self;
    
    //是团队任务才打开参与人的选择
    if (self.isTeamSchedule) {
        self.participantView.hidden = NO;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self.participantView addGestureRecognizer:tap];
    }else{
        self.participantView.hidden = YES;
    }
    
}
-(void)tapClick{
    [self participateSelectAction:nil];
}
- (void)setupNav{
    self.title = @"新建任务";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"完成" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    rightBtn.width = 35;
    rightBtn.height = 35;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置参与人员
    [self creatParticipant];
}

-(void)creatParticipant{
    
    for (UIView * view  in self.participantView.subviews) {
        if (![view isKindOfClass:[UIButton class]] &&  !(view == self.participantLine)) {
            [view removeFromSuperview];
        }
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 80, 32)];
    label.centerY = 22;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"参与人:";
    label.font = KDefaultFontBig;
    [self.participantView addSubview:label];
    
    for (NSInteger i=0; i<self.participantArray.count; i++) {
        if (i>=6) {
            UILabel * spotLable = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-43-20,0,40, 32)];
            spotLable.text = [NSString stringWithFormat:@"等%zd人",self.participantArray.count-6];
            spotLable.font = KDefaultFontSmall;
            spotLable.textAlignment = NSTextAlignmentLeft;
            spotLable.centerY = 22;
            [self.participantView addSubview:spotLable];
            break;
        }
        UIImageView  * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-35*(i%6+1)-40-20,0, 32, 32)];
        imageView.centerY = 22;
        imageView.image = [UIImage imageNamed:@"touxiangKeFu"];
        imageView.layer.cornerRadius = 16;
        imageView.layer.masksToBounds = YES;
        User * user = self.participantArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"touxiangKeFu"] options:SDWebImageRefreshCached progress:nil completed:nil];
        [self.participantView addSubview:imageView];
    }
}
#pragma mark -- 点击事件
- (void)rightItemDidClick{
    SMLog(@"点击了右上角的 完成 按钮");
    //写本地
    [self setupfinish];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)chooseTimeBtnClick:(UIButton *)sender {
    SMLog(@"点击了 请选择时间 按钮");
    //[self.view addSubview:self.datePicker];
    [self.loadDatePickerView addSubview:self.datePicker];
    [self.view addSubview:self.loadDatePickerView];
    
    self.loadDatePickerView.hidden = NO;
    self.datePicker.hidden = NO;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-200-64)];
    view.backgroundColor = [UIColor clearColor];
    view.tag =10;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtn:)];
//    [view addGestureRecognizer:tap];
    [self.view addSubview:view];
    
    [self.view endEditing:YES];
    
}

- (IBAction)remindBtnClick:(UIButton *)sender {
    SMLog(@"点击了 请选择提醒时间 按钮");
    [self.loadPickerView addSubview:self.pickerView];
    [self.view addSubview:self.loadPickerView];
//    [self.view bringSubviewToFront:self.loadPickerView];
    
    self.pickerView.hidden = NO;
    self.loadPickerView.hidden = NO;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight-264)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 11;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtn:)];
//    [view addGestureRecognizer:tap];
    
    [self.view addSubview:view];
    
     [self.view endEditing:YES];
}
//选择参与人员的按钮
- (IBAction)participateSelectAction:(UIButton *)sender {
    SMLog(@"点击选择参与人员的按钮");
    //跳转到我的团队
    SMMyTeamController * Vc = [SMMyTeamController new];
    Vc.type = 1;
    //初始化这个数组 
    Vc.initialArray  = [self.participantArray  copy];
    
    Vc.returnIdArrayBlock = ^(NSArray * idArray){
        //获取到选择的参与人员 的数组
        SMLog(@"%zd",idArray.count);
        [self.participantArray removeAllObjects];
        
        for (User * user in idArray) {
            [self.participantArray addObject:user];
        }
        
        //设置参与人员
        [self creatParticipant];
    };
    [self.navigationController pushViewController:Vc animated:YES];
}

#pragma mark -- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self.inputTextView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.inputTextField resignFirstResponder];
    }
    return YES;
    
}

-(void)setupfinish
{
    //创建完成
    if (![self.inputTextField.text isEqualToString:@""]) {
        if (![self.chooseTimeBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
            if (![self.remindBtn.titleLabel.text isEqualToString:@"请选择提醒时间"]) {
                //缓存到本地
               
//                NSArray * array = [LocalSchedule MR_findByAttribute:@"title" withValue:self.localSchedule.title];
//                if (array.count>0) {
//                    LocalSchedule * localSchedule = [array lastObject];
//                    localSchedule.title = self.inputTextField.text;
//                    localSchedule.remark = self.inputTextView.text;
//                    localSchedule.remindTime = self.remindBtn.titleLabel.text;
//                    localSchedule.schTime =  [NSNumber numberWithInteger:[self dateWithString:self.chooseTimeBtn.titleLabel.text]];
//                    //localSchedule.isProgress = [NSNumber numberWithBool:NO];
//                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//                }else
//                {
//                    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
//                        LocalSchedule * localSchedule = [LocalSchedule MR_createEntityInContext:localContext];
//                        localSchedule.title = self.inputTextField.text;
//                        localSchedule.remark = self.inputTextView.text;
//                        localSchedule.remindTime =self.remindBtn.titleLabel.text;
//                        localSchedule.schTime =  [NSNumber numberWithInteger:[self dateWithString:self.chooseTimeBtn.titleLabel.text]];
//                        localSchedule.isProgress = [NSNumber numberWithBool:NO];
//                    } completion:^(BOOL contextDidSave, NSError *error) {
//                        
//                    }];
//                }
             
                
                //创建一个闹钟
//                [self creatAlarmClockWithDate:[NSDate dateWithTimeIntervalSince1970:[self dateWithString:self.chooseTimeBtn.titleLabel.text]]];
                
                NSMutableArray * idArray = [NSMutableArray array];
                for (User * user in self.participantArray) {
                    [idArray addObject:user.id];
                }
                
                if (!self.isModify) {
                    //新建
                    NSInteger row = [self.pickerView selectedRowInComponent:0];
                    NSArray * array2 = @[@"0",@"300",@"900",@"1800",@"3600",@"7200",@"86400",@"172800",@"604800"];
                    NSDictionary * dic = @{@"title":self.inputTextField.text,@"remark":self.inputTextView.text,@"schTime":[NSString stringWithFormat:@"%.0lf",[self dateWithString:self.chooseTimeBtn.titleLabel.text]],@"remindTime":[NSString stringWithFormat:@"%.0lf",[self stringWithDateDouble:self.remindBtn.titleLabel.text]],@"status":@"0",@"remindType":[NSString stringWithFormat:@"%ld",row],@"type":[NSString stringWithFormat:@"%zd",self.isTeamSchedule],@"users":[idArray copy]};
                    
                    SMLog(@"requestParameter     %@",dic);
                    [[SKAPI shared] publishMission:dic block:^(id result, NSError *error) {
                        if (!error) {
                            SMLog(@" result =    %@",result);
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"KScheduleRefresh" object:nil];
                        }else{
                            SMLog(@"%@",error);
                        }
                    }];
                    
                }else{
                    //修改
                    NSInteger row = [self.pickerView selectedRowInComponent:0];
                    
                    NSDictionary * dic = @{@"id":self.schedule.id,@"title":self.inputTextField.text,@"remark":self.inputTextView.text,@"schTime":[NSString stringWithFormat:@"%.0lf",[self dateWithString:self.chooseTimeBtn.titleLabel.text]],@"remindTime":[NSString stringWithFormat:@"%.0lf",[self stringWithDateDouble:self.remindBtn.titleLabel.text]],@"status":@"0",@"remindType":[NSString stringWithFormat:@"%ld",row],@"type":[NSString stringWithFormat:@"%zd",self.isTeamSchedule],@"users":[idArray copy]};
                    [[SKAPI shared] updateMission:dic block:^(id result, NSError *error) {
                        if (!error) {
                            SMLog(@" result =    %@",result);
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"KScheduleRefresh" object:nil];
                        }else{
                            SMLog(@"%@",error);
                        }
                    }];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showAlertViewWithMessage:@"请选择提醒时间"];
                [self hideAlertView];
            }
        }else
        {
            [self showAlertViewWithMessage:@"请选择时间"];
            [self hideAlertView];
        }
    }else
    {
        [self showAlertViewWithMessage:@"请输入标题"];
        [self hideAlertView];
    }
    
   
}

#pragma mark -提醒相关
-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)hideAlertView
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    _alertView = nil;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        SMLog(@"创建了日前选择器");
        // 创建日期选择器:可以不设置frame
        _datePicker = [[UIDatePicker alloc] init];
        // 设置时区
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        
        // 设置时间模式
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        // 设置最小时间 (20年前)   3miao
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-(20 * 365 * 24 * 60 * 60)];
        // 设置最大时间 (20年后)
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(20 * 365 * 24 * 60 * 60)];
        
        // 设置时间间隔
        // 设置的值必须能够被60整除
        //        _datePicker.minuteInterval = 30;
        
        // 监听时间值改变事件
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.frame = CGRectMake(0, 30, KScreenWidth, 170);
        _datePicker.backgroundColor = SMColor(229, 239, 239);
        
    }
    return _datePicker;
}

#pragma mark - 监听时间值的改变
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    
    // 获得时间
    NSDate *date = (datePicker == nil ? [NSDate date]:datePicker.date);
    //NSDate *date = datePicker.date;
    // 格式化时间
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //    // 时间格式
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    //    // 将时间转换成字符串
        //self.birthField.text = [fmt stringFromDate:date];
    
        [self.chooseTimeBtn setTitle:[fmt stringFromDate:date] forState:UIControlStateNormal];
}

-(void)clickRetain{
    self.loadDatePickerView.hidden = YES;
    self.loadPickerView.hidden = YES;
    UIView * view1 = (UIView *)[self.view viewWithTag:10];
    UIView * view2 = (UIView *)[self.view viewWithTag:11];
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    [self.remindBtn setTitle:self.remindArray[row] forState:UIControlStateNormal];
}
-(void)clickBtn:(UITapGestureRecognizer*)tap{
    self.datePicker.hidden = YES;
    self.loadPickerView.hidden = YES;
    UIView * view1 = (UIView *)[self.view viewWithTag:10];
    UIView * view2 = (UIView *)[self.view viewWithTag:11];
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    [self.remindBtn setTitle:self.remindArray[row] forState:UIControlStateNormal];
}

-(double)dateWithString:(NSString *)dateString
{
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [fmr dateFromString:dateString];
    SMLog(@"时间%lf",[date timeIntervalSince1970]);
    return [date timeIntervalSince1970];
}

-(NSString*)stringWithDate:(NSInteger )dateNum
{
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:dateNum];
    return [fmr stringFromDate:date];
}

//
//-(void)setLocalSchedule:(LocalSchedule *)localSchedule
//{
//    _localSchedule = localSchedule;
//    if (localSchedule!=nil) {
//        self.title = @"修改日程";
//        [self.chooseTimeBtn setTitle:[self stringWithDate:localSchedule.schTime] forState:UIControlStateNormal];
//        [self.remindBtn setTitle:localSchedule.remindTime forState:UIControlStateNormal];
//    }
//    self.inputTextField.text = localSchedule.title;
//    self.inputTextView.text = localSchedule.remark;
//}

-(void)setSchedule:(Schedule *)schedule{
    _schedule = schedule;
    if (schedule != nil) {
        [self.chooseTimeBtn setTitle:[self stringWithDate:_schedule.schTime] forState:UIControlStateNormal];
        [self.remindBtn setTitle:self.remindArray[schedule.remindType] forState:UIControlStateNormal];
        self.inputTextField.text = _schedule.title;
        self.inputTextView.text = _schedule.remark;
        
    }
    
}

#pragma mark - 选择器

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource

-(UIView *)loadPickerView
{
    if (!_loadPickerView) {
        _loadPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200 - 44 - 20, KScreenWidth, 200)];
        _loadPickerView.backgroundColor = SMColor(229, 239, 239);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(KScreenWidth-100, 0, 100, 30);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickRetain) forControlEvents:UIControlEventTouchUpInside];
        [_loadPickerView addSubview:btn];
    }
    return _loadPickerView;
}
-(UIView *)loadDatePickerView
{
    if (!_loadDatePickerView) {
        _loadDatePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200 - 44 - 20, KScreenWidth, 200)];
        _loadDatePickerView.backgroundColor = SMColor(229, 239, 239);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(KScreenWidth-100, 0, 100, 30);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickRetain) forControlEvents:UIControlEventTouchUpInside];
        [_loadDatePickerView addSubview:btn];
    }
    return _loadDatePickerView;
}
-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,30, KScreenWidth, 170)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = SMColor(229, 239, 239);
        //[self.loadPickerView addSubview:_pickerView];
    }
    return _pickerView;
}
//显示几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//显示几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.remindArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.remindArray[row];
}

-(NSArray *)remindArray
{
    if (!_remindArray) {
        _remindArray = @[@"到达截止时间时",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"2小时前",@"1天前(下午6:00)",@"2天前（下午6:00）",@"1周前（下午6:00）"];
    }
    return _remindArray;
}

#pragma mark - 闹钟相关
-(void)creatAlarmClockWithDate:(NSDate *)Schdate
{
    
    //如果是修改
    //进来需要把闹钟去掉
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notiID = noti.userInfo[@"Name"];
        NSString *receiveNotiID = self.inputTextField.text;
        if ([notiID isEqualToString:receiveNotiID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
        }
    }
    
    NSDate *currentDate = [NSDate date];
    
    if ([self stringWithDateDouble:self.remindBtn.titleLabel.text]-[currentDate timeIntervalSince1970]>=0) {
        
        // 初始化本地通知对象
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            // 设置通知的提醒时间
            
            notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
            
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:[self stringWithDateDouble:self.remindBtn.titleLabel.text]-[currentDate timeIntervalSince1970]];
            
            SMLog(@"闹钟时间%f,%@,",[notification.fireDate timeIntervalSince1970],currentDate);
            //SMLog(@"%@",);
            // 设置重复间隔
            //notification.repeatInterval = kCFCalendarUnitDay;
            notification.repeatInterval = 0;
            // 设置提醒的文字内容
            notification.alertBody   = self.inputTextView.text;
            //notification.alertAction = NSLocalizedString(self.inputTextField.text, nil);
            
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            //notification.applicationIconBadgeNumber = 0;
            
            //这里添加识别
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            aUserInfo[@"Name"] = self.inputTextField.text;
            notification.userInfo = aUserInfo;
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
    
}

-(double)stringWithDateDouble:(NSString *)string{

   // NSArray * array = @[@"00 00:00",@"00 00:05",@"00 00:15",@"00 00:30",@"00 01:00",@"00 02:00",@"01 18:00",@"02 18:00",@"07 18:00"];
    NSArray * array2 = @[@"0",@"300",@"900",@"1800",@"3600",@"7200",@"86400",@"172800",@"604800"];
    NSMutableArray * array = [NSMutableArray arrayWithArray:array2];
    double time = 0.0;
    double schTime = [self dateWithString:self.chooseTimeBtn.titleLabel.text];
    for (int i=0; i<self.remindArray.count; i++) {
        if ([string isEqualToString:self.remindArray[i]]) {
            
                //需要处理成18点的响应
                //首先获得时间 与18点比较
                //差值
                //获取到时间  计算出差值
            if (i>5) {
                NSString * schTimeStr = self.chooseTimeBtn.titleLabel.text;
                //获取到时间和分钟   转换成秒钟
                NSString * cTime = [schTimeStr substringWithRange:NSMakeRange(schTimeStr.length-5,5)];
                NSArray * timeArray = [cTime componentsSeparatedByString:@":"];
                double dayTime = [timeArray[0] doubleValue] * 60 * 60 +[timeArray[1] doubleValue] * 60;
                //获取到
                double sixTime = 18 * 60 * 60 ;
                //相差的秒数
                double subTime = sixTime-dayTime;
                // 进一步获取到具体时间
                
                SMLog(@"subTime    =  %lf",subTime);
                
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.0lf",[array2[i] doubleValue] - subTime]];
                time = schTime - [array[i] doubleValue];
            }else{
                time = schTime -[array[i] doubleValue];
            }
            
            
            
        }
    }
    SMLog(@"time = %lf,string = %@",time,string);
    return time;
}


@end
