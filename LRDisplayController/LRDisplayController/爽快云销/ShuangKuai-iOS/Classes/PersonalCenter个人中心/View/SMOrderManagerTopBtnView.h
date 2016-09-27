//
//  SMOrderManagerTopBtnView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderManagerTopBtnView : UIView

@property (nonatomic ,strong)UIButton *icon;

@property (nonatomic ,strong)UILabel *name;

- (instancetype)initWithStr:(NSString *)str image:(UIImage *)image;

- (void)showBlackName;

- (void)showRedName;

@end
