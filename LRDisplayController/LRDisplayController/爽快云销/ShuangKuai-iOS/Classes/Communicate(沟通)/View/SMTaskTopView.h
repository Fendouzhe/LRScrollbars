//
//  SMTaskTopView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TaskBtnTypeAll,
    TaskBtnTypeAlready,
    TaskBtnTypeNotDone,
} TaskBtnType;

@protocol SMTaskTopViewDelegate <NSObject>

- (void)taskTopViewDidClick:(UIButton *)btn;

@end

@interface SMTaskTopView : UIView

@property (nonatomic ,weak)id<SMTaskTopViewDelegate> delegate;

+ (instancetype)taskTopView;

@end
