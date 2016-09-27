//
//  SMGroupChatMemberListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatMemberListViewController.h"
#import "SMCollectionViewCell.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatMemberListCell.h"

#define collectionHeight 80*SMMatchWidth
@interface SMGroupChatMemberListViewController ()

@end

@implementation SMGroupChatMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupUI];
    self.title = @"全部组成员";
    UIView *whiteView = [[UIView alloc] init];
    self.tableView.tableFooterView = whiteView;
    //SMLog(@"self.roomDetail = %@",self.roomDetail.chatroom.remark);
}

#pragma mark -- tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.roomDetail.chatroomMemberList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMGroupChatMemberListCell *cell = [SMGroupChatMemberListCell cellWithTableView:tableView];
    cell.remark = self.roomDetail.chatroom.remark;
    cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
