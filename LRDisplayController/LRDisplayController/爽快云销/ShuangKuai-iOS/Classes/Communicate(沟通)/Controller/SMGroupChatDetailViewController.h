//
//  SMGroupChatDetailViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMGroupChatDetailData;
@class SMGroupChatListData;
@interface SMGroupChatDetailViewController : UIViewController
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
//@property (nonatomic,strong) SMGroupChatListData *chatroom;/**< 房间信息 */
@end
