//
//  SMHomePageCollectionCell0.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell0.h"
#import "SMDataStation.h"
#import "SMDataValue.h"
@interface SMHomePageCollectionCell0 ()

@property (nonatomic ,strong)UILabel *title;/**< 今日收入 */

@property (nonatomic ,strong)UILabel *inComeLabel;/**< 具体收入多少 */

@end

@implementation SMHomePageCollectionCell0

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *title = [[UILabel alloc] init];
        self.title = title;
        [self.contentView addSubview:self.title];
        title.textColor = [UIColor whiteColor];
        title.font = KDefaultFont;
        title.text = @"今日收入(元)";
        
        
        UILabel *inComeLabel = [[UILabel alloc] init];
        self.inComeLabel = inComeLabel;
        [self.contentView addSubview:self.inComeLabel];
        inComeLabel.textColor = [UIColor whiteColor];
        inComeLabel.font = KDefaultFontBig;
        inComeLabel.text = @"¥";
        
        self.backgroundColor = KHomePageRed;
    }
    return self;
}

- (void)setData:(SMDataStation *)data{
    _data = data;
    if (data.name == nil) {
        self.title.text = @"";
    }else{
        self.title.text = data.name;
    }
    
    SMLog(@"data  setData  %@ ",data.name);
}
- (void)setValue:(SMDataValue *)value{
    _value = value;
    if (value.value == nil) {
        self.inComeLabel.text = @"暂无数据";
        self.inComeLabel.textAlignment = NSTextAlignmentCenter;
    }else if ([self.title.text isEqualToString:@"今日订单数"] || [self.title.text isEqualToString:@"我的合伙人"] || [self.title.text isEqualToString:@"待发货订单"] || [self.title.text isEqualToString:@"待付款单数"] || [self.title.text isEqualToString:@"二级订单数"]){
        self.inComeLabel.text = [NSString stringWithFormat:@"%@",value.value];
        self.inComeLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        self.inComeLabel.text = [NSString stringWithFormat:@"¥%.2f",value.value.floatValue];
        self.inComeLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    SMLog(@"value  setvalue  %@ ",value.value);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSNumber *titleHeight = [NSNumber numberWithFloat:15 *SMMatchHeight];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).with.offset(20 *SMMatchHeight);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.height.equalTo(titleHeight);
    }];
    
    NSNumber *inComeHeight = [NSNumber numberWithFloat:20 *SMMatchHeight];
    [self.inComeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.mas_bottom).with.offset(20 *SMMatchHeight);
        make.left.equalTo(self.contentView.mas_left).with.offset(40);
        make.right.equalTo(self.contentView.mas_right).with.offset(-40);
        make.height.equalTo(inComeHeight);
    }];
    
//    self.cellHeight = 20 *SMMatchHeight + 15 *SMMatchHeight + 20 *SMMatchHeight + 20 *SMMatchHeight + 20 *SMMatchHeight;
}

@end
