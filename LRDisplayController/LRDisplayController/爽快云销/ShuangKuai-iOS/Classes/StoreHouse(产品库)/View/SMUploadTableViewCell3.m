//
//  SMUploadTableViewCell3.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMUploadTableViewCell3.h"

@interface SMUploadTableViewCell3 ()
@property (strong, nonatomic) IBOutlet UIButton *certainBtn;

@end
@implementation SMUploadTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.certainBtn.layer.cornerRadius = 5;
    self.certainBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)certainClickAction:(UIButton *)sender {
    SMLog(@"点击了确认上传按钮");
    self.certainblock();
}
@end
