//
//  SMHomePageCollectionCell4.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell4.h"
#import "UIView+Badge.h"

@interface SMHomePageCollectionCell4 ()

@property (nonatomic ,strong)UIImageView *iconView;/**< 图标 */

@property (nonatomic ,strong)UILabel *nameLabel;/**< 选项名称 */

@end

@implementation SMHomePageCollectionCell4

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        self.iconView.image = [UIImage imageNamed:@"100-我的收入"];
//        self.iconView.contentMode = UIViewContentModeCenter;
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.font = KDefaultFontSmall;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = @"我的收入";
        
    }
    return self;
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.iconView.image = [UIImage imageNamed:imageName];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSNumber *iconWH = [NSNumber numberWithFloat:25 *SMMatchHeight];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    NSNumber *nameHeight = [NSNumber numberWithFloat:15 *SMMatchHeight];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.iconView.mas_bottom).with.offset(5);
        make.height.equalTo(nameHeight);
    }];
    
    
}

@end
