//
//  SMShoppingController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
#import "SMSearchProductViewController.h"
#import "SMShoppingController.h"
#import "SMProductCollectionViewCell.h"
#import "SMNewShoppingSequenceCell.h"
#import "SMSequenceView.h"
#import "SMProductDetailController.h"
#import <SDCycleScrollView.h>
#import "SMLeftItemBtn.h"
#import "SMPersonInfoViewController.h"
#import "SMSearchViewController.h"
#import "SMScannerViewController.h"
#import "SMProductClassesController.h"
#import "SMProductTool.h"
#import "LocalHotProductTool.h"
#import "SMClassesController.h"
#import "SMNewProductDetailController.h"

@interface SMSearchProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMNewShoppingSequenceCellDelegate,SMSequenceViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic ,strong)NSMutableArray *arrHotProducts;

@property (nonatomic ,strong)NSMutableArray *arrProducts;

@property (nonatomic ,strong)UIButton *priceBtn;

@property (nonatomic ,strong)UIButton *commisionBtn;

@property (nonatomic ,strong)UIButton *salesCountBtn;

@property (nonatomic ,strong)SMSequenceView *sequenceViewLeft;

@property (nonatomic ,strong)SMSequenceView *sequenceViewRight;

@property (nonatomic ,strong)UIView *cheatView;

@property (nonatomic ,strong)UIWindow *window;

@property (nonatomic ,assign)NSInteger page;

@property (nonatomic ,assign)PRODUCT_SORT_TYPE sequenceType;

@property (nonatomic ,strong)NSArray *arrScrollProducts;

@property (nonatomic ,strong)SMLeftItemBtn *leftIconBtn;

@property (nonatomic ,copy)NSString *baseUrl;/**< <#注释#> */

@property (nonatomic ,copy)NSString *paraStr;/**< 分享出去的链接后面需要拼接的字符串 */

@property (nonatomic ,strong)UIButton *productNewBtn;/**< 新品按钮 */
/**
 *  排序方式
 */
@property(nonatomic,assign)PRODUCT_SORT_TYPE typecount;

@end

@implementation SMSearchProductViewController

-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}
-(NSString *)classId{
    if (!_classId) {
        _classId = [NSString string];
    }
    return _classId;
}


static NSString * const section0Identifier = @"newShoppingSequenceCell";
static NSString * const section1Identifier = @"productCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品";
    
    if (self.keyWord == nil) {
        self.keyWord = @"";
    }
    
    //判断分享出去链接的后面需要拼接什么字符串
    //[self judgeSharePath];
    
    [self setupNav];
    
    [self.view addSubview:self.collectionView];
    self.window = [[UIApplication sharedApplication].windows lastObject];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMNewShoppingSequenceCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:section0Identifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMProductCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:section1Identifier];
    {
//    //拿到热销商品(图片轮播器)数据
//    [LocalHotProductTool initialize];
//    
//    NSArray *arr = [LocalHotProductTool queryData:nil];
//    SMLog(@"arr.count  LocalHotProductTool  %zd",arr.count);
//    
//    if (arr.count > 0) {
//        //        self.arrHotProducts = (NSMutableArray *)arr;
//        for (Product *p in arr) {
//            //            NSArray *arrImagePath = [NSString mj_objectArrayWithKeyValuesArray:p.adImage];
//            //            [self.arrHotProducts addObject:arrImagePath.firstObject];
//            //            SMLog(@"p.adImage   %@",p.adImage);
//            [self.arrHotProducts addObject:p.adImage];
//        }
//        [self.collectionView reloadData];
//    }else{
//        [self getHotProducts];
//    }
//    
//    
//    
//    //拿到普通商品数据
//    [SMProductTool initialize];
//    SMLog(@"[self lookForDataInLocal].count    %zd",[self lookForDataInLocal].count);
//    if ([self lookForDataInLocal].count > 0) {
//        self.arrProducts = (NSMutableArray *)[self lookForDataInLocal];
//        [self.collectionView reloadData];
//        SMLog(@"使用本地数据刷新界面");
//    }else{
//        self.page = 1;
//        self.sequenceType = SortType_Default;
//        [self getProductWith:self.sequenceType];
//    }
        }
    
    [self SetupMJRefresh];
    [self.collectionView.mj_header beginRefreshing];
        //默认选择销量
    self.page = 1;
    self.sequenceType = SortType_Default;
    [self getProductWith:self.sequenceType];
    
//    SMNewShoppingSequenceCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMNewShoppingSequenceCell class]) owner:nil options:nil] firstObject];
//    cell.salesCountBtn.selected = YES;
//    cell.productNew.selected = NO;
//    [self salesCountDidClick:cell.salesCountBtn];
    
}


- (void)judgeSharePath{
//    //        self.baseUrl = @"m.shuangkuai.co/shuangkuai_app/mall.html";
//    [[SKAPI shared] shoppingShareType:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result  shoppingShareType %@",result);
//            NSNumber *num = [[result objectForKey:result] objectForKey:@"template"];
//            if (num.integerValue == 0) {
//                self.paraStr = @"mall_0.html";
//            }else if (num.integerValue == 1){
//                self.paraStr = @"mall_1.html";
//            }else if (num.integerValue == 2){
//                self.paraStr = @"mall_2.html";
//            }
//            self.baseUrl = [KShoppingVcShare stringByAppendingString:self.paraStr];
//        }else{
//            SMLog(@"error shoppingShareType  %@",error);
//        }
//    }];
//    
}
//
//- (NSArray *)lookForDataInLocal{
//    return [SMProductTool queryData:nil];
//}

- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[[UIImage imageNamed:@"nav_search"] scaleToSize:CGSizeMake(KRightItemWidth, KRightItemWidth)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnDidClick)];
    
}

#pragma mark -- SMRightItemViewDelegate
- (void)searchBtnDidClick{
    SMLog(@"点击了 搜索按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *collectionViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getProductWith:self.sequenceType];
        //[self getHotProducts];
    }];
    self.collectionView.mj_header = collectionViewheader;
    
    MJRefreshBackNormalFooter *collectionViewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getProductWith:self.sequenceType];
        
    }];
    self.collectionView.mj_footer = collectionViewfooter;
}

//默认排序 销量优先
- (void)getProductWith:(PRODUCT_SORT_TYPE)type{
    [[SKAPI shared] queryProductByName:self.keyWord andPage:self.page andSize:6 andSortType:type andClassId:self.classId andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        SMLog(@"self.page  %zd",self.page);
        if (!error) { //请求成功
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
            if (self.page == 1) {
                self.arrProducts = [NSMutableArray arrayWithArray:array];
            }else{
                for (Product *p in array) {
                    [self.arrProducts addObject:p];
                }
            }
            
            [self.collectionView reloadData];
            
            //存本地
            for (Product *p in self.arrProducts) {
                [SMProductTool insertModal:p];
                SMLog(@"存入对象 p %@",p);
            }
            
        }else{ //请求失败
            SMLog(@"error  getHotProducts %@",error);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}
//加载图片轮播期
- (void)getHotProducts{
//    
//    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Commission_News andClassId:@"" andIsRecommend:(NSInteger)1  block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            [self.arrHotProducts removeAllObjects];
//            [LocalHotProductTool deleteData:nil];
//            for (Product *p in array) {
//                SMLog(@"p.adImage getHotProducts  %@",p.adImage);
//                self.arrScrollProducts = array;
//                //NSArray *arr = [NSString mj_objectArrayWithKeyValuesArray:p.imagePath];
//                //[self.arrHotProducts addObject:arr.firstObject];
//                [self.arrHotProducts addObject:p.adImage];
//                [LocalHotProductTool insertModal:p];
//            }
//            [self.collectionView reloadData];
//        }else{
//            SMLog(@"error  getHotProducts %@",error);
//        }
//        
//    }];
}

#pragma mark --<UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 1) {
        return self.arrProducts.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){

        SMNewShoppingSequenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section0Identifier forIndexPath:indexPath];
        self.productNewBtn = cell.productNew;
        self.salesCountBtn = cell.salesCountBtn;
        cell.delegate = self;
        return cell;

    }else if (indexPath.section == 1){
        
        SMProductCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:section1Identifier forIndexPath:indexPath];
        cell.product = self.arrProducts[indexPath.row];

        return cell;
    }
    
    return nil;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        return CGSizeMake(KScreenWidth , 40 *SMMatchHeight);
    }else if (indexPath.section == 1){
        return CGSizeMake((KScreenWidth - 15) / 2.0, 209 *SMMatchHeight);
    }
    
    return CGSizeMake(KScreenWidth , 150 *SMMatchHeight);
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0){
        return UIEdgeInsetsMake(0 ,0 ,0 ,0);
    }else if (section == 1){
        return UIEdgeInsetsMake(5 ,5 ,5 ,5);
    }
    
    return UIEdgeInsetsMake(0 ,0 ,0 ,0);
}

//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    SMLog(@"点击了 collectionViewCell %zd组  %zd个",indexPath.section,indexPath.row);
    
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//    vc.product = self.arrProducts[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    SMNewProductDetailController *vc = [[SMNewProductDetailController alloc] init];
    vc.product = self.arrProducts[indexPath.row];
    vc.mode = 1;
    vc.productName = [self.arrProducts[indexPath.row] name];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    cell.alpha = 0;
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.alpha = 1;
//    }];
//}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    SMLog(@"---点击了第%ld张图片", index);
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    vc.product = self.arrScrollProducts[index];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 排序数据获取及刷新UI
/**
 *  价格排序
 */
- (void)getProductSortType_Price_Asc{
    [[SKAPI shared] queryProductByName:self.keyWord andPage:self.page andSize:6 andSortType:SortType_Price_Asc andClassId:self.classId andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

- (void)getProductSortType_Price_Desc{
    [[SKAPI shared] queryProductByName:self.keyWord andPage:self.page andSize:6 andSortType:SortType_Price_Desc andClassId:self.classId andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}
/**
 *  佣金排序
 */
- (void)getProductSortType_Commission_Asc{
    [[SKAPI shared] queryProductByName:self.keyWord andPage:self.page andSize:6 andSortType:SortType_Commission_Asc andClassId:self.classId andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}


- (void)getProductSortType_Commission_Desc{
    [[SKAPI shared] queryProductByName:self.keyWord andPage:self.page andSize:6 andSortType:SortType_Commission_Desc andClassId:self.classId andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
        if (!error) {
            self.arrProducts = [NSMutableArray arrayWithArray:array];
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
    }];
}

#pragma mark -- 点击事件


- (void)bottomBtnDidClick:(UIButton *)btn viewTag:(int)tag{
    SMLog(@"点击了 弹出来的选择排序  下面的按钮排序");
    [self sequenceViewClick:btn tag:tag];
    
    self.page = 1;
    if (tag == 1) {   //价格从高到低
        self.sequenceType = SortType_Price_Desc;
    }else{    //佣金从高到低
        self.sequenceType = SortType_Commission_Desc;
    }
    [self getProductWith:self.sequenceType];
}

///点击了 新品
- (void)productNewDidClick:(UIButton *)btn{
    SMLog(@"点击了 新品");
    self.productNewBtn = btn;
    self.productNewBtn.selected = YES;
    self.salesCountBtn.selected = NO;
    self.priceBtn.selected = NO;
    self.commisionBtn.selected = NO;
    
    self.page = 1;
    self.sequenceType = SortType_Commission_News;
    [self getProductWith:SortType_Commission_News];
    
}
///点击了 价格排序
- (void)priceDidClick:(UIButton *)btn{
    SMLog(@"点击了 价格排序");
    self.priceBtn = btn;
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewLeft];
}
/**
 *  价格或者佣金排序列表点击
 */
- (void)sequenceViewClick:(UIButton *)btn tag:(int)tag{
    if (tag == 1) {  //价格排序那边的
        self.priceBtn.selected = YES;
        self.salesCountBtn.selected = NO;
        self.commisionBtn.selected = NO;
        self.productNewBtn.selected = NO;
        [self.priceBtn setTitle:btn.currentTitle forState:UIControlStateSelected];
        [self.priceBtn setImage:[UIImage imageNamed:@"产品库sahng"] forState:UIControlStateSelected];
        [self cheatViewTap];
    }else{   //佣金排序那边的
        self.priceBtn.selected = NO;
        self.salesCountBtn.selected = NO;
        self.commisionBtn.selected = YES;
        self.productNewBtn.selected = NO;
        [self.commisionBtn setTitle:btn.currentTitle forState:UIControlStateSelected];
        [self.commisionBtn setImage:[UIImage imageNamed:@"产品库sahng"] forState:UIControlStateSelected];
        [self cheatViewTap];
    }
}
/**
 *  价格或者佣金排序列表点击后刷新界面
 */
- (void)topBtnDidClick:(UIButton *)btn viewTag:(int)tag{
    SMLog(@"点击了 弹出来的选择排序  上面的按钮排序");
    [self sequenceViewClick:btn tag:tag];
    
    self.page = 1;
    if (tag == 1) {  //价格从低到高
        self.sequenceType = SortType_Price_Asc;
    }else{   //佣金从低到高
        self.sequenceType = SortType_Commission_Asc;
    }
    [self getProductWith:self.sequenceType];
}

///点击了 佣金排序
- (void)commisionDidClick:(UIButton *)btn{
    SMLog(@"点击了 佣金排序");
    self.commisionBtn = btn;
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewRight];
}
///点击了 销量优先
- (void)salesCountDidClick:(UIButton *)btn{
    SMLog(@"点击了 销量优先");
    self.salesCountBtn = btn;
    self.salesCountBtn.selected = YES;
    self.priceBtn.selected = NO;
    self.commisionBtn.selected = NO;
    self.productNewBtn.selected = NO;
    
    self.page = 1;
    self.sequenceType = SortType_Default;
    [self getProductWith:SortType_Default];
    
}
///点击了 分类
- (void)classesDidClick{
    SMLog(@"点击了 分类");
    SMClassesController *vc = [SMClassesController new];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -- 懒加载
- (UIView *)cheatView{
    if (_cheatView == nil) {
        _cheatView = [[UIView alloc] init];
        _cheatView.frame = self.window.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
        [_cheatView addGestureRecognizer:tap];
    }
    return _cheatView;
}

- (void)cheatViewTap{
    [self.cheatView removeFromSuperview];
    self.cheatView = nil;
    [self.sequenceViewLeft removeFromSuperview];
    self.sequenceViewLeft = nil;
    [self.sequenceViewRight removeFromSuperview];
    self.sequenceViewRight = nil;
}

- (SMSequenceView *)sequenceViewLeft{
    if (_sequenceViewLeft == nil) {
        _sequenceViewLeft = [SMSequenceView sequenceViewWithTopTitle:@"价格从低到高" bottomTitle:@"价格从高到低"];
        _sequenceViewLeft.delegate = self;
        _sequenceViewLeft.tag = 1;
        CGFloat width = (KScreenWidth - KScreenWidth / 8.0 - 60) / 2.0;
        CGFloat y = CGRectGetMaxY([self.priceBtn.superview convertRect:self.priceBtn.frame toView:self.window]);
        SMLog(@"y  SMSequenceView %f",y);
        _sequenceViewLeft.frame = CGRectMake(0, y , width, 64 *SMMatchHeight);
    }
    return _sequenceViewLeft;
}

- (SMSequenceView *)sequenceViewRight{
    if (_sequenceViewRight == nil) {
        _sequenceViewRight = [SMSequenceView sequenceViewWithTopTitle:@"佣金从低到高" bottomTitle:@"佣金从高到低"];
        _sequenceViewRight.delegate = self;
        _sequenceViewRight.tag = 2;
        CGFloat width = (KScreenWidth - KScreenWidth / 8.0 - 60) / 2.0;
        CGFloat y = CGRectGetMaxY([self.commisionBtn.superview convertRect:self.commisionBtn.frame toView:self.window]);
        SMLog(@"y  SMSequenceView %f",y);
        _sequenceViewRight.frame = CGRectMake(width + 60, y , width, 64 *SMMatchHeight);
        
    }
    return _sequenceViewRight;
}

- (NSMutableArray *)arrHotProducts{
    if (_arrHotProducts == nil) {
        _arrHotProducts = [NSMutableArray array];
    }
    return _arrHotProducts;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = KControllerBackGroundColor;
        _collectionView. delegate = self;
        _collectionView. dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
}

@end
