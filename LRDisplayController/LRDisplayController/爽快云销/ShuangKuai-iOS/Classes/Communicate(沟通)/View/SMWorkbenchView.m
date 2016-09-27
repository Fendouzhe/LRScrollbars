//
//  SMWorkbenchView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMWorkbenchView.h"

@interface SMWorkbenchView ()

@property (nonatomic ,strong)UIImageView *iconView;

@property (nonatomic ,strong)UILabel *nameLabel;

@end

@implementation SMWorkbenchView

- (instancetype)initWithImage:(UIImage *)image andName:(NSString *)name andTag:(NSInteger)tag{
    if (self = [super init]) {
        
        //图标
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        iconView.image = image;
        
        //名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = name;
        nameLabel.font = KDefaultFontBig;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        self.tag = tag;
        
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap{
    if ([self.deledate respondsToSelector:@selector(workbenchViewDidClickWithTag:)]) {
        [self.deledate workbenchViewDidClickWithTag:self.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iconWH;
    if (isIPhone5) {
        iconWH = 46;
    }else if (isIPhone6){
        iconWH = 46 *KMatch6;
    }else if (isIPhone6p){
        iconWH = 46 *KMatch6p;
    }
    NSNumber *WHNum = [NSNumber numberWithFloat:iconWH];
    
    CGFloat marginTop = KScreenWidth / 3.0 / 3.0 / 2.0;
    
//    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(WHNum);
//        make.height.equalTo(WHNum);
//    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(marginTop);
        make.width.equalTo(WHNum);
        make.height.equalTo(WHNum);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.iconView.mas_centerX);
        make.top.equalTo(self.iconView.mas_bottom).with.offset(15);
    }];
}

@end
