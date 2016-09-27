//
//  SMSearchPersonViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  comment: 搜索好友列表，是好友

#import "SMSearchPersonViewController.h"
#import "SMFriend.h"
#import "SMPersonInfoViewController.h"
#import "SMContactPersonTableViewCell.h"
#import "ChineseToPinyin.h"

@interface SMSearchPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;/**< 默认表格 */
@property (nonatomic,strong) NSMutableArray *sectionTitles;/**< 头部数组,Str */
@property (nonatomic,strong) NSMutableArray *dataSource;/**< 数据源数据,SMFriend */
@property (nonatomic,strong) NSMutableArray *selectArray;/**< 选中的数据,User */
@property (nonatomic,strong) NSArray *originalArray;/**< 原始好友数据,User */
@end

@implementation SMSearchPersonViewController

-(NSMutableArray *)sectionTitles{
    if (_sectionTitles == nil) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        self.tableView = _tableView;
        MJWeakSelf
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
    }
    return _tableView;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    //联系人搜索结果
    self.title = @"搜索结果";
//    [self requestFriend];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setKeyStr:(NSString *)keyStr{
    _keyStr = [keyStr copy];
    [self requestFriend];
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
            if (weakSelf.keyStr.length) {
                [weakSelf sortOriginalArray];
            }else{
                weakSelf.dataSource = [weakSelf sortDataArray:friendArray];
                [weakSelf.tableView reloadData];
            }
        }else{
            
        }
    }];
}

-(void)sortOriginalArray{
    NSString *keyName = @"name";
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",keyName , self.keyStr];
    NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[self.originalArray filteredArrayUsingPredicate:predicateString]];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (User *user in filteredArray) {
        SMFriend *friend = [[SMFriend alloc] init];
        friend.user = user;
        [tempArray addObject:friend];
    }
    self.dataSource = [self sortDataArray:tempArray];
    [self.tableView reloadData];
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
//    cell.delegate = self;
    
    SMFriend *friend = self.dataSource[indexPath.section][indexPath.row];
    
    cell.myFriend = friend;
    
//    if(friend.select)
//    {
//        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }
    
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
    SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
    
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

//- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
//}
@end
