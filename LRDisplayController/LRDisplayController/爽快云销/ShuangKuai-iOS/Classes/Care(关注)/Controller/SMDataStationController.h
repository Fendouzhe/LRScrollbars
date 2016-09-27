//
//  SMDataStationController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMDataStationControllerDelegate <NSObject>

- (void)refreshSection0Data;

@end

@interface SMDataStationController : UIViewController

@property (nonatomic ,weak)id<SMDataStationControllerDelegate> delegate;/**< <#注释#> */

@end
