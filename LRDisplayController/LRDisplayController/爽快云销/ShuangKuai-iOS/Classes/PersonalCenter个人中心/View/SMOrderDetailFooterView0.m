//
//  SMOrderDetailFooterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailFooterView0.h"
#import "EditPriceViewController.h"
#import "EditFreightViewController.h"
@interface SMOrderDetailFooterView0 ()<UIAlertViewDelegate>

@property(nonatomic,strong)UIAlertView * alerView;

@end
@implementation SMOrderDetailFooterView0

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
    
    //SMLog(@"%ld",self.state);
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
    SMLog(@"关闭订单Or完成订单");
    SMLog(@"%@",self.ID);
    if (self.state == 1 || self.state == 2 ) {
        [self finishOrder];
    }else if (self.state == 3)
    {
        [self closeOrder];
    }else if(self.state==0)
    {
        [self closeOrder];
    }
}

-(void)closeOrder
{
    [[SKAPI shared] closeOrder:self.ID block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            [self showAlertViewMessage:@"已关闭订单"];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)finishOrder
{
    [[SKAPI shared] finishOrder:self.ID block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
            [self showAlertViewMessage:@"已完成订单"];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
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

-(void)setState:(NSInteger)state
{
    _state = state;
    if (self.state == 1|| self.state == 2 ) {
        [self.closeOrderBtn setTitle:@"完成订单" forState:UIControlStateNormal];
    }else if (self.state == 3)
    {
        [self.closeOrderBtn setTitle:@"关闭订单" forState:UIControlStateNormal];
        [self.revisedPricebtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [self.revisedPricebtn setEnabled:NO];
    }else
    {
        //[self.closeOrderBtn setTitle:@"完成订单" forState:UIControlStateNormal];
        [self.closeOrderBtn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [self.closeOrderBtn setEnabled:NO];
    }
}

-(void)showAlertViewMessage:(NSString *)message
{
    if (!_alerView) {
        self.alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.alerView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.popBlock();
        alertView = nil;
    }
}
@end
