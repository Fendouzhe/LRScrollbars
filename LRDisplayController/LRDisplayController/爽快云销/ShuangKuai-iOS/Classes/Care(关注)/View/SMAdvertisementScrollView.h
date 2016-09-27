//
//  SMAdvertisementScrollView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAdvertisementScrollView : UIView

//把需要轮播的文字装成一个数组 传进来
//+ (instancetype)advertisementWithArray:(NSArray *)arrAd;

- (instancetype)initWithArray:(NSArray *)arrAd;

@end
