//
//  SMAddLabelView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAddLabelViewDelegate <NSObject>

- (void)sureBtnDidClick;

- (void)cancelBtnDidClick;

@end

@interface SMAddLabelView : UIView

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (nonatomic ,weak)id<SMAddLabelViewDelegate> delegate;/**< <#注释#> */

+ (instancetype)addLabelView;

@end
