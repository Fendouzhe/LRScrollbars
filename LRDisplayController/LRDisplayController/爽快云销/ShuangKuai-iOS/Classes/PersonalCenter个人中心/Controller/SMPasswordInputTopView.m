//
//  SMPasswordInputTopView.m
//  输入密码界面test
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 yuzhongkeji. All rights reserved.
//

#import "SMPasswordInputTopView.h"

@interface SMPasswordInputTopView ()

@property (weak, nonatomic) IBOutlet UIView *upGrayView;

@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;

@property (weak, nonatomic) IBOutlet UIView *midGrayView;


@end

@implementation SMPasswordInputTopView

+ (instancetype)passwordInputTopView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMPasswordInputTopView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.upGrayView.backgroundColor = KControllerBackGroundColor;
    self.bottomGrayView.backgroundColor = KControllerBackGroundColor;
    self.midGrayView.backgroundColor = KControllerBackGroundColor;
}

- (IBAction)cancelBtnClick {
    SMLog(@"点击了 topView 左边的取消按钮");
    if ([self.delegate respondsToSelector:@selector(cancelBtnDidClick)]) {
        [self.delegate cancelBtnDidClick];
    }
}


@end
