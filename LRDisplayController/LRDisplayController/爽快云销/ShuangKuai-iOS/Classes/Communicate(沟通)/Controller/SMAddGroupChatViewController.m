//
//  SMAddGroupChatViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddGroupChatViewController.h"
#import "SMFriend.h"
#import "SMFriendGroup.h"
#import "SMContactPersonTableViewCell.h"
#import "SMConnectPersonSection0.h"
#import "SMConnectPersonSectionData.h"
#import "SMMyTeamController.h"
#import "SMPersonInfoViewController.h"
#import "SMAddGroupTeamViewController.h"
#import "SMGroupChatListViewController.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatListData.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"


@interface SMAddGroupChatViewController ()<SMAddGroupTeamViewControllerDelegate,SMContactPersonTableViewCellDelegate>
@property (nonatomic ,strong)NSArray *arrLetters;

@property (nonatomic ,strong)NSMutableArray *arrayDatas;

@property (nonatomic,strong) NSArray *topDataArray;/**< 顶部 */

@property (nonatomic,strong) NSMutableArray *selectArray;/**< 已经选择的数组,User */

@property (nonatomic,strong) NSMutableArray *groupSelectArray;/**< 团队已经选择的数组 */

@end

@implementation SMAddGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.allowsMultipleSelectionDuringEditing=YES;
//    [self.tableView setEditing:YES]; //////设置uitableview为编译状态
    self.tableView.editing = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.title = @"联系人列表";
    //    [self.view addSubview:self.tableView];
    
    SMConnectPersonSectionData *data1 = [[SMConnectPersonSectionData alloc] init];
    data1.imageStr = nil;
    data1.labelStr = @"群组";
    data1.myoption = ^(){
        SMGroupChatListViewController *vc = [[SMGroupChatListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    SMConnectPersonSectionData *data2 = [[SMConnectPersonSectionData alloc] init];
    data2.imageStr = nil;
    data2.labelStr = @"我的团队";
    data2.myoption = ^(){
        SMAddGroupTeamViewController *vc = [[SMAddGroupTeamViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.topDataArray = @[data1,data2];
    
    [self requestFriend];
    
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
    
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array.count   好友数 %zd",array.count);
            SMLog(@"array   %@",array);
            
            for (NSInteger i = 0 ; i < self.arrLetters.count; i++) {
                NSString *letter = self.arrLetters[i];//ABCD..
                
                NSMutableArray *arrFriend = [NSMutableArray array];
                //遍历返回过来的user数组
                for (NSInteger j = 0; j < array.count; j++) {
                    User *user = array[j];
                    NSString *sort = user.sort;
                    //如果有user的sort（名字首字母缩写）与给定数组中的字母相同
                    if ([sort isEqualToString:letter]) {
                        SMFriend *friend = [[SMFriend alloc] init];
                        friend.user = user;
                        [arrFriend addObject:friend];
                    }
                    //                    else if ([sort isEqualToString:@"?"]){
                    //                        SMFriend *friend = [[SMFriend alloc] init];
                    //                        friend.user = user;
                    //                        [arrFriend addObject:friend];
                    //                    }
                }
                
                if (arrFriend.count > 0) {
                    SMFriendGroup *friendG = [[SMFriendGroup alloc] init];
                    
                    friendG.arrFriend = arrFriend;
                    friendG.sort = letter;
                    
                    [self.arrayDatas addObject:friendG];
                }
            }
            SMLog(@"self.arrayDatas   %@",self.arrayDatas);
            [self.tableView reloadData];
            //            for (User *u in array) {
            //                SMLog(@"u   %@",[u class]);
            //            }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrayDatas.count) {
        return self.arrayDatas.count+1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        SMFriendGroup *friendGroup = self.arrayDatas[section - 1];
        SMLog(@"friendGroup.arrFriend.count   %zd",friendGroup.arrFriend.count);
        return friendGroup.arrFriend.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMConnectPersonSection0 *cell = [SMConnectPersonSection0 cellWithTableview:tableView];
        switch (indexPath.row) {
            case 0:
            {
                [cell setImage:nil WithStr:@"我的群组"];
            }
                break;
            case 1:
            {
                [cell setImage:nil WithStr:@"我的团队"];
            }
                break;
            default:
                break;
        }
        return cell;
    }else{
        SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
        //可以在这里给cell赋值
        cell.delegate = self;
        SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section-1];
        SMFriend *friend = friendGroup.arrFriend[indexPath.row];
        
        cell.myFriend = friend;
        
        if(friend.select)
        {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
//        if(indexPath.section<10 && indexPath.section > 5){
//            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < self.arrayDatas.count; i++) {
        SMFriendGroup *friendG = self.arrayDatas[i];
        NSString *title = friendG.sort;
        if ([title isEqualToString:@"?"]) {
            title = @"#";
            [arrM addObject:title];
            continue;
        }
        [arrM addObject:title];
    }
    return arrM;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else{
        SMFriendGroup *friendG = self.arrayDatas[section-1];
        if ([friendG.sort isEqualToString:@"?"]) {
            return @"#";
        }else{
            
            return friendG.sort;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
    if (indexPath.section == 0) {
        SMLog(@"点击了 我的团队cell");
        //        SMMyTeamController *vc = [[SMMyTeamController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
        SMConnectPersonSectionData *data = self.topDataArray[indexPath.row];
        if(data.myoption){
            data.myoption();
        }
    }else{
        
        SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.myFriend.select = !cell.myFriend.select;
        SMLog(@"选中");
        
        SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section-1];
        SMFriend *theFriend = friendGroup.arrFriend[indexPath.row];
        
        [self.selectArray addObject:theFriend.user];
        SMLog(@"最新状态");
        for (User *user1 in self.selectArray) {
            SMLog(@"%@,%@",user1.name,user1.userid);
        }
//        SMFriendGroup *friendG = self.arrayDatas[indexPath.section - 1];
//        SMFriend *friend = friendG.arrFriend[indexPath.row];
//        friend.select = cell.selected;
//        if(cell.selected){
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
//        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section){
        return YES;
    }else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SMLog(@"点击了 我的团队cell");
        //        SMMyTeamController *vc = [[SMMyTeamController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
        SMConnectPersonSectionData *data = self.topDataArray[indexPath.row];
        if(data.myoption){
            data.myoption();
        }
    }else{
        SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.myFriend.select = !cell.myFriend.select;
        
        SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section-1];
        SMFriend *theFriend = friendGroup.arrFriend[indexPath.row];
        
        [self.selectArray removeObject:theFriend.user];
        SMLog(@"最新状态");
        for (User *user1 in self.selectArray) {
            SMLog(@"%@,%@",user1.name,user1.userid);
        }
//        for (User *user in self.selectArray) {
//            if ([user.userid isEqualToString:theFriend.user.userid]) {
//                [self.selectArray removeObject:user];
//                break;
//            }
//        }
        
    }
    SMLog(@"取消选中");
}

#pragma mark -- SMAddGroupTeamViewControllerDelegate
-(void)addFriend:(User *)user{
    [self.selectArray addObject:user];
    SMLog(@"%@,%@",user.name,user.userid);
    SMLog(@"最新状态");
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
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
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
    }
}

#pragma mark -- SMContactPersonTableViewCellDelegate
-(void)personCellAddFriend:(User *)user{
    SMLog(@"%@,%@",user.name,user.userid);
}

-(void)personCellDelFriend:(User *)user{
    SMLog(@"%@,%@",user.name,user.userid);
}

#pragma mark -- 懒加载
//- (UITableView *)tableView{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
////        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
//    }
//    return _tableView;
//}

- (NSArray *)arrLetters{
    if (_arrLetters == nil) {
        _arrLetters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"?"];
    }
    return _arrLetters;
}

- (NSMutableArray *)arrayDatas{
    if (_arrayDatas == nil) {
        _arrayDatas = [NSMutableArray array];
    }
    return _arrayDatas;
}

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
