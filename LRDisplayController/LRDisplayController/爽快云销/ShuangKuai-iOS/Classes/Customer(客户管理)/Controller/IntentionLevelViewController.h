//
//  IntentionLevelViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  意向等级

#import <UIKit/UIKit.h>

@protocol IntentionLevelViewControllerDelegate <NSObject>

@optional
-(void)chooseIntentionLevel:(NSString *)level;
@end

@interface IntentionLevelViewController : UITableViewController
@property (nonatomic,weak) id<IntentionLevelViewControllerDelegate> delegate;/**<  */
@end
