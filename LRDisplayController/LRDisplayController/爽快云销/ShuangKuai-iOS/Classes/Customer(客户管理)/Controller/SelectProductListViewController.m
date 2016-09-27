//
//  SelectProductListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SelectProductListViewController.h"
#import "CustomerProductListCell.h"
#import "CustomerProductListSelectModel.h"
#import "SMSequenceView.h"
#import "CustomerProductListHeaderView.h"
#import "RightImageButton.h"
#import "SelectProductListMaskView.h"

@interface SelectProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomerProductListHeaderViewDelegate,SelectProductListMaskViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;/**< 控制器 */
@property (nonatomic,strong) NSMutableArray *dataArray;/**< 数据源数组,Product */
@property (nonatomic,weak) UIButton *rightBtn;/**< 右上角 */
@property (nonatomic,strong) NSArray *selectArray;/**< 选择的数组 */
@property (nonatomic,strong) CustomerProductListHeaderView *topView;/**< 头部 */
@property (nonatomic,assign) NSInteger selectButtonNumber;/**< 选中的按钮 */
@property (nonatomic,assign) PRODUCT_SORT_TYPE sortType;/**< 排列属性 */
@property (nonatomic,assign) int pageNumber;/**< 当前页面数 */
@property (nonatomic,assign) int totalPage;/**< 页面总数 */
@property (nonatomic,assign) int pageSize;/**< 一页最大数量 */
@end

@implementation SelectProductListViewController
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = KControllerBackGroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        layout.minimumInteritemSpacing = 10;
        // _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CustomerProductListCell class] forCellWithReuseIdentifier:@"CustomerProductListCell"];
        [self.view addSubview:_collectionView];
        MJWeakSelf
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.view);
            make.top.equalTo(@(40*SMMatchWidth));
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }];
        
    }
    return _collectionView;
}

-(CustomerProductListHeaderView *)topView{
    if (_topView == nil) {
        _topView = [[CustomerProductListHeaderView alloc] init];
        [_topView.priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_topView.priceBtn setImage:[UIImage imageNamed:@"productBottom"] forState:UIControlStateNormal];
        [_topView.priceBtn setImage:[UIImage imageNamed:@"productTop"] forState:UIControlStateSelected];
        [_topView.productNewBtn setTitle:@"新品" forState:UIControlStateNormal];
        [_topView.saleBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_topView.brokerageBtn setTitle:@"佣金" forState:UIControlStateNormal];
        [_topView.brokerageBtn setImage:[UIImage imageNamed:@"productBottom"] forState:UIControlStateNormal];
        [_topView.brokerageBtn setImage:[UIImage imageNamed:@"productTop"] forState:UIControlStateSelected];
        _topView.startArray = @[@"价格",@"新品",@"销量",@"佣金"];
        _topView.delegate = self;
        [self.view addSubview:_topView];
        MJWeakSelf
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.height.equalTo(@(40*SMMatchWidth));
        }];
    }
    return _topView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择意向商品";
    
    self.sortType = SortType_Commission_News;
    
    self.pageNumber = 1;
    
    self.totalPage = 1;
    
    self.pageSize = 10;
    
    [self queryProduct];
    
    MJWeakSelf
    MJRefreshBackNormalFooter *collectionViewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber++;
        [weakSelf queryProduct];
        
    }];
    self.collectionView.mj_footer = collectionViewfooter;
    
//    CustomerProductListSelectModel *model1= [[CustomerProductListSelectModel alloc] init];
//    model1.iconImage = @"";
//    model1.title = @"手机001";
//    model1.price = @"22222";
//    model1.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model2= [[CustomerProductListSelectModel alloc] init];
//    model2.iconImage = @"";
//    model2.title = @"手机002";
//    model2.price = @"22222";
//    model2.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model3= [[CustomerProductListSelectModel alloc] init];
//    model3.iconImage = @"";
//    model3.title = @"手机003";
//    model3.price = @"22222";
//    model3.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model4= [[CustomerProductListSelectModel alloc] init];
//    model4.iconImage = @"";
//    model4.title = @"手机004";
//    model4.price = @"22222";
//    model4.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model5= [[CustomerProductListSelectModel alloc] init];
//    model5.iconImage = @"";
//    model5.title = @"手机005";
//    model5.price = @"22222";
//    model5.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model6= [[CustomerProductListSelectModel alloc] init];
//    model6.iconImage = @"";
//    model6.title = @"手机006";
//    model6.price = @"22222";
//    model6.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model7= [[CustomerProductListSelectModel alloc] init];
//    model7.iconImage = @"";
//    model7.title = @"手机007";
//    model7.price = @"22222";
//    model7.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model8= [[CustomerProductListSelectModel alloc] init];
//    model8.iconImage = @"";
//    model8.title = @"手机008";
//    model8.price = @"22222";
//    model8.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model9= [[CustomerProductListSelectModel alloc] init];
//    model9.iconImage = @"";
//    model9.title = @"手机009";
//    model9.price = @"22222";
//    model9.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model10= [[CustomerProductListSelectModel alloc] init];
//    model10.iconImage = @"";
//    model10.title = @"手机010";
//    model10.price = @"22222";
//    model10.brokerage = @"100";
//    
//    CustomerProductListSelectModel *model11= [[CustomerProductListSelectModel alloc] init];
//    model11.iconImage = @"";
//    model11.title = @"手机011";
//    model11.price = @"22222";
//    model11.brokerage = @"100";
//    
//    self.dataArray = @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11];
//    
//    [self.collectionView reloadData];
    
    [self topView];
    
//    UIButton *rightBtn = [[UIButton alloc] init];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjialianxirrenRed"] forState:UIControlStateNormal];
//    rightBtn.width = 22;
//    rightBtn.height = 22;
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [rightBtn sizeToFit];
//    self.rightBtn = rightBtn;
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确定" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    rightBtn.width = 30;
//    rightBtn.height = 22;
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)queryProduct{
//    if (self.pageNumber>self.totalPage) {
//        return;
//    }
    [MBProgressHUD showMessage:@"正在加载"];
    MJWeakSelf
    [[SKAPI shared] queryProductByName:@"" andPage:self.pageNumber andSize:self.pageSize andSortType:self.sortType andClassId:@"" andIsRecommend:0 block:^(NSArray *array, NSError *error) {
        if (!error) {
            [weakSelf.collectionView.mj_footer endRefreshing];
//            weakSelf.dataArray = array;
            
            if (weakSelf.pageNumber == 1) {
//                weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                if (weakSelf.oldSelectArray) {
                    for (Product *product in array) {
                        
                        for (NSString *productIDStr in weakSelf.oldSelectArray) {
                            if ([product.id isEqualToString:productIDStr]) {
                                product.select = YES;
                                break;
                            }
                        }
                    }
                    weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                }else{
                    weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                }
                
            }else{
                if (weakSelf.oldSelectArray) {
                    for (Product *product in array) {
                        for (NSString *productIDStr in weakSelf.oldSelectArray) {
                            if ([product.id isEqualToString:productIDStr]) {
                                product.select = YES;
                                break;
                            }
                        }
                    }
                    [weakSelf.dataArray addObjectsFromArray:array];
                }else{
                    [weakSelf.dataArray addObjectsFromArray:array];
                }
                
            }
            [weakSelf.collectionView reloadData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideHUD];
    }];
}

-(void)rightItemClick{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (Product *model in self.dataArray) {
        if (model.isSelect) {
            [tempArray addObject:model];
        }
    }
    self.selectArray = [tempArray copy];
    if ([self.delegate respondsToSelector:@selector(chooseProduct:)]) {
        [self.delegate chooseProduct:self.selectArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-30)*0.5, (KScreenWidth-30)*0.5+50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomerProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomerProductListCell" forIndexPath:indexPath];
    cell.cellData = self.dataArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomerProductListCell *cell = (CustomerProductListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Product *cellData = cell.cellData;
    if ([cellData isKindOfClass:[Product class]]) {
        [cell cellSelect];
    }
}


#pragma mark - CustomerProductListHeaderViewDelegate
-(void)sequenceButtonClick:(NSInteger)number{
    switch (number) {
        case 0:
        {
            SelectProductListMaskView *maskView = [[SelectProductListMaskView alloc] init];
            [maskView addButtonWithTitle:@[@"价格从低到高",@"价格从高到低"]];
            [maskView setButtonWithTopFrame:CGRectMake(0, 64+40*SMMatchWidth, KScreenWidth/4, 40*SMMatchWidth)];
            maskView.delegate = self;
            self.selectButtonNumber = number;
            
        }
            break;
        case 1:
        {
            self.pageNumber = 1;
            self.totalPage = 1;
            self.sortType = SortType_Commission_News;
            [self queryProduct];
        }
            break;
        case 2:
        {
            self.pageNumber = 1;
            self.totalPage = 1;
            self.sortType = SortType_Sales;
            [self queryProduct];
        }
            break;
        case 3:
        {
            SelectProductListMaskView *maskView = [[SelectProductListMaskView alloc] init];
            [maskView addButtonWithTitle:@[@"佣金从低到高",@"佣金从高到低"]];
            [maskView setButtonWithTopFrame:CGRectMake(KScreenWidth/4*3, 64+40*SMMatchWidth, KScreenWidth/4, 40*SMMatchWidth)];
            maskView.delegate = self;
            self.selectButtonNumber = number;
        }
            break;
        default:
            break;
    }
}
#pragma mark - SelectProductListMaskViewDelegate
-(void)maskViewClickWithNumber:(NSInteger)number{
    if (self.selectButtonNumber == 0) {
        switch (number) {
            case 0:
            {
                [self.topView.priceBtn setTitle:@"价格从低到高" forState:UIControlStateNormal];
                [self.topView layoutSubviews];
                [self.topView setButtonClick:self.selectButtonNumber];
                self.pageNumber = 1;
                self.totalPage = 1;
                self.sortType = SortType_Price_Asc;
                [self queryProduct];
            }
                break;
            case 1:
            {
                [self.topView.priceBtn setTitle:@"价格从高到低" forState:UIControlStateNormal];
                [self.topView layoutSubviews];
                [self.topView setButtonClick:self.selectButtonNumber];
                self.pageNumber = 1;
                self.totalPage = 1;
                self.sortType = SortType_Price_Desc;
                [self queryProduct];
            }
                break;
            default:
                break;
        }
    }else if(self.selectButtonNumber == 3){
        switch (number) {
            case 0:
            {
                [self.topView.brokerageBtn setTitle:@"佣金从低到高" forState:UIControlStateNormal];
                [self.topView layoutSubviews];
                [self.topView setButtonClick:self.selectButtonNumber];
                self.pageNumber = 1;
                self.totalPage = 1;
                self.sortType = SortType_Commission_Asc;
                [self queryProduct];
            }
                break;
            case 1:
            {
                [self.topView.brokerageBtn setTitle:@"佣金从高到低" forState:UIControlStateNormal];
                [self.topView layoutSubviews];
                [self.topView setButtonClick:self.selectButtonNumber];
                self.pageNumber = 1;
                self.totalPage = 1;
                self.sortType = SortType_Commission_Desc;
                [self queryProduct];
            }
            default:
                break;
        }
    };
}

@end
