//
//  SMActiveQcodeView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMActiveQcodeView.h"

@implementation SMActiveQcodeView

+(instancetype)activeQcodeView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    self.bigTitleLabel.font = [UIFont boldSystemFontOfSize:20*KMatch];
    self.activeTitleLabel.font = [UIFont systemFontOfSize:18*KMatch];
    self.productName.font = [UIFont systemFontOfSize:15*KMatch];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:18*KMatch];
    self.hiddenButton.titleLabel.font = [UIFont systemFontOfSize:18*KMatch];
    
    self.qcodeLabelHeightConstrait.constant = 44*KMatch;
    self.saveButtonHeightConstrait.constant = 44*KMatch;
    self.hiddenButtonHeightConstrait.constant = 44*KMatch;
    
    self.topMarginConstrait.constant = 25*KMatch;
    self.leftMarginConstrait.constant = 25*KMatch;
    self.bottomMarginConstrait.constant = 25*KMatch;
    self.rightMarginConstrait.constant = 25*KMatch;
    
    self.qcodeImageHeightConstrait.constant = 210*KMatch;
}

- (IBAction)saveToPhotoLibrary:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(saveToPhotoWithSMActiveQcodeView:)]) {
        [self.delegate saveToPhotoWithSMActiveQcodeView:self];
    }
}

- (IBAction)hidenBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hiddenWithSMActiveQcodeView:)]) {
        [self.delegate hiddenWithSMActiveQcodeView:self];
    }
}





@end
