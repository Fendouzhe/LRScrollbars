//
//  SMGroupChatMemberListViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMGroupChatDetailData;
@interface SMGroupChatMemberListViewController : UITableViewController
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@end
