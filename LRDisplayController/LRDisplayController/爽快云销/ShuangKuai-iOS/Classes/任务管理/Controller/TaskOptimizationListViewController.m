//
//  TaskOptimizationListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskOptimizationListViewController.h"
#import "SMSearchButtonView.h"
#import "TaskListTopSelectView.h"
#import "SMCreatTaskController.h"
#import "TaskListModel.h"
#import "TaskListViewModel.h"
#import "TaskListCell.h"
#import "TaskDetailInfoViewController.h"
#import "TaskMaskView.h"
#import "SMPersonInfoViewController.h"
#import "SMSearchViewController.h"

@interface TaskOptimizationListViewController ()<UITableViewDelegate,UITableViewDataSource,SMSearchButtonViewDelegate,TaskListCellDelegate,TaskMaskViewDelegate,TaskListTopSelectViewDelegate>
@property (nonatomic,strong) UITableView *tableView;/**< 表格 */
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@property (nonatomic,strong) SMSearchButtonView *searchView;/**< 搜索框 */
@property (nonatomic,strong) TaskListTopSelectView *selectView;/**< 选择框 */
@property (nonatomic,assign) int centerSelectNumber;/**< 中间的选项，0未选择，1选择我发布的，2选择我接收的 */
@property (nonatomic,assign) int rightSelectNumber;/**< 右边的选项，0未选择，1选择未发布的，2未完成的，3已完成的 */
@property (nonatomic,assign) int leftSelectNumber;/**< 左边的选项，0未选择，1选择 */
@property (nonatomic,assign) int selectViewNumber;/**< 按钮选择，0左，1中，2右 */
@property (nonatomic,strong) UIButton *rightBtn;/**< <#属性#> */

@end

@implementation TaskOptimizationListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    //废弃
    self.title = @"协同任务";
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.dataArray = @[viewModel1,viewModel2,viewModel3];
    //    [self.tableView reloadData];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"新建" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    rightBtn.width = 30;
//    rightBtn.height = 22;
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightBtn = rightBtn;
    
    [self searchView];
    [self selectView];
    self.leftSelectNumber = 0;
    self.centerSelectNumber = 0;
    self.rightSelectNumber = 2;
    [self requestData];
    
}

-(void)rightItemClick{
    SMCreatTaskController *vc = [[SMCreatTaskController alloc] init];
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
    [MBProgressHUD showMessage:@"正在加载"];
    [[SKAPI shared] queryMissionList:type andOffset:offset andLastTimestamp:lastTime andStatus:status andKeyword:keyword block:^(id result, NSError *error) {
        [MBProgressHUD hideHUD];
        if(!error){
            SMLog(@"%@",result);
//            NSMutableArray *tempArray = [NSMutableArray array];
//            for (TaskListModel *model in result) {
//                TaskListViewModel *viewModel = [[TaskListViewModel alloc] init];
//                viewModel.cellData = model;
//                [tempArray addObject:viewModel];
//            }
            weakSelf.dataArray = result;
            [weakSelf.tableView reloadData];
        }else{
            SMLog(@"%@",error);
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
    vc.taskID = [self.dataArray[indexPath.row] cellData].schedule.id;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已经完成"] withPosition:2];
                }
                    break;
                case 1:
                {
                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    maskView.delegate = self;
                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已经完成"] withPosition:2];
                }
                    break;
                case 2:
                {
                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                    maskView.delegate = self;
                    [maskView addTextButtonWithArrayText:@[@"未完成",@"已经完成"] withPosition:2];
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

#pragma mark - TaskListCellDelegate
-(void)clickNameWithUserID:(NSString *)userID{
    
    SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
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
                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
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
                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
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
                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
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
@end
