//
//  SMOrderDetailFooterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailFooterView.h"
#import "EditPriceViewController.h"
#import "EditFreightViewController.h"
@interface SMOrderDetailFooterView ()


@end
@implementation SMOrderDetailFooterView

-(void)awakeFromNib
{
    self.revisedPricebtn.layer.cornerRadius = SMCornerRadios*2;
    self.revisedPricebtn.layer.masksToBounds = YES;
    self.modifyFreightBtn.layer.cornerRadius = SMCornerRadios*2;
    self.modifyFreightBtn.layer.masksToBounds = YES;
    self.closeOrderBtn.layer.cornerRadius = SMCornerRadios*2;
    self.closeOrderBtn.layer.masksToBounds = YES;
    
    //判断状态
    [self selectstate];
}
-(void)selectstate
{
    //if (self.state == 0) {
        [self.revisedPricebtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [self.revisedPricebtn setEnabled:NO];
        [self.modifyFreightBtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [self.modifyFreightBtn setEnabled:NO];
   // }
}

- (IBAction)revisedPriceBtn:(UIButton *)sender {
    SMLog(@"修改价格按钮");
    EditPriceViewController * editPrice = [EditPriceViewController new];
    self.pushBlock(editPrice);
    
}
- (IBAction)modifyFreightBtnAction:(UIButton *)sender {
    SMLog(@"修改运费");
    EditFreightViewController * editFreight = [EditFreightViewController new];
    self.pushBlock(editFreight);
}
- (IBAction)closeOrderBtnAction:(UIButton *)sender {
    SMLog(@"关闭订单");
    
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
