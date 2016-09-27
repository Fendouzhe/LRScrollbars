//
//  SMTogetherBuyWebVc.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTogetherBuyWebVc : UIViewController

@property (nonatomic ,copy)NSString *pId;/**< <#注释#> */

@property(nonatomic,copy)NSString *titleName;

@property(nonatomic,assign)NSInteger tag;

@property(nonatomic,copy)NSString *imageUrl;

@property(nonatomic,assign)BOOL isPush;
//是否单品列表
@property(nonatomic,assign)BOOL isSingle;
@end
