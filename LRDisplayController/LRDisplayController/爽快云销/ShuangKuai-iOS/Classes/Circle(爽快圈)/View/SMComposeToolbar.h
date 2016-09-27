//
//  SMComposeToolbar.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SMComposeToolbarButtonTypeCamera, // 拍照
    SMComposeToolbarButtonTypePicture, // 相册
    SMComposeToolbarButtonTypeMention, // @
    SMComposeToolbarButtonTypeTrend, // #
    SMComposeToolbarButtonTypeEmotion // 表情
}SMComposeToolbarButtonType;

@class SMComposeToolbar;

@protocol SMComposeToolbarDelegate <NSObject>

//用户点了发送微博的工具栏
- (void)composeToolbar:(SMComposeToolbar *)toolbar didClickButton:(SMComposeToolbarButtonType)buttonType;

@end

@interface SMComposeToolbar : UIView

@property (nonatomic, assign) BOOL showKeyboardButton;

@property (nonatomic, weak) id<SMComposeToolbarDelegate> delegate;

@end
