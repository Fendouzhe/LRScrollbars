//
//  SMCounterHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCounterHeaderView.h"

@interface SMCounterHeaderView ()

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareHeight;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end

@implementation SMCounterHeaderView

+ (instancetype)counterHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCounterHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconHeight.constant = 50 *SMMatchHeight;
    self.iconWidth.constant = self.iconHeight.constant;
    
    self.shareWidth.constant = 26 *SMMatchWidth;
    self.shareHeight.constant = 26 *SMMatchHeight;
    
    self.icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
    [self.icon addGestureRecognizer:tap];
    
    self.icon.layer.cornerRadius = self.icon.width * SMMatchHeight * 0.5;
    self.icon.clipsToBounds = YES;
    self.icon.layer.borderWidth = 2.2;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.counterName.shadowColor = [UIColor blackColor];
    self.counterName.shadowOffset = CGSizeMake(1, 1);
    
    self.shopKeeper.shadowColor = [UIColor blackColor];
    self.shopKeeper.shadowOffset = CGSizeMake(1, 1);
    
    self.bjIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.bjIcon.clipsToBounds = YES;
    
}

- (void)setShelfName:(NSString *)shelfName{
    _shelfName = shelfName;
    self.counterName.text = shelfName;
}

- (void)iconClick{
    if ([self.delegate respondsToSelector:@selector(iconDidClick)]) {
        [self.delegate iconDidClick];
    }
}

- (IBAction)shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick)]) {
        [self.delegate shareBtnDidClick];
    }
}
@end
