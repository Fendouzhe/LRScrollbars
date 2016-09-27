//
//  SMHomePageCollectionCell0.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMDataStation;
@class SMDataValue;
@interface SMHomePageCollectionCell0 : UICollectionViewCell

@property (nonatomic ,strong)SMDataStation *data;/**< <#注释#> */

@property (nonatomic ,assign)CGFloat cellHeight; /**< cell高度 */

@property (nonatomic ,strong)SMDataValue *value;/**< <#注释#> */

@end
