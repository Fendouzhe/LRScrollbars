//
//  TaskCommentInputView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskCommentInputView.h"

@interface TaskCommentInputView ()<UITextViewDelegate>


@end

@implementation TaskCommentInputView
//-(UIButton *)button{
//    if (_button == nil) {
//        _button = [UIButton buttonWithType:UIButtonTypeCustom];
//        _button.layer.cornerRadius = SMCornerRadios;
//        _button.layer.masksToBounds = YES;
//        [_button setBackgroundColor:KRedColorLight];
////        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//    }
//    return _button;
//}

-(void)buttonClick{
    if (!self.textField.text.length) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(postCommentWithStr:)]) {
        [self.delegate postCommentWithStr:self.textField.text];
        self.textField.text = @"";
    }
}

//-(UITextView *)textField{
//    if (_textField == nil) {
//        _textField = [[UITextView alloc] init];
//        _textField.delegate = self;
//        _textField.font = [UIFont systemFontOfSize:16];
//        _textField.layer.cornerRadius = 6;
//        _textField.layer.masksToBounds = YES;
//        [self addSubview:_textField];
//    }
//    return _textField;
//}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        MJWeakSelf
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        lineView.backgroundColor = SMColor(209, 209, 209);
//        [self addSubview:lineView];
//        self.backgroundColor = SMColor(241, 241, 241);
////        self.backgroundColor = [UIColor redColor];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = KDefaultFontBig;
//        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发送" attributes:dict];
//        [self.button setAttributedTitle:str forState:UIControlStateNormal];
//        
//        
//        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf).with.offset(lineView.height+6);
//            make.right.equalTo(weakSelf).with.offset(-10);
//            make.bottom.equalTo(weakSelf).with.offset(-6);
//            make.width.equalTo(@58);
//        }];
//        
//        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf).with.offset(10);
//            make.right.equalTo(weakSelf.button.mas_left).with.offset(-10);
////            make.top.equalTo(weakSelf).with.offset(5);
////            make.bottom.equalTo(weakSelf).with.offset(-5);
//            make.centerY.equalTo(weakSelf.button.mas_centerY);
//            make.height.equalTo(@(minHeight));
//        }];
//        
// 
//        //占位文本
//        UILabel *placeHolderLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.textField.left+3, _textField.y, _textField.width-3, _textField.height)];
//        placeHolderLabel.text = @"请输入评论内容";
//        placeHolderLabel.textColor = [UIColor lightGrayColor];
//        placeHolderLabel.font = [UIFont systemFontOfSize:18];
//        [self addSubview:placeHolderLabel];
//        self.placeHolderLabel = placeHolderLabel;
//        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.textField.mas_left).offset(3);
//            make.top.equalTo(weakSelf.textField.mas_top);
//            make.bottom.equalTo(weakSelf.textField.mas_bottom);
//            make.width.equalTo(weakSelf.textField.mas_width);
//        }];
        
        
        //self.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor = SMColor(209, 209, 209);
        [self addSubview:lineView];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat margin = 10;
        //输入框
        UITextView *inputTextView = [[UITextView alloc] init];//WithFrame:CGRectMake(screenWidth*0.05, 4 + lineView.height, screenWidth*0.7, minHeight)];
        [self addSubview:inputTextView];
        self.textField = inputTextView;
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.layer.borderWidth = 0.8;
        self.textField.layer.borderColor = SMColor(209, 209, 209).CGColor;
        self.textField.layer.cornerRadius = 6;
        self.textField.layer.masksToBounds = YES;
        
        //占位文本
        UILabel *placeHolderLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.textField.left+3, inputTextView.y, inputTextView.width-3, inputTextView.height)];
        placeHolderLabel.text = @"请输入评论内容";
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        placeHolderLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:placeHolderLabel];
        self.placeHolderLabel = placeHolderLabel;
        
        //发送按钮
        UIButton *senMessageButton = [[UIButton alloc] init];//WithFrame:CGRectMake(self.textField.right+10, self.textField.bottom-minHeight, screenWidth*0.18, minHeight)];
        senMessageButton.backgroundColor = KRedColorLight;
        [senMessageButton setTitle:@"发送" forState:UIControlStateNormal];
        senMessageButton.layer.cornerRadius = 8;
        senMessageButton.layer.masksToBounds = YES;
        [senMessageButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:senMessageButton];
        self.button = senMessageButton;
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-4);
            make.right.equalTo(weakSelf.mas_right).offset(-margin);
            make.width.equalTo(@58);
            make.height.equalTo(@(minHeight));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.self).offset(margin);
            make.top.equalTo(lineView.mas_bottom).offset(4);
            make.bottom.equalTo(weakSelf).offset(-4);
            make.right.equalTo(weakSelf.button.mas_left).offset(-margin);
        }];
        
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.textField.mas_left).offset(3);
            make.top.equalTo(weakSelf.textField.mas_top);
            make.width.equalTo(weakSelf.textField.mas_width).offset(-3);
            make.height.equalTo(@(minHeight));
        }];
        
    }
    return self;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    self.placeHolderLabel.hidden = textView.text.length;
    
    CGFloat textViewH = 0;
    // 获取contentSize的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        textViewH = minHeight;
    }else if (contentHeight > maxHeight){
        textViewH = maxHeight;
    }else{
        textViewH = contentHeight;
    }
    CGFloat offHeight = textViewH-self.textField.height;
    self.textField.height += offHeight;
    self.button.bottom = self.textField.bottom;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    //    [textView setContentOffset:CGPointZero animated:YES];
    //    [textView scrollRangeToVisible:textView.selectedRange];
    if (offHeight>0||offHeight<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeToolBarHeightNotification object:nil userInfo:@{@"offHeight":@(offHeight)}];
    }
    
    
}
@end
