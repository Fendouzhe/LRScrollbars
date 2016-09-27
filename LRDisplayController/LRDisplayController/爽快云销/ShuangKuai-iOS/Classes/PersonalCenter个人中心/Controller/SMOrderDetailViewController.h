//
//  SMOrderDetailViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderDetailViewController : UIViewController

@property(nonatomic,strong)SalesOrder * salesOrder;

@property(nonatomic,strong)OrderProduct * orderProduct;

@property(nonatomic,copy)NSArray * products;
/**
 *  从未付款界面push过来的。   就不显示物流状态
 */
@property (nonatomic ,assign) BOOL pushedByWaitForPay;
/**
 *  从未已完成界面 push 过来的 ，完成订单改成关闭订单。
 */
@property (nonatomic ,assign) BOOL pushedByAlreadyDone;

@property (nonatomic ,assign)BOOL pushedBuyClosed; /**< 已关闭push 过来的 */

@property (nonatomic ,assign)BOOL pushedByRefund; /**< 从退款/售货商品push进来的 */

@end
