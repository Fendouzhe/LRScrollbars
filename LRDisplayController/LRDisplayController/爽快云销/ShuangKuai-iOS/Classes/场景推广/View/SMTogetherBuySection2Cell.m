//
//  SMTogetherBuySection2Cell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTogetherBuySection2Cell.h"
#import "SMPintuanCollectionViewCell.h"
#import "SMGroupbuyDetailList.h"
#import "SMPintuanSingleCollectionCell.h"

@interface SMTogetherBuySection2Cell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *detailArr;

@property(nonatomic,assign)CGFloat hightED;

@end

@implementation SMTogetherBuySection2Cell

- (NSMutableArray *)detailArr{
    if (_detailArr == nil) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

static NSString *const reuserIdentifier = @"SMPintuanCollectionViewCell";
static NSString *const reuserIdentifier8 = @"SMPintuanSingleCollectionCell";

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KScreenWidth - 3*10)/2, KTuiguangCollectionCellHeight * KMatch);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.contentView addSubview:_collectionView];
        _collectionView.backgroundColor = KTuiGuangVcBgColor;
        //_collectionView = collectionView;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMPintuanCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuserIdentifier];
        [_collectionView registerClass:[SMPintuanSingleCollectionCell class] forCellWithReuseIdentifier:reuserIdentifier8];
    }
    return _collectionView;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SMTogetherBuySection2Cell";
    SMTogetherBuySection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.hightED = 0.0;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
}

- (void)setDataArr:(NSArray *)dataArr{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    _dataArr = dataArr;
//    [dataArr enumerateObjectsUsingBlock:^(SMGroupbuyDetailList *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (model.groupbuyStatus == 1) {
//            [self.detailArr addObject:model];
//        }
//    }];
    
    self.hightED = 0; //当重新换数据源的时候 初始化自己的高度. (如果不写 就有一种意外比如 比如一个cell被重用,开始这个cell的collectionView的cell 和重用之后是一样的  self.hightED != hight  重用之前 和重用之后的内容高度 很定是一样的啊 那么他的高度是不用跟新 但是更新tableViewCell的高度的 代理方法还是 要走吧
}


#pragma mark -  UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //Xib
    //SMPintuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier forIndexPath:indexPath];
    SMPintuanSingleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier8 forIndexPath:indexPath];
    SMGroupbuyDetailList *model = self.dataArr[indexPath.item];
    cell.model = model;
    [self updateCollectionViewHight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SMGroupbuyDetailList *model = self.dataArr[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(togetherBuyCollectionViewCellClickWithModel:)]) {
        
        [self.delegate togetherBuyCollectionViewCellClickWithModel:model];
    }
}

#pragma mark -  UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

-(void)updateCollectionViewHight:(CGFloat)hight{
    
    if (self.hightED != hight) { //这个判断起到两个作用 第一 以为这个方法被调用多次这样写 保证 每个cell里面调用一次,切只调用一次  第二是当cell被重用从用的cell上的collectionView内容高度不一样的时候重新 更新跟新高度
        self.hightED = hight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(uodataTableViewCellHight:andHight:andIndexPath:)]) {
            [self.delegate uodataTableViewCellHight:self andHight:hight andIndexPath:self.indexPath];
        }
    }
}


@end
