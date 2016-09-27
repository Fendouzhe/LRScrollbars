//
//  SMSectionHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSectionHeaderView.h"

@interface SMSectionHeaderView ()



@property (nonatomic ,strong)UILabel *titleLabel;

@property (nonatomic ,strong)UILabel *leftLabel;

@property (nonatomic ,strong)UILabel *rightLabel;

@property (nonatomic ,strong)UIButton *moreBtn;

@property (nonatomic ,assign)CGFloat margin;

@end

@implementation SMSectionHeaderView

//- (instancetype)initWithString:(NSString *)title{
//    
//    SMSectionHeaderView *sectionHeaderView = [[SMSectionHeaderView alloc] init];
//    sectionHeaderView.titleParameter = title;
//    return sectionHeaderView;
//}

- (instancetype)initWithString:(NSString *)title andBtnType:(recommendBtnType)recommendBtnType{
   
    if (self = [super init]) {
        
        //中间的标题Label
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        self.titleLabel.text = title;
        self.titleParameter = title;
//        titleLabel.backgroundColor = [UIColor greenColor];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tintColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        self.leftLabel = leftLabel;
        leftLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        self.rightLabel = rightLabel;
        rightLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:rightLabel];
        
        
        //更多按钮
        UIButton *moreBtn = [[UIButton alloc] init];
        moreBtn.tag = recommendBtnType;
        self.moreBtn = moreBtn;
        [self addSubview:moreBtn];
        NSMutableAttributedString *moreStr = [[NSMutableAttributedString alloc] initWithString:@"更多>"];
        NSRange moreStrLaterRange = {1,2};
        
        [moreStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:moreStrLaterRange];
        [moreStr addAttribute:NSForegroundColorAttributeName value:SMColor(159, 3, 47) range:moreStrLaterRange];
        
        NSRange moreStrFrontRange = {0,2};
        [moreStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:moreStrFrontRange];
        [moreStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:moreStrFrontRange];
        
        [moreBtn setAttributedTitle:moreStr forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)moreBtnDidClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(sectionHeaderMoreBtnClick:)]) {
        [self.delegate sectionHeaderMoreBtnClick:btn];
    }
    
}


//
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
////        self.backgroundColor = [UIColor greenColor];
//        
//        
//        UILabel *titleLabel = [[UILabel alloc] init];
//        self.titleLabel = titleLabel;
//        self.titleLabel.text = self.titleParameter;
//        SMLog(@"%@",self.titleParameter);
//        titleLabel.backgroundColor = [UIColor greenColor];
//        titleLabel.font = [UIFont systemFontOfSize:10];
//        titleLabel.textColor = [UIColor blackColor];
//        titleLabel.tintColor = [UIColor blackColor];
//        [self addSubview:titleLabel];
//        
//        UILabel *leftLabel = [[UILabel alloc] init];
//        self.leftLabel = leftLabel;
//        leftLabel.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:leftLabel];
//        
//        UILabel *rightLabel = [[UILabel alloc] init];
//        self.rightLabel = rightLabel;
//        rightLabel.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:rightLabel];
//        
//        UIButton *moreBtn = [[UIButton alloc] init];
//        self.moreBtn = moreBtn;
//        [self addSubview:moreBtn];
//        NSMutableAttributedString *moreStr = [[NSMutableAttributedString alloc] initWithString:@"更多 >"];
//        NSRange moreStrRange = {2,1};
//        [moreStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:moreStrRange];
//        [moreStr addAttribute:NSForegroundColorAttributeName value:SMColor(159, 3, 47) range:moreStrRange];
//        [moreBtn setAttributedTitle:moreStr forState:UIControlStateNormal];
//        
//    }
//    return self;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.margin = 10;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.titleLabel.mas_left).with.offset(-self.margin);
        make.left.equalTo(self.mas_left).with.offset(self.margin);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@1);
    }];
    
    CGFloat height = self.bounds.size.height - 5 * 2;
    NSNumber *heightNum = [NSNumber numberWithFloat:height];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).with.offset(-self.margin);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(heightNum);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right).with.offset(self.margin);
        make.right.equalTo(self.moreBtn.mas_left).with.offset(-self.margin);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@1);
    }];
    
    
    
}

@end
