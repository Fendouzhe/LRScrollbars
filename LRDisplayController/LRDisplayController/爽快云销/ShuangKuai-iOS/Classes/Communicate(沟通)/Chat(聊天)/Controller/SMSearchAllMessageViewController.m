//
//  SMSearchAllMessageViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchAllMessageViewController.h"
#import "ChatMessageSave.h"
#import "SearchChatMessageCell.h"
#import <RongIMKit/RongIMKit.h>
#import "SMNewChatViewController.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatListData.h"

@interface SMSearchAllMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;/**< tableview */
@property (nonatomic,strong) NSArray *messageArray;/**< messageArray */
@end

@implementation SMSearchAllMessageViewController

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = whiteView;
        
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJWeakSelf
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        self.tableView.frame = self.view.bounds;
    }
    return _tableView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //聊天记录搜索
    self.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self tableView];
//    [self.view addSubview:self.tableView];
//    MJWeakSelf
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    }];
//    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.tableView.frame = self.view.bounds;
}

-(void)setKeyWords:(NSString *)keyWords{
    _keyWords = keyWords;
    MJWeakSelf
    [[ChatMessageSave shareInstance] searchMessageWithKeywords:keyWords withSuccessBlock:^(NSArray *array, NSError *error) {
        weakSelf.messageArray = array;
        //SMLog(@"weakSelf.messageArray = %@",array);
        [weakSelf.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchChatMessageCell *cell = [SearchChatMessageCell cellWithTableView:tableView];
    cell.cellData = self.messageArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;//*SMMatchHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchChatMessageCell *cell = (SearchChatMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    RCMessage *cellData = cell.cellData;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    switch (cellData.conversationType) {
        case ConversationType_PRIVATE:
        {
            NSString *tagertId;
            NSString *title = cell.mainLabel.text;
            if ([cellData.targetId isEqualToString:userID]) {
                tagertId = cellData.senderUserId;
                
            }else{
                tagertId = cellData.targetId;
                
            }
            SMNewChatViewController *conversationVC = [[SMNewChatViewController alloc] init];
            conversationVC.conversationType = cellData.conversationType;
            conversationVC.targetId = tagertId;
            conversationVC.title = title;
            conversationVC.isSearchVc = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
            break;
        case ConversationType_GROUP:
        {
            SMGroupChatViewController *groupVC = [[SMGroupChatViewController alloc] init];
            groupVC.conversationType = cellData.conversationType;
            groupVC.targetId = cellData.targetId;
            groupVC.title = cell.mainLabel.text;
            groupVC.groupId = cellData.targetId;
            groupVC.isSearchVc = YES;
            [self requestDataWithGroupID:cellData.targetId withVC:groupVC];
        }
            break;
        default:
            break;
    }
}

-(void)requestDataWithGroupID:(NSString *)groupID withVC:(SMGroupChatViewController *)vc{
    [[SKAPI shared] queryGroupDetail4IM:groupID more:YES block:^(id result, NSError *error) {
        if (!error) {
            
            [SMGroupChatDetailData mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"chatroomMemberList" : [ChatroomMemberListData class]
                         // @"statuses" : [Status class],
                         
                         };
            }];
            SMGroupChatDetailData *listData = [SMGroupChatDetailData mj_objectWithKeyValues:[result valueForKey:@"result"]];
            //        int a = 0;
            
            vc.roomDetail = listData;
            if (vc.roomData==nil) {
                vc.roomData = listData.chatroom;
            }
            if(!vc.title.length){
                vc.title = listData.chatroom.roomName;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}

@end
