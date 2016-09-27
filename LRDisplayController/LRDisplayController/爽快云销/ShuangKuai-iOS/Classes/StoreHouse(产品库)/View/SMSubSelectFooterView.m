//
//  SMSubSelectFooterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSubSelectFooterView.h"
#import "SMShelfProductViewController.h"
#import "SMShelfActionViewController.h"
#import "SMShelfDiscountController.h"
#import <MBProgressHUD.h>

@interface SMSubSelectFooterView ()

@property (strong, nonatomic) IBOutlet UIButton *retainBtn;
@end
@implementation SMSubSelectFooterView


-(NSMutableArray *)favIDArray
{
    if (!_favIDArray) {
        _favIDArray = [NSMutableArray array];
    }
    return _favIDArray;
}

-(void)awakeFromNib
{
    self.retainBtn.layer.cornerRadius = 2*SMCornerRadios;
    self.retainBtn.layer.masksToBounds = YES;
    self.retainBtn.backgroundColor = KRedColorLight;
}

- (IBAction)retainAction:(UIButton *)sender {
    SMLog(@"点击 确定");
    //通知cheat 下来
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KCheatViewDisappear" object:nil];
    //这里执行添加
    if (self.isdown) {
        [self subproduct];
    }else
    {
        [self addprodct];
    }
}

-(void)addprodct
{
    SMLog(@"id = %@,array = %@",self.productID,self.favIDArray);
    [[SKAPI shared] addItem:self.productID toMyStorage:[self.favIDArray copy] andType:(int)self.type block:^(id result, NSError *error) {
        if (!error) {
            //发送通知  刷新
            if (self.type == 0) {
                SMShelfProductViewController * Vc = [[SMShelfProductViewController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc.fav = fav;
                    [Vc loadDatas];
                }
            }else if(self.type == 1){
                SMShelfActionViewController * Vc1 = [[SMShelfActionViewController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc1.fav = fav;
                    [Vc1 loadDatas];
                }
            }else{
                SMShelfDiscountController * Vc2 = [[SMShelfDiscountController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc2.fav = fav;
                    [Vc2 loadDatas];
                }
            }
            
            //上架成功提示
            
            [MBProgressHUD showSuccess:@"上架成功"];
            
            
            SMLog(@"result = %@",result);
        }else
        {
            SMLog(@"error = %@",error);
        }
    }];
}

-(void)subproduct
{
    SMLog(@"%@",self.favIDArray);
    [[SKAPI shared] removeItem:self.productID fromMyStorage:[self.favIDArray copy] andType:(int)self.type block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result = %@",result);
            if (self.type == 0) {
                SMShelfProductViewController * Vc = [[SMShelfProductViewController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc.fav = fav;
                    [Vc loadDatas];
                }
            }else if(self.type == 1){
                SMShelfActionViewController * Vc1 = [[SMShelfActionViewController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc1.fav = fav;
                    [Vc1 loadDatas];
                }
            }else{
                SMShelfDiscountController * Vc2 = [[SMShelfDiscountController alloc]init];
                for (NSString * favid in self.favIDArray) {
                    
                    Favorites * fav = [Favorites new];
                    fav.id = favid;
                    Vc2.fav = fav;
                    [Vc2 loadDatas];
                }
            }
            
            [MBProgressHUD showSuccess:@"下架成功"];
        }else
        {
            SMLog(@"error = %@",error);
        }
    }];
}
@end
