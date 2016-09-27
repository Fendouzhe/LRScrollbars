//
//  SMFriendsWithGroupViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMFriendsWithGroupViewController.h"
#import "SMFriendList.h"
#import "SMFriend.h"
#import "SMFriendGroup.h"
#import "SMConnectPersonSection0.h"
#import "SMContactPersonTableViewCell.h"
#import "SMMyTeamController.h"
#import "SMPersonInfoViewController.h"
#import "SMGroupChatListViewController.h"
#import "ChineseToPinyin.h"

@interface SMFriendsWithGroupViewController ()
@property (nonatomic,copy) NSString *keyWord;/**< 关键字 */
//@property (nonatomic,strong) NSArray *arrLetters;/**< 排序数组 */
@property (nonatomic,strong) NSArray *dataArray;/**< 目标数组 */
@property (nonatomic,strong) NSMutableArray *sectionTitles;/**< 标题字符串 */
@end

@implementation SMFriendsWithGroupViewController

- (NSString *)keyWord{
    if (_keyWord == nil) {
        _keyWord = @"";
    }
    return _keyWord;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
        
    }
    return _dataArray;
}

//- (NSArray *)arrLetters{
//    if (_arrLetters == nil) {
//        _arrLetters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"?"];
//        
//    }
//    return _arrLetters;
//}

-(NSMutableArray *)sectionTitles
{
    if (_sectionTitles==nil) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestFriend];
}

- (void)requestFriend{
    SMLog(@"%@",self.keyWord);
    [[SKAPI shared] queryFriend:self.keyWord block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array.count   好友数 %zd",array.count);
            SMLog(@"array   %@",array);
            [[SMFriendList sharedManager] startWithFriendsArray:array];
            
            NSMutableArray *tempFriendsArray = [NSMutableArray array];
            for (User *user in array) {
                SMFriend *friends = [[SMFriend alloc] init];
                friends.user = user;
                [tempFriendsArray addObject:friends];
            }
            
            self.dataArray = [self sortDataArray:tempFriendsArray];
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:friendsListData.user.name];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:friendsListData];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(SMFriend *obj1, SMFriend *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.user.name];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.user.name];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    SMLog(@"self.dataArray.count new  %zd",self.dataArray.count);
    return self.dataArray.count + 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
    if (section == 0) {
        return 2;
    }else{
//        SMFriendGroup *friendGroup = self.dataArray[section - 1];
//        SMLog(@"friendGroup.arrFriend.count   %zd",friendGroup.arrFriend.count);
        NSArray *array = self.dataArray[section - 1];
        return array.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//第一组显示“我的团队”
        
        SMConnectPersonSection0 *cell = [SMConnectPersonSection0 cellWithTableview:tableView];
        return cell;
        
    }else{
        SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
        //可以在这里给cell赋值
        
//        SMFriendGroup *friendGroup = self.dataArray[indexPath.section - 1];
//        SMFriend *friend = friendGroup.arrFriend[indexPath.row];
        SMFriend *friend = self.dataArray[indexPath.section-1][indexPath.row];
        cell.myFriend = friend;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.dataArray.count){
        if(section == 0){
            return 0;
        }else{
            if ([[self.dataArray objectAtIndex:(section-1)] count] == 0)
            {
                return 0;
            }else{
                return 22;
            }
        }
        
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {   //第一组“我的团队”
        CGFloat height;
        if (isIPhone5) {
            height = 65;
        }else if (isIPhone6){
            height = 65 *KMatch6Height;
        }else if (isIPhone6p){
            height = 65;
        }
        return height;
    }else{
        //            CGFloat height;
        //            if (isIPhone5) {
        //                height = 51;
        //            }else if (isIPhone6){
        //                height = 51 *KMatch6Height;
        //            }else if (isIPhone6p){
        //                height = 51;
        //            }
        return 41 *SMMatchHeight+10;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
        
    if (section == 0) { //"我的团队"这一组
        return nil;
    }else{
//        SMFriendGroup *smFriend = self.dataArray[section - 1];
//        if ([smFriend.sort isEqualToString:@"?"]) {
//            return @"#";
//        }else{
//            
//            return smFriend.sort;
//        }
        return self.sectionTitles[section-1];
    }
    //        SMFriendGroup *friendG = self.dataArray[section];
    //        return friendG.sort;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMLog(@"点击了 我的团队cell");
        if (indexPath.row == 0 ) {
            SMMyTeamController *vc = [[SMMyTeamController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMGroupChatListViewController *vc = [[SMGroupChatListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
        SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
//        SMFriendGroup *friendG = self.dataArray[indexPath.section - 1];
        SMFriend *user = self.dataArray[indexPath.section - 1][indexPath.row];
        vc.user = user.user;
        [self.navigationController pushViewController:vc animated:YES];
        SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
