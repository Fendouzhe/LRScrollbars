//
//  SliderShopView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SliderShopView.h"
#import "SliderShopCell.h"

@interface SliderShopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) UICollectionView *collectionView;/**< <#属性#> */
@property (nonatomic,assign) NSInteger selectIndex;/**< <#属性#> */
//@property (nonatomic,assign,getter=isReload) BOOL reload;/**< <#属性#> */
@end

@implementation SliderShopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.itemSize = CGSizeMake(30, 30);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[SliderShopCell class] forCellWithReuseIdentifier:@"SliderShopCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.collectionView = collectionView;
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80.0f,40.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SliderShopCell" forIndexPath:indexPath];
    cell.cellData = self.dataArray[indexPath.item];
    if (self.selectIndex == indexPath.item) {
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SliderShopCell *cell = (SliderShopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.selected = !cell.selected;
    self.selectIndex = indexPath.item;
}

@end
