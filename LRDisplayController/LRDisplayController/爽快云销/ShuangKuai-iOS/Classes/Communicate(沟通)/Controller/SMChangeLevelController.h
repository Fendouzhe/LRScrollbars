//
//  SMChangeLevelController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMChangeLevelControllerDelegate <NSObject>

- (void)refreshLevelWith:(Customer *)cus;

@end

@interface SMChangeLevelController : UIViewController

@property (nonatomic ,weak)id<SMChangeLevelControllerDelegate> delegate;

@property (nonatomic ,strong)Customer *cus;

@end
