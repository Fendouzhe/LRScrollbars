//
//  SMDetailProductInfoController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDetailProductInfoController : UIViewController
/**
 *  上一个界面选中的是第几个cell 进行的跳转，通过这个数字来判断需要显示哪一个当前页面
 */
@property (nonatomic ,assign)NSInteger fromNum;

@end
