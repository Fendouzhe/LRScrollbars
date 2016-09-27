//
//  SMShareTypeView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShareTypeView.h"

@interface SMShareTypeView ()

@property (weak, nonatomic) IBOutlet UIButton *webBtn;

@property (weak, nonatomic) IBOutlet UIButton *qrcodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation SMShareTypeView

+ (instancetype)shareTypeView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMShareTypeView" owner:nil options:nil] lastObject];
}

- (IBAction)shareWebsite:(id)sender {
    if (_websiteBlock) {
        self.websiteBlock(self.webBtn.tag);
    }
    
}

- (IBAction)shareQrcode:(id)sender {
    if (_qrcodeBlock) {
        self.qrcodeBlock(self.qrcodeBtn.tag);
    }
}

- (IBAction)cancel:(id)sender {
    if (_cancelBlock) {
        self.cancelBlock(self.cancelBtn.tag);
    }
}

- (void)awakeFromNib{
    self.layer.cornerRadius = SMCornerRadios;
    self.clipsToBounds = YES;
}

@end
