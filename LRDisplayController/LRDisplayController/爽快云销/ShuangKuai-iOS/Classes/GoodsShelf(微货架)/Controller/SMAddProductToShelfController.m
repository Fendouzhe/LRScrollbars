//
//  SMAddProductToShelfController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddProductToShelfController.h"
#import "SMAddProductCellSection0.h"
#import "SMNewShoppingSequenceCell.h"
#import "SMProductCollectionViewCell.h"
#import "SMSequenceView.h"
#import "SMProductTool.h"
#import "SMProductClassesController.h"
#import "LocalHotProductTool.h"
#import "SMProductDetailController.h"


@interface SMAddProductToShelfController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMSequenceViewDelegate,SMNewShoppingSequenceCellDelegate>

@property (nonatomic ,strong)UICollectionView *collectionView;/**< collectionView */

@property (nonatomic ,strong)UIButton *priceBtn;/**<  价格排序 */

@property (nonatomic ,strong)UIButton *commisionBtn;/**< 佣金排序 */

@property (nonatomic ,strong)UIButton *salesCountBtn;/**< 销量排序 */

@property (nonatomic ,strong)UIWindow *window;/**< <#注释#> */

@property (nonatomic ,strong)UIView *cheatView;/**< <#注释#> */

@property (nonatomic ,strong)SMSequenceView *sequenceViewLeft;

@property (nonatomic ,strong)SMSequenceView *sequenceViewRight;

@property (nonatomic ,assign)NSInteger page; /**< <#注释#> */

@property (nonatomic ,strong)UIButton *productNewBtn;/**< 新品 */

@property (nonatomic ,assign)PRODUCT_SORT_TYPE sequenceType;

@property (nonatomic ,strong)NSMutableArray *arrProducts;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrHotProducts;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrScrollProducts;

@end

@implementation SMAddProductToShelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择您喜欢的商品";
    [self.view addSubview:self.collectionView];
    self.window = [[UIApplication sharedApplication].windows lastObject];
    
    //拿到热销商品数据
    [LocalHotProductTool initialize];
    NSArray *arr = [LocalHotProductTool queryData:nil];
    SMLog(@"arr.count  LocalHotProductTool  %zd",arr.count);
    
    if (arr.count > 0) {
        //        self.arrHotProducts = (NSMutableArray *)arr;
        for (Product *p in arr) {
            //            NSArray *arrImagePath = [NSString mj_objectArrayWithKeyValuesArray:p.adImage];
            //            [self.arrHotProducts addObject:arrImagePath.firstObject];
            //            SMLog(@"p.adImage   %@",p.adImage);
            [self.arrHotProducts addObject:p.adImage];
        }
        [self.collectionView reloadData];
    }else{
        [self getHotProducts];
    }
    
    //拿到普通商品数据
    [SMProductTool initialize];
    SMLog(@"[self lookForDataInLocal].count    %zd",[self lookForDataInLocal].count);
    if ([self lookForDataInLocal].count > 0) {
        self.arrProducts = (NSMutableArray *)[self lookForDataInLocal];
        [self.collectionView reloadData];
        SMLog(@"使用本地数据刷新界面");
    }else{
        self.page = 1;
        self.sequenceType = SortType_Default;
        [self getProductWith:self.sequenceType];
    }
    
    [self SetupMJRefresh];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *collectionViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getProductWith:self.sequenceType];
        [self getHotProducts];
    }];
    self.collectionView.mj_header = collectionViewheader;
    
    MJRefreshBackNormalFooter *collectionViewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getProductWith:self.sequenceType];
        
    }];
    self.collectionView.mj_footer = collectionViewfooter;
}

- (NSArray *)lookForDataInLocal{
    return [SMProductTool queryData:nil];
}

- (void)getHotProducts{
    
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:SortType_Commission_News andClassId:@"" andIsRecommend:(NSInteger)1  block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrHotProducts removeAllObjects];
            [LocalHotProductTool deleteData:nil];
            for (Product *p in array) {
                SMLog(@"p.adImage getHotProducts  %@",p.adImage);
                self.arrScrollProducts = array;
                NSArray *arr = [NSString mj_objectArrayWithKeyValuesArray:p.imagePath];
                //                [self.arrHotProducts addObject:arr.firstObject];
                [self.arrHotProducts addObject:p.adImage];
                [LocalHotProductTool insertModal:p];
            }
            [self.collectionView reloadData];
        }else{
            SMLog(@"error  getHotProducts %@",error);
        }
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2){
        return 5;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        SMAddProductCellSection0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addProductCellSection0" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        
        SMNewShoppingSequenceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newShoppingSequenceCell00" forIndexPath:indexPath];
        self.productNewBtn = cell.productNew;
        self.salesCountBtn = cell.salesCountBtn;
        cell.delegate = self;
        return cell;
                                           
    }else if (indexPath.section == 2){
        SMProductCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCollectionViewCell00" forIndexPath:indexPath];
        cell.product = self.arrProducts[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(KScreenWidth, 30 *SMMatchHeight);
    }else if (indexPath.section == 1){
        return CGSizeMake(KScreenWidth , 30 *SMMatchHeight);
    }else if (indexPath.section == 2){
        return CGSizeMake((KScreenWidth - 15) / 2.0, 209 *SMMatchHeight);
    }
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 2){
        return UIEdgeInsetsMake(5 ,5 ,5 ,5);
    }

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    SMLog(@"点击了 collectionViewCell %zd组  %zd个",indexPath.section,indexPath.row);
    
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    vc.product = self.arrProducts[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- 点击事件
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

- (void)priceDidClick:(UIButton *)btn{
    SMLog(@"点击了 价格排序");
    self.priceBtn = btn;
    //    UIImage *image = btn.imageView.image;
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    //    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewLeft];
}

- (void)commisionDidClick:(UIButton *)btn{
    SMLog(@"点击了 佣金排序");
    self.commisionBtn = btn;
    [self.window addSubview:self.cheatView];
    [self.window addSubview:self.sequenceViewRight];
}

- (void)salesCountDidClick:(UIButton *)btn{
    SMLog(@"点击了 销量优先");
    self.salesCountBtn.selected = YES;
    self.priceBtn.selected = NO;
    self.commisionBtn.selected = NO;
    self.productNewBtn.selected = NO;
    
    self.page = 1;
    self.sequenceType = SortType_Default;
    [self getProductWith:SortType_Default];
    
}

- (void)classesDidClick{
    SMLog(@"点击了 分类");
    SMProductClassesController *vc = [[SMProductClassesController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 点击事件
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

//默认排序 销量优先
- (void)getProductWith:(PRODUCT_SORT_TYPE)type{
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:6 andSortType:type andClassId:@"" andIsRecommend:(NSInteger)0  block:^(NSArray *array, NSError *error) {
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



#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout  alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KControllerBackGroundColor;
        [_collectionView registerClass:[SMAddProductCellSection0 class] forCellWithReuseIdentifier:@"addProductCellSection0"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SMNewShoppingSequenceCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"newShoppingSequenceCell00"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SMProductCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"productCollectionViewCell00"];
    }
    return _collectionView;
}

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

- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
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

@end
