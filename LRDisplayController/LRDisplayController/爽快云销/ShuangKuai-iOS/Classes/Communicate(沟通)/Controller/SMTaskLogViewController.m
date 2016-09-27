//
//  SMTaskLogViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskLogViewController.h"
#import "SMTaskTopView.h"
#import "SMTaskTableViewCell.h"
#import "SMDetailScheduleViewController.h"
#import "SMNewScheduleViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "LocalSchedule+CoreDataProperties.h"
#import "AppDelegate.h"
#import "SMTitleView.h"
#import "SMTaskTableViewCell2.h"
#import "SingtonManager.h"
@interface SMTaskLogViewController ()<SMTaskTopViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)SMTaskTopView *topView;

@property (nonatomic ,strong)UITableView *tableViewAll;

@property (nonatomic ,strong)UITableView *tableViewAlready;

@property (nonatomic ,strong)UITableView *tableViewNotDone;

@property (nonatomic ,assign)CGFloat topViewHeight;

@property(nonatomic,copy)NSMutableArray * datasArray;

@property(nonatomic,copy)NSMutableArray * doneArray;

@property(nonatomic,copy)NSMutableArray * notDoneArray;

//团队的tableview
@property(nonatomic,strong)UITableView * teamTableview;

//记录到最后一个模型的时间戳  用于刷新数据
@property(nonatomic,assign)NSInteger lastTimestamp;

//是否为团队任务
@property(nonatomic,assign)BOOL isTeamSchedule;
//团队任务的数据源
@property(nonatomic,copy)NSMutableArray * teamArray;
//判断是否点击了团队任务  第一次点击刷新 再次点击不刷新
@property(nonatomic,assign)BOOL isClickTeam;
//自定义的titleView
@property(nonatomic,strong)SMTitleView * titleView;
@end

@implementation SMTaskLogViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
//    [self addTopView];
    
    [self addTableView];
    
    [self setupMjRefresh];
    
    self.lastTimestamp = 0;
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"KScheduleRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"KRefreshStatus" object:nil];
    
    SingtonManager * sington = [SingtonManager sharedManager];
    NSMutableArray * array = [NSMutableArray array];
    for (Msg * msg in sington.jobArray) {
        [array addObject:msg.messageId];
    }
    SMLog(@"array = %@",array);
    if (array.count>0) {
        [self.titleView showRightSpot];
    }
    [[SKAPI shared] receiptMessage:[array copy] block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [sington.jobArray removeAllObjects];
            sington.jobNum = sington.orderArray.count;
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)addTableView{
    [self.view addSubview:self.tableViewAll];
//    [self.view addSubview:self.tableViewAlready];
//    [self.view addSubview:self.tableViewNotDone];
    
    [self.view addSubview:self.teamTableview];
    
    self.tableViewAll.hidden = NO;
    self.teamTableview.hidden = YES;
}

- (void)setupNav{
    self.title = @"任务日程";
    
    //加号
    UIButton *rightBtn = [[UIButton alloc] init];
    //[rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjai"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
    [rightBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    rightBtn.titleLabel.font = KDefaultFontBig;
    rightBtn.width = 40;
    rightBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    
    //创建自定义的titleView
    SMTitleView * titleView = [SMTitleView CreatNavSwipTitleViewWithLeftTitle:@"个人任务" andRight:@"团队任务" andViewController:self];
    self.titleView = titleView;
    [titleView leftBtnClickAction:^{
        self.isTeamSchedule = NO;
        self.tableViewAll.hidden = NO;
        self.teamTableview.hidden = YES;
        [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
        rightBtn.enabled = YES;
    }];
    
    [titleView rightBtnClickAction:^{
        self.isTeamSchedule = YES;
        self.tableViewAll.hidden = YES;
        self.teamTableview.hidden = NO;
        if (!level2) {
            //1级
            [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
            rightBtn.enabled = YES;
        }else{
            //2级
            [rightBtn setTitle:@"" forState:UIControlStateNormal];
            rightBtn.enabled = NO;
        }
        if (!self.isClickTeam) {
            [self requestData];
            self.isClickTeam = YES;
        }
        
    }];
    
    [titleView hiddenLeftSpot];
    [titleView hiddenRightSpot];
    
    
    
    
    
}

/**
 *  新建日程
 */
- (void)rightItemDidClick{
    SMLog(@"点击了创建按钮");
    SMNewScheduleViewController *newVc = [[SMNewScheduleViewController alloc] init];
    newVc.isTeamSchedule = self.isTeamSchedule;
    newVc.isModify = NO;
    [self.navigationController pushViewController:newVc animated:YES];
}

- (void)addTopView{
    SMTaskTopView *topView = [SMTaskTopView taskTopView];
    topView.delegate = self;
    self.topView = topView;
    [self.view addSubview:topView];
    
    CGFloat height;
    if (isIPhone5) {
        height = 34;
    }else if (isIPhone6){
        height = 34 *KMatch6;
    }else if (isIPhone6p){
        height = 34 *KMatch6p;
    }
    topView.frame = CGRectMake(0, 0, KScreenWidth, height);
    self.topViewHeight = CGRectGetHeight(self.topView.frame);
}
#pragma mark -- SMTaskTopViewDelegate
- (void)taskTopViewDidClick:(UIButton *)btn{
    SMLog(@"点击了 任务日志的头部按钮  %zd",btn.tag);
    if (btn.tag == TaskBtnTypeAll) {
        
        self.tableViewAll.hidden = NO;
        self.tableViewAlready.hidden = YES;
        self.tableViewNotDone.hidden = YES;
    }else if (btn.tag == TaskBtnTypeAlready){
        
        self.tableViewAll.hidden = YES;
        self.tableViewAlready.hidden = NO;
        self.tableViewNotDone.hidden = YES;
    }else if (btn.tag == TaskBtnTypeNotDone){
        
        self.tableViewAll.hidden = YES;
        self.tableViewAlready.hidden = YES;
        self.tableViewNotDone.hidden = NO;
    }
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableViewAll) {
        return 1;
    }else if (tableView == self.tableViewAlready){
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewAll) {
        return self.datasArray.count;
    }else if(tableView == self.teamTableview)
    {
        return self.teamArray.count;
    }
//    if (tableView == self.tableViewAll) {
//        return self.datasArray.count;
//    }
//    if (tableView == self.tableViewAlready) {
//        return  self.doneArray.count;
//    }
//    if (tableView == self.tableViewNotDone) {
//        return self.notDoneArray.count;
//    }else if (tableView == self.teamTableview){
//        return 10;
//    }
//    return 0;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.teamTableview) {
        SMTaskTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        cell.schedule =self.teamArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    SMTaskTableViewCell *cell = [SMTaskTableViewCell cellWithTableView:tableView];
    cell.schedule  = self.datasArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (tableView == self.tableViewAll) {
//        if (self.datasArray.count>indexPath.row) {
//            [cell refreshUI:self.datasArray[self.datasArray.count -indexPath.row-1]];
//        }
//    }else if(tableView == self.tableViewAlready)
//    {
//        if (self.doneArray.count>indexPath.row) {
//            [cell refreshUI:self.doneArray[self.doneArray.count -indexPath.row-1]];
//        }
//    }else
//    {
//        if (self.notDoneArray.count>indexPath.row) {
//            [cell refreshUI:self.notDoneArray[self.notDoneArray.count -indexPath.row-1]];
//        }
//        
//    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"点了任务日志里的cell");
    if (tableView == self.teamTableview) {
        SMDetailScheduleViewController *detailVc = [[SMDetailScheduleViewController alloc] init];
        Schedule * schedule  = self.teamArray[indexPath.row];
        detailVc.schId = schedule.id;
        detailVc.isTeamSchedule = self.isTeamSchedule;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else if (tableView == self.tableViewAll){
        SMDetailScheduleViewController *detailVc = [[SMDetailScheduleViewController alloc] init];
        
        Schedule * schedule  = self.datasArray[indexPath.row];
        detailVc.schId = schedule.id;
        detailVc.isTeamSchedule = self.isTeamSchedule;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSArray * array = [LocalSchedule MR_findByAttribute:@"title" withValue:[self.datasArray[self.datasArray.count-1-indexPath.row] title]];
//        for (LocalSchedule * local in array) {
//            
//            for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//                NSString *notiID = noti.userInfo[@"Name"];
//                NSString *receiveNotiID = local.title;
//                if ([notiID isEqualToString:receiveNotiID]) {
//                    [[UIApplication sharedApplication] cancelLocalNotification:noti];
//                }
//            }
//            
//            [local MR_deleteEntity];
//            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//        }
//        [self loadDatas];
//        [self loadDoneDatas];
//        [self loadNotDoneDatas];
        if (tableView == self.tableViewAll) {
            Schedule * schedule = self.datasArray[indexPath.row];
            [[SKAPI shared] deleteMission:schedule.id block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"%@",result);
                    //刷新这一行
                    [self.datasArray removeObjectAtIndex:indexPath.row];
                    [self.tableViewAll deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }else if (tableView == self.teamTableview){
            Schedule * schedule = self.teamArray[indexPath.row];
            [[SKAPI shared] deleteMission:schedule.id block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"%@",result);
                    [self.teamArray removeObjectAtIndex:indexPath.row];
                     [self.teamTableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }
    }
}

/**
 *  请求数据
 */
-(void)requestData{
    
    //0 代表个人任务  1代表团队任务   分页方式的改变   offset 每一页的多少个  LastTimestamp 第一页最后一个模型的时间戳
    
    

    SMLog(@"self.lastTimestamp =    %zd",self.lastTimestamp);
    
//    [[SKAPI shared] queryMissionList:self.isTeamSchedule andOffset:10 andLastTimestamp:self.lastTimestamp block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"requestData   %@",result);
//            
//            if (self.isTeamSchedule == 1 && !self.teamTableview.mj_footer.isRefreshing) {
//                [self.teamArray removeAllObjects];
//            }else if(self.isTeamSchedule == 0 && !self.tableViewAll.mj_footer.isRefreshing){
//                [self.datasArray removeAllObjects];
//            }
//            if ([(NSArray *)result count]>0) {
//                for ( Schedule * schedule in result) {
//                    if (self.isTeamSchedule) {
//                        [self.teamArray addObject:schedule];
//                    }else{
//                        [self.datasArray addObject:schedule];
//                    }
//                }
//                
//                if (self.isTeamSchedule) {
//                    [self.teamTableview reloadData];
//                    [self.teamTableview.mj_header endRefreshing];
//                    [self.teamTableview.mj_footer endRefreshing];
//                }else{
//                    [self.tableViewAll reloadData];
//                    [self.tableViewAll.mj_header endRefreshing];
//                    [self.tableViewAll.mj_footer endRefreshing];
//                }
//
//            }else{
//                [self.tableViewAll.mj_footer endRefreshingWithNoMoreData];
//                [self.teamTableview.mj_footer endRefreshingWithNoMoreData];
//            }
//            
//        }else{
//            SMLog(@"%@",error);
//        }
//    }];
}

#pragma mark -- 懒加载
- (UITableView *)tableViewAll{
    if (_tableViewAll == nil) {
        _tableViewAll = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight) style:UITableViewStyleGrouped];
        _tableViewAll.delegate = self;
        _tableViewAll.dataSource = self;
        //        _tableViewAll.backgroundColor = [UIColor yellowColor];
    }
    return _tableViewAll;
}

-(UITableView *)teamTableview{
    if (!_teamTableview) {
        _teamTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight) style:UITableViewStyleGrouped];
        _teamTableview.delegate = self;
        _teamTableview.dataSource = self;
        //注册cell
        [_teamTableview registerNib:[UINib nibWithNibName:@"SMTaskTableViewCell2" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    }
    return _teamTableview;
}

- (UITableView *)tableViewAlready{
    if (_tableViewAlready == nil) {
        _tableViewAlready = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight) style:UITableViewStyleGrouped];
        _tableViewAlready.delegate = self;
        _tableViewAlready.hidden = YES;
        _tableViewAlready.dataSource = self;
        //        _tableViewAlready.backgroundColor = [UIColor greenColor];
    }
    return _tableViewAlready;
}

- (UITableView *)tableViewNotDone{
    if (_tableViewNotDone == nil) {
        _tableViewNotDone = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight) style:UITableViewStyleGrouped];
        _tableViewNotDone.delegate = self;
        _tableViewNotDone.dataSource = self;
        _tableViewNotDone.hidden = YES;
        //        _tableViewNotDone.backgroundColor = [UIColor redColor];
    }
    return _tableViewNotDone;
}

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];

    }
    return _datasArray;
}

-(NSMutableArray *)teamArray{
    if (!_teamArray) {
        _teamArray = [NSMutableArray array];
    }
    return _teamArray;
}
-(NSMutableArray *)doneArray
{
    if (!_doneArray) {
        _doneArray = [NSMutableArray array];
        
    }
    return _doneArray;
}
-(NSMutableArray *)notDoneArray
{
    if (!_notDoneArray) {
        _notDoneArray = [NSMutableArray array];
        
    }
    return _notDoneArray;
}

#pragma mark -  本地取数据

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDatas];
        [self loadDoneDatas];
        [self loadNotDoneDatas];
        //[self.tableViewAll reloadData];
//        [self.tableViewNotDone reloadData];
//        [self.tableViewAlready reloadData];
    });
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    
}

-(void)loadDatas
{
//    NSArray * array = [LocalSchedule MR_findAll];
    
//    [self.datasArray removeAllObjects];
//    for (LocalSchedule * localModel in array) {
//        [self.datasArray addObject:localModel];
//    }
    //[self.tableViewAll reloadData];
}

-(void)loadDoneDatas
{
    [self.doneArray removeAllObjects];
    NSArray * arr = [LocalSchedule MR_findAll];
    for (LocalSchedule * localSchedule in arr) {
        if ([localSchedule.isProgress boolValue] ) {
            [self.doneArray addObject:localSchedule];
        }
    }
    //[self.tableViewAlready reloadData];
    
}
-(void)loadNotDoneDatas
{
    [self.notDoneArray removeAllObjects];
    NSArray * arr = [LocalSchedule MR_findAll];
    for (LocalSchedule * localSchedule in arr) {
        if (![localSchedule.isProgress boolValue]) {
            [self.notDoneArray addObject:localSchedule];
        }
    }
   // [self.tableViewNotDone reloadData];
}

-(void) setupMjRefresh{
    //个人
    MJRefreshNormalHeader *Producttableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.lastTimestamp = 0;
        [self requestData];
    }];
    self.tableViewAll.mj_header = Producttableviewtheader;
    MJRefreshBackNormalFooter *Productfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        Schedule * schelude = [self.datasArray lastObject];
        self.lastTimestamp = schelude.lastUpdate;
        [self requestData];
    }];
    self.tableViewAll.mj_footer = Productfooter;
    //团队的
    MJRefreshNormalHeader *teamTableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.lastTimestamp = 0;
        [self requestData];
    }];
    self.teamTableview.mj_header = teamTableviewtheader;
    MJRefreshBackNormalFooter *teamfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        Schedule * schelude = [self.teamArray lastObject];
        self.lastTimestamp = schelude.lastUpdate;
        [self requestData];
    }];
    self.teamTableview.mj_footer = teamfooter;
}
-(void)dealloc{
    SMLog(@"dealloc");
}
@end
