//
//  SMExpertTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMExpertTableViewCell.h"

@interface SMExpertTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation SMExpertTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //切圆角
    self.iconImage.layer.cornerRadius=22;
    self.iconImage.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(User *)user andPlace:(NSInteger)No
{

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    
    self.iconImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClick)];
    
    [self.iconImage addGestureRecognizer:tap];
    
    self.nameLabel.text = user.name;
    if (!user.sumMoney) {
        self.achievementLabel.text = @"业绩:0.00元";
    }else
    {
        self.achievementLabel.text = [NSString stringWithFormat:@"业绩:%.2f元",user.sumMoney.doubleValue];
    }
    
    self.placeLabel.text  = [NSString stringWithFormat:@"第%ld名",No];
}

-(void)iconClick
{
    SMLog(@"点击 头像");
    
    //跳转至个人详情界面
    self.pushblock();
}
@end
