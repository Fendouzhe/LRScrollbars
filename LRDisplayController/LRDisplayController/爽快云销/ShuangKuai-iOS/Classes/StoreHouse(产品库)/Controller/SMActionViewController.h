//
//  SMActionViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMActionViewController : UIViewController
/**
 *  在吧活动添加到货架时需要的数组
 */
@property (nonatomic ,strong)NSMutableArray *arrActionIDs;

@property (nonatomic ,strong)Activity *activity;

@property (nonatomic ,assign)NSInteger numOfExtension;

/**
 *  判断是否是在柜台模板中进入的
 这边只允许下架
 */
@property(nonatomic,assign)BOOL isPushCounter;
/**
 *  只允许上架
 */
@property(nonatomic,assign)BOOL isup;
/**
 *  当前跳转的货架
 */
@property(nonatomic,strong)Favorites * favorites;



@end
