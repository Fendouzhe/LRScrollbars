//
//  SMSearchViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSearchViewController : UIViewController

/**
 *  记录跳转过来的页面//以及要跳转的界面
    0 商品
    1 活动
    2 优惠券
    3 爽快圈
    4 企业动态
 */
@property(nonatomic,assign)NSInteger categoryType;



@end
