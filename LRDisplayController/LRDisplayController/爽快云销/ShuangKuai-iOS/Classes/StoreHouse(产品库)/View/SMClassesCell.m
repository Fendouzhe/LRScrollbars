//
//  SMClassesCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMClassesCell.h"
#import "SMClassesCollectionViewCell.h"
#import "SMClassesLevel2.h"

@interface SMClassesCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong)UICollectionView *collectionView;/**< collectionView */

@end

@implementation SMClassesCell

+ (instancetype)cellWithTableView:(UITableView *)tavbleView{
    
    static NSString *ID = @"classesCell";
    SMClassesCell *cell = [tavbleView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMClassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrLevel2s.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SMClassesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classesCollectionViewCell" forIndexPath:indexPath];
    SMClassesLevel2 *model2 = self.arrLevel2s[indexPath.row];
    cell.model2 = model2;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 10) / 2, 40 *SMMatchHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMClassesLevel2 *model2 = self.arrLevel2s[indexPath.row];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"KSearchProductByClassNotiKey2"] = model2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSearchProductByClassNoti2" object:self userInfo:dict];
}

- (void)setArrLevel2s:(NSArray *)arrLevel2s{
    _arrLevel2s = arrLevel2s;
    
    
    [self.collectionView reloadData];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.collectionView.frame = self.contentView.bounds;
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SMClassesCollectionViewCell class] forCellWithReuseIdentifier:@"classesCollectionViewCell"];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = KControllerBackGroundColor;

    }
    return _collectionView;
}


@end
