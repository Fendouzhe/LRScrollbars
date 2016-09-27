//
//  SMNewsController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewsController.h"
#import "SMShelfDiscountCell.h"
#import "SMCompanyHouseCell.h"
#import "LocalNews.h"
#import "AppDelegate.h"


@interface SMNewsController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic ,strong)NSMutableArray *arrDatas;

@property(nonatomic,assign)NSInteger page;

@end

@implementation SMNewsController

-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业动态";
    
    [self.view addSubview:self.tableView];
    
    //[self loadDatas];
    [self loadSqlite];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.page = 1;
    
    [self setupMJRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"homePageRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canNotScroll) name:KNewsCanNotScroll object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsCanScroll) name:KNewsCanScroll object:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    SMLog(@"NSStringFromCGPoint(self.tableView.contentOffset)   %@",NSStringFromCGPoint(self.tableView.contentOffset));
    if (self.tableView.contentOffset.y < 0) {
        self.tableView.scrollEnabled  = NO;
    }
}

- (void)newsCanScroll{
    self.tableView.scrollEnabled = YES;
}

- (void)canNotScroll{
    self.tableView.scrollEnabled = NO;
}

- (void)loadView{ //自定义设置控制器的View(可改变其类型)
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight - KTabBarHeight)];
    self.view = bgview;
}

-(void)refreshData{
    self.page = 1;
    [self loadDatas];
}
- (void)loadDatas{
    //获取到公司ID
    NSString * ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    [[SKAPI shared] queryNewsByCompanyId:ID andKeyword:self.keyWord andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array.count>0) {
                if (!self.tableView.mj_footer.isRefreshing) {
                    [self.arrDatas removeAllObjects];
                }
                for (News *n in array) {
                    [self.arrDatas addObject:n];
                }
                
                [self saveSqliteWithArray:self.arrDatas];
                SMLog(@"arrDatas queryNewsByCompanyId   %@",self.arrDatas);
                [self.tableView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshing];
                });
            }else
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
           
        }else{
            SMLog(@"error   %@",error);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCompanyHouseCell *cell = [SMCompanyHouseCell cellWithTableVIew:tableView];
    cell.news = self.arrDatas[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 102;
    }else if (isIPhone6){
        height = 102 *KMatch6;
    }else if (isIPhone6p){
        height = 102 *KMatch6p;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMLog(@"新闻 didSelectRowAtIndexPath   %zd",indexPath.row);
    News *news = self.arrDatas[indexPath.section];
    
    SMLog(@" news传递的对象  didSelectRowAtIndexPath   %@",news);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KDiscoverNoteClickNewsKey] = news;
    [[NSNotificationCenter defaultCenter] postNotificationName:KDiscoverNoteClickNews object:self userInfo:dict];
    
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.hidden = YES;
        _tableView.frame = self.view.bounds;
    }
    return _tableView;
}

- (NSMutableArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

-(void)setupMJRefresh
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDatas];
    }];
    self.tableView.mj_footer = footer;
//    self.tableView.mj_footer.automaticallyHidden = YES;
    
}


-(void)saveSqliteWithArray:(NSArray *)array
{
    //缓存前  要删掉
    
    NSArray * localArray = [LocalNews MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalNews * news in localArray) {
        
        [news MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    for (News * news in array) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            LocalNews * localNews = [LocalNews MR_createEntityInContext:localContext];
            localNews.id = news.id;
            localNews.companyId = news.companyId;
            localNews.content = news.content;
            localNews.title = news.title;
            localNews.createAt = [NSNumber numberWithInteger:news.createAt];
            localNews.lastUpdate = [NSNumber numberWithInteger:news.lastUpdate];
            localNews.imagePaths = news.imagePaths;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
        }];
    }
}

-(void)loadSqlite
{
    NSArray * array = [LocalNews MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [self.arrDatas removeAllObjects]; 
    if (array.count>0) {
        for (LocalNews * localNews in array) {
            News * news = [News new];
            news.id = localNews.id;
            news.companyId = localNews.companyId;
            news.content = localNews.content;
            news.title = localNews.title;
            news.createAt = localNews.createAt.integerValue;
            news.lastUpdate = localNews.lastUpdate.integerValue;
            news.imagePaths = localNews.imagePaths;
            SMLog(@"title =    %@",news.title);
            [self.arrDatas addObject:news];
        }
        [self.tableView reloadData];
    }else
    {
        [self loadDatas];
    }
}

@end
