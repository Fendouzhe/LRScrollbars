//
//  SMOrderSubViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderSubViewController : UIViewController
/**
 *  确定状态  0，1，2，3，4，5 分别代表代  付款，已付款，已发货，已完成，已关闭  
 *  1.6 版修改： -1,0,1,2,3,4,   分别代表  全部订单，待付款，已付款(待发货)，已发货，已完成，已关闭
 */
@property(nonatomic,assign)NSInteger type;

- (void)requestType:(NSInteger)type;

@end
