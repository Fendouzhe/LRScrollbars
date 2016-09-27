//
//  SMBankCardCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMBankCardCell.h"

@implementation SMBankCardCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"bankCardCell";
    SMBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMBankCardCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
//    self.colorView.backgroundColor = SMRandomColor;
    self.colorView.layer.cornerRadius = SMCornerRadios;
    self.colorView.clipsToBounds = YES;
    self.backgroundColor = KControllerBackGroundColor;
}

- (void)setBankColor:(UIColor *)bankColor{
    _bankColor = bankColor;
    self.colorView.backgroundColor = bankColor;
}

-(void)refreshUI:(BankCard *)bankcard
{
    self.bankNameLabel.text= bankcard.bankName;
    self.bankCardNum.text = bankcard.account;
    self.bankCardNum.text =  [self.bankCardNum.text stringByReplacingCharactersInRange:NSMakeRange(4, 12) withString:@"************"];    
}
@end
