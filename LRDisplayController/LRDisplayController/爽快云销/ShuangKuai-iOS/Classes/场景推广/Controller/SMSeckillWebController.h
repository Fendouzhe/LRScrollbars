//
//  SMSeckillWebController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSeckillWebController : UIViewController

@property (nonatomic ,strong)SMSeckill *model;/**< <#注释#> */
@property(nonatomic,copy)NSString *imageUrl;
//活动ID
@property(nonatomic,copy)NSString *pId;

@property(nonatomic,assign)BOOL isPush;


@end
