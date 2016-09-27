//
//  SMAgreementView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAgreementView.h"

@interface SMAgreementView ()

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;




@end

@implementation SMAgreementView

+ (instancetype)agreementView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMAgreementView" owner:nil options:nil] lastObject];
}


- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (IBAction)sureBtnClick:(id)sender {
    SMLog(@"点击了确定");
    if (self.gouBtn.selected) {//如果已经阅读协议
        if ([self.deledate respondsToSelector:@selector(sureBtnDidClick)]) {
            [self.deledate sureBtnDidClick];
        }
    }else{//没有阅读协议
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先阅读《用户协议》" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)loadWebView{

    
}

- (void)awakeFromNib{
//    
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"sk_xieyi.html" ofType:nil];
//    
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    
//    [self.webVIew loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
 
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sk_xieyi.html" ofType:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
//    [self.webVIew loadRequest:request];
//    [self.webVIew loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil] baseURL:nil];
    
    self.webVIew.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor lightGrayColor];
//    self.alpha = 0.7;
    
    [self.sureBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    
}

@end
