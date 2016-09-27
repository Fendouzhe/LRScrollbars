//
//  CustomAlertView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cancelActionBlock)(void);
typedef void (^retainActionBlock)(NSString * text);

@interface CustomAlertView : UIView


@property(nonatomic,strong)cancelActionBlock canelblock;

@property(nonatomic,strong)retainActionBlock retainblock;

@end
