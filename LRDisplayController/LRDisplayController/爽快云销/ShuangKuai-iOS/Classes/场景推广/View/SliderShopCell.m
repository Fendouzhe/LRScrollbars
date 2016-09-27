//
//  SliderShopCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SliderShopCell.h"
#import "SliderShopModel.h"

@interface SliderShopCell ()
@property (nonatomic,weak) UILabel *mainLabel;/**<  */
@property (nonatomic,weak) UILabel *detailLabel;/**< <#属性#> */
@end

@implementation SliderShopCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *mainLabel = [[UILabel alloc] init];
        mainLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:mainLabel];
        self.mainLabel = mainLabel;
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
//            make.height.equalTo(@30);
        }];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(mainLabel.mas_bottom);
        }];
        
        self.mainLabel.textColor = KGrayColor;
        self.detailLabel.textColor = KGrayColor;
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.mainLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = KRedColor;
    }else{
        self.mainLabel.textColor = KGrayColor;
        self.detailLabel.textColor = KGrayColor;
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(void)setCellData:(SliderShopModel *)cellData{
    _cellData = cellData;
    self.mainLabel.text = cellData.title;
    self.detailLabel.text = cellData.detail;
    SMLog(@"%@,%@",cellData.title,cellData.detail);
}

@end
