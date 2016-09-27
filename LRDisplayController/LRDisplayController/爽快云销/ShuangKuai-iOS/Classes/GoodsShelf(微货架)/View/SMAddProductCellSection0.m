//
//  SMAddProductCellSection0.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddProductCellSection0.h"

@interface SMAddProductCellSection0 ()

@property (nonatomic ,strong)UIButton *searchBtn;/**< 搜索按钮 */

@end

@implementation SMAddProductCellSection0

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KControllerBackGroundColor;
        
        self.searchBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.searchBtn];
        [self.searchBtn setImage:[UIImage imageNamed:@"放大镜"] forState:UIControlStateNormal];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
        dict[NSFontAttributeName] = KDefaultFont;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" 搜索" attributes:dict];
        [self.searchBtn setAttributedTitle:str forState:UIControlStateNormal];
        self.searchBtn.userInteractionEnabled = NO;
        self.searchBtn.backgroundColor = [UIColor whiteColor];
        self.searchBtn.layer.cornerRadius = SMCornerRadios;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
}

@end
