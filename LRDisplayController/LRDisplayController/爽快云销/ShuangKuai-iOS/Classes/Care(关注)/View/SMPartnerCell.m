//
//  SMPartnerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPartnerCell.h"

@interface SMPartnerCell ()
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//业绩,成交额
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@end

@implementation SMPartnerCell

+ (instancetype)cellWithTanleView:(UITableView *)tableView{
    
    static NSString *ID = @"partnerCell";
    SMPartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMPartnerCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction)chatBtnClick {
    if ([self.delegate respondsToSelector:@selector(chatBtnDidClick)]) {
        [self.delegate chatBtnDidClick];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    if (isIPhone5) {
        self.iconW.constant = 40;
    }else if (isIPhone6){
        self.iconW.constant = 40 *KMatch6;
    }else if (isIPhone6p){
        self.iconW.constant = 40 *KMatch6p;
    }
    self.iconH.constant = self.iconW.constant;
    
    self.iconBtn.layer.cornerRadius = self.iconW.constant / 2.0;
    self.iconBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
