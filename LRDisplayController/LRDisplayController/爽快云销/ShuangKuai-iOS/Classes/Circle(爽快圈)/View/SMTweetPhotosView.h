//
//  SMTweetPhotosView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTweetPhotosView : UIView
/**
 *  图片的个数
 */
@property (nonatomic ,strong)NSArray *imageStrs;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;

@end
