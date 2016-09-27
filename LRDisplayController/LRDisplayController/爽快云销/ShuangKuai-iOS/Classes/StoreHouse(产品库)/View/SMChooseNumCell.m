//
//  SMChooseNumCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/19.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChooseNumCell.h"

@interface SMChooseNumCell ()

@property (weak, nonatomic) IBOutlet UIButton *chooseNumBtn;

@end

@implementation SMChooseNumCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"chooseNumCell";
    SMChooseNumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMChooseNumCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.chooseNumBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    self.chooseNumBtn.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseThePhoneNum:) name:@"KChooseThePhoneNum" object:nil];
}

- (void)chooseThePhoneNum:(NSNotification *)noti{
    
    NSString *selectedNum = noti.userInfo[@"KChooseThePhoneNumKey"];
    self.phoneNumLable.text = selectedNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
