//
//  SMAddGroupTeamViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMAddGroupTeamViewControllerDelegate <NSObject>

@optional
-(void)addFriend:(User *)user;
-(void)delFriend:(User *)user;
-(void)changeFriend:(User *)user;
@end

@interface SMAddGroupTeamViewController : UITableViewController
// 最先选择的数组
@property(nonatomic,copy)NSArray *oldSelectArray;
/**
 *  代理
 */
@property (nonatomic ,weak) id<SMAddGroupTeamViewControllerDelegate> delegate;
@end
