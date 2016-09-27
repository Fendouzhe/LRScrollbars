//
//  SMNewShoppingSequenceCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMNewShoppingSequenceCellDelegate <NSObject>

- (void)priceDidClick:(UIButton *)btn;

- (void)salesCountDidClick:(UIButton *)btn;

- (void)commisionDidClick:(UIButton *)btn;

- (void)classesDidClick;

- (void)productNewDidClick:(UIButton *)btn;

@end

@interface SMNewShoppingSequenceCell : UICollectionViewCell

//价格排序
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
//销量排序
@property (weak, nonatomic) IBOutlet UIButton *salesCountBtn;
//佣金排序
@property (weak, nonatomic) IBOutlet UIButton *commisionBtn;
// 新品
@property (weak, nonatomic) IBOutlet UIButton *productNew;

@property (nonatomic ,weak)id<SMNewShoppingSequenceCellDelegate> delegate;



@end
