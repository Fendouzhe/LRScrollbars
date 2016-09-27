
//
//  SMNewMemberController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDeleteMemberController.h"
#import "SMNewMemberController.h"
#import "ChineseToPinyin.h"
#import "SMFriend.h"
#import "SMContactPersonTableViewCell.h"
#import "ChatTopOfTableView.h"
#import "SMGroupChatListViewController.h"
#import "SMAddGroupTeamViewController.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatListData.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"

@interface SMDeleteMemberController ()<SMContactPersonTableViewCellDelegate,ChatTopOfTableViewDelegate,SMAddGroupTeamViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *sectionTitles;//头部数组
@property (nonatomic,strong) NSMutableArray *dataSource;/**< 数据源数据 */
@property (nonatomic,strong) NSMutableArray *selectArray;/**< 选中的数据 */
@property (nonatomic,strong) NSArray *originalArray;/**< 原始好友数据 */
@end

@implementation SMDeleteMemberController

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)sectionTitles{
    if (_sectionTitles==nil) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"删除联系人";
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestFriend];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMenmberToGroup)];
}

//确定点击
-(void)deleteMenmberToGroup{
    
    NSString *groupId = self.roomDetail.chatroom.id;
    NSMutableArray *useridArray = [NSMutableArray array];
    for (User *user in self.selectArray) {
        [useridArray addObject:user.userid];
    }
    
    [[SKAPI shared] deleteMember4IM:groupId andUserIds:useridArray block:^(id result, NSError *error) {
        SMLog(@"result = %@------- error = %@",result,error);
        [[NSNotificationCenter defaultCenter] postNotificationName:DeleteGroupMemberNotification object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}



//- (void)setChatroomMemberList:(NSArray *)chatroomMemberList{
//    _chatroomMemberList = chatroomMemberList;
//    SMLog(@"chatroomMemberList = %@",chatroomMemberList);
//    [_chatroomMemberList enumerateObjectsUsingBlock:^(ChatroomMemberListData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        SMFriend *friend = [[SMFriend alloc] init];
//        friend.user = obj.user;
//        [self.dataSource addObject:friend];
//    }];
//    //[self.tableView reloadData];
//}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    SMGroupChatMemberListCell *cell = [SMGroupChatMemberListCell cellWithTableView:tableView];
////    cell.cellData = self.roomDetail.chatroomMemberList[indexPath.row];
////    return cell;
//}


//加载联系人
- (void)requestFriend{
    MJWeakSelf
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            NSMutableArray *friendArray = [NSMutableArray array];
            for (User *user in array) {

                SMFriend *friend = [[SMFriend alloc] init];
                
                [self.chatroomMemberList enumerateObjectsUsingBlock:^(ChatroomMemberListData *listData, NSUInteger indx, BOOL * _Nonnull stop) {
                    //SMLog(@"id = %@-----userId = %@",listData.userId,listData.userId);
                    
                    if([user.userid isEqualToString:listData.userId]) {

                        friend.user = user;
                        [friendArray addObject:friend];
                        *stop = YES;
                    }
                    
                }];
            }
            weakSelf.dataSource = [weakSelf sortDataArray:friendArray];
            [weakSelf.tableView reloadData];
        }else{
            
        }
    }];
}

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger count = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (SMFriend *friendsListData in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        //        NSString *realNameStr = friendsListData.strRealName;
        //        if (!realNameStr.length) {
        //            realNameStr = @"#";
        //        }
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:friendsListData.name];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:friendsListData];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(SMFriend *obj1, SMFriend *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.name];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.name];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < self.sectionTitles.count; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:(section)] count] == 0)
    {
        return 0;
    }else{
        return 22;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    SMLog(@"section = %ld,%ld",section,[[self.dataSource objectAtIndex:(section)] count]);
    return [self.dataSource[section] count];//[[self.dataSource objectAtIndex:(section)] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
    //可以在这里给cell赋值
    cell.delegate = self;
    
    SMFriend *friend = self.dataSource[indexPath.section][indexPath.row];
    
    cell.myFriend = friend;
    
    if(friend.select)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    SMLog(@"选中");
    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
    
    [self.selectArray addObject:theFriend.user];
    SMLog(@"最新状态");
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    
    
    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
    
    [self.selectArray removeObject:theFriend.user];
    SMLog(@"最新状态");
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
    }
}

- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}

#pragma mark - SMAddGroupTeamViewControllerDelegate
-(void)addFriend:(User *)user{
    [self.selectArray addObject:user];
    SMLog(@"%@,%@",user.name,user.userid);
    SMLog(@"最新状态");
    //    for (User *user1 in self.selectArray) {
    //        SMLog(@"%@,%@",user1.name,user1.userid);
    //    }
    for (int i = 0; i < self.dataSource.count; i++) {
        for (int j = 0; j < [self.dataSource[i] count]; j++) {
            SMFriend *friend = self.dataSource[i][j];
            if ([friend.user.userid isEqualToString:user.userid]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

-(void)delFriend:(User *)user{
    SMLog(@"%@,%@",user.name,user.userid);
    for (User *user1 in self.selectArray) {
        if ([user.userid isEqualToString:user1.userid]) {
            [self.selectArray removeObject:user1];
        }
    }
    SMLog(@"最新状态");
    //    for (User *user1 in self.selectArray) {
    //        SMLog(@"%@,%@",user1.name,user1.userid);
    //    }
    for (int i = 0; i < self.dataSource.count; i++) {
        for (int j = 0; j < [self.dataSource[i] count]; j++) {
            SMFriend *friend = self.dataSource[i][j];
            if ([friend.user.userid isEqualToString:user.userid]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }
}
#pragma mark - ChatTopOfTableViewDelegate
-(void)chatTopOfTableViewWithNumber:(NSUInteger)tag{
    switch (tag) {
        case 0:
        {
            SMGroupChatListViewController *vc = [[SMGroupChatListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            SMAddGroupTeamViewController *vc = [[SMAddGroupTeamViewController alloc] init];
            vc.delegate = self;
            vc.oldSelectArray = self.selectArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

