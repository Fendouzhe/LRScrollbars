//
//  SMCardCollectionCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCardCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *botttomLabel;

+ (instancetype)cardCollectionCell;

- (void)getChange:(NSInteger)index;

@end
