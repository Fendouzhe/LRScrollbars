//
//  SMShareToWXMenu.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/30.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShareToWXMenuDelegate <NSObject>

- (void)wxMenuDidClick;

@end

@interface SMShareToWXMenu : UIView

@property (nonatomic ,weak)id<SMShareToWXMenuDelegate> delegate;

+ (instancetype)shareToWXMenu;

@end
