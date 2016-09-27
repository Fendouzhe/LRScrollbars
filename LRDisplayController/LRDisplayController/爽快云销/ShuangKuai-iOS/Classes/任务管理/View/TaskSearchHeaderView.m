//
//  TaskSearchHeaderView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskSearchHeaderView.h"

@interface TaskSearchHeaderView ()<UITextFieldDelegate>

@end

@implementation TaskSearchHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KGrayColor;
        [self textField];
    }
    return self;
}

-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        _textField.placeholder = @"搜索手机号等";
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.right.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(5);
            make.bottom.equalTo(self).with.offset(-5);
        }];
    }
    return _textField;
}

-(void)setSearchTextWithStr:(NSString *)str{
    self.textField.text = str;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (!textField.text.length) {
//        return;
//    }
//    if ([self.delegate respondsToSelector:@selector(taskSearchWithStr:)]) {
//        [self.delegate taskSearchWithStr:self.textField.text];
//    }
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        return YES;
    }
    if ([self.delegate respondsToSelector:@selector(taskSearchWithStr:)]) {
        [self.delegate taskSearchWithStr:self.textField.text];
    }
    return YES;
}

@end
