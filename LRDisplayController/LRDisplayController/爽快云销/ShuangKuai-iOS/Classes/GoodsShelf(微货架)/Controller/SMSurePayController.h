//
//  SMSurePayController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSurePayController : UIViewController

@property (nonatomic ,copy)NSString *productID;

@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *cardNum;

@property (nonatomic ,copy)NSString *token1;
@property (nonatomic ,copy)NSString *token2;
@property (nonatomic ,copy)NSString *token3;

@property (nonatomic ,strong)ProductSpec *spec;

@property (nonatomic ,copy)NSString *specId;/**< <#注释#> */

@property (nonatomic ,copy)NSString *phoneNumPara;


@end
