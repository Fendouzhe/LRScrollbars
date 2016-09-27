//
//  SMPasswordInputTopView.h
//  输入密码界面test
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 yuzhongkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPasswordInputTopViewDelegate <NSObject>

- (void)cancelBtnDidClick;

@end

@interface SMPasswordInputTopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIButton *btn6;
/**
 *  上看的提示标语
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,weak)id<SMPasswordInputTopViewDelegate> delegate;

+ (instancetype)passwordInputTopView;

@end
