//
//  SMGroupChatViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

/**
 *  群聊界面
 */
#import "SMGroupChatViewController.h"
#import "SMGroupChatListData.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatDetailData.h"
#import "SMGroupChatDetailViewController.h"
#import "ChatMessageSave.h"
#import "SMImageNaviController.h"


@interface SMGroupChatViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource>

@property (nonatomic,weak) UIButton *rightBtn;/**< 右上角的按钮 */
@end

@implementation SMGroupChatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNumberChangeNotification:) name:AddGroupMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNumberChangeNotification:) name:DeleteGroupMemberNotification object:nil];
}

- (void)back{
    
    if (self.navigationController.viewControllers.count>3 && _isSearchVc == NO) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
///添加，删除组成员回调方法
- (void)groupNumberChangeNotification:(NSNotification *)notice{
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //删除工具条位置功能按钮
    [self.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
//    [self requestData];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
 
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"qunziliao"] forState:UIControlStateNormal];
    rightBtn.width = 22*SMMatchWidth;
    rightBtn.height = 22*SMMatchHeight;
    self.rightBtn = rightBtn;
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //重新定义方法
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"fanhuihong" highImage:@"fanhuihong"];
    
    [self requestData];
}

-(void)rightItemClick{
    
    SMGroupChatDetailViewController *vc = [[SMGroupChatDetailViewController alloc] init];
    vc.roomDetail = self.roomDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    //[[SKAPI shared] queryGroupDetail4IM:self.roomData.id more:YES block:^(id result, NSError *error) {
    [[SKAPI shared] queryGroupDetail4IM:self.groupId more:YES block:^(id result, NSError *error) {
        [SMGroupChatDetailData mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"chatroomMemberList" : [ChatroomMemberListData class]
                     // @"statuses" : [Status class],
                     
                     };
        }];
        SMGroupChatDetailData *listData = [SMGroupChatDetailData mj_objectWithKeyValues:[result valueForKey:@"result"]];
//        int a = 0;
        self.roomDetail = listData;
        self.title = listData.chatroom.roomName;
    }];
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    RCGroup *rcGroup = [[RCGroup alloc] initWithGroupId:self.roomData.id groupName:self.roomData.roomName portraitUri:self.roomData.imageUrl];
    return completion(rcGroup);
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    for (ChatroomMemberListData *listData in self.roomDetail.chatroomMemberList) {
        if ([userId isEqualToString:listData.userId]) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:listData.name portrait:listData.portrait];
            return completion(userInfo);
//            break;
        }
    }
//    completion(nil);
}

-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion{
    NSString *userChatID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if ([userId isEqualToString:userChatID]) {  //如果是自己方
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        NSString *portrait = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPortrait];
        //        SMLog(@"name    %@   portrait   %@ userChatID  %@",name,portrait,userChatID);
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
        return completion(user);
        
    }else {  //
        for (ChatroomMemberListData *listData  in self.roomDetail.chatroomMemberList) {
            if ([listData.userId isEqualToString:userId]) {
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:listData.userId name:listData.name portrait:listData.portrait];
//                SMLog(@"self.user.userid    %@   self.user.name   %@ self.user.portrait  %@",self.user.userid,self.user.name,self.user.portrait);
                return completion(user);
            }
        }
        
    }
}

/*!
 查看图片消息中的图片
 
 @param model   消息Cell的数据模型
 
 @discussion SDK在此方法中会默认调用RCImagePreviewController下载并展示图片。
 */
- (void)presentImagePreviewController:(RCMessageModel *)model{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    //_imagePreviewVC.title = @"图片预览";
    
    SMImageNaviController *nav = [[SMImageNaviController alloc] initWithRootViewController:_imagePreviewVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
    if([message.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *txtMsg = (RCTextMessage*)message.content;
        //使用txtMsg做一些事情 ...
        SMLog(@"消息内容 = %@",txtMsg.content);
        if(message.messageDirection == 1){
            [[ChatMessageSave shareInstance] saveMessage:message];
        }
    }
    return message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
