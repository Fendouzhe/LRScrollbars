//
//  SMSystermMessageView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSystermMessageView.h"

@interface SMSystermMessageView()

@property (weak, nonatomic) IBOutlet UILabel *meesageNumLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation SMSystermMessageView

+ (instancetype)systermMessageView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    self.sepLineHeight.constant = 0.5;
    [self layoutIfNeeded];
    self.meesageNumLabel.layer.cornerRadius = self.meesageNumLabel.width/2;
    self.meesageNumLabel.layer.masksToBounds = YES;
    self.meesageNumLabel.hidden = YES;
}

- (void)setMessageNum:(NSInteger )messageNum{
    if (messageNum > 0) {
        self.meesageNumLabel.hidden = NO;
        _messageNum = messageNum;
        _meesageNumLabel.text = [NSString stringWithFormat:@"%lu",messageNum];
    }else{
        self.meesageNumLabel.hidden = YES;
    }
}

- (IBAction)systemMessageClick:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    if ([self.delegate respondsToSelector:@selector(clickButtonWithSystermMessageView:)]) {
        [self.delegate clickButtonWithSystermMessageView:self];
    }
}
@end
