//
//  SMHomePageCollectionCell1.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCollectionCell1.h"
#import "SMDataStation.h"
#import "SMDataValue.h"
#import "SMHomeSection0DataModel.h"

@interface SMHomePageCollectionCell1 ()

@property (nonatomic ,strong)UILabel *topLabel;/**< 上面的label */

@property (nonatomic ,strong)UILabel *bottomLabel;/**< 下面的label */

@property (nonatomic ,strong)UIView *rightView;/**< 右边的竖线 */
@end

@implementation SMHomePageCollectionCell1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.topLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.topLabel];
        self.topLabel.textColor = [UIColor whiteColor];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.font = KDefaultFont13Match;
        //self.topLabel.text = @"今日订单数";
        
        
        self.bottomLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.bottomLabel];
        self.bottomLabel.textColor = [UIColor whiteColor];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.font = KDefaultFontBig;
        //self.bottomLabel.text = @"";
        
        
        self.rightView = [[UIView alloc] init];
        [self.contentView addSubview:self.rightView];
        self.rightView.backgroundColor = [UIColor whiteColor];
        self.rightView.alpha = 0.2;
        self.rightView.hidden = YES;
        
        //self.backgroundColor = KHomePageRed;
        self.backgroundColor = KBlackColorLight;
    }
    return self;
}

- (void)setDataModel:(SMHomeSection0DataModel *)dataModel{
    
    _dataModel = dataModel;
    //SMLog(@"setDataModel: type = %lu value = %@",dataModel.type,dataModel.value);
    if (dataModel.type == 1) {//今日收入
        self.topLabel.text = @"今日收入";
    }else if (dataModel.type == 2) {//本周收入
        self.topLabel.text = @"本周收入";
    }else if (dataModel.type == 3) {//本月收入
        self.topLabel.text = @"本月收入";
    }else{
        self.topLabel.text = @"暂无数据";
    }
    
    self.bottomLabel.text = dataModel.value.length == 0 ? @"¥0.00" : [NSString stringWithFormat:@"¥%@",dataModel.value];
}

//旧版
- (void)setData:(SMDataStation *)data{
    _data = data;
    self.topLabel.text = data.name;
}
//旧版
- (void)setValue:(SMDataValue *)value{
    _value = value;
    //SMLog(@"value = %@",value);
    self.bottomLabel.text = [NSString stringWithFormat:@"%@",value.value];
}


- (void)hideRightView{
    self.rightView.hidden = YES;
}

- (void)showRightView{
    self.rightView.hidden = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSNumber *topLabelHeight = [NSNumber numberWithFloat:10 *SMMatchHeight];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(12 *SMMatchHeight);
        //make.height.equalTo(topLabelHeight);
        make.width.equalTo(self.contentView);
    }];
    
    //NSNumber *bottomLabelHeight = [NSNumber numberWithFloat:20 *SMMatchHeight];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.topLabel.mas_bottom).with.offset(15 *SMMatchHeight);
        //make.height.equalTo(bottomLabelHeight);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10 *SMMatchHeight);
        make.width.equalTo(self.contentView);
    }];
    
    NSNumber *rightViewHeight = [NSNumber numberWithFloat:45 *SMMatchHeight];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(rightViewHeight);
        make.width.equalTo(@0.7);
    }];
    
}

- (void)dealloc{
    SMLog(@"dealloc   SMHomePageCollectionCell1");
}

@end
