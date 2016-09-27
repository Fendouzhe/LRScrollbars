//
//  SMHotProductController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHotProductController.h"
#import "SMProductCollectionViewCell.h"
#import "SMDetailStoreHouseController.h"
#import "LocalStorehouse.h"
#import "AppDelegate.h"

#define KCollectionViewCell @"productCollectionViewCell"
@interface SMHotProductController ()<UICollectionViewDelegate,UICollectionViewDataSource>



@property (nonatomic ,strong)NSMutableArray *dataProducts;

@property(nonatomic,assign)NSInteger page;

@end

@implementation SMHotProductController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    self.page = 1;
    
    [self setupMJRefresh];
    
    //[self loadDatas];
    [self loadSqlite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"homePageRefresh" object:nil];
    
    self.collectionView.bounces = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCanNotScroll) name:KProductCanNotScroll object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCanScroll) name:KProductCanScroll object:nil];
}

- (void)productCanScroll{
    self.collectionView.scrollEnabled = YES;
}

- (void)productCanNotScroll{
    self.collectionView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    SMLog(@"NSStringFromCGPoint(self.collectionView.contentOffset)   %@",NSStringFromCGPoint(self.collectionView.contentOffset));
    if (self.collectionView.contentOffset.y < 0) {
        self.collectionView.scrollEnabled  = NO;
    }
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
    
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:9 andSortType:SortType_Default andClassId:@"" andIsRecommend:0 block:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array.count>0) {
                if (!self.collectionView.mj_footer.isRefreshing) {
                    [self.dataProducts removeAllObjects];
                }
                for (Product *p in array) {
                    [self.dataProducts addObject:p];
                }
                SMLog(@"arrDatas queryNewsByCompanyId   %@",self.dataProducts);
                
                [self saveSqliteWithArray:self.dataProducts];
                
                [self.collectionView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.collectionView.mj_footer endRefreshing];
                });
            }else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                });
            }
        }else{
            SMLog(@"%@",error);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer endRefreshing];
            });
        }
        
    }];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section{
    return self.dataProducts.count;
}

-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView{
    return 1 ;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"SMProductCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:KCollectionViewCell];
    
    SMProductCollectionViewCell *cell = [SMProductCollectionViewCell productCollectionViewCell];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: KCollectionViewCell forIndexPath:indexPath];
    
    Product *product = self.dataProducts[indexPath.row];
    cell.product = product;
    
    
    return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    SMLog(@"点击了 collectionViewCell   %zd",indexPath.row);
    //拿到所点击的那一个collectionView  然后赋值给下一个控制器的product属性
    Product *product = self.dataProducts[indexPath.row];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KDiscoverNoteClickProductKey] = product;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KDiscoverNoteClickProduct object:self userInfo:dict];
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat w;
    CGFloat h;
    
    //    if (isIPhone5) {
    //        w = 145;
    //    }else if (isIPhone6){
    //        w = 145 *KMatch6;
    //    }else if (isIPhone6p){
    //        w = 145 *KMatch6p;
    //    }
    if (isIPhone5) {
        h = 209;
    }else if (isIPhone6){
        h = 209 *KMatch6Height;
    }else if (isIPhone6p){
        h = 209 *KMatch6pHeight;
    }
    
    if (indexPath == 0) {
        w = KScreenWidth;
    }else{
        w = (KScreenWidth - 3 * margin) / 2.0;
    }
    
    return CGSizeMake (w , h);
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section{
    
    return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView. delegate = self ;
        _collectionView. dataSource = self ;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = KControllerBackGroundColor;
    }
    return _collectionView;
}

- (NSMutableArray *)dataProducts{
    if (_dataProducts == nil) {
        _dataProducts = [NSMutableArray array];
    }
    return _dataProducts;
}

-(void)setupMJRefresh
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDatas];
    }];
    self.collectionView.mj_footer = footer;
}

//需要缓存产品  添加字段区分在哪边缓存的

-(void)saveSqliteWithArray:(NSArray *)array
{
    
    NSArray * localArray = [LocalStorehouse MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalStorehouse * product in localArray) {
        if (product.isPlace.integerValue == 0) {
            [product MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (Product * productModel in array) {
            LocalStorehouse * LocalStorehouseModel = [LocalStorehouse MR_createEntityInContext:localContext];
            LocalStorehouseModel.id = productModel.id;
            LocalStorehouseModel.name = productModel.name;
            LocalStorehouseModel.followers = [NSNumber numberWithInteger:productModel.followers];
            LocalStorehouseModel.lastUpdate = [NSNumber numberWithInteger:productModel.lastUpdate];
            LocalStorehouseModel.imagePath = productModel.imagePath;
            LocalStorehouseModel.price = productModel.price;
            LocalStorehouseModel.finalPrice = productModel.finalPrice;
            LocalStorehouseModel.companyName = productModel.companyName;
            LocalStorehouseModel.commission = productModel.commission;
            LocalStorehouseModel.stock = [NSNumber numberWithInteger:productModel.stock];
            LocalStorehouseModel.sales = [NSNumber numberWithInteger:productModel.sales];
            LocalStorehouseModel.isPlace = [NSNumber numberWithInteger:0];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}

-(void)loadSqlite
{
    [self.dataProducts removeAllObjects];
    
    NSMutableArray * array = [NSMutableArray array];
    //全部产品
    NSArray * localarray = [LocalStorehouse MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalStorehouse * storehouse in localarray) {
        if (storehouse.isPlace.integerValue == 0) {
            [array addObject:storehouse];
        }
    }
    
    if (array.count>0) {
        for (NSInteger i = 0; i<array.count; i++) {

            Product * productModel = [Product new];
            LocalStorehouse * localstorehouse = array[i];
            if (localstorehouse.isPlace.integerValue == 0) {
                productModel.id = localstorehouse.id;
                productModel.name = localstorehouse.name;
                productModel.followers = localstorehouse.followers.integerValue;
                productModel.lastUpdate = localstorehouse.lastUpdate.integerValue;
                productModel.imagePath = localstorehouse.imagePath;
                productModel.price = localstorehouse.price;
                productModel.finalPrice = localstorehouse.finalPrice;
                productModel.companyName = localstorehouse.companyName;
                productModel.commission = localstorehouse.commission;
                productModel.stock = localstorehouse.stock.integerValue;
                productModel.sales = localstorehouse.sales.integerValue;
                [self.dataProducts addObject:productModel];
            }
            
            [self.collectionView reloadData];
        }
    }else
    {
        [self loadDatas];
    }
    
}

@end
