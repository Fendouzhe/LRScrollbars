//
//  SMChooseTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChooseTableViewCell.h"

@interface SMChooseTableViewCell ()

@property (strong, nonatomic) IBOutlet UIButton *numBtnOne;

@property (strong, nonatomic) IBOutlet UIButton *numBtnTwo;

@end
@implementation SMChooseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"chooseTableViewCell";
    SMChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMChooseTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setLeftNum:(NSString *)leftNum{
    _leftNum = leftNum;
    [self.numBtnOne setTitle:leftNum forState:UIControlStateNormal];
}

- (void)setRightNum:(NSString *)rightNum{
    _rightNum = rightNum;
    [self.numBtnTwo setTitle:rightNum forState:UIControlStateNormal];
}


- (IBAction)chooseBtnAction:(UIButton *)sender {
    SMLog(@"选择了号码");
    if ([self.delegate respondsToSelector:@selector(choosePhoneNum:)]) {
        [self.delegate choosePhoneNum:sender];
    }
}

@end
