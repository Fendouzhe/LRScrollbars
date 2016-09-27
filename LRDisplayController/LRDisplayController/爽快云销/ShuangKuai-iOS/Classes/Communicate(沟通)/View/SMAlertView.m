//
//  SMAlertView.m
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/7/31.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAlertView.h"

@implementation SMAlertView

+ (instancetype)alertView{
   return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.groupImageView.layer.cornerRadius = self.groupImageView.width * 0.5;
    self.groupImageView.layer.masksToBounds = YES;
    self.inputTextField.delegate = self;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGroupImageNoti:) name:@"GetGroupImageNotification" object:nil];
    
    [self.inputTextField addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
}
- (void)click{
    //if ([UIScreen mainScreen].bounds.size.height <= 667) {
    if (![self.inputTextField isFirstResponder]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TextFieldClickNotification object:nil];
        //return;
    }
    [self.inputTextField becomeFirstResponder];
    //}
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

//- (void)getGroupImageNoti:(NSNotification *)notice{
//    self.groupImageView.image = notice.userInfo[@"image"];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
///添加组图片
- (IBAction)addImageButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(alertViewChooseImageButtonClick:)]) {
        [self.delegate alertViewChooseImageButtonClick:self];
    }
}
///创建群组按钮
- (IBAction)createGroup:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewCreateButtonClick:)]) {
        [self.delegate alertViewCreateButtonClick:self];
    }
}
///取消
- (IBAction)cancel:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alertViewCancelButtonClick:)]) {
        [self.delegate alertViewCancelButtonClick:self];
    }
}


@end
