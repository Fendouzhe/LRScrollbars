//
//  SMGroupChatListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMGroupChatListViewController.h"
#import "SMGroupChatListData.h"
#import "SMGroupChatListTableViewCell.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatList.h"
#import "TempAppShareObject.h"

@interface SMGroupChatListViewController ()<SWTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;/**< 数组 */
@end

@implementation SMGroupChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群组";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self requestData];
}

- (void)requestData{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[SKAPI shared] queryGroupList4IM:^(id result, NSError *error) {
//        SMLog(@"群聊群组列表 = %@",result);
        if(!error){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSString *status = [result valueForKey:@"status"];
            if (0 == [status intValue]) {
                id page = [result valueForKey:@"result"];
                NSArray *companyArray = [SMGroupChatListData mj_objectArrayWithKeyValuesArray:page];
                self.dataArray = [NSMutableArray arrayWithArray:companyArray];
                [[SMGroupChatList sharedManager] startWithGroupArray:companyArray];
                UIView *whiteView = [[UIView alloc] init];
                self.tableView.tableFooterView = whiteView;
                [self.tableView reloadData];
            } else{
//                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
//                NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
//                
//                block(nil, error);
                [MBProgressHUD showError:@"加载失败,请检查网络!"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMGroupChatListTableViewCell *cell = [SMGroupChatListTableViewCell cellWithTableView:tableView];
//    cell.rightUtilityButtons = [self rightButtons];
    cell.cellData = self.dataArray[indexPath.row];
//    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            SMLog(@"More button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [self deleteWithIndex:cellIndexPath];
        }
            break;
        default:
            break;
    }
}

-(void)deleteWithIndex:(NSIndexPath *)index{
    SMGroupChatListData *data = self.dataArray[index.row];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    MJWeakSelf
    //NSString *roomID = data.id;
    if ([data.createrId isEqualToString:userID]) {
        [[SKAPI shared] dismissGroup4IM:data.id block:^(id result, NSError *error) {
            if (!error) {
                [weakSelf.dataArray removeObjectAtIndex:index.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[index]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }else{
        
        [[SKAPI shared] quitGroup4IM:data.id block:^(id result, NSError *error) {
            if (!error) {
                [weakSelf.dataArray removeObjectAtIndex:index.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[index]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.navigationController.viewControllers.count>3) {
//        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:NO];
////        return;
//    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    SMGroupChatListData *cellData = self.dataArray[indexPath.row];
    SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
    vc.groupId = cellData.id;
    //目标会话一定要设置
    vc.targetId = cellData.id;
    vc.conversationType = ConversationType_GROUP;
    vc.roomData = cellData;
    vc.title = cellData.roomName;
    [self.navigationController pushViewController:vc animated:YES];
    //[self requestDataWithGroupID:cellData.id withVC:vc];
}
-(void)requestDataWithGroupID:(NSString *)groupID withVC:(SMGroupChatViewController *)vc{
    MJWeakSelf
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
            if (weakSelf.navigationController==nil) {
                SMLog(@"导航控制器为空");
                [TempAppShareObject shareInstance].tempGroupVC = vc;
                [[NSNotificationCenter defaultCenter] postNotificationName:NeedPostGroupChatViewController object:weakSelf];
            }else{
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }];
}

@end
