//
//  SMStroreHouseForShelfController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMStroreHouseForShelfControllerDelegate <NSObject>

- (void)refreshUI;

@end

@interface SMStroreHouseForShelfController : UIViewController

@property (nonatomic ,weak)id<SMStroreHouseForShelfControllerDelegate> delegate;

@property (nonatomic ,assign) BOOL PushedByExtension;

@property (nonatomic ,assign)NSInteger numOfExtension;


@end
