//
//  CustomerDetailBigFrameModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CustomerDetailJustHeightModel;
@interface CustomerDetailBigFrameModel : NSObject
@property (nonatomic,strong) CustomerDetailJustHeightModel *cellModel;/**<  */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */
@end
