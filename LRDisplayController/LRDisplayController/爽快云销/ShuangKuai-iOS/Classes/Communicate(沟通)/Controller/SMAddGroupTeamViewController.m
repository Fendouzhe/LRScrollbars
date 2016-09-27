//
//  SMAddGroupTeamViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddGroupTeamViewController.h"
#import "SMMyTemCell.h"
#import "SMPersonInfoViewController.h"
#import "SMContactPersonTableViewCell.h"
#import "SMFriend.h"

@interface SMAddGroupTeamViewController ()<UITextFieldDelegate,SMContactPersonTableViewCellDelegate>

@property(nonatomic,copy)NSMutableArray * dataArray;/**< 显示的数组 */

//添加好友时的textfield的内容
@property(nonatomic,copy)NSString * remark;
@end

@implementation SMAddGroupTeamViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupNav];
    
    self.title = @"我的团队";
    
    self.tableView.editing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestData];
    
}

-(void)setupNav{
    
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.width = 40;
//    rightBtn.height = 30;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = KDefaultFontBig;
    dic[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:@"保存" attributes:dic];
    [rightBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}




-(void)saveClick{
    
    
}
-(void)requestData{
    MJWeakSelf
    [[SKAPI shared] queryMyTeamList:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result =     %@",result);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            for (User * user in self.oldSelectArray) {
                [dic setObject:@"" forKey:user.id];
                
            }
            
            
            for (User * user in result) {
                SMLog(@"username = %@,userid = %@",user.name,user.userid);
                SMFriend *friend = [[SMFriend alloc] init];
                friend.user = user;
                [weakSelf.dataArray addObject:friend];
                
                if (dic[user.id]) {
                    friend.select = YES;
//                    [self.IdArray addObject:user];
                }else{
                    friend.select = NO;
                }
                
            }
            
            /**
             * 添加测试数据
             */
            
//            User *user1 = [[User alloc] init];
//            user1.name = @"test1";
//            user1.userid = @"test1";
//            SMFriend *friend1 = [[SMFriend alloc] init];
//            friend1.user = user1;
//            friend1.select = YES;
//            
//            User *user2 = [[User alloc] init];
//            user2.name = @"test2";
//            user2.userid = @"test2";
//            SMFriend *friend2 = [[SMFriend alloc] init];
//            friend2.user = user2;
//            friend2.select = NO;
//            
//            [weakSelf.dataArray addObject:friend1];
//            [weakSelf.dataArray addObject:friend2];
            
            [weakSelf.tableView reloadData];
            
//            [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
//                if (!error) {
//                    SMLog(@"%@",array);
//                    //进行处理
//                    for (User * user in self.dataArray) {
//                        for (User * user1 in array) {
//                            if ([user.userid isEqualToString:user1.userid]) {
//                                //是自己好友
//                                user.isFriend = YES;
//                                break;
//                            }
//                            
//                            user.isFriend = NO;
//                        }
//                    }
//                    [weakSelf.tableView reloadData];
//                }else{
//                    SMLog(@"%@",error);
//                }
//            }];
            
//            SMLog(@"%@",self.IdArray);
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 7;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
    //可以在这里给cell赋值
    cell.delegate = self;
    
//    SMFriend *friend = [[SMFriend alloc] init];
    SMFriend *friend = self.dataArray[indexPath.row];
    cell.myFriend = friend;
    
    if(friend.select)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    //        if(indexPath.section<10){
    //            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //        }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    SMLog(@"选中");
    
    SMFriend *theFriend = self.dataArray[indexPath.row];
    
    theFriend.select = YES;
    if ([self.delegate respondsToSelector:@selector(addFriend:)]) {
        [self.delegate addFriend:theFriend.user];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    
    SMFriend *theFriend = self.dataArray[indexPath.row];
    theFriend.select = NO;
    if ([self.delegate respondsToSelector:@selector(delFriend:)]) {
        [self.delegate delFriend:theFriend.user];
    }

        
    
}

- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}


- (void)alertTextFieldTextDidChange:(NSNotification *)notification
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    
    if (alert) {
        UITextField *lisen = [alert.textFields lastObject];
        self.remark = lisen.text;
    }
}

@end
