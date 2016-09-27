//
//  SMHotActionController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHotActionController.h"
#import "SMAllActionTableViewCell.h"
#import "LocalActivity.h"
#import "AppDelegate.h"

@interface SMHotActionController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *arrDatas;

@property(nonatomic,assign)NSInteger page;

@end

@implementation SMHotActionController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.page = 1;
    
    //[self loadDatas];
    [self loadSqlite];
    
    [self setupMJRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"homePageRefresh" object:nil];
}

- (void)loadView{ //自定义设置控制器的View(可改变其类型)
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight - KTabBarHeight)];
    self.view = bgview;
}

-(void)refreshData
{
    self.page = 1;
    [self loadDatas];
}

- (void)loadDatas{
    
    //获取到公司id
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    [[SKAPI shared] queryActivityByCompanyId:Id andKeyword:@"" andIsRecommend:YES andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array.count>0) {
                if (!self.tableView.mj_footer.isRefreshing) {
                    [self.arrDatas removeAllObjects];
                }
                for (Activity *a in array) {
                    [self.arrDatas addObject:a];
                }
                SMLog(@"arrDatas queryNewsByCompanyId   %@",self.arrDatas);
                [self saveSqliteWithArray:self.arrDatas];
                [self.tableView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshing];
                });
            }else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                });
            }
        }else{
            SMLog(@"%@",error);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }
        
    }];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMAllActionTableViewCell *cell = [SMAllActionTableViewCell cellWithTableView:tableView];
    //        cell.gouBtn.hidden = YES;
    Activity *action = self.arrDatas[indexPath.row];
    cell.action = action;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 155;
    }else if (isIPhone6){
        height = 155 *KMatch6;
    }else if (isIPhone6p){
        height = 155 *KMatch6p;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"didSelectRowAtIndexPath    %zd",indexPath.row);

    Activity *activity = self.arrDatas[indexPath.row];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KDiscoverNoteClickActionKey] = activity;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KDiscoverNoteClickAction object:self userInfo:dict];
}



#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [UIColor yellowColor];
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
}


//需要缓存产品  添加字段区分在哪边缓存的

-(void)saveSqliteWithArray:(NSArray *)array
{
    
    NSArray * localArray = [LocalActivity MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalActivity * action in localArray) {
        if (action.isPlace .integerValue == 0) {
            [action MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (Activity * activity in array) {
            LocalActivity * localActivity = [LocalActivity MR_createEntityInContext:localContext];
            localActivity.id = activity.id;
            localActivity.createAt = [NSNumber numberWithInteger:activity.createAt];
            localActivity.content = activity.content;
            localActivity.name = activity.name;
            localActivity.title = activity.title;
            localActivity.lastUpdate = [NSNumber numberWithInteger:activity.lastUpdate];
            localActivity.companyId = activity.companyId;
            localActivity.startTime = [NSNumber numberWithInteger:activity.startTime];
            localActivity.endTime = [NSNumber numberWithInteger:activity.endTime];
            localActivity.imagePaths = activity.imagePaths;
            localActivity.isPlace = [NSNumber numberWithInteger:0];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}

-(void)loadSqlite
{
    NSMutableArray * actionArray = [NSMutableArray array];
    
    //全部活动
    NSArray * localactionArray = [LocalActivity MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalActivity * localaction in localactionArray) {
        if (localaction.isPlace.integerValue == 0) {
            [actionArray addObject:localaction];
        }
    }
    
    if (actionArray.count>0) {
        for (NSInteger i=0; i<actionArray.count; i++) {

            Activity * action = [Activity new];
            LocalActivity * localActivity = actionArray[i];
            if (localActivity.isPlace.integerValue == 0) {
                action.id = localActivity.id;
                action.createAt = localActivity.createAt.integerValue;
                action.content = localActivity.content;
                action.name = localActivity.name;
                action.title = localActivity.title;
                action.lastUpdate = localActivity.lastUpdate.integerValue;
                action.companyId = localActivity.companyId;
                action.startTime = localActivity.startTime.integerValue;
                action.endTime = localActivity.endTime.integerValue;
                action.imagePaths = localActivity.imagePaths;
                [self.arrDatas addObject:action];
            }
        }
    }else
    {
        [self loadDatas];
    }
    
    
    
    
    
}



@end
