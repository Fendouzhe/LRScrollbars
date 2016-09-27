//
//  SMCareViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  

#import "SMCareViewController.h"
#import "SMLeftItemBtn.h"
#import "SMRightItemView.h"
#import "SMPersonCenterViewController.h"
#import "YLFristVCHeardView.h"
#import "SMAdViewController.h"
#import "SMSuperSalerCell.h"
#import "SMCareVcBottomView.h"
#import "SMHotProductController.h"
#import "SMHotActionController.h"
#import "SMNewsController.h"
#import "SMExpertViewController.h"
#import "SMScannerViewController.h"
#import "SMSearchViewController.h"
#import "SMActionViewController.h"
#import "SMDetailStoreHouseController.h"
#import "SMNewsDetailController.h"
#import "SMProductDetailController.h"
#import "SMDiscoverBottomCell.h"
#import "SMDiscoverBottomHeaderView.h"
#import "SMPersonInfoViewController.h"
#import "SMTaskLogViewController.h"
#import "AppDelegate.h"
#import "SMPlaySound.h"
#import <AVIMClient.h>
#import <AVIMConversation.h>
#import "SMChatMessage.h"
#import "SMChatMessageFrame.h"
#import "SMPartnerConnectViewController.h"
#import "SMCustomContactViewController.h"
#import "SMConfirmPaymentController.h"
#import "SMNetworkViewController.h"
#import "LocalUser.h"
#import "SMQuickSalesManagementCell.h"
#import "SMAdvertisementCell.h"
#import "SMNewHotProductCell.h"
#import "SMNewProductSectionHeader.h"
#import "SMProductDetailController.h"
#import "SMMyInComeViewController.h"
#import <Harpy.h>
#import "SMPartnerController.h"
#import "SMPartnerDetailController.h"
#import "SMShelfTemplateViewController.h"
#import "SMNewOrderManagerViewController.h"
#import "SMAgreementView.h"
#import "SMPersonInfoViewController.h"
#import "SingtonManager.h"
#import "SMPartnerConnectViewController.h"
#import "SMTaskLogViewController.h"
#import "SMNewCustomManagerController.h"
#import "SMSignInViewController.h"
#import "SMDiscountCouponViewController.h"
#import "xuanfuwu.h"
#import "UIButton+Badge.h"
#import "SMHomePageController.h"
#import "SMNewPartnerConnectViewController.h"
#import "SMNewPartnerConnectViewController.h"
#import "SliderShopViewController.h"


@interface SMCareViewController ()<SMRightItemViewDelegate,YLFristVCHeardViewDelegate,SMSuperSalerCellDelegate,UIScrollViewDelegate,AVIMClientDelegate,SMQuickSalesManagementCellDelegate,HarpyDelegate,SMAgreementViewDeledate>


@property (nonatomic ,strong)SMHotProductController *vc1;

@property (nonatomic ,strong)SMHotActionController *vc2;

@property (nonatomic ,strong)SMNewsController *vc3;

@property (nonatomic ,copy)NSMutableArray * datasArray;

@property (nonatomic ,strong)SMDiscoverBottomCell *bottomCell;

@property(nonatomic,assign)NSInteger searchCount;

@property(nonatomic,strong)UILabel * companyName;

@property (nonatomic ,strong)SMDiscoverBottomHeaderView *discoverBottomHeaderView;

@property (nonatomic ,assign)BOOL isSelectingNews;
//快销管理cell的高度
@property (nonatomic ,assign)CGFloat quickSalesManagementHeight;

@property (nonatomic ,strong)NSArray *arrHotProducts;

@property (nonatomic ,strong)SMAgreementView *agreementView;

@property (nonatomic ,strong)UIView *cheatView;



@property(nonatomic,strong)SMLeftItemBtn * leftIconBtn;

@property (nonatomic ,assign)CGFloat section0CellHeight;

@property (nonatomic,strong) NSMutableArray *refreshImages;//刷新动画的图片数组
@property (nonatomic,strong) NSMutableArray *normalImages;//普通状态下的图片数组
@property (nonatomic,strong) NSTimer *timer;//模拟数据刷新需要的时间控制器
@property (nonatomic,assign) int time;

@property (nonatomic ,strong)SMQuickSalesManagementCell *cell0;/**<  */

@end

@implementation SMCareViewController

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(NSMutableArray *)adArray{
    if (!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    application.tabbar = self.tabBarController;
    application.OneVC = self;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
    
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.leftIconBtn.customImageView.image = image;
    }
    
    SingtonManager * sington = [SingtonManager sharedManager];
    if (sington.friendNum+sington.orderNum+sington.jobNum>0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:0];
        [self.cell0.myOrderBtn showBadgeWith:[NSString stringWithFormat:@"%zd",sington.friendNum+sington.orderNum+sington.jobNum]];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        [self.cell0.myOrderBtn removeBadge];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiaoBaiSe"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loadSqlite];
    [self setupNav];
    
    [self requestData];
    
    [self requestAdData];
    
    [self setupMJRefresh];
    
    [self addNotifications];
    
    [self addAppDeledate];
    
    [self getHotProducts];
    
    //检查版本更新
//    [self setupCheakVersion];
    
    [self refreshToken];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshUnread) name:RefreshUnreadNotification object:nil];
    //判断是否需要展示协议
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"KUserIsSigned"]) {
        [self userIsSigned];
    }
    SMLog(@"KUserIsSigned  %zd",[[NSUserDefaults standardUserDefaults] integerForKey:@"KUserIsSigned"]);
    
    //获取离线的未读
    [self Unread];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
//    SliderShopViewController *vc = [[SliderShopViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];  
    
}

-(void)RefreshUnread{
    [self Unread];
}

- (void)refreshToken{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:24 * 60 * 60 target:self selector:@selector(getNewToken) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)getNewToken{
//    [[SKAPI shared] tokenRefresh:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"token刷新成功");
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
}


- (void)userIsSigned{
    SMLog(@"userIsSigned");
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //蒙板
    UIView *cheatView = [[UIView alloc] init];
    self.cheatView = cheatView;
    cheatView.frame = window.bounds;
    cheatView.backgroundColor = [UIColor lightGrayColor];
    cheatView.alpha = 0.5;
    [window addSubview:cheatView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
    [cheatView addGestureRecognizer:tap];
    
    //协议
    SMAgreementView *agreementView = [SMAgreementView agreementView];
    self.agreementView = agreementView;
    agreementView.deledate = self;
    [window addSubview:agreementView];
    MJWeakSelf
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.cheatView.mas_top).with.offset(64);
        make.bottom.equalTo(weakSelf.cheatView.mas_bottom).with.offset(-49);
        make.left.equalTo(weakSelf.cheatView.mas_left).with.offset(50);
        make.right.equalTo(weakSelf.cheatView.mas_right).with.offset(-50);
    }];
//    [agreementView loadWebView];
    

    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"sk_xieyi.html" ofType:nil];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [agreementView.webVIew loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
 
}

- (void)cheatViewTap{
    SMLog(@"点击了 灰色蒙板");
    [self.cheatView removeFromSuperview];
    self.cheatView = nil;
    
    [self.agreementView removeFromSuperview];
    self.agreementView = nil;
}

#pragma mark -- SMAgreementViewDeledate
- (void)sureBtnDidClick{
    SMLog(@"sureBtnDidClick   SMAgreementViewDeledate");
    [self cheatViewTap];
    [[SKAPI shared] agreement:^(id result, NSError *error) {
        if (error) {
            SMLog(@"error   %@",error);
        }
    }];
    
}

//-(void)setupCheakVersion{
//    //检查更新的第三方
//    [[Harpy sharedInstance] setAppID:@"1095188682"];
//    [[Harpy sharedInstance] setPresentingViewController:self];
//    [[Harpy sharedInstance] setDelegate:self];
//    //[[Harpy sharedInstance] setAlertControllerTintColor:@"[uicolor ]"];
//    [[Harpy sharedInstance] setAppName:@"爽快"];
//    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
//    //[[Harpy sharedInstance] setCountryCode:@"zh_CN"];
//    //[[Harpy sharedInstance] setForceLanguageLocalization:@"zh_CN"];
//    [[Harpy sharedInstance] setDebugEnabled:YES];
//    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];//设置语言
//    //检测更新
//    [[Harpy sharedInstance] checkVersion];
//}

//- (void)userIsSigned{
//
//    //展示协议界面
//    SMAgreementView *cheatView = [SMAgreementView agreementView];
//    [self.view addSubview:cheatView];
//    cheatView.frame = self.view.bounds;
//    self.cheatView = cheatView;
//
//}


- (void)getHotProducts{
    MJWeakSelf
    [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:5 andSortType:SortType_Default andClassId:@"" andIsRecommend:(NSInteger)1  block:^(NSArray *array, NSError *error) {
        if (!error) {
            weakSelf.arrHotProducts = array;
            SMLog(@"array.count  self.arrHotProducts  %zd",array.count);
            [weakSelf.tableView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
        
    }];
}

- (void)addAppDeledate{
//    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    application.client.delegate = self;
    
//    [application.client openWithCallback:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            SMLog(@"%zd",succeeded);
//        }else{
//            SMLog(@"%@",error);
//        }
//    }];

//    SMNetworkViewController * network = [SMNetworkViewController new];
//    
//    [self.navigationController pushViewController:network animated:YES];

}

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCellDidClick:) name:KDiscoverNoteClickAction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCellDidClick:) name:KDiscoverNoteClickProduct object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsCellDidClick:) name:KDiscoverNoteClickNews object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disCoverNoteClickWithBtn:) name:KDisCoverNoteClickWithBtn object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superManIconDidClick:) name:KSuperManIconClickNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveLocalNotification) name:@"ReceiveLocalNotification" object:nil];
}

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //震动
    SMPlaySound *playSound =[[SMPlaySound alloc] initForPlayingVibrate];
    [playSound play];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"message"] = message;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveTypedMessage" object:self userInfo:dict];
    
    if ([message.clientId rangeOfString:@"shuangkuai-sales-"].location != NSNotFound) {
        
        //接收到爽快好友
        NSString * Id = [message.clientId substringWithRange:NSMakeRange(17, message.clientId.length-17)];
        
        SMChatMessage *messageRec = [[SMChatMessage alloc] init];
        
        messageRec.text = message.text;
        // 设置时间
        // 获得当前时间
        NSDate *nowDate = [NSDate date];
        // 创建一个格式化时间对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        // HH:mm 大写表示24小时  hh:mm 表示12小时
        formatter.dateFormat = @"HH:mm";
        // 将当前时间转换成字符串
        NSString *time = [formatter stringFromDate:nowDate];
        messageRec.time = time;
        messageRec.type = HMMessageTypeOther;
        
        //存时间戳
        NSTimeInterval timedouble = [nowDate timeIntervalSince1970];
        
        messageRec.unix = timedouble;
        
        SMChatMessageFrame * chatf = [SMChatMessageFrame messageFrameWithMeassge:messageRec];

        SMLog(@"id =  %@",Id);
        MJWeakSelf
        //请求到user
        [[SKAPI shared] queryUserProfile:Id block:^(id result, NSError *error) {
            if (!error) {
                //SMLog(@"%@",result);
                //通知那边存数据

                AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                if ([application.notesViewController isKindOfClass:[SMPartnerConnectViewController class]]) {
                    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                    dict1[KChatVcDisappearNotUserKey] = (User *)result;
                    dict1[KChatVcDisappearNotLastMessageKey] = chatf; //最后一条消息
                    [[NSNotificationCenter defaultCenter] postNotificationName:KChatVcDisappearNot object:weakSelf userInfo:dict1];
                }else{
                    SMPartnerConnectViewController * Vc = [SMPartnerConnectViewController new];
                    
                    [Vc receiveConversationWithUser:(User *)result andChatMessgaeFrame:chatf];
                }
               
            }else{
                SMLog(@"%@",error);
            }
        }];
    }else{
        //接收到客服的
        //通知客服列表刷新
        
        //创建消息
        SMChatMessage *messageRec = [[SMChatMessage alloc] init];
        
        messageRec.text = message.text;
        // 设置时间
        // 获得当前时间
        NSDate *nowDate = [NSDate date];
        // 创建一个格式化时间对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        // HH:mm 大写表示24小时  hh:mm 表示12小时
        formatter.dateFormat = @"HH:mm";
        // 将当前时间转换成字符串
        NSString *time = [formatter stringFromDate:nowDate];
        messageRec.time = time;
        messageRec.type = HMMessageTypeOther;
        
        messageRec.OtherClientId = message.clientId;
        //存时间戳
        NSTimeInterval timedouble = [nowDate timeIntervalSince1970];
        
        messageRec.unix = timedouble;
        messageRec.conversationId = conversation.conversationId;
        
        SMLog(@"pid =   %@",conversation.attributes);
        
        messageRec.pid = conversation.attributes[@"pid"];
        
        SMChatMessageFrame * chatf = [SMChatMessageFrame messageFrameWithMeassge:messageRec];
        
        //通知刷新数据库
        
        AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([application.notesViewController isKindOfClass:[SMCustomContactViewController class]]) {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            dict1[KChatVcDisappearNotUserKey] = conversation;
            dict1[KChatVcDisappearNotLastMessageKey] = chatf; //最后一条消息
            [[NSNotificationCenter defaultCenter] postNotificationName:KChatVcDisappearNotCustom object:self userInfo:dict1];
            
        }else{
            
            SMCustomContactViewController * Vc = [SMCustomContactViewController new];
            Vc.conversation = conversation;
            [Vc receiveConversationWithUser:nil andChatMessgaeFrame:chatf];
        }
    } 
}

-(void)ReceiveLocalNotification
{
    [self.navigationController pushViewController:[SMTaskLogViewController new] animated:YES];
}

- (void)superManIconDidClick:(NSNotification *)note{
    SMLog(@"superManIconDidClick");
    User *user = note.userInfo[KSuperManIconClickNoteKey];
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)disCoverNoteClickWithBtn:(NSNotification *)note{
    UIButton *btn = note.userInfo[KDisCoverNoteClickWithBtnKey];
    SMLog(@"点击 %zd",btn.tag);
    self.searchCount = btn.tag;
    
    switch (btn.tag) {
        case 0://热销商品
            self.bottomCell.vc1.view.hidden = NO;
            self.bottomCell.vc2.view.hidden = YES;
            self.bottomCell.vc3.view.hidden = YES;
            self.isSelectingNews = NO;
            break;
        case 1://活动
            self.bottomCell.vc1.view.hidden = YES;
            self.bottomCell.vc2.view.hidden = NO;
            self.bottomCell.vc3.view.hidden = YES;
            break;
        case 2://最新动态
            self.bottomCell.vc1.view.hidden = YES;
            self.bottomCell.vc2.view.hidden = YES;
            self.bottomCell.vc3.view.hidden = NO;
            self.searchCount = 3;
            self.isSelectingNews = YES;
            break;
            
        default:
            break;
    }
}

- (void)newsCellDidClick:(NSNotification *)note{
    News *news = note.userInfo[KDiscoverNoteClickNewsKey];
    SMLog(@" news传递的对象   %@",news);
    SMNewsDetailController *vc = [[SMNewsDetailController alloc] init];
    vc.news = news;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)productCellDidClick:(NSNotification *)note{
    Product *product = note.userInfo[KDiscoverNoteClickProductKey];
    SMLog(@"product  productCellDidClick  %@",product);
//    SMDetailStoreHouseController *detailVc = [[SMDetailStoreHouseController alloc] initWithStyle:UITableViewStyleGrouped];
//    detailVc.product = product;
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    vc.isPushCounter = NO;
    vc.product = product;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionCellDidClick:(NSNotification *)note{
    Activity *action = note.userInfo[KDiscoverNoteClickActionKey];
    SMActionViewController *actionVc = [[SMActionViewController alloc] init];
    //模型赋值
    actionVc.activity = action;
    [self.navigationController pushViewController:actionVc animated:YES];
}

//- (void)setupFootterView{
////    UIView *view = [[UIView alloc] init];
////    view.backgroundColor = [UIColor greenColor];
////    self.tableView.tableFooterView = view;
////    view.height = KScreenHeight;
////    view.width = KScreenWidth;
//    
//    SMCareVcBottomView *bottomView = [SMCareVcBottomView careVcBottomView];
//    bottomView.height = KScreenHeight + 40;
//    bottomView.width = KScreenWidth;
//    self.tableView.tableFooterView = bottomView;
//    self.vc1 = bottomView.vc1;
//    self.vc2 = bottomView.vc2;
//    self.vc3 = bottomView.vc3;
//}

- (void)setupHeaderView{
    CGFloat height;
    if (isIPhone5) {
        height = KDiscoverLunBoH;
    }else if (isIPhone6){
        height = KDiscoverLunBoH *KMatch6;
    }else if (isIPhone6p){
        height = KDiscoverLunBoH *KMatch6p;
    }
    
    //创建轮播器
    YLFristVCHeardView *headerView = [[YLFristVCHeardView alloc] init];
    headerView.delegate = self;
    headerView.frame = CGRectMake(0, 0, KScreenWidth, height);
    self.tableView.tableHeaderView = headerView;
    
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
    }

    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.companyName.textColor = [UIColor blackColor];
//    NSString * companyName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
//    label.text = companyName;
    self.companyName.font = [UIFont systemFontOfSize:20];
    self.companyName.textAlignment = NSTextAlignmentCenter;
    
    
    SMRightItemView *rightItemView = [SMRightItemView rightItemView];
//    rightItemView.isCreatedByCareVC = YES;
    rightItemView.width = KRightItemWidth;
    rightItemView.height = KRightItemHeight;
    rightItemView.delegate = self;
//    rightItemView.backgroundColor = [UIColor greenColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestCompanyName];
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KUserEngCompanyName"]) {
//        self.companyName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"KUserEngCompanyName"];
//    }else{
//        //获取
//        [self requestCompanyName];
//    }
    
    self.navigationItem.title = self.companyName.text;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    self.tabBarController.tabBar.translucent = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = KControllerBackGroundColor;
}

- (void)leftItemDidClick:(UIButton *)btn{
    SMLog(@"点击了左上角的头像按钮  %@",[btn class]);
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMRightItemViewDelegate
- (void)searchBtnDidClick{
    SMLog(@"点击了 搜索按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = self.searchCount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanerBtnDidClick{
    SMLog(@"点击了 二维码按钮");
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- YLFristVCHeardViewDelegate
//监听用户点击了哪张图片，并做相应的响应事件
- (void)headerViewDidClickedPage:(NSInteger)page imagePath:(NSString *)imagePath{
    SMLog(@"点击了 第%zd 张图片",page);
    //跳转页面加载
    SMAdViewController *adVc = [[SMAdViewController alloc] init];
    adVc.imagePath = imagePath;
    [self.navigationController pushViewController:adVc animated:YES];
}

#pragma mark -- 懒加载
- (NSArray *)arrHotProducts{
    if (_arrHotProducts == nil) {
        _arrHotProducts = [NSArray array];
    }
    return _arrHotProducts;
}

- (void)superMansDidClick{
    SMLog(@"点击了达人榜");
    SMExpertViewController *vc = [[SMExpertViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:YES];    
}

#pragma mark -- UITableView 数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.arrHotProducts.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        SMQuickSalesManagementCell *cell = [SMQuickSalesManagementCell cellWithTableview:tableView];
        self.cell0 = cell;
        cell.delegate = self;
//        self.quickSalesManagementHeight = cell.cellHeight;
//        SMLog(@"cell.cellHeight   %f",cell.cellHeight);
//        self.section0CellHeight = cell.cellHeight;
//        SMLog(@"cell.cellHeight   %f",cell.cellHeight);
        return cell;
    }else if (indexPath.section == 1){
        SMAdvertisementCell *cell = [SMAdvertisementCell cellWithTableview:tableView];
        [cell refreshUI:self.adArray];
        return cell;
    }else if (indexPath.section == 2){
        SMSuperSalerCell *cell = [SMSuperSalerCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.datasArray = self.datasArray;
        return cell;
    }
//    else if (indexPath.section == 3){
//        SMNewHotProductCell *cell = [SMNewHotProductCell cellWithTableView:tableView];
//        if (self.arrHotProducts.count > 0) {
//            cell.product = self.arrHotProducts[indexPath.row];
//        }
//        return cell;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
//        if (isIPhone5) {
//            height = 137 *2;
//        }else if (isIPhone6){
//            height = 145 *2;
//        }else if (isIPhone6p){
//            height = 151 *2;
//        }
        CGFloat marginLeftRight = 25 *SMMatchHeight;
        CGFloat marginUpDown = 15 *SMMatchHeight;
        CGFloat labelHeight = 15 *SMMatchHeight;
        CGFloat wh = (KScreenWidth - marginLeftRight * 5) / 4.0;
        return 20 *SMMatchHeight + marginUpDown + (wh + marginUpDown + labelHeight + marginLeftRight) *2;

    }else if (indexPath.section == 1){
        return 50 *SMMatchHeight;
    }else if (indexPath.section == 2){
//        if (isIPhone5) {
//            height = 180;
//        }else if (isIPhone6){
//            height = 180 *KMatch6 - 11;
//        }else if (isIPhone6p){
//            height = 180 *KMatch6p - 13;
//        }
        
        return 180 *SMMatchHeight;
    }
//    else if (indexPath.section == 3){
//        if (isIPhone5) {
//            height = 175;
//        }else if (isIPhone6){
//            height = 175 *KMatch6Height;
//        }else if (isIPhone6p){
//            height = 175 *KMatch6pHeight;
//        }
//    }
    
    return height;
}
//cell动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        cell.alpha = 0.0;
    
        [UIView animateWithDuration:1 animations:^{
            cell.alpha = 1.0;
        }];
    
    
    
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //设置动画时间为0.25秒,xy方向缩放的最终值为1
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
    
    
    
    
    //    CATransform3D transform3D = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 1.0);
    //    // 定义 cell 的初始状态
    //    cell.alpha = 0.0;
    //    cell.layer.transform = transform3D;
    //    cell.layer.anchorPoint = CGPointMake(0.0, 0.5); // 设置锚点位置；默认为中心点(0.5, 0.5)
    //
    //    // 定义 cell 的最终状态，执行动画效果
    //    // 方式一：普通操作设置动画
    ////        [UIView beginAnimations:@"transform" context:NULL];
    ////        [UIView setAnimationDuration:0.5];
    ////        cell.alpha = 1.0;
    ////        cell.layer.transform = CATransform3DIdentity;
    ////        CGRect rect = cell.frame;
    ////        rect.origin.x = 0.0;
    ////        cell.frame = rect;
    ////        [UIView commitAnimations];
    //
    //    // 方式二：代码块设置动画
    //    [UIView animateWithDuration:0.5 animations:^{
    //        cell.alpha = 1.0;
    //        cell.layer.transform = CATransform3DIdentity;
    //        CGRect rect = cell.frame;
    //        rect.origin.x = 0.0;
    //        cell.frame = rect;
    //    }];
    //    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
////    SMLog(@"NSStringFromCGRect(self.discoverBottomHeaderView.frame)   %@",NSStringFromCGRect(self.discoverBottomHeaderView.frame));  414   445
//    SMLog(@"NSStringFromCGPoint(self.tableView.contentOffset)   %@",NSStringFromCGPoint(self.tableView.contentOffset));
//    CGPoint point = self.tableView.contentOffset;
//
//    CGFloat y;
//    if (isIPhone5) {
//        y = 351;
//    }else if (isIPhone6){
////        y = 351 *KMatch6Height;
//        y = 362;
//    }else if (isIPhone6p){
////        y = 351 *KMatch6pHeight;
//        y = 390;
//    }
//
//    if (point.y <= y) {
////        self.vc1.collectionView.scrollEnabled = NO;
////        self.vc3.tableView.scrollEnabled = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNewsCanNotScroll object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KProductCanNotScroll object:nil];
//    }else{
//        SMLog(@">352");
////        self.vc1.collectionView.scrollEnabled = YES;
////        self.vc3.tableView.scrollEnabled = YES;
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:KProductCanScroll object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNewsCanScroll object:nil];
//    }
//}

#pragma mark -- tableView 数据源及代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        SMNewProductSectionHeader *view = [SMNewProductSectionHeader newProductSectionHeader];
        return view;
    }
    return nil;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    if (section == 3) {
//        CGFloat height;
//        if (isIPhone5) {
//            height = 40;
//        }else if (isIPhone6){
//            height = 40 *KMatch6;
//        }else if (isIPhone6p){
//            height = 40 *KMatch6p;
//        }
//        return height;
//    }
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {//点击热销产品
        SMProductDetailController *vc = [[SMProductDetailController alloc] init];
        vc.product = self.arrHotProducts[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- SMQuickSalesManagementCellDelegate

- (void)discountBtnDidClick{
    SMLog(@"点击了 优惠券兑换");
    SMDiscountCouponViewController *vc = [SMDiscountCouponViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signInBtnDidClick{
    SMLog(@"点击了 外勤签到");
    SMSignInViewController *vc = [SMSignInViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customerBtnDidClick{
    SMLog(@"点击了客户管理");
    SMNewCustomManagerController *vc = [SMNewCustomManagerController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)taskBtnDidClick{
    SMLog(@"点击了任务日程");
    SMTaskLogViewController *vc = [SMTaskLogViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)connectBtnDidClick{
    SMLog(@"点击了 伙伴连线");
//    SMPartnerConnectViewController *vc = [SMPartnerConnectViewController new];
    SMNewPartnerConnectViewController *vc = [[SMNewPartnerConnectViewController alloc] init];
//    SMNewPartnerConnectViewController *vc = [[SMNewPartnerConnectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myOrderBtnBtnDidClick{
    SMLog(@"点击了 我的订单");

    SMNewOrderManagerViewController * orderManager = [SMNewOrderManagerViewController new];
    [self.navigationController pushViewController:orderManager animated:YES];

}

- (void)myIncomeBtnDidClick{
    SMLog(@"点击了 我的收入");
    SMMyInComeViewController * income = [SMMyInComeViewController new];
    [self.navigationController pushViewController:income animated:YES];
    
}

- (void)myCounterDidClick{
    SMLog(@"点击了 我的柜台");
    SMShelfTemplateViewController *shelfVc = [[SMShelfTemplateViewController alloc] init];
    [self.navigationController pushViewController:shelfVc animated:YES];
}

- (void)partnerBtnDidClick{
    SMLog(@"点击了 合伙人");
    SMPartnerController *vc = [[SMPartnerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupMJRefresh{
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    [header setImages:self.normalImages forState:MJRefreshStateIdle];
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden= YES;//如果不隐藏这个会默认 图片在最左边不是在中间
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        
//        
//        //发送通知 然后刷新
//        [self requestData];
//        [self requestAdData];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"homePageRefresh" object:nil];
//    }];
//    self.tableView.mj_header = header;
    
}

#pragma mark -- 懒加载 菊花图片
- (NSMutableArray *)normalImages{
    if (_normalImages == nil) {
        _normalImages = [[NSMutableArray alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载icon1"]];
        [self.normalImages addObject:image];
    }
    return _normalImages;
}

//正在刷新状态下的图片
- (NSMutableArray *)refreshImages{
    if (_refreshImages == nil) {
        _refreshImages = [[NSMutableArray alloc] init];
        //				循环添加图片
        for (NSUInteger i = 1; i<=10; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载icon%ld", i]];
            [self.refreshImages addObject:image];
        }
    }
    return _refreshImages;
}

- (void)loadNewData{
    //模拟刷新的时间
    self.timer  =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    self.time = 3;
    
    [self requestData];
    [self requestAdData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homePageRefresh" object:nil];
}

-(void)timeAction {
    self.time --;
    SMLog(@"%d",self.time);
    if (self.time == 0) {
        //		刷新数据
        [self.tableView reloadData];
        //		停止刷新
        [self.tableView.mj_header endRefreshing];
        [self.timer invalidate];
    }
}

-(void)requestData{
    //获取数据啦
    MJWeakSelf
    [[SKAPI shared] queryChampion:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.datasArray removeAllObjects];
            }
            for (User * user in array) {
                [self.datasArray addObject:user];
            }
            
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                               [weakSelf.tableView reloadData];
                               
                           });
//            [self.tableView reloadData];
//            [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
            //存数据
            //[self saveSqliteWithData:array];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }
    }];
}

-(void)requestCompanyName{
    NSString * companyId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    MJWeakSelf
    [[SKAPI shared] queryCompanyById:companyId block:^(Company *company, NSError *error) {
        if (!error) {
            //获取到
            SMLog(@"companyId  %@  company.engName  %@    %@",companyId,company.engName,company);
            weakSelf.companyName.text = company.engName;
            
            [[NSUserDefaults standardUserDefaults] setObject:company.engName forKey:@"KUserEngCompanyName"];
            weakSelf.navigationItem.title = company.engName;
        }else{
            SMLog(@"%@",error);
        }
    }];
}

-(void)saveSqliteWithData:(NSArray *)array
{
    //存之前删掉
    NSArray * localArray = [LocalUser MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (LocalUser * localUser in localArray) {
            [localUser MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    
    //再存起来
    
    for (NSInteger i=0; i<array.count; i++) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            User * user = array[i];
            LocalUser * localUser = [LocalUser MR_createEntityInContext:localContext];
            localUser.userid = user.userid;
            localUser.name = user.name;
            localUser.gender = [NSNumber numberWithInteger:user.gender];
            localUser.password = user.password;
            localUser.email = user.email;
            localUser.phone = user.phone;
            localUser.portrait = user.portrait;
            //localUser.id = user.id;
            localUser.intro = user.intro;
            localUser.follows = [NSNumber numberWithInteger:user.follows];
            localUser.tweets = [NSNumber numberWithInteger:user.tweets];
            localUser.rtckey = user.rtcKey;
            localUser.address = user.address;
            localUser.telephone = user.telephone;
            localUser.companyName = user.companyName;
            localUser.sumMoney = user.sumMoney;
            localUser.companyId = user.companyId;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
        }];
    }
}

// 存的是 首页的冠军榜
-(void)loadSqlite{
    //[self requestData];
    //清空数组
    [self.datasArray removeAllObjects];
    
    NSArray * localArray = [LocalUser MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    if (localArray.count>=3) {
        for (LocalUser * localUser in localArray) {
            User * user = [User new];
            user.userid = localUser.userid;
            user.name = localUser.name;
            user.gender = localUser.gender.integerValue;
            user.password = localUser.password;
            user.email = localUser.email;
            user.phone = localUser.phone;
            user.portrait = localUser.portrait;
            //localUser.id = user.id;
            user.intro = localUser.intro;
            user.follows = localUser.follows.integerValue;
            user.tweets = localUser.tweets.integerValue;
            user.rtcKey = localUser.rtckey;
            user.address = localUser.address;
            user.telephone = localUser.telephone;
            user.companyName = localUser.companyName;
            user.sumMoney = localUser.sumMoney;
            user.companyId = localUser.companyId;
            [self.datasArray addObject:user];
        }
    }else{
        [self requestData];
    }
}


- (void)dealloc
{
    SMLog(@"首页dealloc");
}

-(void)requestAdData{
    MJWeakSelf
    [[SKAPI shared] queryMsg:65535 andLastTimestamp:0 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            for (Msg * msg in result) {
                [weakSelf.adArray addObject:msg];
                SMLog(@"msg =  %@",msg.content);
            }
            
            [weakSelf.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
}


-(void)Unread{
    //获取未读
    SingtonManager * sington = [SingtonManager sharedManager];
    //初始化
    [sington initial];
    MJWeakSelf
    [[SKAPI shared] queryOfflineMessages:^(id result, NSError *error) {
        if (!error) {
            
            //排重
            SMLog(@"未读%@",result[@"result"][@"messages"]);
            for (NSDictionary * dic in result[@"result"][@"messages"]) {
                Msg * msg = [Msg mj_objectWithKeyValues:dic];
                if ([dic[@"type"] integerValue] == 30||[dic[@"type"] integerValue] == 31||[dic[@"type"] integerValue] == 32) {
                    [sington.friendArray addObject:msg];
                    
                    sington.friendNum  = sington.friendArray.count;
                    
                    
                }else if([dic[@"type"] integerValue] == 10 ||[dic[@"type"] integerValue] == 11 ||[dic[@"type"] integerValue] == 12){
                    [sington.orderArray addObject:msg];
                    sington.orderNum  = sington.orderArray.count;
                }else if ([dic[@"type"] integerValue] == 40 || [dic[@"type"] integerValue] == 41 ||[dic[@"type"] integerValue] == 42){
                    [sington.jobArray addObject:msg];
                    sington.jobNum  = sington.jobArray.count;
                }
            }
            
            if (sington.friendNum+sington.orderNum+sington.jobNum > 0) {
                [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:0];
                [weakSelf.cell0.myOrderBtn showBadgeWith:[NSString stringWithFormat:@"%zd",sington.friendNum+sington.orderNum + sington.jobNum]];
            }else{
                [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];
                [weakSelf.cell0.myOrderBtn removeBadge];
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
@end
