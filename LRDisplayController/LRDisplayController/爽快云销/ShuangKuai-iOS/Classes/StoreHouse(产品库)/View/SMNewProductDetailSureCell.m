//
//  SMNewProductDetailSureCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewProductDetailSureCell.h"

@interface SMNewProductDetailSureCell ()

@property (nonatomic ,strong)UIButton *sureBtn;/**< <#注释#> */

@end

@implementation SMNewProductDetailSureCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"newProductDetailSureCell";
    SMNewProductDetailSureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMNewProductDetailSureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.sureBtn = [[UIButton alloc] init];
        self.sureBtn.backgroundColor = KRedColorLight;
        [self.contentView addSubview:self.sureBtn];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFontBig;
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确  定" attributes:dict];
        [self.sureBtn setAttributedTitle:str forState:UIControlStateNormal];
        self.sureBtn.userInteractionEnabled = NO;
        self.sureBtn.layer.cornerRadius = SMCornerRadios;
        self.sureBtn.clipsToBounds = YES;
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.sureBtn.frame = self.contentView.bounds;
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
