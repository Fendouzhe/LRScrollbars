//
//  SMShelfHotProductController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfHotProductController.h"
#import "SMNewHotProductCell.h"
#import "SMProductDetailController.h"
#import "SMShelfHotProductHeaderView.h"
#import "SMStroreHouseForShelfController.h"

@interface SMShelfHotProductController ()<UITableViewDataSource,UITableViewDelegate,SMShelfHotProductHeaderViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *arrDatas;

@end

@implementation SMShelfHotProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    
    [self setupHeaderView];
    
    [self getDatas];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProducts:) name:KRefreshCounterProductNoti object:nil];
}

- (void)refreshProducts:(NSNotification *)noti{
    
    self.fav = noti.userInfo[KRefreshCounterProductNotiKey];
    SMLog(@"refreshProducts  KRefreshCounterProductNotiKey  self.fav   %@",self.fav);
    [self getDatas];
}

- (void)setupHeaderView{
    SMShelfHotProductHeaderView *header = [SMShelfHotProductHeaderView shelfHotProductHeaderView];
    CGFloat height = KScreenHeight / K5Height * 1.0 * 32;
    header.width = KScreenWidth;
    header.height = height;
    header.delegate = self;
    self.tableView.tableHeaderView = header;
}

#pragma mark -- 生命周期
- (void)loadView{ //自定义设置控制器的View(可改变其类型)
    
    CGFloat topViewHeight;
    CGFloat midViewHeight;
    if (isIPhone5) {
        topViewHeight = 135;
        midViewHeight = 55;
    }else if (isIPhone6){
        topViewHeight = 135 *KMatch6Height;
        midViewHeight = 55 *KMatch6Height;
    }else if (isIPhone6p){
        topViewHeight = 135 *KMatch6pHeight;
        midViewHeight = 55 *KMatch6pHeight;
    }
//    CGFloat height = KScreenHeight - KTabBarHeight - topViewHeight - midViewHeight - 40;   //40是“热销产品”“优惠券”那一行的高度
    CGFloat height = KScreenHeight - KTabBarHeight - topViewHeight - midViewHeight;
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
    self.view = bgview;
}


- (void)getDatas{
    
    [[SKAPI shared] queryMyStorageItems:self.fav.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrDatas removeAllObjects];
            //再重新添加新数据
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [self.arrDatas addObject:f];
                }
            }
            
            [self.tableView reloadData];
            if ([self.delegate respondsToSelector:@selector(hideHUD)]) {
                [self.delegate hideHUD];
            }
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

#pragma mark -- SMShelfHotProductHeaderViewDelegate
- (void)rightBtnDidClick{
    SMLog(@"点击了 更多商品");
//    SMStroreHouseForShelfController *vc = [SMStroreHouseForShelfController new];
//    [self.navigationController pushViewController:vc animated:YES];
    if ([self.delegate respondsToSelector:@selector(moreProductDidClick)]) {
        [self.delegate moreProductDidClick];
    }
}

#pragma mark -- <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    SMLog(@"self.arrDatas.count   %zd",self.arrDatas.count);
    SMLog(@"self.arrDatas  KRefreshShelfProduct  %zd",self.arrDatas.count);
    return self.arrDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMNewHotProductCell *cell = [SMNewHotProductCell cellWithTableView:tableView];

    cell.favoritesDetail = self.arrDatas[indexPath.row];
    SMLog(@"favoritesDetail.itemName  %@",cell.favoritesDetail.itemName);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 5 + 205 * SMMatchHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.delegate respondsToSelector:@selector(goToProductDetailVC:and:)]) {
        [self.delegate goToProductDetailVC:[self.arrDatas[indexPath.row] itemId] and:self.fav];
    }
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//    [[SKAPI shared] queryProductById:[self.arrDatas[indexPath.row] itemId] block:^(Product *product, NSError *error) {
//        vc.product = product;
//        vc.isBelongCounter = YES;
//        vc.isGoodsShelf = YES;
//        vc.favorites = self.fav;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    
    
}


#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height);
    }
    return _tableView;
}

- (NSMutableArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

@end
