//
//  SMAgreementView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAgreementViewDeledate <NSObject>

- (void)sureBtnDidClick;

@end

@interface SMAgreementView : UIView

@property (nonatomic ,weak)id<SMAgreementViewDeledate> deledate;

@property (weak, nonatomic) IBOutlet UIWebView *webVIew;

+ (instancetype)agreementView;

- (void)loadWebView;

@end
