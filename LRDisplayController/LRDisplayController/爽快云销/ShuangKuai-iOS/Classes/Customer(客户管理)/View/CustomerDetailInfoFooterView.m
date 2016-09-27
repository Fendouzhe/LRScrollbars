//
//  CustomerDetailInfoFooterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailInfoFooterView.h"

@interface CustomerDetailInfoFooterView ()
@property (nonatomic,strong) UITextField *textField;/**< 输入框 */
@property (nonatomic,strong) UIButton *button;/**< 确认按钮 */
@end

@implementation CustomerDetailInfoFooterView

-(UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = SMCornerRadios;
        _button.layer.masksToBounds = YES;
        [_button setBackgroundColor:KRedColorLight];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = KDefaultFontBig;
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

-(void)buttonClick{
    if (!self.textField.text.length) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(addNewNoteButtonClickWithStr:)]) {
        [self.delegate addNewNoteButtonClickWithStr:self.textField.text];
        self.textField.text = @"";
    }
}

-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = KDefaultFont;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"输入客户备注信息";
        [self addSubview:_textField];
    }
    return _textField;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        MJWeakSelf
        self.backgroundColor = [UIColor whiteColor];
        [self.button setTitle:@"发布" forState:UIControlStateNormal];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(5);
            make.right.equalTo(weakSelf).with.offset(-10);
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.width.equalTo(@50);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(10);
            make.right.equalTo(weakSelf.button.mas_left).with.offset(-10);
            make.top.equalTo(weakSelf).with.offset(5);
            make.bottom.equalTo(weakSelf).with.offset(-5);
        }];
        
        
    }
    return self;
}



@end
