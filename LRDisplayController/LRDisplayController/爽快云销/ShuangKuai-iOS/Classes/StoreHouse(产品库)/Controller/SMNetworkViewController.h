//
//  SMNetworkViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNetworkViewController : UIViewController

@property (nonatomic ,copy)NSString *productID;

@property (nonatomic ,assign) BOOL isDianxin;

@property (nonatomic ,strong)ProductSpec *spec;

@property (nonatomic ,copy)NSString *specId;/**< ProductSpec *spec  的id */
//购买的号码
@property (nonatomic ,copy)NSString *phoneNum;
@end
