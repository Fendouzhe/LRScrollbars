//
//  AcceptViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "AcceptViewCell.h"
#import "AcceptViewModel.h"
#import "TaskUserCell.h"

@interface AcceptViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;/**< <#属性#> */

@end

@implementation AcceptViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setCellData:(AcceptViewModel *)cellData{
    _cellData = cellData;
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellData.acceptArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskUserCell" forIndexPath:indexPath];
    cell.user = self.cellData.acceptArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KTaskInfoIconWidth,KTaskInfoIconWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[TaskUserCell class] forCellWithReuseIdentifier:@"TaskUserCell"];
        [self.contentView addSubview:_collectionView];
        MJWeakSelf
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView).with.offset(5);
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-5);
        }];
    }
    return _collectionView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"AcceptViewCell";
    AcceptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AcceptViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

@end
