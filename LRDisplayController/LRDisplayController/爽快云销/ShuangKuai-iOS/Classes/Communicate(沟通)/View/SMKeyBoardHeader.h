//
//  SMKeyBoardHeader.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMKeyBoardHeaderDelegate <NSObject>

- (void)composeBtnDidClick;

@end

@interface SMKeyBoardHeader :UIView
/**
 *  发表日志按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *composeBtn;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (nonatomic ,weak)id<SMKeyBoardHeaderDelegate> delegate;
+ (instancetype)keyBoardHeader;

@end
