//
//  SMComposePhotosView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMComposePhotosViewDelegate <NSObject>

- (void)addBtnDidClick;

- (void)locationBtnDidClick;

- (void)photoViewDidClick:(UIButton *)btn andPhotos:(NSMutableArray *)photos;

@end

@interface SMComposePhotosView : UIView

/**
 *  “所在位置” 按钮   
 */
@property (nonatomic ,strong)UIButton *locationBtnText;

@property (nonatomic ,copy)NSString *locationBtnTextStr;

@property (nonatomic ,strong)NSMutableArray *photos;

@property (nonatomic ,weak)id<SMComposePhotosViewDelegate> delegate;

@property (nonatomic ,assign) CGFloat viewHeight;



- (void)addphoto:(UIImage *)photo;

/**
 *重新设置 @“所在位置” 显示的文字
 */
- (void)setBtnTitleAgain:(NSString *)str;

@end
