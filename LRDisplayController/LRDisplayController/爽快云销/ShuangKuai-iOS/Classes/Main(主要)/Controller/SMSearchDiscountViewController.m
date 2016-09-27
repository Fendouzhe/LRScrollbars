//
//  SMSearchDiscountViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchDiscountViewController.h"
#import "SMShelfDiscountCell.h"

@interface SMSearchDiscountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,assign)NSInteger page;

@end

@implementation SMSearchDiscountViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"优惠券";
    
    //tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KStateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
    [self SetupMJRefresh];
    
    [self loadNewDataDiscounts];
}


#pragma mark - tableview相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMShelfDiscountCell *cell = [SMShelfDiscountCell cellWithTableView:tableView];
#pragma 可以在这里模型赋值
    cell.coupon = self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (isIPhone5) {
        height = 92;
    }else if (isIPhone6){
        height = 92 *KMatch6;
    }else if (isIPhone6p){
        height = 92 *KMatch6p;
    }
    return height;
}

#pragma mark - MJRefresh

-(void)SetupMJRefresh
{

    MJRefreshNormalHeader *discountstableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNewDataDiscounts];
    }];
    
    self.tableView.mj_header = discountstableviewtheader;
    MJRefreshBackNormalFooter *discountstableviewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadNewDataDiscounts];
        
    }];
    self.tableView.mj_footer = discountstableviewfooter;
    
}

- (void)loadNewDataDiscounts{
    
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    [[SKAPI shared]queryCompanyId:Id andKeyword:self.keyWord andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.dataArray removeAllObjects];
            }
            if (array.count>0) {
                for (Coupon * coupon in array) {
                    [self.dataArray addObject:coupon];
                }
                [self.tableView reloadData];
                
                [self.tableView.mj_footer  endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }else
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }
        }else
        {
            [self.tableView.mj_footer  endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView.mj_footer  endRefreshing];
//        [self.tableView.mj_header endRefreshing];
//    });
}

@end
