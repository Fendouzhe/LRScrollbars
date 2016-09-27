//
//  SMKeyBoardHeader.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMKeyBoardHeader.h"

@implementation SMKeyBoardHeader

+ (instancetype)keyBoardHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMKeyBoardHeader" owner:nil options:nil] lastObject];
}

- (IBAction)composeBtnClick {
    
    SMLog(@"点击了 发送日志按钮");
    if ([self.delegate respondsToSelector:@selector(composeBtnDidClick)]) {
        [self.delegate composeBtnDidClick];
    }
}


- (void)awakeFromNib{
    
    [self.composeBtn setBackgroundColor:KRedColor];
    self.composeBtn.layer.cornerRadius = SMCornerRadios;
    self.composeBtn.clipsToBounds = YES;
    
}

@end
