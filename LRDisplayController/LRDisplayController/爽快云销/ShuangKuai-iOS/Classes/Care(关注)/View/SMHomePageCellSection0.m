//
//  SMHomePageCellSection0.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCellSection0.h"
#import "SMHomePageCollectionCell0.h"
#import "SMHomePageCollectionCell1.h"
#import "SMHomePageCollectionCell2.h"
#import "SMDataStation.h"
#import "SMDataValue.h"

@interface SMHomePageCellSection0 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMHomePageCollectionCell2Delegate>

@property (nonatomic ,strong)UICollectionView *collectionView;/**< collectionView */

@property (nonatomic ,strong)NSMutableArray *arrOpening;/**< 打开的数据 */

@property (nonatomic ,strong)NSMutableArray *arrSection2;/**< collectionview第二组的所有数据 */

@property (nonatomic ,strong)NSMutableArray *arrType;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrValue;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrSection2Value;/**< <#注释#> */

@end

@implementation SMHomePageCellSection0

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"homePageCellSection0";
    SMHomePageCellSection0 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collectionView];
//        self.collectionView regis
    }
    return self;
}

- (void)setArrDatas:(NSArray *)arrDatas{
    _arrDatas = arrDatas;
    //SMLog(@"arrDatas = %@",arrDatas);
    [self.collectionView reloadData];
    {
        //旧版
//    [self.arrOpening removeAllObjects];
//    [self.arrSection2 removeAllObjects];
//    [self.arrType removeAllObjects];
//    [self.arrSection2Value removeAllObjects];
//    
//    for (SMDataStation *data in arrDatas) {
//        if (data.status.integerValue) { //开着的
//            SMLog(@"data.name setArrDatas  %@  ",data.name);
//            [self.arrOpening addObject:data];
//            [self.arrType addObject:[NSNumber numberWithInteger:data.type]];
//        }
//    }
//
//    NSNumber *num;
//    if (self.arrOpening.count > 0) {
//        num = @1;
//    }else{
//        num = @2;
//    }
//    
//    
////    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
////    dict[@"KChangeCellHeight0Key"] = num;
////    [[NSNotificationCenter defaultCenter] postNotificationName:KChangeCellHeight0 object:self userInfo:dict];
//    for (id x in self.arrType) {
//        SMLog(@"x  self.arrType   %@ ",x);
//    }
//    
//    //从接口拿到每个字段对应的值
//    [[SKAPI shared] queryDataStatistics:self.arrType block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result  queryDataStatistics  %@   [result class]   %@",result,[result class]);
//            self.arrValue = [SMDataValue mj_objectArrayWithKeyValuesArray:result];
//            for (SMDataValue *value in self.arrValue) {
//                NSInteger index = [self.arrValue indexOfObject:value];
//                if (index != 0) {
//                    [self.arrSection2Value addObject:value];
//                }
//            }
//            [self.collectionView reloadData];
//        }else{
//            SMLog(@"error   %@ ",error);
//        }
//    }];
//    
//    //把数组第一个元素剔除，得到的新数组就是 section2 里面的title了
//    for (SMDataStation *data in self.arrOpening) {
//        NSInteger index = [self.arrOpening indexOfObject:data];
//        if (index != 0) {
//            [self.arrSection2 addObject:data];
//        }
//    }
//
//    [self.collectionView reloadData];
    }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //旧版
    //return 3;
    
    //新版
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //旧版
//    if (section == 0) {
//        return 1;
//    }else if (section == 1){
//        return self.arrSection2.count;
//    }else if (section == 2){
//        return 1;
//    }
//    return 0;
    
    //新版
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //旧版
//    if (indexPath.section == 0) {
//        [collectionView registerClass:[SMHomePageCollectionCell0 class] forCellWithReuseIdentifier:@"homePageCollectionCell0"];
//        SMHomePageCollectionCell0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell0" forIndexPath:indexPath];
////        self.cell0Height = cell.cellHeight;
//        
//        cell.data = self.arrOpening.firstObject;
//        cell.value = self.arrValue.firstObject;
//        //SMLog(@"cell.cellHeight  %f",cell.cellHeight);
//        return cell;
//    }else if (indexPath.section == 1){
//        [collectionView registerClass:[SMHomePageCollectionCell1 class] forCellWithReuseIdentifier:@"homePageCollectionCell1"];
//        SMHomePageCollectionCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell1" forIndexPath:indexPath];
////        [self.arrOpening removeObjectAtIndex:0];
//        cell.data = self.arrSection2[indexPath.row];
//        if (self.arrSection2Value.count) {
//            cell.value = self.arrSection2Value[indexPath.row];
//        }
//        
//        //SMLog(@"indexPath.row  cellForItemAtIndexPath   %zd   self.arrOpening.count   %zd",indexPath.row,self.arrSection2.count );
////        if ((indexPath.row + 1) % 4 == 0) { //如果是最右边的item 就隐藏item内部最右边的竖线
////            [cell hideRightView];
////        }
//        return cell;
//    }else if (indexPath.section == 2){//更多数据按钮
//        [collectionView registerClass:[SMHomePageCollectionCell2 class] forCellWithReuseIdentifier:@"homePageCollectionCell2"];
//        SMHomePageCollectionCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell2" forIndexPath:indexPath];
//        cell.delegate = self;
//        return cell;
//    }
    
    //新版
    if (indexPath.section == 0){
        [collectionView registerClass:[SMHomePageCollectionCell1 class] forCellWithReuseIdentifier:@"homePageCollectionCell1"];
        SMHomePageCollectionCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell1" forIndexPath:indexPath];
        cell.dataModel = self.arrDatas[indexPath.item];
        return cell;
    }else if (indexPath.section == 1){//更多数据按钮
        [collectionView registerClass:[SMHomePageCollectionCell2 class] forCellWithReuseIdentifier:@"homePageCollectionCell2"];
        SMHomePageCollectionCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell2" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //旧版
//    if (indexPath.section == 0) {
////        if (self.arrOpening.count == 0) {
////            return CGSizeMake(0, 0);
////        }
//        return CGSizeMake(KScreenWidth, (20 + 15 + 20 + 20 + 20) *SMMatchHeight);
//    }else if (indexPath.section == 1){
//        
//        return CGSizeMake(KScreenWidth / 4.0, (10 + 10 + 15 + 20 + 15)*SMMatchHeight);
//    }else if (indexPath.section == 2){
//        return CGSizeMake(KScreenWidth, 25 *SMMatchHeight);
//    }
    //新版
    if (indexPath.section == 0){
        return CGSizeMake(KScreenWidth / 3.0, (10 + 10 + 15 + 20 + 15)*SMMatchHeight);
    }else if (indexPath.section == 1){
        return CGSizeMake(KScreenWidth, (25+1) *SMMatchHeight);
    }
    return CGSizeMake(0, 0);
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0 ,0 ,0 ,0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(homePageCellSection0DataClickWithIndex:)]) {
        [self.delegate homePageCellSection0DataClickWithIndex:indexPath.item];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.collectionView.frame = self.contentView.bounds;
    //SMLog(@"self.collectionView.frame  %@",NSStringFromCGRect(self.collectionView.frame));
}

#pragma mark -- 代理点击事件
- (void)addBtnDidClick{
    if ([self.delegate respondsToSelector:@selector(addBtnDidClick)]) {
        [self.delegate addBtnDidClick];
    }
}


#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = KBlackColorLight;//KHomePageRed;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.layer.shadowOffset = CGSizeMake(-5, -5);
        _collectionView.layer.shadowColor = [UIColor greenColor].CGColor;
        _collectionView.layer.shadowOpacity = 0.5;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)arrOpening{
    if (_arrOpening == nil) {
        _arrOpening = [NSMutableArray array];
    }
    return _arrOpening;
}

- (NSMutableArray *)arrSection2{
    if (_arrSection2 == nil) {
        _arrSection2 = [NSMutableArray array];
    }
    return _arrSection2;
}

- (NSMutableArray *)arrType{
    if (_arrType == nil) {
        _arrType = [NSMutableArray array];
    }
    return _arrType;
}

- (NSMutableArray *)arrSection2Value{
    if (_arrSection2Value == nil) {
        _arrSection2Value = [NSMutableArray array];
    }
    return _arrSection2Value;
}
@end
