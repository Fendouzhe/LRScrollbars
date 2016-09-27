//
//  SMParticipantController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMParticipantController.h"
#import "SMChooseParticipantCell.h"
#import "SMFriend.h"
#import "SMFriendGroup.h"
#import "SMParticipant.h"


@interface SMParticipantController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrFriend;/**< 好友里的人 */

@property (nonatomic ,strong)NSMutableArray *arrTeam;/**< 我的团队里的人 */

@property (nonatomic ,strong)NSMutableArray *arrShow;/**< （排重后的人） */

@property (nonatomic ,strong)NSMutableArray *arrayDatas;/**< 最终tableView 展示数据时需要的数组  */

@property (nonatomic ,strong)NSArray *arrLetters;/**< ABCD.... */


@end

@implementation SMParticipantController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self requestData];
    
}

- (void)setupNav{
    self.title = @"选择参与人";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确定" attributes:dict];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    rightBtn.width = 30;
//    rightBtn.height = 25;
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)rightItemClick{
    SMLog(@"点击了 确定");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData{
    
    [self requestFriend]; //好友里的人
    
}

- (void)requestFriend{
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            self.arrFriend = [NSMutableArray arrayWithArray:array];
            
            [self requestMyTeam]; //我的团队里的人
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)requestMyTeam{
    [[SKAPI shared] queryMyTeamList:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  queryMyTeamList  %@",result);
//            for (User *user in (NSArray *)result) {
//                SMLog(@"user.name   %@",user.name);
//            }
            self.arrTeam = [NSMutableArray arrayWithArray:(NSArray *)result];
            //下面排重
            for (User *user in self.arrFriend) {
                [self.arrShow addObject:user];
            }
            
            for (User *user in self.arrTeam) {
                
                BOOL flag = NO;
                for (int i = 0; i < self.arrFriend.count; i++) {
                    User *u = self.arrFriend[i];
                    
                    if ([user.id isEqualToString:u.id]) {
                        flag = YES;
                    }
                }
                
                if (flag == NO) {  //如果到这里flag 是NO ，就说明，这个user 是没有重复
                    [self.arrShow addObject:user];
                }
            }
            
            // 到这里  ， self.arrShow 就是最终需要展示出来的数组（已排重后的）,下面就将这些数据重新整理成需要分组展示的数据
            [self setupGroupData:self.arrShow];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)setupGroupData:(NSMutableArray *)array{
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
    
    //刚进入界面时，判断哪些是上次已选中的人
    if (self.arrHaveChoosed.count > 0) {
        for (int i = 0; i < self.arrHaveChoosed.count; i++) {
            SMFriend *friend = self.arrHaveChoosed[i];
            for (SMFriendGroup *group in self.arrayDatas) {
                for (SMFriend *f in group.arrFriend) {
                    if ([f.user.id isEqualToString:friend.user.id]) {
                        f.isSelected = YES;
                    }
                }
            }
        }
    }
    
    
    SMLog(@"self.arrHaveChoosedPushedByFather.count   %zd",self.arrHaveChoosedPushedByFather.count);
    if (self.arrHaveChoosedPushedByFather.count > 0) {
        for (int i = 0; i < self.arrHaveChoosedPushedByFather.count; i++) {
            SMParticipant *p = self.arrHaveChoosedPushedByFather[i];
            for (SMFriendGroup *group in self.arrayDatas) {
                for (SMFriend *f in group.arrFriend) {
                    if ([f.user.id isEqualToString:p.userid]) {
                        f.isSelected = YES;
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SMFriendGroup *friendGroup = self.arrayDatas[section];
    SMLog(@"friendGroup.arrFriend.count   %zd",friendGroup.arrFriend.count);
    return friendGroup.arrFriend.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMChooseParticipantCell *cell = [SMChooseParticipantCell cellWithTableView:tableView];
    SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section];
    SMFriend *friendModel = friendGroup.arrFriend[indexPath.row];
    cell.friendModel = friendModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 *SMMatchHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMChooseParticipantCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.gouBtn.selected = !cell.gouBtn.selected;
    cell.friendModel.isSelected = cell.gouBtn.selected;
}



- (void)setupTableView{
    [self.view addSubview:self.tableView];
}

- (void)dealloc{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (SMFriendGroup *friendG in self.arrayDatas) {
        
        for (int i = 0; i < friendG.arrFriend.count; i++) {
            SMFriend *friend = friendG.arrFriend[i];
            if (friend.isSelected) {
                [arr addObject:friend];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(haveSelectedPerson:)]) {
        [self.delegate haveSelectedPerson:arr];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)arrFriend{
    if (_arrFriend == nil) {
        _arrFriend = [NSMutableArray array];
    }
    return _arrFriend;
}

- (NSMutableArray *)arrTeam{
    if (_arrTeam == nil) {
        _arrTeam = [NSMutableArray array];
    }
    return _arrTeam;
}

- (NSMutableArray *)arrShow{
    if (_arrShow == nil) {
        _arrShow = [NSMutableArray array];
    }
    return _arrShow;
}

- (NSArray *)arrLetters{
    if (_arrLetters == nil) {
        _arrLetters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"?",@"1"];
    }
    return _arrLetters;
}

- (NSMutableArray *)arrayDatas{
    if (_arrayDatas == nil) {
        _arrayDatas = [NSMutableArray array];
    }
    return _arrayDatas;
}

- (NSArray *)arrHaveChoosedPushedByFather{
    if (_arrHaveChoosedPushedByFather == nil) {
        _arrHaveChoosedPushedByFather = [NSMutableArray array];
    }
    return _arrHaveChoosedPushedByFather;
}

@end
