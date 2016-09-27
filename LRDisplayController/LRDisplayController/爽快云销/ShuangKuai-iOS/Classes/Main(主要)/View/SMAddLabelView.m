//
//  SMAddLabelView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddLabelView.h"

@interface SMAddLabelView ()


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SMAddLabelView

+ (instancetype)addLabelView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMAddLabelView" owner:nil options:nil] lastObject];
}

- (IBAction)cancelBtnClick {
    if ([self.delegate respondsToSelector:@selector(cancelBtnDidClick)]) {
        [self.delegate cancelBtnDidClick];
    }
}

- (IBAction)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(sureBtnDidClick)]) {
        [self.delegate sureBtnDidClick];
    }
}

-(void)awakeFromNib{
    
    self.layer.cornerRadius = SMCornerRadios;
    self.clipsToBounds = YES;
}
@end
