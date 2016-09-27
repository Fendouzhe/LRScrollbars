//
//  SMScanerBtn.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMScanerBtn.h"

@implementation SMScanerBtn

+ (instancetype)scanerBtn{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (self.isCreatedByCareVC) {
            [self setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
        }else{
            [self setBackgroundImage:[UIImage imageNamed:@"saomiaoGray"] forState:UIControlStateNormal];
        }
        
        
    }
    return self;
}
-(void)setIsCreatedByCareVC:(BOOL)isCreatedByCareVC{
    _isCreatedByCareVC = isCreatedByCareVC;
    [self setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
}

- (void)setIsCreatedByShoppingVC:(BOOL)isCreatedByShoppingVC{
    _isCreatedByShoppingVC = isCreatedByShoppingVC;
    [self setBackgroundImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
}
@end
