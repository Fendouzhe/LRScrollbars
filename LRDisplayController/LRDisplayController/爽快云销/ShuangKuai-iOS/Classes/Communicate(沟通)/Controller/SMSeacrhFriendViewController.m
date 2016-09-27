//
//  SMSeacrhFriendViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  搜索好友，不一定就是好友

#import "SMSeacrhFriendViewController.h"
#import "SKAPI.h"
#import "SMFriend.h"
#import "SMContactPersonTableViewCell.h"
#import "SMPersonInfoViewController.h"
#import "SMNewPersonInfoController.h"

@interface SMSeacrhFriendViewController ()
@property (nonatomic,strong) NSMutableArray *dataArray;/**< 数据源 */
@property (nonatomic,assign) int pageSize;/**< pagesize */
@property (nonatomic,assign) int totalPage;/**< 总共页面数量 */
@end

@implementation SMSeacrhFriendViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.pageSize = 10;
    UIView *whiteView = [[UIView alloc] init];
    self.tableView.tableFooterView = whiteView;
    
    MJWeakSelf
    MJRefreshBackNormalFooter *Productfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestAddNewPage];
        
    }];
    self.tableView.mj_footer = Productfooter;
    [self requestAddNewPage];
}

//-(void)setKeyWord:(NSString *)keyWord{
//    _keyWord = [keyWord copy];
////    [self requestDataWithNumberPage:1];
//}

-(void)requestAddNewPage{
    if(!self.pageNumber){
        self.pageNumber ++;
        [self requestDataWithNumberPage:self.pageNumber];
//        self.pageNumber ++;
    }else{
        if (self.pageNumber > self.totalPage) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.pageNumber = self.pageNumber +1;
            [self requestDataWithNumberPage:self.pageNumber];
        }
    }
}

-(void)requestDataWithNumberPage:(int)pageNumber{
    
//    self.pageNumber = self.pageNumber + 1;
    MJWeakSelf
    [[SKAPI shared] queryUser:self.keyWord andPage:pageNumber andSize:self.pageSize block:^(id responseObject, NSError *error) {
        if (!error) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
//            NSMutableArray *tempArray = [NSMutableArray array];
            for (User *user in datas) {
                SMFriend *friend = [[SMFriend alloc] init];
                friend.user = user;
                [weakSelf.dataArray addObject:friend];
            }
            int totalPage = [[page valueForKey:@"totalPage"] intValue];
            weakSelf.totalPage = totalPage;
            [weakSelf.tableView reloadData];
//            weakSelf.dataArray = tempArray;
            
//            MJRefreshBackNormalFooter *Productfooter = self.tableView.mj_footer;
            [weakSelf.tableView.mj_footer endRefreshing];
            if (totalPage == pageNumber) {
                SMLog(@"没有下一页");
                self.tableView.mj_footer = nil;
            }
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
    SMFriend *friend = self.dataArray[indexPath.row];
    cell.myFriend = friend;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
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
    SMNewPersonInfoController *vc =[[SMNewPersonInfoController alloc] init];
    SMFriend *friend = self.dataArray[indexPath.row];
    vc.user = friend.user;
    //        vc.client = self.client;
    [self.navigationController pushViewController:vc animated:YES];
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
}

@end
