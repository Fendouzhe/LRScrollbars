//
//  SMHomePageCollectionCell3.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell3.h"

@interface SMHomePageCollectionCell3 ()

@property (nonatomic ,strong)UILabel *title;/**< 分享管理 标题 */

@end

@implementation SMHomePageCollectionCell3

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.title = [[UILabel alloc] init];
        self.title.font = KDefaultFont;
        [self.contentView addSubview:self.title];
        self.title.text = @"分销管理";
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
}

@end
