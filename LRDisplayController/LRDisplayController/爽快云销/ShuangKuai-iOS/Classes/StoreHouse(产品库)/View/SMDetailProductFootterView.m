//
//  SMDetailProductFootterView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductFootterView.h"

@interface SMDetailProductFootterView ()
/**
 *  上架
 */
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
/**
 *  下架
 */
@property (weak, nonatomic) IBOutlet UIButton *downBtn;

@property (weak, nonatomic) IBOutlet UIButton *goToShelf;

@end

@implementation SMDetailProductFootterView

+ (instancetype)detailProductFootterView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDetailProductFootterView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    SMLog(@"self.isClick=%zd",self.isClick);
    if (self.isClick) {
        [self.upBtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        self.upBtn.enabled = NO;
    }
    
//    self.backgroundColor = KControllerBackGroundColor;
////    self.goToShelf.backgroundColor = SMColor(251, 44, 8);
//    self.upBtn.backgroundColor = SMColor(251, 44, 8);
//    self.downBtn.backgroundColor = KRedColor;
    
    [self.upBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    self.downBtn.layer.cornerRadius = SMCornerRadios;
    self.downBtn.clipsToBounds = YES;
    self.downBtn.backgroundColor = KRedColorLight;
}

- (IBAction)upBtnClick:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(upBtnDidClick:)]) {        
        [self.delegate upBtnDidClick:self.upBtn];
    }
}

- (IBAction)downBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(downBtnDidClick)]) {
        [self.delegate downBtnDidClick];
    }
}

- (IBAction)goToShelfClick {
    if ([self.delegate respondsToSelector:@selector(goToShelfBtnDidClick)]) {
        [self.delegate goToShelfBtnDidClick];
    }
}



//颜色转换 背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
