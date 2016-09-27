//
//  SMscheduleDetailTableViewCell2.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMscheduleDetailTableViewCell2.h"

@interface SMscheduleDetailTableViewCell2 ()

@end
@implementation SMscheduleDetailTableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editAction:(UIButton *)sender {
    self.editblock();
}
@end
