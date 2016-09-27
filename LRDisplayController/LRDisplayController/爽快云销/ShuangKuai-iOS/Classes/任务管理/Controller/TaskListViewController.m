//
//  TaskListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListModel.h"
#import "TaskListViewModel.h"
#import "MainTaskParticipant.h"
#import "TaskListCell.h"
#import "SMSearchButtonView.h"
#import "TaskListTopSelectView.h"
#import "TaskMaskView.h"
#import "SMPersonInfoViewController.h"
#import "TaskDetailInfoViewController.h"
#import "TaskSearchController.h"
#import "SMCreatTaskController.h"
#import "SMSearchViewController.h"
#import "TaskListViewModel.h"
#import "SingtonManager.h"
#import "SMNewPersonInfoController.h"


@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource,SMSearchButtonViewDelegate,TaskListCellDelegate,TaskMaskViewDelegate,TaskListTopSelectViewDelegate,SMCreatTaskControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;/**< 表格 */
@property (nonatomic,strong) NSMutableArray *dataArray;/**< 数据源 */
@property (nonatomic,strong) SMSearchButtonView *searchView;/**< 搜索框 */
@property (nonatomic,strong) TaskListTopSelectView *selectView;/**< 选择框 */
@property (nonatomic,assign) int centerSelectNumber;/**< 中间的选项，0未选择，1选择我发布的，2选择我接收的 */
@property (nonatomic,assign) int rightSelectNumber;/**< 右边的选项，0未选择，1选择未发布的，2未完成的，3已完成的 */
@property (nonatomic,assign) int leftSelectNumber;/**< 左边的选项，0未选择，1选择 */
@property (nonatomic,assign) int selectViewNumber;/**< 按钮选择，0左，1中，2右 */
@property (nonatomic,strong) UIButton *rightBtn;/**< <#属性#> */
@end

@implementation TaskListViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self searchView];
    [self selectView];
    self.leftSelectNumber = 0;
    self.centerSelectNumber = 0;
    self.rightSelectNumber = 2;
    
    [self requestData];
    
    [self SetupMJRefresh];
    
    ///清除消息红点
    SingtonManager * sington = [SingtonManager sharedManager];
    NSMutableArray * array = [NSMutableArray array];
    for (Msg * msg in sington.jobArray) {
        [array addObject:msg.messageId];
    }
    //SMLog(@"array = %@",array);
    [[SKAPI shared] receiptMessage:[array copy] block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [sington.jobArray removeAllObjects];
            sington.jobNum = sington.jobArray.count;
        }else{
            SMLog(@"%@",error);
        }
    }];
    
}

-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *collectionViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];

    }];
    self.tableView.mj_header = collectionViewheader;
}


- (void)setupNav{
    self.title = @"协同任务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.dataArray = @[viewModel1,viewModel2,viewModel3];
    //    [self.tableView reloadData];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"新建" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    //    rightBtn.width = 30;
    //    rightBtn.height = 22;
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightBtn = rightBtn;
}

-(void)rightItemClick{
    SMCreatTaskController *vc = [[SMCreatTaskController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestData{
    NSString *type;
    NSInteger offset = 10000;
    NSString *lastTime;
    NSString *status;
    NSString *keyword =nil;
    
    if (self.leftSelectNumber) {
        type = nil;
//        offset = 10000;
//        lastTime = -1;
        status = nil;
    }else if(self.centerSelectNumber == 0){
        
//        offset = 10000;
//        lastTime = -1;
        status = nil;
        switch (self.rightSelectNumber) {
            case 0:
            {
                status = nil;
            }
                break;
            case 1:
            {
                status = @"0";
            }
                break;
            case 2:
            {
                status = @"1";
            }
                break;
            case 3:
            {
                status = @"2";
            }
                break;
            default:
                break;
        }
    }else if(self.centerSelectNumber == 1){
        type = @"1";
//        offset = 10000;
//        lastTime = -1;
        switch (self.rightSelectNumber) {
            case 0:
            {
                status = nil;
            }
                break;
            case 1:
            {
                status = @"0";
            }
                break;
            case 2:
            {
                status = @"1";
            }
                break;
            case 3:
            {
                status = @"2";
            }
                break;
            default:
                break;
        }
    }else if(self.centerSelectNumber == 2){
        type = @"0";
        switch (self.rightSelectNumber) {
            
//            offset = 10000;
//            lastTime = @"";
            case 0:
            {
                status = nil;
            }
                break;
            case 2:
            {
                status = @"1";
            }
                break;
            case 3:
            {
                status = @"2";
            }
                break;
            default:
                break;
        }
    }
    MJWeakSelf
//    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    [[SKAPI shared] queryMissionList:type andOffset:offset andLastTimestamp:lastTime andStatus:status andKeyword:keyword block:^(id result, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        if(!error){
            SMLog(@"queryMissionList  result   %@",result);
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (TaskListModel *model in result) {
                TaskListViewModel *viewModel = [[TaskListViewModel alloc] init];
                viewModel.cellData = model;
                [tempArray addObject:viewModel];
            }
            weakSelf.dataArray = tempArray;
            [weakSelf.tableView reloadData];
        }else{
            SMLog(@"queryMissionList  error  %@",error);
            
        }
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListCell *cell = [TaskListCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataArray[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailInfoViewController *vc = [[TaskDetailInfoViewController alloc] init];
    
    TaskListViewModel *model = self.dataArray[indexPath.row];
    vc.taskID = model.cellData.schedule.id;
    vc.schedule = model.cellData.schedule;
    vc.block = ^(){
        [self requestData];
    };
    
    SMLog(@"vc.taskID  %@  vc.schedule  %@",vc.taskID,vc.schedule);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TaskListTopSelectViewDelegate
-(void)topSelectButtonClick:(int)number{
    switch (number) {
        case 0:
        {
            [self.selectView setButtonTextWithArray:@[@"全部",@"任务状态",@"完成状态"]];
            [self.selectView setButtonSelectWithNumber:0];
            self.leftSelectNumber = 1;
            self.centerSelectNumber = 0;
            self.rightSelectNumber = 0;
            self.selectViewNumber = 0;
            [self requestData];
        }
            break;
        case 1:
        {
            TaskMaskView *maskView = [[TaskMaskView alloc] init];
            maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
            maskView.delegate = self;
            [maskView addTextButtonWithArrayText:@[@"我发出的任务",@"我接收的任务"] withPosition:1];
            self.selectViewNumber = 1;
        }
            break;
        case 2:
        {
            self.selectViewNumber = 2;
            switch (self.centerSelectNumber) {
                case 0:
                {
                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    maskView.delegate = self;
                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已完成"] withPosition:2];
                }
                    break;
                case 1:
                {
                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    maskView.delegate = self;
                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已完成"] withPosition:2];
                }
                    break;
                case 2:
                {
                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    maskView.delegate = self;
                    [maskView addTextButtonWithArrayText:@[@"未完成",@"已完成"] withPosition:2];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/**
 *  当提交一个编辑操作的时候调用
 *  只要实现了这个方法，那么向左滑动就会出现删除按钮，
 *  只有点击了删除按钮才会调用该方法
 *  @param editingStyle 编辑操作
 UITableViewCellEditingStyleDelete, 删除
 UITableViewCellEditingStyleInsert  插入
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
//        // 删除数组中对应的模型
//        [self.contacts removeObjectAtIndex:indexPath.row];
//        // 刷新表格
//        // 全局刷新，性能不好，要使用局部刷新
//        //    [self.tableView reloadData];
//        
//        // reloadRowsAtIndexPaths:刷新前后，数组中元素个数和界面显示的行数不能变
//        //    self.tableView reloadRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
//        
//        // 删除指定的行
//        // 注意点：数组中删除的元素个数必须和界面上删除的行数一致
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        
        TaskListViewModel *model = self.dataArray[indexPath.row];
        
        SMLog(@"model.cellData.schedule.type  %zd   model.cellData.schedule.status   %zd",model.cellData.schedule.type,model.cellData.schedule.status);
        
        if (model.cellData.schedule.status == 2) {  //已完成，不可删除
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此任务已完成，不可被删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        if (![model.cellData.schedule.userId isEqualToString:userId]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您不是该任务发布人，不可删除." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [MBProgressHUD showMessage:@"正在删除..."];
        [[SKAPI shared] deleteMission:model.cellData.schedule.id block:^(id result, NSError *error) {
            [MBProgressHUD hideHUD];
            if (!error) {
                [MBProgressHUD showSuccess:@"删除成功！"];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }else{
                [MBProgressHUD showError:@"删除失败，请重试"];
            }
        }];
       
    }
}

/**
 *  告诉tableView第indexPath行要执行怎么操作
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.editing) { // 插入操作
        return UITableViewCellEditingStyleInsert;
    }
    // 删除操作
    return UITableViewCellEditingStyleDelete;
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - SMCreatTaskControllerDelegate
-(void)editTaskSuccess{
    [self requestData];
}

#pragma mark - TaskListCellDelegate
-(void)clickNameWithUserID:(NSString *)userID{

    //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    User *tapUser = [[User alloc] init];
    tapUser.userid = userID;
    vc.user = tapUser;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TaskMaskViewDelegate
-(void)selectButtonWithNumber:(int)number{
//    SMLog(@"%d",number);
    switch (self.selectViewNumber) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [self.selectView setFirstButtonSelect:NO];
            switch (number) {
                case 0:
                {
                    self.leftSelectNumber = 0;
                    self.centerSelectNumber = 1;
                    self.rightSelectNumber = 0;
//                    self.selectViewNumber = 1;
                    [self.selectView setSecondButtonSelectWithText:@"我发出的任务"];
                    [self.selectView setThirdButtonSelectWithText:@"发布状态"];
                    [self requestData];
                }
                    break;
                case 1:
                {
                    self.leftSelectNumber = 0;
                    self.centerSelectNumber = 2;
                    self.rightSelectNumber = 0;
//                    self.selectViewNumber = 1;
                    [self.selectView setSecondButtonSelectWithText:@"我接收的任务"];
                    [self.selectView setThirdButtonSelectWithText:@"发布状态"];
                    [self requestData];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            [self.selectView setFirstButtonSelect:NO];
            self.leftSelectNumber = 0;
            switch (self.centerSelectNumber) {
                case 0:
                {
                    switch (number) {
                        case 0:
                        {
                            self.rightSelectNumber = 1;
                            [self.selectView setThirdButtonSelectWithText:@"未发布"];
                            [self requestData];
                        }
                            break;
                        case 1:
                        {
                            self.rightSelectNumber = 2;
                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
                            [self requestData];
                        }
                            break;
                        case 2:
                        {
                            self.rightSelectNumber = 3;
                            [self.selectView setThirdButtonSelectWithText:@"已完成"];
                            [self requestData];
                        }
                        default:
                            break;
                    }
                }
                    break;
                case 1:
                {
                    switch (number) {
                        case 0:
                        {
                            self.rightSelectNumber = 1;
                            [self.selectView setThirdButtonSelectWithText:@"未发布"];
                            [self requestData];
                        }
                            break;
                        case 1:
                        {
                            self.rightSelectNumber = 2;
                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
                            [self requestData];
                            
                        }
                            break;
                        case 2:
                        {
                            self.rightSelectNumber = 3;
                            [self.selectView setThirdButtonSelectWithText:@"已完成"];
                            [self requestData];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 2:
                {
                    switch (number) {
                        case 0:
                        {
                            self.rightSelectNumber = 2;
                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
                            [self requestData];
                        }
                            break;
                        case 1:
                        {
                            self.rightSelectNumber = 3;
                            [self.selectView setThirdButtonSelectWithText:@"已完成"];
                            [self requestData];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)searchButtonClick{
//    TaskSearchController *vc = [[TaskSearchController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 9;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
-(SMSearchButtonView *)searchView{
    if (_searchView == nil) {
        _searchView = [[SMSearchButtonView alloc] init];
        _searchView.backgroundColor = SMColor(241,242,244);
        _searchView.delegate = self;
        [self.view addSubview:_searchView];
        MJWeakSelf
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.height.equalTo(@(45*SMMatchWidth));
        }];
    }
    return _searchView;
}

-(TaskListTopSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[TaskListTopSelectView alloc] init];
        _selectView.delegate = self;
        [self.view addSubview:_selectView];
        MJWeakSelf
        [_selectView setButtonTextWithArray:@[@"全部",@"任务状态",@"未完成"]];
        [_selectView setButtonSelectWithNumber:2];
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.searchView.mas_bottom);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.height.equalTo(@(40*SMMatchWidth));
        }];
    }
    return _selectView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        MJWeakSelf
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.selectView.mas_bottom);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
