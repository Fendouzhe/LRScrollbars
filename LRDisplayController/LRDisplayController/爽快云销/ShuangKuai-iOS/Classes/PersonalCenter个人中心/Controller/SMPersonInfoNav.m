//
//  SMPersonInfoNav.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoNav.h"



@implementation SMPersonInfoNav

+ (instancetype)personInfoNav{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMPersonInfoNav" owner:nil options:nil] lastObject];
}


- (IBAction)back:(id)sender {
    if (_backBlock) {
        self.backBlock();
    }
}

- (IBAction)edit:(id)sender {
    if (_editBlock) {
        self.editBlock();
    }
}

- (IBAction)setting:(id)sender {
    if (_settingBlock) {
        self.settingBlock();
    }
}

- (void)awakeFromNib{
    self.icon.layer.cornerRadius = 15;
    self.icon.clipsToBounds = YES;
    self.icon.alpha = 0;
}

- (IBAction)iconBtnClick:(id)sender {
    if (self.iconClickBlock) {
        self.iconClickBlock();
    }
}

@end
