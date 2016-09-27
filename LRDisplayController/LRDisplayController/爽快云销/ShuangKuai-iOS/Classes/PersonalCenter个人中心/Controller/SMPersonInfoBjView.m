//
//  SMPersonInfoBjView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoBjView.h"

@interface SMPersonInfoBjView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@end

@implementation SMPersonInfoBjView

+ (instancetype)personInfoBjView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMPersonInfoBjView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.iconWidth.constant = 68 *SMMatchWidth;
    self.iconHeight.constant = 68 *SMMatchWidth;
    self.icon.layer.cornerRadius = 34 *SMMatchWidth;
    self.icon.clipsToBounds = YES;
}


@end
