//
//  SMUploadTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMUploadTableViewCell.h"

@interface SMUploadTableViewCell ()

@property (strong, nonatomic) IBOutlet UIView *cheatView;

@end
@implementation SMUploadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cheatView.backgroundColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:0.2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)uploadClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(takePhotoBtnDidClick:)]) {
        [self.delegate takePhotoBtnDidClick:sender];
    }
}
@end
