//
//  SMMakeDiscountDetailViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMakeDiscountDetailViewController : UIViewController
/**
 *  优惠券码
 */
@property (nonatomic ,copy)NSString *codeNum;

@property(nonatomic,strong)Coupon * coupon;

@end
