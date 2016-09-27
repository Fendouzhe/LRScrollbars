//
//  SMActivieSignWebController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMActivieSignWebController : UIViewController
//签到登记 页面 传参：{
//user:销售员ID
//api:当前环境的Api域名（参考用户数据台）
//eid:活动ID（从二维码中解析）
//sn:订单号（从二维码中解析）
//t:随机数（防止缓存）
//}

//@property(nonatomic,copy)NSString *userid;

@property(nonatomic,copy)NSString *eid;

@property(nonatomic,copy)NSString *sn;

//@property(nonatomic,copy)NSString *t;

@end
