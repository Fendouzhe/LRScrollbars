//
//  SMRepostView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRepostView : UIView

@property (nonatomic ,strong)UIView *grayView;
/**
 *  左边的图片
 */
@property (nonatomic ,strong)UIImageView *leftImageView;
/**
 *  右边的文字说明
 */
@property (nonatomic ,strong)UILabel *rightLabel;

@property (nonatomic ,strong)Tweet *tweet;

+ (instancetype)repostView;

- (void)setImageAndLabel:(Tweet *)tweet;
@end
