//
//  SMBankCardCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMBankCardCell : UITableViewCell
/**
 *  银行标志
 */
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
/**
 *  银行名字
 */
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
/**
 *  银行卡号码
 */
@property (weak, nonatomic) IBOutlet UILabel *bankCardNum;
/**
 *  带颜色的那一大块view
 */
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic ,strong)UIColor *bankColor;/**< 银行卡背景颜色 */



+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)refreshUI:(BankCard *)bankcard;
@end
