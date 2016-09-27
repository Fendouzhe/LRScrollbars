//
//  SMMakeDiscountRuleTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMakeDiscountRuleTableViewCell.h"

@interface SMMakeDiscountRuleTableViewCell ()
/**
 *  title
 */
@property(nonatomic,strong)UILabel * titleLabel;
/**
 *  使用时间:
 */
@property(nonatomic,strong)UILabel * timeLabel;
/**
 *  使用规则:
 */
@property(nonatomic,strong)UILabel * ruleLabel;

@end

@implementation SMMakeDiscountRuleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //[self setupLabel];
}


-(void)setupLabelWith:(NSString *) contect
{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth, 21)];
    self.titleLabel.text = @"优惠券详情:";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    
    //横线
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(5, 41, KScreenWidth-10, 1);
    lineLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 41+10, KScreenWidth-20, 21)];
    self.timeLabel.text = @"使用时间: 08:00至24:00";
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.timeLabel];
    
    UILabel *ruleTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 41+10+31, KScreenWidth-20, 21)];
    ruleTitleLable.text = @"使用规则:";
    ruleTitleLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:ruleTitleLable];
    
    //动态计算高度
    CGFloat height =  [self heightLableString:contect];
    
    self.ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25,110, KScreenWidth-50,height)];
    self.ruleLabel.font = [UIFont systemFontOfSize:15];
    self.ruleLabel.text = contect;
    self.ruleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.ruleLabel];
    
}

-(CGFloat)heightLableString:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth-50,KScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return size.height;
}
@end
