//
//  SMConnectPersonController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConnectPersonController.h"
#import "SMFriend.h"
#import "SMFriendGroup.h"
#import "SMContactPersonTableViewCell.h"
#import "SMConnectPersonSection0.h"
#import "SMConnectPersonSectionData.h"
#import "SMMyTeamController.h"
#import "SMPersonInfoViewController.h"
#import "SMGroupChatListViewController.h"

@interface SMConnectPersonController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSArray *arrLetters;

@property (nonatomic ,strong)NSMutableArray *arrayDatas;

@property (nonatomic,strong) NSArray *topDataArray;/**< 顶部 */

@end

@implementation SMConnectPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人列表";
//    [self.view addSubview:self.tableView];
    
    SMConnectPersonSectionData *data1 = [[SMConnectPersonSectionData alloc] init];
    data1.imageStr = nil;
    data1.labelStr = @"我的群组";
    data1.myoption = ^(){
        SMGroupChatListViewController *vc = [[SMGroupChatListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    SMConnectPersonSectionData *data2 = [[SMConnectPersonSectionData alloc] init];
    data2.imageStr = nil;
    data2.labelStr = @"我的团队";
    data2.myoption = ^(){
        SMMyTeamController *vc = [[SMMyTeamController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.topDataArray = @[data1,data2];//群聊版本
//    self.topDataArray = @[data2];//非群聊版本
    [self requestFriend];
    
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        return self.topDataArray.count;
    }else{
        SMFriendGroup *friendGroup = self.arrayDatas[section - 1];
        SMLog(@"friendGroup.arrFriend.count   %zd",friendGroup.arrFriend.count);
        return friendGroup.arrFriend.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMConnectPersonSection0 *cell = [SMConnectPersonSection0 cellWithTableview:tableView];
//        switch (indexPath.row) {
//            case 0:
//            {
//                [cell setImage:nil WithStr:@"我的群组"];
//            }
//                break;
//            case 1:
//            {
//                [cell setImage:nil WithStr:@"我的团队"];
//            }
//                break;
//            default:
//                break;
//        }
        SMConnectPersonSectionData *data = self.topDataArray[indexPath.row];
        [cell setImage:data.imageStr WithStr:data.labelStr];
        return cell;
    }else{
        SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
        //可以在这里给cell赋值
        
        SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section-1];
        SMFriend *friend = friendGroup.arrFriend[indexPath.row];
        cell.myFriend = friend;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SMLog(@"点击了 我的团队cell");
//        SMMyTeamController *vc = [[SMMyTeamController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        SMConnectPersonSectionData *data = self.topDataArray[indexPath.row];
        if(data.myoption){
            data.myoption();
        }
    }else{
        //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
        SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
        SMFriendGroup *friendG = self.arrayDatas[indexPath.section - 1];
        SMFriend *friend = friendG.arrFriend[indexPath.row];
        vc.user = friend.user;
//        vc.client = self.client;
        [self.navigationController pushViewController:vc animated:YES];
        SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
    }
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


@end
