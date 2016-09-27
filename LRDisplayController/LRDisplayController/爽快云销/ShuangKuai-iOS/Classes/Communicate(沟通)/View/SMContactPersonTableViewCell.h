//
//  SMContactPersonTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMContactPersonTableViewCellDelegate <NSObject>

@optional
-(void)personCellAddFriend:(User *)user;
-(void)personCellDelFriend:(User *)user;
@end

@class SMFriend;
@interface SMContactPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic ,strong)SMFriend *myFriend;
@property (nonatomic ,strong)User *user;
@property (nonatomic, weak) id<SMContactPersonTableViewCellDelegate> delegate;
+ (instancetype)contactPersonCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
