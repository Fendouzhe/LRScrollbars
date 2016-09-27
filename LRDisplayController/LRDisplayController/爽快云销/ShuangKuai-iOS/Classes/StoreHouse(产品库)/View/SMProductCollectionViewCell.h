//
//  SMProductCollectionViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMProductCollectionViewCell : UICollectionViewCell
/**
 *  佣金
 */
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
/**
 *  产品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (nonatomic ,strong)Product *product;
+ (instancetype)productCollectionViewCell;



@end
