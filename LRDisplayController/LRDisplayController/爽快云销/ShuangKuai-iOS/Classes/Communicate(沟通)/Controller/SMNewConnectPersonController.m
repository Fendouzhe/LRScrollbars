//
//  SMNewConnectPersonController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewConnectPersonController.h"
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
#import "SMPersonInfoViewController.h"
#import "SMMyTeamController.h"
#import "SMNewPersonInfoController.h"

@interface SMNewConnectPersonController ()<SMContactPersonTableViewCellDelegate,ChatTopOfTableViewDelegate,SMAddGroupTeamViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *sectionTitles;/**< 头部数组,Str */
@property (nonatomic,strong) NSMutableArray *dataSource;/**< 数据源数据,SMFriend */
@property (nonatomic,strong) NSMutableArray *selectArray;/**< 选中的数据,User */
@property (nonatomic,strong) NSArray *originalArray;/**< 原始好友数据,User */


@end

@implementation SMNewConnectPersonController
-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)sectionTitles
{
    if (_sectionTitles==nil) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self requestFriend];
    
    ChatTopOfTableView *topView = [[ChatTopOfTableView alloc] init];
    topView.delegate = self;
    [topView setWithImageArray:@[@"group",@"hehuoren00"] withStrArray:@[@"我的群组",@"我的团队"]];
    self.tableView.tableHeaderView = topView;
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.width = 40;
    rightBtn.height = 30;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = KDefaultFontBig;
    dic[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:@"确定" attributes:dic];
    [rightBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addGroupChat) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)addGroupChat{
    if (self.selectArray.count>2) {
        UIImage *image = [UIImage imageNamed:@"qunziliao"];
        NSString *groupName = [NSString stringWithFormat:@"%@,%@....",[self.selectArray[0] name],[self.selectArray[1] name]];
        NSMutableArray *tempIDArray = [NSMutableArray array];
        for (User *user in self.selectArray) {
            [tempIDArray addObject:user.userid];
        }
        MJWeakSelf
        [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) {
            if (!error) {
                NSString *token = [[result valueForKey:@"result"] valueForKey:@"token"];
                [[SKAPI shared] createGroup4IM:@"" andImageToken:token andGroupName:groupName andUserIds:tempIDArray block:^(id result, NSError *error) {
                    if (!error) {
                        SMLog(@"群聊返回值 = %@",result);
                        NSString *tagertID = [result valueForKey:@"result"];
                        SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
                        vc.targetId = tagertID;
                        vc.conversationType = ConversationType_GROUP;
                        SMGroupChatListData *roomData = [[SMGroupChatListData alloc] init];
                        roomData.id = tagertID;
                        roomData.roomName = groupName;
                        vc.roomData = roomData;
                        SMGroupChatDetailData *detailData = [[SMGroupChatDetailData alloc] init];
                        detailData.chatroom = roomData;
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (User *user in weakSelf.selectArray) {
                            ChatroomMemberListData *listData = [[ChatroomMemberListData alloc] init];
                            listData.user = user;
                            [tempArray addObject:listData];
                        }
                        detailData.chatroomMemberList = [tempArray copy];
                        vc.title = groupName;
                        vc.roomDetail = detailData;
                        [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
                        //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        //                        });
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        SMLog(@"%@",error);
                    }
                }];
            }
        }];
    }
}



- (void)requestFriend{
    MJWeakSelf
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            weakSelf.originalArray = array;
            NSMutableArray *friendArray = [NSMutableArray array];
            for (User *user in array) {
                SMFriend *friend = [[SMFriend alloc] init];
                friend.user = user;
                [friendArray addObject:friend];
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
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
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
//            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.name];
//            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
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
    for (int i = 0; i < [self.sectionTitles count]; i++) {
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
    return [self.dataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    SMLog(@"section = %ld,%ld",section,[[self.dataSource objectAtIndex:(section)] count]);
    return [[self.dataSource objectAtIndex:(section)] count];
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
//    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.myFriend.select = !cell.myFriend.select;
//    SMLog(@"选中");
//    
//    
//    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
//    
//    [self.selectArray addObject:theFriend.user];
//    SMLog(@"最新状态");
//    for (User *user1 in self.selectArray) {
//        SMLog(@"%@,%@",user1.name,user1.userid);
//    }
    //SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    SMFriend *friend = self.dataSource[indexPath.section][indexPath.row];
    vc.user = friend.user;
    //        vc.client = self.client;
    [self.navigationController pushViewController:vc animated:YES];
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.myFriend.select = !cell.myFriend.select;
//    
//    
//    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
//    
//    [self.selectArray removeObject:theFriend.user];
//    SMLog(@"最新状态");
//    for (User *user1 in self.selectArray) {
//        SMLog(@"%@,%@",user1.name,user1.userid);
//    }
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
//            SMAddGroupTeamViewController *vc = [[SMAddGroupTeamViewController alloc] init];
//            vc.delegate = self;
//            vc.oldSelectArray = self.selectArray;
//            [self.navigationController pushViewController:vc animated:YES];
            SMMyTeamController *vc = [[SMMyTeamController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
