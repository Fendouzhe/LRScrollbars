//
//  SMHomePageController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageController.h"
#import "SMHomePageCellSection0.h"
#import "SMHomePageCellSection1.h"
#import "SMSuperSalerCell.h"
#import "SMAdvertisementCell.h"
#import "SMLeftItemBtn.h"
#import "SMPersonInfoViewController.h"
#import "SMRightItemView.h"
#import "SMSearchViewController.h"
#import "SMScannerViewController.h"
#import "SMDataStationController.h"
#import "SMExpertViewController.h"
#import <AVQuery.h>
#import "SMDataStation.h"
#import "SMMyInComeViewController.h"
#import "SMPartnerController.h"
#import "SMTaskLogViewController.h"
#import "SMNewCustomManagerController.h"
#import "SMSignInViewController.h"
#import "SMPartnerConnectViewController.h"
#import "SMNewOrderManagerViewController.h"
#import "SMCustomerController.h"
#import "SMWantBuyCustomerController.h"
#import "SMCustomerController.h"
#import "EditCustomerController.h"
#import "CustomerDetailInfoViewController.h"
#import "SelectProductListViewController.h"
#import "CreatNewCustomerViewController.h"
#import "SMCreatTaskController.h"
#import "SMNewPartnerConnectViewController.h"
#import "SMParticipantController.h"
#import <Harpy.h>
#import "SMAddProductToShelfController.h"
#import "SMNewPartnerConnectViewController.h"
#import "TaskListViewController.h"
#import "TaskDetailInfoViewController.h"
#import "SMCustomerListViewController.h"
#import "SMCustomerController.h"
#import "SMScenePromotionController.h"
#import "SMTogetherBuyController.h"
#import "SMActionViewController.h"
#import "SMScenePromotionController2.h"
#import "EventInvitationsViewController.h"
#import "SliderShopViewController.h"
#import "SMSearchAllMessageViewController.h"
#import "ChatMessageSave.h"
#import "SMClassesController.h"
#import "UIView+Badge.h"
#import "SingtonManager.h"


@interface SMHomePageController ()<UITableViewDelegate,UITableViewDataSource,SMSuperSalerCellDelegate,SMRightItemViewDelegate,SMHomePageCellSection0Delegate,SMHomePageCellSection1Delegate,HarpyDelegate,SMDataStationControllerDelegate>

@property (nonatomic ,strong)UITableView *tableview;/**< tableview */

@property (nonatomic ,assign)CGFloat todayIncomeHeight; /**< 今日收入高度 */

@property (nonatomic ,strong)NSMutableArray *arrSuperMan;/**< 销售达人数据 */

@property (nonatomic ,strong)NSMutableArray *arrAdd;/**< 广告数据 */

@property (nonatomic ,strong)SMLeftItemBtn *leftIconBtn;/**< 左上角头像 */

//@property(nonatomic,assign)NSInteger searchCount;

@property(nonatomic,strong)UILabel * companyName;

@property (nonatomic ,assign)BOOL isFirstComeIn; /**< 从lenaCloud那里第一次拿数据 */

@property (nonatomic ,copy)NSString *objectId;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrSection0Datas;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrOpening;/**< <#注释#> */

@property (nonatomic ,assign)BOOL section2IsOpen; /**< 第二组是否处于展开状态 */

@property (nonatomic ,strong)UIButton *moreBtn;/**< 第二组中更多按钮 */

@property (nonatomic ,assign)NSInteger changeCellHeight; /**< 如果是1 就是有高度   如果是2就是没高度 */

@property (nonatomic ,strong)SMHomePageCellSection1 *cell1;


@end

@implementation SMHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCheakVersion];
    
    [self setupNav];
    
    [self.view addSubview:self.tableview];
    
    [self SetupMJRefresh];
    
    [self refreshToken];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superManIconDidClick:) name:KSuperManIconClickNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellHeight0:) name:KChangeCellHeight0 object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_header beginRefreshing];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadNoti) name:RefreshUnreadNotification object:nil];
    //获取离线的未读
    [self Unread];
}

-(void)refreshUnreadNoti{
    [self Unread];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //实时更新
    //[self getSection0Datas];
    //返回控制器时清除红点
    [self Unread];
}

- (void)refreshToken{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:23 * 60 * 60 target:self selector:@selector(getNewToken) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)getNewToken{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:KRefreshToken];
    SMLog(@"refreshToken   getNewToken   %@",refreshToken);
    
    [[SKAPI shared] resetting];
    
    [[SKAPI shared] tokenRefresh:refreshToken result:^(id result, NSError *error) {
        if (!error) {
            NSString *accessToken = [[result objectForKey:@"result"] objectForKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:KAccessToken];
            
            [[SKAPI shared] appendToken];
            
            SMLog(@"token 刷新成功   %@",result);
        }else{
            SMLog(@"token 刷新失败   %@",error);
        }
    }];
    
}

-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *collectionViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getSection0Datas];
        
        [self getSuperMan];
        
        [self getAddDatas];
        
        //[self Unread];
    }];
    self.tableview.mj_header = collectionViewheader;
}



- (void)changeCellHeight0:(NSNotification *)noti{
    NSNumber *num = noti.userInfo[@"KChangeCellHeight0Key"];
    self.changeCellHeight = num.integerValue;
}


-(void)setupCheakVersion{
    //检查更新的第三方
    [[Harpy sharedInstance] setAppID:@"1095188682"];
    [[Harpy sharedInstance] setPresentingViewController:self];
    [[Harpy sharedInstance] setDelegate:self];
    //[[Harpy sharedInstance] setAlertControllerTintColor:@"[uicolor ]"];
    [[Harpy sharedInstance] setAppName:@"爽快云销"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    //[[Harpy sharedInstance] setCountryCode:@"zh_CN"];
    //[[Harpy sharedInstance] setForceLanguageLocalization:@"zh_CN"];
    [[Harpy sharedInstance] setDebugEnabled:YES];
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];//设置语言
    //检测更新
    [[Harpy sharedInstance] checkVersion];
}



- (void)getSection0Datas{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *cql = [NSString stringWithFormat:@"select * from StudioDataSet where UserId ='%@'",userId];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error){
        
        if (!error) {
            //SMLog(@"results:%@", result.results);
            self.isFirstComeIn = !result.results.count;
            if (result.results.count <= 0) {  //如果拿到的是空数组，就去 StudioDataSetDefaultList 这个表里面去拿数据
                [self getDataFromDefaultList];
            }else{ // 返回的有数据
                //SMLog(@"返回的有数据");
                //                SMLog(@"result   %@",result.results);
                AVObject *obj = result.results.firstObject;
                self.objectId = obj.objectId;
                self.arrSection0Datas = [SMDataStation mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"localData"] objectForKey:@"DataSet"]];

                //SMLog(@"obj   getSection0Datas  %@ ",[obj objectForKey:@"localData"]);
                [self.tableview reloadData];
            }
//            for (SMDataStation *data in self.arrSection0Datas) {
//                //SMLog(@"data.name   %@   %zd   [data.status class]   %@    data.type  %zd",data.name,data.status.integerValue,[data.status class] , data.type);
//            }
        }else{
            
            //SMLog(@"error doCloudQueryInBackgroundWithCQL %@",error);
            [self getDataFromDefaultList];
        }
    }];
}

- (void)getDataFromDefaultList{
    AVQuery *query = [AVQuery queryWithClassName:KLeanCloudFormNameDefault];
    [query getObjectInBackgroundWithId:KLeanCloudObjectIdDefault block:^(AVObject *object, NSError *error) {
        // object 就是 id 为 558e20cbe4b060308e3eb36c 的 Todo 对象实例
        
        if (!error) {
            self.arrSection0Datas = [SMDataStation mj_objectArrayWithKeyValuesArray:[[object objectForKey:@"localData"] objectForKey:@"DataSet"]];
            SMLog(@"getObjectInBackgroundWithId  %@",[[object objectForKey:@"localData"] objectForKey:@"DataSet"]);
            [self.tableview reloadData];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}


- (void)setupNav{
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftIconBtn = leftItemBtn;
    CGFloat wh;
    if (isIPhone5) {
        wh = KIconWH;
    }else if (isIPhone6){
        wh = KIconWH *KMatch6;
    }else if (isIPhone6p){
        wh = KIconWH * KMatch6p;
    }else if (KScreenHeight == 480){
        wh = KIconWH;
    }
    
    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMRightItemView *rightItemView = [SMRightItemView rightItemView];
    //    rightItemView.isCreatedByCareVC = YES;
    rightItemView.width = KRightItemWidth;
    rightItemView.height = KRightItemHeight;
    rightItemView.delegate = self;
    //    rightItemView.backgroundColor = [UIColor greenColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.companyName.textColor = [UIColor blackColor];
    //    NSString * companyName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
    //    label.text = companyName;
    self.companyName.font = [UIFont systemFontOfSize:KNavTitleFont *SMMatchWidth];
    self.companyName.textAlignment = NSTextAlignmentCenter;
    [self requestCompanyName];
    self.navigationItem.title = self.companyName.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:KNavTitleFont *SMMatchWidth];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

-(void)requestCompanyName{
    NSString * companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    [[SKAPI shared] queryCompanyById:companyId block:^(Company *company, NSError *error) {
        if (!error) {
            //获取到
            //SMLog(@"companyId  %@  company.engName  %@    %@",companyId,company.engName,company);
            self.companyName.text = company.engName;
            
            [[NSUserDefaults standardUserDefaults] setObject:company.engName forKey:KUserEngCompanyName];
            self.navigationItem.title = company.engName;
        }else{
            SMLog(@"queryCompanyById    %@",error);
        }
    }];
}


#pragma mark -- SMRightItemViewDelegate
- (void)searchBtnDidClick{
    SMLog(@"点击了 搜索按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
//    vc.categoryType = self.searchCount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanerBtnDidClick{
    SMLog(@"点击了 二维码按钮");
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftItemDidClick{
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMHomePageCellSection0Delegate
- (void)addBtnDidClick{
    SMLog(@"点击了 添加");
    SMDataStationController *vc = [SMDataStationController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshSection0Data{
    [self getSection0Datas];
}

- (void)superMansDidClick{
    SMLog(@"点击了达人榜");
    SMExpertViewController *vc = [[SMExpertViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:YES];
}
//广告
- (void)getAddDatas{
    [[SKAPI shared] queryMsg:65535 andLastTimestamp:0 block:^(id result, NSError *error) {
        [self.arrAdd removeAllObjects];
        if (!error) {
            [self.tableview.mj_header endRefreshing];
            for (Msg * msg in result) {
                [self.arrAdd addObject:msg];
                SMLog(@"msg =  %@",msg.content);
            }
//            [self.tableview reloadData];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self.tableview.mj_header endRefreshing];
            SMLog(@"%@",error);
        }
    }];
}

#pragma mark -- SMHomePageCellSection1Delegate
- (void)moreBtnDidClick2:(UIButton *)btn{
    SMLog(@"点击了 更多");
    self.moreBtn = btn;//没用
    self.section2IsOpen = btn.selected;
    [self Unread];
    [self.tableview reloadData];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
//    [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
}
//销售达人
- (void)getSuperMan{
    [[SKAPI shared] queryChampion:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            
            [self.arrSuperMan removeAllObjects];
            [self.tableview.mj_header endRefreshing];
//            if (!self.tableView.mj_footer.isRefreshing) {
//                [self.datasArray removeAllObjects];
//            }
            for (User * user in array) {
                [self.arrSuperMan addObject:user];
            }
            
//            [self.tableview reloadData];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:3];
            [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            //存数据
            //[self saveSqliteWithData:array];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_header endRefreshing];
//            });
        }else{
            
            [self.tableview.mj_header endRefreshing];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_header endRefreshing];
//            });
        }
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SMHomePageCellSection0 *cell = [SMHomePageCellSection0 cellWithTableView:tableView];
        cell.arrDatas = self.arrSection0Datas;
        cell.delegate = self;
//        self.todayIncomeHeight = cell.cell0Height;
        return cell;
    }else if (indexPath.section == 1){
        SMHomePageCellSection1 *cell = [SMHomePageCellSection1 cellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        SMAdvertisementCell *cell = [SMAdvertisementCell cellWithTableview:tableView];
        [cell refreshUI:self.arrAdd];
        return cell;
    }else if (indexPath.section == 3){
        SMSuperSalerCell *cell = [SMSuperSalerCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.datasArray = self.arrSuperMan;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        int rows = [self showRows];
//        SMLog(@"rows  heightForRowAtIndexPath %zd",rows);
//        if (self.changeCellHeight == 1) {
//            return (20 + 15 + 20 + 20 + 20) *SMMatchHeight + (10 + 10 + 15 + 20 + 15)*SMMatchHeight *rows + 30 *SMMatchHeight;
//        }else if (self.changeCellHeight == 2){
//            return (10 + 10 + 15 + 20 + 15)*SMMatchHeight *rows + 30 *SMMatchHeight;
//        }
        return (20 + 15 + 20 + 20 + 20) *SMMatchHeight + (10 + 10 + 15 + 20 + 15)*SMMatchHeight *rows + 25 *SMMatchHeight;
    }else if (indexPath.section == 1){
        
        int count;
        if (self.section2IsOpen) {
            count = 7;
        }else{
            count = 4;
        }
        int rows = (count + (4-1)) / 4;
        return 25 *SMMatchHeight + ((5 + 25 + 5 + 15 + 5) *SMMatchHeight) *rows + 25 *SMMatchHeight;
    }else if (indexPath.section == 2){
        return 50 *SMMatchHeight;
    }else if (indexPath.section == 3){
        
        if (isIPhone4) {
            return 180;
        }
        return 180 * SMMatchHeight;
    }
    return 0;
}

- (void)itemDidSelected:(NSInteger)type{
    if (type == 0) {
        SMLog(@"点击了 我的收入");
        SMMyInComeViewController * income = [SMMyInComeViewController new];
        [self.navigationController pushViewController:income animated:YES];
    }else if (type == 1){
        SMLog(@"点击了 合伙人");
        SMPartnerController *vc = [[SMPartnerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 2){
        SMLog(@"点击了 订单管理");
        SMNewOrderManagerViewController * orderManager = [SMNewOrderManagerViewController new];
        [self.navigationController pushViewController:orderManager animated:YES];
    }else if (type == 3){
        SMLog(@"点击了 伙伴连线");

        //SMPartnerConnectViewController *vc = [SMPartnerConnectViewController new];
        
        SMNewPartnerConnectViewController *vc = [[SMNewPartnerConnectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 4){
        SMLog(@"点击了 客户管理");
        SMCustomerController *vc = [SMCustomerController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //撤了
//    else if (type == 5){
//        SMLog(@"点击了 外勤签到");
//        SMSignInViewController *vc = [SMSignInViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else if (type == 5){
        SMLog(@"点击了 协同任务");
//        SMTaskLogViewController *vc = [SMTaskLogViewController new];

//        [self.navigationController pushViewController:vc animated:YES];
        // SMCreatTaskController *vc = [SMCreatTaskController new];
        TaskListViewController *vc = [[TaskListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 6){
        SMLog(@"点击了 客服连线");
        SMCustomerListViewController *vc = [[SMCustomerListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (int)showRows{
    [self.arrOpening removeAllObjects];
    for (SMDataStation *data in self.arrSection0Datas) {
        if (data.status.integerValue) { //开着的
            SMLog(@"data.name setArrDatas  %@   data.value  %@",data.name,data.value);
            [self.arrOpening addObject:data];
        }
    }
    
    int rows = (((int)self.arrOpening.count - 1) + 4 - 1) / 4;
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 0.01;
    }else{
        return 10;
    }
}

- (void)superManIconDidClick:(NSNotification *)note{
    SMLog(@"superManIconDidClick");
    User *user = note.userInfo[KSuperManIconClickNoteKey];
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 获取未读消息

-(void)Unread{
    //获取未读
    SingtonManager * sington = [SingtonManager sharedManager];
    //初始化
    [sington initial];
    MJWeakSelf
    [[SKAPI shared] queryOfflineMessages:^(id result, NSError *error) {
        if (!error) {
            //NSLog(@"未读%@",result[@"result"][@"messages"]);
            NSLog(@"queryOfflineMessages = %@-----error = %@",result,error);
            
            for (NSDictionary * dic in result[@"result"][@"messages"]) {
                
                Msg * msg = [Msg mj_objectWithKeyValues:dic];
                //好友请求消息
                if ([dic[@"type"] integerValue] == 30||[dic[@"type"] integerValue] == 31||[dic[@"type"] integerValue] == 32) {
                    [sington.friendArray addObject:msg];
                    sington.friendNum  = sington.friendArray.count;
                    
                //订单消息
                }else if([dic[@"type"] integerValue] == 10 ||[dic[@"type"] integerValue] == 11 ||[dic[@"type"] integerValue] == 12){
                    [sington.orderArray addObject:msg];
                    sington.orderNum  = sington.orderArray.count;
                //任务
                }else if ([dic[@"type"] integerValue] == 40 || [dic[@"type"] integerValue] == 41 ||[dic[@"type"] integerValue] == 42){
                    [sington.jobArray addObject:msg];
                    sington.jobNum  = sington.jobArray.count;
                }
            }
            
            if (sington.friendNum) {//伙伴连线
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowBageNotification object:nil userInfo:@{@"tag":KHuoBanLianXianTag}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:HiddenBageNotification object:nil userInfo:@{@"tag":KHuoBanLianXianTag}];
            }
            if (sington.orderNum) {//订单管理
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowBageNotification object:nil userInfo:@{@"tag":KOrderManagerTag}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:HiddenBageNotification object:nil userInfo:@{@"tag":KOrderManagerTag}];
            }
            if (sington.jobNum) {//协同任务
                [[NSNotificationCenter defaultCenter] postNotificationName:ShowBageNotification object:nil userInfo:@{@"tag":KXieTongTaskTag}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:HiddenBageNotification object:nil userInfo:@{@"tag":KXieTongTaskTag}];
            }
            
            if (sington.friendNum+sington.orderNum+sington.jobNum > 0) {
                [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:0];

            }else{
                [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];

            }
            //排除好友添加消息的重复
            [weakSelf repetitive];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

-(void)repetitive{
    //排除重复
    SingtonManager * sington = [SingtonManager sharedManager];
    NSMutableArray * mutArray = [NSMutableArray array];
    
    for (Msg * msg in sington.friendArray) {
        SMLog(@"%@",msg.body);
        NSMutableString * str = (NSMutableString *)msg.body;
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSInteger i=0;
        for ( i= 0; i<mutArray.count; i++) {
            Msg * message = mutArray[i];
            NSMutableString * str1 = (NSMutableString *)message.body;
            NSData * data = [str1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"userA"] isEqualToString:dic1[@"userA"]]) {
                break;
            }
        }
        if (i == mutArray.count) {
            [mutArray addObject:msg];
        }
    }
    
    //只改变Num 的值  数组不改
    sington.friendNum = mutArray.count;
}


#pragma mark -- 懒加载
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = KControllerBackGroundColor;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
    }
    return _tableview;
}

- (NSMutableArray *)arrAdd{
    if (_arrAdd == nil) {
        _arrAdd = [NSMutableArray array];
    }
    return _arrAdd;
}

- (NSMutableArray *)arrSuperMan{
    if (_arrSuperMan == nil) {
        _arrSuperMan = [NSMutableArray array];
    }
    return _arrSuperMan;
}

- (NSMutableArray *)arrOpening{
    if (_arrOpening == nil) {
        _arrOpening = [NSMutableArray array];
    }
    return _arrOpening;
}
@end
