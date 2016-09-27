//
//  SMGroupChatHistoryViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatHistoryViewController.h"
#import "SMGroupChatListData.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatDetailData.h"

@interface SMGroupChatHistoryViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource>

@end

@implementation SMGroupChatHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
}

-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    self.chatSessionInputBarControl.hidden = YES;
    MJWeakSelf
    [self.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(64);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.conversationDataRepository.count-1 inSection:0];
//    [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
    
//    self.conversationMessageCollectionView.frame = self.view.frame;
//    [self.conversationMessageCollectionView reloadData];
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    RCGroup *rcGroup = [[RCGroup alloc] initWithGroupId:self.roomDetail.chatroom.id groupName:self.roomDetail.chatroom.roomName portraitUri:self.roomDetail.chatroom.imageUrl];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
