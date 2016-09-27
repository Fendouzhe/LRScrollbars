//
//  SMShelfProductViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  1号微货架

#import "SMShelfProductViewController.h"
#import "SMShelfProductCell.h"
#import "LocalFavoritesDetail.h"
#import "AppDelegate.h"
#import "SMNewHotProductCell.h"

@interface SMShelfProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UICollectionView *collectionView;
/**
 *   最下面的删除按钮
 */
@property (nonatomic ,strong)UIView *bottomViewDelete;
/**
 *  全选左边的 勾勾按钮
 */
@property (nonatomic ,strong)UIButton *gouBtn;

@property (nonatomic ,strong)NSMutableArray *arrCell;

@property (nonatomic ,assign)BOOL isManaging;
/**
 *  要删除的商品id
 */
@property (nonatomic ,strong)NSMutableArray *arrDelete;
/**
 *  现在已有的商品id数组
 */
@property (nonatomic ,strong)NSMutableArray *arrCurrentIDS;

@property (nonatomic,strong)UITableView * tabelView;
@end

@implementation SMShelfProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isRootShelf) {
        self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-175-44-44);
    }
    
    //[self.view addSubview:self.collectionView];
    [self.view addSubview:self.tabelView];
    //[self loadSplite];
//    直接获取网络新数据
    //static NSInteger i=0;

    [self loadDatas];

    
    //是添加的才注册通知 没有添加不添加观察者
    if (!self.isBelongCounter) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDatas:) name:KRefreshDatasNote object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouBtnDidClick:) name:@"KDeleteNoteProduct" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClickNote) name:@"KDeleteBtnClickNoteProduct" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshupData) name:@"RefreshData" object:nil];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

-(void)refreshupData
{
    [self loadDatas];
}
- (void)deleteBtnClickNote{
    [self loadDatas];
}

- (void)gouBtnDidClick:(NSNotification *)note{
    
    NSString *selectedStr = note.userInfo[@"KSelectedStrProduct"];
    SMLog(@"%zd",selectedStr.integerValue);
    NSString *modleID = note.userInfo[@"KModleIDProduct"];
    if (selectedStr.integerValue) { //如果勾勾是选中状态
        NSInteger flag = 0;
        for (NSString *ID in self.arrDelete) {
            if ([modleID isEqualToString:ID]) {
                flag++;
            }
        }
        if (flag == 0) {
            [self.arrDelete addObject:modleID];
        }
        SMLog(@"self.arrDelete   1   %@",self.arrDelete);
    }else{  //如果勾勾是  未选中状态
        //拿到模型在数组中的位置，并移除
        NSInteger index = [self.arrDelete indexOfObject:modleID];
    
        [self.arrDelete removeObjectAtIndex:index];
        SMLog(@"self.arrDelete  0   %@",self.arrDelete);
        SMLog(@"modleID   %@",modleID);
    }
    
    SMLog(@"%@",self.arrDelete);
}

- (void)loadDatas{
    SMLog(@"loadDatas   self.fav.id    %@",self.fav.id);
    [self.arrCurrentIDS removeAllObjects];
    [[SKAPI shared] queryMyStorageItems:self.fav.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arrM = [NSMutableArray array];
            
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [arrM addObject:f];
                    [self.arrCurrentIDS addObject:f.itemId];
                }
            }
            self.arrProducts = arrM;
            // 在这里把数据存下来
            [self saveSqliteWithDatas:[arrM copy]];
            
            SMLog(@"self.arrProducts   %@",self.arrProducts);
//            [self.collectionView reloadData];
            [self.tabelView reloadData];
        }else{
            SMLog(@"error  %@",error);
            //加载失败时  读取本地数据
            [self loadSplite];
        }
    }];
}

- (void)refreshDatas:(NSNotification *)note{
    NSString *favID = note.userInfo[KFavID];
    [[SKAPI shared] queryMyStorageItems:favID block:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arrM = [NSMutableArray array];
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [arrM addObject:f];
                    [self.arrCurrentIDS addObject:f.itemId];
                }
            }
            self.arrProducts = arrM;
//            [self.collectionView reloadData];
            [self.tabelView reloadData];
            SMLog(@"self.arrProducts   refreshDatas   %@",self.arrProducts);
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)loadView{ //自定义设置控制器的View(可改变其类型)
    CGFloat height = KScreenHeight - KStateBarHeight - 40 - 10 - 65;
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
    self.view = bgview;
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"collectionView   cellForItemAtIndexPath ");
    UINib *nib = [UINib nibWithNibName:@"SMShelfProductCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:KShelfProductCell];
    
//    SMShelfProductCell *cell = [SMShelfProductCell shelfProductCell];
    SMShelfProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KShelfProductCell forIndexPath:indexPath];
//    cell.gouBtn.hidden = YES;
    cell.favDetail = self.arrProducts[indexPath.row];
    
//    if (self.isManaging) {
//        cell.gouBtn.hidden = YES;
//        SMLog(@"self.isManaging    %zd",self.isManaging);
//    }
    
    [self.arrCell addObject:cell];
    
    //    [collectionView registerNib:[UINib nibWithNibName:@"SMProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:KCollectionViewCell];
    //    SMProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCollectionViewCell forIndexPath:indexPath];
    
    self.collectionView.backgroundColor = SMColor(244, 245, 246);
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
  
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    SMLog(@"点击了 collectionViewCell   %zd",indexPath.row);
    if ([self.delegate respondsToSelector:@selector(productCellDidClick:isBelongToCounter:)]) {
        [self.delegate productCellDidClick:indexPath.row isBelongToCounter:self.isBelongCounter];
    }
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    
    CGFloat w;
    CGFloat h;
    CGFloat margin = 10;
    
    if (isIPhone5) {
        h = 170;
    }else if (isIPhone6){
        h = 170 *KMatch6Height;
    }else if (isIPhone6p){
        h = 170 *KMatch6pHeight;
    }
    
    w = (KScreenWidth - 3 * margin) / 2.0;
    
    return CGSizeMake (KScreenWidth , h);

//    CGFloat margin = 10;
//    CGFloat w = (KScreenWidth - 3 *margin) / 2;
    
//    return CGSizeMake (w , 220);
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section{
    
    return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrProducts.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMNewHotProductCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.favoritesDetail = self.arrProducts[indexPath.row];
   // [self.arrCell addObject:cell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 175;
    }else if (isIPhone6){
        height = 175 *KMatch6Height;
    }else if (isIPhone6p){
        height = 175 *KMatch6pHeight;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(productCellDidClick:isBelongToCounter:)]) {
        [self.delegate productCellDidClick:indexPath.row isBelongToCounter:self.isBelongCounter];
    }
}
#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView. delegate = self ;
        _collectionView. dataSource = self ;
        _collectionView.backgroundColor = KControllerBackGroundColor;
    }
    return _collectionView;
}

-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = KControllerBackGroundColor;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabelView registerNib:[UINib nibWithNibName:@"SMNewHotProductCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
    }
    return _tabelView;
}
#pragma mark -- 点击事件

- (void)managerAllClick{
    SMLog(@"点击了批量管理");
    //加载出 下面的删除按钮
    [self.view addSubview:self.bottomViewDelete];
    [_bottomViewDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@50);
    }];
//    
//    self.isManaging = isManaging;
//    [self.collectionView reloadData];
    
//    for (SMShelfProductCell *cell in self.arrCell) {
//        cell.gouBtn.hidden = NO;
//        
//    }
    for (FavoritesDetail *f in self.arrProducts) {
        if (f.type == 0) {
            f.isMoveRight = !f.isMoveRight;
        }
    }
    
//    [self.collectionView reloadData];
    [self.tabelView reloadData];
    
    
//    self.arrCell = nil;
//    [self.collectionView reloadData];
}

- (void)managerAllClickAgain{
    SMLog(@"再次点击了批量管理");
    [self.bottomViewDelete removeFromSuperview];
    
    for (FavoritesDetail *f in self.arrProducts) {
        if (f.type == 0) {
            f.isMoveRight = !f.isMoveRight;
        }
    }
    
    //[self.arrDelete removeAllObjects];
    
//    [self.collectionView reloadData];
    [self.tabelView reloadData];
//    self.arrCell = nil;
//    [self.collectionView reloadData];
}

#pragma mark -- 懒加载
- (UIView *)bottomViewDelete{
    if (_bottomViewDelete == nil) {
        _bottomViewDelete = [[UIView alloc] init];
        _bottomViewDelete.backgroundColor = [UIColor whiteColor];
        
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [_bottomViewDelete addSubview:deleteBtn];
        [deleteBtn setTitle:@"下架" forState:UIControlStateNormal];
        [deleteBtn setBackgroundColor:KRedColor];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(_bottomViewDelete.mas_right).with.offset(0);
            make.top.equalTo(_bottomViewDelete.mas_top).with.offset(0);
            make.bottom.equalTo(_bottomViewDelete.mas_bottom).with.offset(0);
            make.width.equalTo(@85);
        }];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        //圆圈
        UIButton *gouBtn = [[UIButton alloc] init];
        [_bottomViewDelete addSubview:gouBtn];
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"honggou"] forState:UIControlStateSelected];
        
        [gouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomViewDelete.mas_centerY);
            make.left.equalTo(_bottomViewDelete.mas_left).with.offset(5);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [gouBtn addTarget:self action:@selector(gouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.gouBtn = gouBtn;
        
        //全选
        UIButton *allSelectedBtn = [[UIButton alloc]  init];
        [_bottomViewDelete addSubview:allSelectedBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"全选" attributes:dict];
        [allSelectedBtn setAttributedTitle:str forState:UIControlStateNormal];
        allSelectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [allSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomViewDelete.mas_centerY);
            make.left.equalTo(gouBtn.mas_right).with.offset(5);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [allSelectedBtn addTarget:self action:@selector(allSelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //给一条灰色横线
        UIView *grayLine = [[UIView alloc] init];
        [_bottomViewDelete addSubview:grayLine];
        grayLine.backgroundColor = KControllerBackGroundColor;
        
        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_bottomViewDelete.mas_left).with.offset(0);
            make.right.equalTo(_bottomViewDelete.mas_right).with.offset(0);
            make.top.equalTo(_bottomViewDelete.mas_top).with.offset(0);
            make.height.equalTo(@1);
        }];
    }
    return _bottomViewDelete;
}

- (NSMutableArray *)arrCell{
    if (_arrCell == nil) {
        _arrCell = [NSMutableArray array];
    }
    return _arrCell;
}


//点了全选
- (void)allSelectedBtnClick:(UIButton *)btn{
    SMLog(@"点了全选按钮");
    [self gouBtnClick:self.gouBtn];
}
//点了全选 左边的勾勾
- (void)gouBtnClick:(UIButton *)btn{
    SMLog(@"点击了 全选勾勾");
    btn.selected = !btn.selected;
    //如果全选左边的勾勾 按钮为选中状态。则把每一个cell 内的勾勾都变为选中状态
    if (self.gouBtn.selected) {
        for (FavoritesDetail *f in self.arrProducts) {
//            f.isAllSelected = YES;
            f.isSelected = YES;
            NSString *selectedStr = [NSString stringWithFormat:@"%zd",f.isSelected];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"KSelectedStrProduct"] = selectedStr;
            dict[@"KModleIDProduct"] = f.id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteProduct" object:self userInfo:dict];
        }
    }else{        
        for (FavoritesDetail *f in self.arrProducts) {
//            f.isAllSelected = NO;
            f.isSelected = NO;
            NSString *selectedStr = [NSString stringWithFormat:@"%zd",f.isSelected];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"KSelectedStrProduct"] = selectedStr;
            dict[@"KModleIDProduct"] = f.id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteProduct" object:self userInfo:dict];
        }
    }
    
//    [self.collectionView reloadData];
    [self.tabelView reloadData];
}

- (void)deleteBtnClick{
    SMLog(@"点击了 下架按钮");
    
//    for (NSString *ID in self.arrDelete) {
//        NSInteger index = [self.arrCurrentIDS indexOfObject:ID];
//        SMLog(@"deleteBtnClick    index   %zd",self.arrCurrentIDS);
//        [self.arrCurrentIDS removeObjectAtIndex:index];
//    }
//    [self.collectionView reloadData];
//    [[SKAPI shared] createItem2MyStorage:self.fav.id andName:@"" andProductIds:self.arrCurrentIDS andActivityIds:@[] andCouponIds:@[] block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result  %@",result);
//            
////          [self.collectionView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteBtnClickNoteProduct" object:self];
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
    SMLog(@"self.arrDelete = %@",self.arrDelete);

   
    [[SKAPI shared] deleteMyStorageItems:self.arrDelete andFavId:self.fav.id andType:0 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [self.arrDelete removeAllObjects];
            //[self.collectionView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteBtnClickNoteProduct" object:self];
            self.gouBtn.selected = NO;
        }else
        {
            SMLog(@"%@",error);
        }
    }];
    
    //[self loadDatas];
}

#pragma mark -- 懒加载
- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
}

- (NSMutableArray *)arrDelete{
    if (_arrDelete == nil) {
        _arrDelete = [NSMutableArray array];
    }
    return _arrDelete;
}

- (NSMutableArray *)arrCurrentIDS{
    if (_arrCurrentIDS == nil) {
        _arrCurrentIDS = [NSMutableArray array];
        
    }
    return _arrCurrentIDS;
}


-(void)saveSqliteWithDatas:(NSArray *)array
{
    //存之前需要删除 原来的数据
    
    SMLog(@"%@",array);
    NSArray * sandBoxArray = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.fav.id inContext:[NSManagedObjectContext MR_defaultContext]];
    
   
        for (LocalFavoritesDetail * localdetail in sandBoxArray) {
           //这边要区分出  产品/活动/优惠券  对应删除
            if (localdetail.type.integerValue==0) {
                
                [localdetail MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (FavoritesDetail * detail in array) {
            if (detail.type == 0) {
                LocalFavoritesDetail * favoritesDetail = [LocalFavoritesDetail MR_createEntityInContext:localContext];
                favoritesDetail.id = detail.id;
                favoritesDetail.isMoveRight = [NSNumber numberWithInteger:detail.isMoveRight];
                favoritesDetail.isAllSelected =[NSNumber numberWithInteger:detail.isAllSelected];
                favoritesDetail.itemId = detail.itemId;
                favoritesDetail.itemName = detail.itemName;
                favoritesDetail.value1 = detail.value1;
                favoritesDetail.value2 = detail.value2;
                favoritesDetail.value3 = detail.value3;
                favoritesDetail.startTime = [NSNumber numberWithInteger:detail.startTime];
                favoritesDetail.endTime = [NSNumber numberWithInteger:detail.endTime];
                favoritesDetail.type = [NSNumber numberWithInteger:detail.type];
                favoritesDetail.imagePath = detail.imagePath;
                favoritesDetail.descr = detail.descr;
                favoritesDetail.favID = self.fav.id;
            }
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
}

-(void)loadSplite
{
    //先清除数组
    [self.arrProducts removeAllObjects];
    //查找到相应的数据
    NSArray * array = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.fav.id inContext:[NSManagedObjectContext MR_defaultContext]];
    //如果没有数据 直接请求
    if (array.count==0) {
        [self loadDatas];
    }else
    {
        for (LocalFavoritesDetail * localFavoritesDetail in array) {
            if (localFavoritesDetail.type.integerValue==0) {
                FavoritesDetail * favoritesDetail = [FavoritesDetail new];
                favoritesDetail.id = localFavoritesDetail.id;
                favoritesDetail.isMoveRight = localFavoritesDetail.isMoveRight.integerValue;
                favoritesDetail.isAllSelected =localFavoritesDetail.isAllSelected.integerValue;
                favoritesDetail.itemId = localFavoritesDetail.itemId;
                favoritesDetail.itemName = localFavoritesDetail.itemName;
                favoritesDetail.value1 = localFavoritesDetail.value1;
                favoritesDetail.value2 = localFavoritesDetail.value2;
                favoritesDetail.value3 = localFavoritesDetail.value3;
                favoritesDetail.startTime = localFavoritesDetail.startTime.integerValue;
                favoritesDetail.endTime = localFavoritesDetail.endTime.integerValue;
                favoritesDetail.type = localFavoritesDetail.type.integerValue;
                favoritesDetail.imagePath = localFavoritesDetail.imagePath;
                favoritesDetail.descr = localFavoritesDetail.descr;
                
                [self.arrProducts addObject:favoritesDetail];
            }
            
        }
    }
    
//    [self.collectionView reloadData];
    [self.tabelView reloadData];
}

@end
