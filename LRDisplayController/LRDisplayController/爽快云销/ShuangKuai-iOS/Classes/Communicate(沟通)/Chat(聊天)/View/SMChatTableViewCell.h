//
//  SMChatTableViewCell.h
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMChatMessageFrame;
@interface SMChatTableViewCell : UITableViewCell

@property(nonatomic,strong) SMChatMessageFrame *messageFrame;

//- (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong)User *user;

@end
