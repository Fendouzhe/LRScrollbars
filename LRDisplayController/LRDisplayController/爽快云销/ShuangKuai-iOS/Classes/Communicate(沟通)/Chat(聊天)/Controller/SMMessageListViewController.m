//
//  SMMessageListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMessageListViewController.h"
#import "SMFriendList.h"
#import "SMNewChatViewController.h"
#import "SMGroupChatList.h"
#import "SMGroupChatListData.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"
#import "SMSystermMessageView.h"
#import "SMInformationViewController.h"
#import "SingtonManager.h"

@interface SMMessageListViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,SMSystermMessageViewDelegate>
@property (nonatomic,assign) BOOL inGetFriendList;/**< 正在获取好友列表 */
@property (nonatomic,assign) BOOL inGetGroupList;/**< 正在获取群组列表 */
/*!
 目标会话ID
 */
@property(nonatomic, copy) NSString *targetId;

@property (nonatomic,strong) RCConversationModel *model;

@property (nonatomic,strong)SMSystermMessageView *sysMessageView;

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation SMMessageListViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)startTimer{
//    self.timer = [NSTimer timerWithTimeInterval:60*6 target:self selector:@selector(getSystermMessage) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)]];
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
    {
//    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
//    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserChatToken];
//    [[RCIM sharedRCIM] connectWithToken:tokenStr success:^(NSString *userId) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//            NSString *userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//            NSString *userPortrait = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPortrait];
//            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userIDStr name:userNameStr portrait:userPortrait];
//            [RCIM sharedRCIM].currentUserInfo = userInfo;
//            //        [[RCIM sharedRCIM] setUserInfoDataSource:weakSelf];
//            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KUserChatID];
//        });
//        
//        SMLog(@"融云连接成功");
//    } error:^(RCConnectErrorCode status) {
//        SMLog(@"融云连接错误");
//    } tokenIncorrect:^{
//        SMLog(@"token错误");
//    }];
    }
    
    //头部爽快系统消息
    SMSystermMessageView *sysMessageView = [SMSystermMessageView systermMessageView];
    sysMessageView.frame = CGRectMake(0, 0, self.view.width, 67);
    self.sysMessageView = sysMessageView;
    self.sysMessageView.delegate  = self;
    self.conversationListTableView.tableHeaderView = sysMessageView;
    //self.sysMessageView.messageNum = 22;
    //获取爽快消息数量
    [self getSystermMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitGroupNotifi:) name:QuitGroupNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGroupMessageStateNoti:) name:ChangeGroupMessageStateNotification object:nil];
}

- (void)getSystermMessage{
    [self.dataArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SKAPI shared] queryFriendMessages:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"requestNewData--result = %@",result);
                
                NSMutableArray * mySendArray = [NSMutableArray array];
                for (NSDictionary * dic in result) {
                    Information * info = [Information mj_objectWithKeyValues:dic];
                    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
                    if ([info.sender isEqualToString:userId]) {
                        //是自己主动发送
                        [mySendArray addObject:info];
                        //
                    }else{
                        //不是自己主动发送的
                        [self.dataArray addObject:info];
                        
                    }
                }
                NSMutableArray * deleteArray = [NSMutableArray array];
                for (Information * myInfo in mySendArray) {
                    for (Information* otherInfo in self.dataArray) {
                        //如果自己发送时的接受者和别人请求添加你的发送者相同
                        if ([myInfo.receiver isEqualToString:otherInfo.sender]) {
                            if (myInfo.type == otherInfo.type) {
                                //如果是相同状态的只存在一个
                                //要删除
                                [deleteArray addObject:otherInfo];
                            }
                            if (otherInfo.type == 30) {
                                //是请求消息
                                otherInfo.type = myInfo.type;
                            }
                            
                        }
                    }
                }
                for (Information * info in deleteArray) {
                    [self.dataArray removeObject:info];
                }
                
                NSMutableArray * receiveStatusArray = [NSMutableArray array];
                //如果是30状态 和已处理的消息 隐藏 也就是删除
                for (Information * info in self.dataArray) {
                    if (info.type == 30 && info.receiveStatus == 1) {
                        [receiveStatusArray addObject:info];
                    }
                }
                for (Information * info in receiveStatusArray) {
                    [self.dataArray removeObject:info];
                }
                
                NSMutableArray *numArr = [NSMutableArray array];
                [self.dataArray enumerateObjectsUsingBlock:^(Information *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.type == 30) {
                        [numArr addObject:obj];
                    }
                    if (idx == numArr.count-1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.sysMessageView.messageNum = numArr.count;
                        });
                    }
                }];
                
                
            }else{
                SMLog(@"%@",error);
            }
            
        }];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取未读消息 判断是否清除上一个消息红点
    [self notifyUpdateUnreadMessageCount];

    //[self.conversationListTableView reloadData];
    
//    [self getGroupList];
//    [self getFriendList];
    
    //开启定时器
    [self startTimer];
    
//    [self.sysMessageView removeFromSuperview];
//    SMSystermMessageView *sysMessageView = [SMSystermMessageView systermMessageView];
//    sysMessageView.frame = CGRectMake(0, 0, self.view.width, 67);
//    self.sysMessageView = sysMessageView;
//    self.conversationListTableView.tableHeaderView = sysMessageView;
    
}

/*!
 即将更新未读消息数的回调
 
 @discussion 当收到消息或删除会话时，会调用此回调，您可以在此回调中执行未读消息数相关的操作。
 */
- (void)notifyUpdateUnreadMessageCount{
    //__weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UnreadMessageCountNotification object:nil userInfo:@{@"count":@(count)}];

    });
}


//退群删除会话列表
- (void)quitGroupNotifi:(NSNotification *)notice{

    BOOL success = [[RCIMClient sharedRCIMClient] removeConversation:_model.conversationType targetId:_model.targetId];
    SMLog(@"success = %d",success);
    if (success) {
        [self refreshConversationTableViewIfNeeded];
    }
}
// 设置会话的消息提醒状态（免打扰）
- (void)changeGroupMessageStateNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:dict[@"targetId"] isBlocked:[dict[@"status"] integerValue] success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"RCConversationNotificationStatus = %zd",nStatus);
        [self refreshConversationTableViewIfNeeded];
    } error:^(RCErrorCode status) {
        SMLog(@"RCErrorCode = %zd",status);
    }];
}
///*!
// 从本地存储中删除会话
// 
// @param conversationType    会话类型
// @param targetId            目标会话ID
// @return                    是否删除成功
// 
// @discussion 此方法会从本地存储中删除该会话，但是不会删除会话中的消息。
// */
//- (BOOL)removeConversation:(RCConversationType)conversationType
//                  targetId:(NSString *)targetId;
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion{
    
    if (self.inGetFriendList) {
        return;
    }

    NSString *userChatID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if ([userId isEqualToString:userChatID]) {  //如果是自己方
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        NSString *portrait = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPortrait];
        //        SMLog(@"name    %@   portrait   %@ userChatID  %@",name,portrait,userChatID);
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
        return completion(user);
        
    }else {  //
//        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:self.user.userid name:self.user.name portrait:self.user.portrait];
//        SMLog(@"self.user.userid    %@   self.user.name   %@ self.user.portrait  %@",self.user.userid,self.user.name,self.user.portrait);
//        return completion(user);
        
        if ([SMFriendList sharedManager].isGetValue) {
            //BOOL isInFriend = NO;
            for (User *user in [SMFriendList sharedManager].friendsArray) {
                if ([user.userid isEqualToString:userId]) {
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                    return completion(userInfo);
                }
            }
        }else{
            [self getFriendList];
        }
        
        //FIXME: 如果好友被删除，就不会显示头像
    }
}


- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    if (self.inGetGroupList) {
        return;
    }
    if ([SMGroupChatList sharedManager].isGetValue) {
        for (SMGroupChatListData *listData in [SMGroupChatList sharedManager].groupArray) {
            RCGroup *rcGroup = [[RCGroup alloc] initWithGroupId:listData.id groupName:listData.roomName portraitUri:listData.imageUrl];
//            //设置消息提醒状态
//            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:listData.id isBlocked:![listData.messageStatus integerValue] success:^(RCConversationNotificationStatus nStatus) {
//                NSLog(@"RCConversationNotificationStatus = %zd",nStatus);
//            } error:^(RCErrorCode status) {
//                SMLog(@"RCErrorCode = %zd",status);
//            }];
            return completion(rcGroup);
        }
    }else{
        [self getGroupList];
    }
    
}

-(void)getFriendList{
    self.inGetGroupList = YES;
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            //[[SMFriendList sharedManager] startWithFriendsArray:array];
            for (User *user in array) {
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:user.userid];
                //刷新
                [self refreshConversationTableViewIfNeeded];
            }
        }else{
        }
        self.inGetFriendList = NO;
    }];
}

-(void)getGroupList{
    self.inGetGroupList = YES;
    [[SKAPI shared] queryGroupList4IM:^(id result, NSError *error) {
        NSLog(@"群聊群组列表 = %@",result);
        
        if(!error){
            NSString *status = [result valueForKey:@"status"];
            if (0 == [status intValue]) {
                id page = [result valueForKey:@"result"];
                NSArray *companyArray = [SMGroupChatListData mj_objectArrayWithKeyValuesArray:page];
                
                [[SMGroupChatList sharedManager] startWithGroupArray:companyArray];
                for (SMGroupChatListData *listData in companyArray) {
                    RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:listData.id groupName:listData.roomName portraitUri:listData.imageUrl];
                    
                    //设置消息提醒状态
                    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:listData.id isBlocked:![listData.messageStatus integerValue] success:^(RCConversationNotificationStatus nStatus) {
                        
                        NSLog(@"RCConversationNotificationStatus = %zd  listData.messageStatus = %@",nStatus,listData.messageStatus);
                    } error:^(RCErrorCode status) {
                        SMLog(@"RCErrorCode = %zd",status);
                    }];
                    
                    [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:listData.id];
                    //刷新
                    [self refreshConversationTableViewIfNeeded];
                    
                }
                
         } else{
//                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
//                NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
//
//                block(nil, error);
         }
            
         self.inGetGroupList = NO;
        }
    }];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    switch (conversationModelType) {
        case RC_CONVERSATION_MODEL_TYPE_NORMAL:
        {
            switch (model.conversationType) {
                case ConversationType_PRIVATE:
                {
                    SMNewChatViewController *conversationVC = [[SMNewChatViewController alloc] init];
                    conversationVC.conversationType = model.conversationType;
                    conversationVC.targetId = model.targetId;
                    conversationVC.title = model.conversationTitle;
                    self.targetId = model.targetId;
                    self.model = model;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                }
                    break;
                case ConversationType_GROUP:
                {
                    SMGroupChatViewController *groupVC = [[SMGroupChatViewController alloc] init];
                    groupVC.conversationType = model.conversationType;
                    groupVC.targetId = model.targetId;
                    groupVC.title = model.conversationTitle;
                    groupVC.groupId = model.targetId;
                    self.targetId = model.targetId;
                    self.model = model;
                    [self.navigationController pushViewController:groupVC animated:YES];
                    //[self requestDataWithGroupID:model.targetId withVC:groupVC];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_COLLECTION:
        {
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION:
        {
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE:
        {
        }
            break;
        default:
            break;
    }
}

-(void)requestDataWithGroupID:(NSString *)groupID withVC:(SMGroupChatViewController *)vc{
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [[SKAPI shared] queryGroupDetail4IM:groupID more:YES block:^(id result, NSError *error) {
    //            if (!error) {
    //
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [self.navigationController pushViewController:vc animated:YES];
    //                });
    //
    //                [SMGroupChatDetailData mj_setupObjectClassInArray:^NSDictionary *{
    //                    return @{
    //                             @"chatroomMemberList" : [ChatroomMemberListData class]
    //                             // @"statuses" : [Status class],
    //                             };
    //                }];
    //                SMGroupChatDetailData *listData = [SMGroupChatDetailData mj_objectWithKeyValues:[result valueForKey:@"result"]];
    //                //        int a = 0;
    //
    //                vc.roomDetail = listData;
    //                vc.roomData = listData.chatroom;
    //                vc.title = listData.chatroom.roomName;
    //                SMLog(@"result = %@",result);
    //            }
    //            
    //        }];
    //    });
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    SMLog(@"scrollView = %lf",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y<=0) {
//        [self.conversationListTableView setContentOffset:CGPointZero];
//    }
//}

#pragma mark - SMSystermMessageViewDelegate
//爽快消息点击
- (void)clickButtonWithSystermMessageView:(SMSystermMessageView *)view{
 
    SMInformationViewController *vc = [[SMInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.sysButton.backgroundColor = [UIColor whiteColor];
    });
}

@end
