//
//  SMCommunicateTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMClient.h>
#import <AVIMConversationQuery.h>
#import <AVIMConversation.h>
#import <AVIMTextMessage.h>
@class SMConversation;

@interface SMCommunicateTableViewCell : UITableViewCell

@property (nonatomic ,strong)SMConversation *conversation;

@property (nonatomic ,strong)User *user;

+ (instancetype)communicateCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)AVIMConversation * avConversation;

@property (strong, nonatomic) IBOutlet UIButton *unreadBtn;

@end
