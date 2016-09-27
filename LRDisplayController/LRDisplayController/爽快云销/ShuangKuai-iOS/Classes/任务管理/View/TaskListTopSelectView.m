//
//  TaskListTopSelectView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskListTopSelectView.h"
#import "RightImageButton.h"

@interface TaskListTopSelectView ()
@property (nonatomic,strong) UIButton *firstButton;/**< 第一个按钮 */
//@property (nonatomic,strong) RightImageButton *secondButton;/**< 第二个按钮 */
//@property (nonatomic,strong) RightImageButton *thirdButton;/**< 第三个按钮 */
@property (nonatomic,weak) UIButton *selectButton;/**< 选中的按钮 */
@property (nonatomic,strong) UIView *lineView;/**< 分割线 */
@end

@implementation TaskListTopSelectView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        UIButton *backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backGroundButton.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
//        [backGroundButton addTarget:self action:@selector(backGroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)backGroundButtonClick{
    
}

-(UIButton *)firstButton{
    if (_firstButton == nil) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _firstButton.titleLabel.font = font;
        [_firstButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:_firstButton];
    }
    return _firstButton;
}

-(RightImageButton *)secondButton{
    if (_secondButton == nil) {
        _secondButton = [RightImageButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _secondButton.titleLabel.font = font;
        [_secondButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secondButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secondButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_secondButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [_secondButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateSelected];
        [self addSubview:_secondButton];
    }
    return _secondButton;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = KGrayColorSeparatorLine;
        [self addSubview:_lineView];
    }
    return _lineView;
}

-(RightImageButton *)thirdButton{
    if (_thirdButton == nil) {
        _thirdButton = [RightImageButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _thirdButton.titleLabel.font = font;
        [_thirdButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_thirdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_thirdButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_thirdButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [_thirdButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateSelected];
        [self addSubview:_thirdButton];
    }
    return _thirdButton;
}

-(void)buttonClick:(UIButton *)btn{
    if (btn==self.firstButton) {
        if ([self.delegate respondsToSelector:@selector(topSelectButtonClick:)]) {
            [self.delegate topSelectButtonClick:0];
        }
        return;
    }
    if (btn ==self.secondButton) {
        if ([self.delegate respondsToSelector:@selector(topSelectButtonClick:)]) {
            [self.delegate topSelectButtonClick:1];
        }
        return;
    }
    if (btn == self.thirdButton) {
        if ([self.delegate respondsToSelector:@selector(topSelectButtonClick:)]) {
            [self.delegate topSelectButtonClick:2];
        }
        return;
    }
}

-(void)setSecondButtonSelectWithText:(NSString *)text{
    [self.secondButton setTitle:text forState:UIControlStateNormal];
    [self.secondButton setTitle:text forState:UIControlStateSelected];
//    self.selectButton.selected = NO;
    if (self.selectButton == self.firstButton) {
        self.selectButton.selected = NO;
    }else{
        
    }
    self.secondButton.selected = YES;
    self.selectButton = self.secondButton;
}

-(void)setThirdButtonSelectWithText:(NSString *)text{
    [self.thirdButton setTitle:text forState:UIControlStateNormal];
    [self.thirdButton setTitle:text forState:UIControlStateSelected];
//    self.selectButton.selected = NO;
    if (self.selectButton == self.firstButton) {
        self.selectButton.selected = NO;
    }else{
        
    }
    self.thirdButton.selected = YES;
    self.selectButton = self.thirdButton;
}

-(void)setFirstButtonSelect:(BOOL)select{
    self.firstButton.selected = select;
}

-(void)setButtonTextWithArray:(NSArray *)array{
    if (array.count==3) {
        [self.firstButton setTitle:array[0] forState:UIControlStateNormal];
        [self.secondButton setTitle:array[1] forState:UIControlStateNormal];
        [self.thirdButton setTitle:array[2] forState:UIControlStateNormal];
    }else{
        SMLog(@"数组长度错误");
    }
}

-(void)setButtonSelectWithNumber:(int)number{
    switch (number) {
        case 0:
        {
            self.firstButton.selected = YES;
            self.secondButton.selected = NO;
            self.thirdButton.selected = NO;
        }
            break;
        case 1:
        {
            self.firstButton.selected = NO;
            self.secondButton.selected = YES;
            self.thirdButton.selected = NO;
        }
            break;
        case 2:
        {
            self.firstButton.selected = NO;
            self.secondButton.selected = NO;
            self.thirdButton.selected = YES;
        }
            break;
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.firstButton sizeToFit];
    [self.secondButton sizeToFit];
    [self.thirdButton sizeToFit];
    CGFloat firstButtonW = self.firstButton.frame.size.width;
    CGFloat firstButtonH = self.firstButton.frame.size.height;
    CGFloat firstButtonX = KScreenWidth/4-firstButtonW*0.5-20;
    CGFloat firstButtonY = (self.frame.size.height - self.firstButton.frame.size.height)*0.5;
    
    self.firstButton.frame= CGRectMake(firstButtonX, firstButtonY, firstButtonW, firstButtonH);
    CGFloat secondButtonW = self.secondButton.frame.size.width;
    CGFloat secondButtonH = self.secondButton.frame.size.height;
    CGFloat secondButtonX = self.frame.size.width*0.5-secondButtonW*0.5;
    CGFloat secondButtonY = (self.frame.size.height - self.secondButton.frame.size.height)*0.5;
    self.secondButton.frame = CGRectMake(secondButtonX, secondButtonY, secondButtonW, secondButtonH);
    CGFloat thirdButtonW = self.thirdButton.frame.size.width;
    CGFloat thirdButtonH = self.thirdButton.frame.size.height;
    CGFloat thirdButtonX = self.frame.size.width - (self.frame.size.width/3 - thirdButtonW)*0.5 - thirdButtonW;
    CGFloat thirdButtonY = (self.frame.size.height - self.thirdButton.frame.size.height)*0.5;
    self.thirdButton.frame = CGRectMake(thirdButtonX, thirdButtonY, thirdButtonW, thirdButtonH);
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 0.5);
}

@end
