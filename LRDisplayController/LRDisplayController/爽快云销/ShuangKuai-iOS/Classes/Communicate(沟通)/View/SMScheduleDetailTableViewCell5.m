//
//  SMScheduleDetailTableViewCell5.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScheduleDetailTableViewCell5.h"

@implementation SMScheduleDetailTableViewCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary *)dic{
    
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSArray * array = dic[@"usersList"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 80, 32)];
    label.centerY = self.frame.size.height/2;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"参与人:";
    label.font = KDefaultFontBig;
    
    [self.contentView addSubview:label];
    
    for (NSInteger i=0; i<array.count; i++) {
        if (i>=6) {
            UILabel * spotLable = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-40,0,40, 32)];
            spotLable.text = [NSString stringWithFormat:@"等%zd人",array.count-6];
            spotLable.font = KDefaultFontSmall;
            spotLable.textAlignment = NSTextAlignmentLeft;
            spotLable.centerY = self.contentView.height/2;
            [self.contentView addSubview:spotLable];
            break;
        }
            UIImageView  * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-35*(i%6+1)-40,0, 32, 32)];
            imageView.centerY = self.contentView.height/2;
//            imageView.image = [UIImage imageNamed:@"touxiangKeFu"];
        imageView.layer.cornerRadius = 16;
        imageView.layer.masksToBounds = YES;
        NSDictionary * dic = array[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"portrait"]] placeholderImage:[UIImage imageNamed:@"touxiangKeFu"] options:SDWebImageRefreshCached progress:nil completed:nil];
            [self.contentView addSubview:imageView];
        }
    
    if (array.count == 0) {
        UILabel * spotLable = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-80,0,80, 32)];
        spotLable.text = @"暂无参与人员";
        spotLable.font = KDefaultFontSmall;
        spotLable.textAlignment = NSTextAlignmentLeft;
        spotLable.centerY = self.contentView.height/2;
        [self.contentView addSubview:spotLable];

    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(8,self.contentView.size.height-1, KScreenWidth-8, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.8;
    [self.contentView addSubview:lineView];
    
}

@end
