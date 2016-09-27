//
//  SMPersonCenterCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonCenterCell.h"

@interface SMPersonCenterCell ()
@property (strong, nonatomic) IBOutlet UIView *underView;

@end
@implementation SMPersonCenterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"personCenterCell";
    SMPersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMPersonCenterCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }    
    return cell;
}

- (IBAction)iconBtnClick:(UIButton *)sender {
    SMLog(@"点击了头像按钮");
    if ([self.delegate respondsToSelector:@selector(iconBtnDidClick)]) {
        [self.delegate iconBtnDidClick];
    }
}

- (IBAction)circleBtnClick:(UIButton *)sender {
    SMLog(@"点击了 爽快圈按钮");
    if ([self.delegate respondsToSelector:@selector(circleBtnDidClick)]) {
        [self.delegate circleBtnDidClick];
    }
}

- (IBAction)caredBtnClick:(UIButton *)sender {
    SMLog(@"点击了 关注的企业按钮");
    if ([self.delegate respondsToSelector:@selector(caredBtnDidClick)]) {
        [self.delegate caredBtnDidClick];
    }
}



- (void)awakeFromNib {
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    self.iconBtn.layer.cornerRadius = 25;
    self.iconBtn.clipsToBounds = YES;
    
    self.underView.hidden = YES;
}

- (IBAction)erWeiMaClick {
    if ([self.delegate respondsToSelector:@selector(erWeiMaDidClick)]) {
        [self.delegate erWeiMaDidClick];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
