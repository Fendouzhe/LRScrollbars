//
//  SMMonthlyBillViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMonthlyBillViewController.h"
#import "SMMonthlyBillHeaderView.h"
#import "SMCommisionSettlementCell2.h"
#import "SMDatePickerHeaderView.h"
#import "BMDatePickerView.h"
#import "AppDelegate.h"


@interface SMMonthlyBillViewController ()<UITableViewDataSource,UITableViewDelegate,SMMonthlyBillHeaderViewDelegate,SMDatePickerHeaderViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

// 日期选择器
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic ,strong)SMMonthlyBillHeaderView *topView;

@property (nonatomic ,strong)UIView *grayView;

@property (nonatomic ,strong)SMDatePickerHeaderView *dateHeaderView;

@property(nonatomic,strong)NSMutableArray * datasArray;

@end

@implementation SMMonthlyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"月账单";
    
    
    [self setupTopView];
    
    //获取新的数据，并刷新tableView。
    [[SKAPI shared] queryCommissionByYear:self.year andMonth:self.month block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.datasArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
        
    }];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)setupTopView{
    SMMonthlyBillHeaderView *topView = [SMMonthlyBillHeaderView monthlyBillHeaderView];
    [self.view addSubview:topView];
    topView.delegate = self;
    self.topView = topView;
    
    self.topView.yearLabel.text = [NSString stringWithFormat:@"%@年",self.year];
    [self.topView.monthBtn setTitle:[NSString stringWithFormat:@"%@月",self.month] forState:UIControlStateNormal];
    
    CGFloat height;
    if (isIPhone5) {
        height = 110;
    }else if (isIPhone6){
        height = 110 *KMatch6;
    }else if (isIPhone6p){
        height = 110 *KMatch6p;
    }
    topView.frame = CGRectMake(0, 0, KScreenWidth, height);
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCommisionSettlementCell2 *cell = [SMCommisionSettlementCell2 cellWithTableView:tableView];
    cell.commission = self.datasArray[indexPath.row];
    cell.jiantou.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 60;
    }else if (isIPhone6){
        height = 60 *KMatch6;
    }else if (isIPhone6p){
        height = 60 *KMatch6p;
    }
    return height;
}

#pragma mark -- SMMonthlyBillHeaderViewDelegate
- (void)monthChooseBtnDidClick{
    SMLog(@"点击了 选择月份 按钮 2");
    //添加蒙板
//    [self.view addSubview:self.grayView];
//    
//    [self.view addSubview:self.datePicker];
//    
//    [self.view addSubview:self.dateHeaderView];
    
    BMDatePickerView *datePickerView = [BMDatePickerView BMDatePickerViewCertainActionBlock:^(NSString *selectYearMonthString) {
        SMLog(@"选择的时间是: %@",selectYearMonthString);
        NSString *yearStr = [selectYearMonthString substringToIndex:4];
        NSString *monthStr = [selectYearMonthString substringFromIndex:4];
        SMLog(@"YearStr  %@  monthStr  %@",yearStr,monthStr);
        
        self.topView.yearLabel.text = [NSString stringWithFormat:@"%@年",yearStr];
        [self.topView.monthBtn setTitle:[NSString stringWithFormat:@"%@月",monthStr] forState:UIControlStateNormal];
        
        //获取新的数据，并刷新tableView。
        [[SKAPI shared] queryCommissionByYear:yearStr andMonth:monthStr block:^(NSArray *array, NSError *error) {
            if (!error) {
                self.datasArray = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
            }else{
                SMLog(@"error   %@",error);
            }
            
        }];
    }];
    [datePickerView show];
}

- (void)grayViewClick{
    SMLog(@"点击了 蒙板");
    [_datePicker removeFromSuperview];
    [_grayView removeFromSuperview];
    [_dateHeaderView removeFromSuperview];
}

#pragma mark - 监听时间值的改变
- (void)datePickerValueChanged:(UIDatePicker *)datePicker{
    // 获得时间
    NSDate *date = datePicker == nil ? [NSDate date]:datePicker.date;
    // 格式化时间
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 时间格式
//    fmt.dateFormat = @"yyyy-MM-dd";
//    // 将时间转换成字符串
//    self.birthField.text = [fmt stringFromDate:date];
    
    [self getDateWithDate:date];
    
}

- (void)getDateWithDate:(NSDate *)date{

    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    self.topView.yearLabel.text = [NSString stringWithFormat:@"%zd年",year];
    [self.topView.monthBtn setTitle:[NSString stringWithFormat:@"%0zd月",month] forState:UIControlStateNormal];
    
    //时间变换，刷新数据
    [self requestDatas];
}

#pragma mark -- SMDatePickerHeaderViewDelegate
- (void)topBtnDidClick:(UIButton *)btn{
    if (btn.tag == 0) {
        SMLog(@"点了 取消 按钮");
        [self grayViewClick];
    }else if (btn.tag == 1){
        SMLog(@"点了 完成 按钮");
        [self grayViewClick];
    }
}


#pragma mark -- 懒加载

- (SMDatePickerHeaderView *)dateHeaderView{
    if (_dateHeaderView == nil) {
        _dateHeaderView = [SMDatePickerHeaderView datePickerHeaderView];
        CGFloat y = CGRectGetMinY(self.datePicker.frame) - 35;
        _dateHeaderView.frame = CGRectMake(0, y, KScreenWidth, 35);
        _dateHeaderView.delegate = self;
    }
    return _dateHeaderView;
}

- (UIView *)grayView{
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        _grayView.frame = self.view.bounds;
        _grayView.backgroundColor = [UIColor grayColor];
        _grayView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grayViewClick)];
        [_grayView addGestureRecognizer:tap];
    }
    return _grayView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, KScreenWidth, KScreenHeight - 110 - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        SMLog(@"创建了日前选择器");
        // 创建日期选择器:可以不设置frame
        _datePicker = [[UIDatePicker alloc] init];
        // 设置时区
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        
        // 设置时间模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        // 设置最小时间 (20年前)
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-(20 * 365 * 24 * 60 * 60)];
        // 设置最大时间 (20年后)
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(20 * 365 * 24 * 60 * 60)];
        
        
        // 设置时间间隔
        // 设置的值必须能够被60整除
        //        _datePicker.minuteInterval = 30;
        
        // 监听时间值改变事件
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.frame = CGRectMake(0, KScreenHeight - 216 - 44 - 20, KScreenWidth, 216);
        _datePicker.backgroundColor = SMColor(229, 239, 239);
    }
    return _datePicker;
}

#pragma mark - 根据时间选择器选择的时间 获取相应的数据 刷新到tableview

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(void)requestDatas
{
    SMLog(@"%@-%@",self.topView.yearLabel.text,self.topView.monthBtn.titleLabel.text);
    
    [self.datasArray removeAllObjects];
    NSString *yearStr = [[self.topView.yearLabel.text componentsSeparatedByString:@"年"] firstObject];
    NSString *monthStr = [[self.topView.monthBtn.titleLabel.text componentsSeparatedByString:@"月"] firstObject];
    
    SMLog(@"self.topView.yearLabel.text  %@",self.topView.yearLabel.text);
    [[SKAPI shared] queryCommissionByYear:yearStr andMonth:monthStr block:^(NSArray *array, NSError *error) {
//        SMLog(@"%@",array);
        //        self.datasArray  = [array mutableCopy];
        for (id m in array) {
            SMLog(@"[m class]  %@",[m class]);
        }
        for (Commission * commossion in array) {
            [self.datasArray addObject:commossion];
        }
        [self.tableView reloadData];
    }];
}

@end
