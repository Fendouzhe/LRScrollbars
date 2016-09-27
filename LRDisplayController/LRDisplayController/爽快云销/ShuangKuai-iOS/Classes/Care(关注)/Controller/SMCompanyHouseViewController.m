//
//  SMCompanyHouseViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCompanyHouseViewController.h"
#import "SMSearchBar.h"
#import "SMScanerBtn.h"
#import "SMSearchHeaderView.h"
#import "SMCompanyHouseCell.h"
#import "SMCompanyHouseView.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface SMCompanyHouseViewController ()

@property (nonatomic ,strong)SMSearchHeaderView *SearchHeader;
//@property (nonatomic ,strong)UITapGestureRecognizer *tap;

/**
 *  当前显示的是哪一页
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic ,strong)Reachability *reach;
@end

@implementation SMCompanyHouseViewController

#pragma mark -- 懒加载
//- (UITapGestureRecognizer *)tap{
//    if (_tap == nil) {
//        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//    }
//    return _tap;
//}

- (NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reach = [Reachability reachabilityWithHostName:@"baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    [self.reach startNotifier];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyTapClick) name:@"companyHouseTapClick" object:nil];
    
    [self setupNav];
    
    [self setupSearchHeaderView];
    
    //liyongjie add
    [self setupRefreshHeaderAndFooter];
}
/**
 *  检测网络状态
 */
- (void)reachabilityChanged{
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            SMLog(@"没有联网");
            self.datas = [NSMutableArray arrayWithContentsOfFile:KCompanyHousePath];
            SMLog(@"%@",KCompanyHousePath);
            break;
        case ReachableViaWiFi:
            SMLog(@"wifi上网");
            break;
        case ReachableViaWWAN:
            //手机上模拟才写的这段代码，后面可以删掉这句代码
            self.datas = [NSMutableArray arrayWithContentsOfFile:KCompanyHousePath];
            SMLog(@"手机流量上网");
            break;
        default:
            break;
    }
}

- (void)dealloc{
    [self.reach stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 生命周期
//liyongjie add
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadMoreData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //将已下载好的数据缓存到本地中
//    NSString *homePath = NSHomeDirectory();
//    NSString *companyHousePath = [NSHomeDirectory() stringByAppendingPathComponent:@"companyHouse"];
    
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
//    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    
//    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"companyHouse.plist"];
    
    
//    [self.datas writeToFile:KCompanyHousePath atomically:YES];
//    SMLog(@"viewWillDisappear     %@",KCompanyHousePath);
//    SMLog(@"%@",self.datas);
    
}

- (void)companyTapClick{
    SMLog(@"点击了 公司说明 ");
    [self.SearchHeader.searchField resignFirstResponder];
}

//liyongjie add
- (void)setupRefreshHeaderAndFooter {
    __weak typeof (self) weakSelf = self;
    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
//    header.automaticallyChangeAlpha = YES;
    footer.automaticallyRefresh = NO;
//    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

//liyongjie add
- (void)loadMoreData {

    self.currentPage++;
    [[SKAPI shared] queryCompanyByName:@"" isRecommend:FALSE andPage:self.currentPage andSize:4 block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            if (array.count > 0) {
                for (Company *company in array) {
                    [self.datas addObject:company];
                    //写入本地  这方法不太好
                    [NSKeyedArchiver archiveRootObject:company toFile:KCompanyHousePath];
                    SMLog(@"%@",KCompanyHousePath);
                }

                // 刷新表格
                [self.tableView reloadData];
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                [self.tableView.mj_footer endRefreshing];
            } else {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            SMLog(@"%@",error);
        }
    }];
}

- (void)setupSearchHeaderView{
    
    SMSearchHeaderView *SearchHeader = [SMSearchHeaderView searchHeaderView];
    SearchHeader.width = KScreenWidth;
    SearchHeader.height = 39;
    self.tableView.tableHeaderView = SearchHeader;
    //回调刷新
    SearchHeader.refreshblock = ^(NSMutableArray * array){
        [self.datas removeAllObjects];
        self.datas = [array mutableCopy];
        [self.tableView reloadData];
    };
    self.SearchHeader = SearchHeader;
}

- (void)setupNav{
    
    //搜索栏
//    SMSearchBar *searchBar = [SMSearchBar searchBar];
//    self.searchBar = searchBar;
//    searchBar.width = 210;
//    searchBar.height = 22;
//    self.navigationItem.titleView = searchBar;
    self.tableView.backgroundColor = KControllerBackGroundColor;
    self.title = @"企业库";
    
    //二维码
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![self.SearchHeader isExclusiveTouch]) {
        [self.SearchHeader resignFirstResponder];
    }
    [self.SearchHeader resignFirstResponder];
}

- (void)scanerBtnDidClick{
    [self.SearchHeader resignFirstResponder];
    SMLog(@"点击了扫描二维码的按钮");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return 10;
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMCompanyHouseCell *cell = [SMCompanyHouseCell cellWithTableVIew:tableView];
    
    
    //liyongjie add
    Company *company = self.datas[indexPath.row];
    cell.companyHouseView.companyInfoLabel.text =  company.descr;
    cell.companyHouseView.companyName.text =  company.name;
    cell.companyHouseView.Id = company.id;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:company.logoPath]];
    [cell.companyHouseView.iconBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    //------------------------------------------------
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 94;
    }else if (isIPhone6){
        height = 94 *KMatch6;
    }else if (isIPhone6p){
        height = 94 *KMatch6p;
    }
    return height;
}

@end
