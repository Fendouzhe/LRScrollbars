//
//  TaskSearchController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskSearchController.h"
#import "TaskSearchHeaderView.h"
#import "TaskListCell.h"
#import "SMPersonInfoViewController.h"
#import "TaskListModel.h"
#import "TaskListViewModel.h"
#import "TaskListTopSelectView.h"
#import "TaskMaskView.h"
#import "TaskDetailInfoViewController.h"

@interface TaskSearchController ()<TaskSearchHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,TaskListCellDelegate,TaskListTopSelectViewDelegate,TaskMaskViewDelegate>
@property (nonatomic,strong) TaskSearchHeaderView *headerView;/**< <#属性#> */
@property (nonatomic,strong) UITableView *tableView;/**<  */
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
//@property (nonatomic,strong) TaskListTopSelectView *selectView;/**< 选择框 */
@property (nonatomic,assign) int centerSelectNumber;/**< 中间的选项，0未选择，1选择我发布的，2选择我接收的 */
@property (nonatomic,assign) int rightSelectNumber;/**< 右边的选项，0未选择，1选择未发布的，2未完成的，3已完成的 */
@property (nonatomic,assign) int leftSelectNumber;/**< 左边的选项，0未选择，1选择 */
@property (nonatomic,assign) int selectViewNumber;/**< 按钮选择，0左，1中，2右 */
@end

@implementation TaskSearchController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"日程搜索";
    self.view.backgroundColor = KControllerBackGroundColor;
//    [self headerView];
    [self setupSearchHeader];
    [self setupTableView];
    
    self.leftSelectNumber = 0;
    self.centerSelectNumber = 0;
    self.rightSelectNumber = 0;
}

- (void)setupSearchHeader{
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@(40*SMMatchHeight));
    }];
}

- (void)setupTableView{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
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

//#pragma mark - TaskListTopSelectViewDelegate
//-(void)topSelectButtonClick:(int)number{
//    switch (number) {
//        case 0:
//        {
//            [self.selectView setButtonTextWithArray:@[@"全部",@"任务状态",@"完成状态"]];
//            [self.selectView setButtonSelectWithNumber:0];
//            self.leftSelectNumber = 1;
//            self.centerSelectNumber = 0;
//            self.rightSelectNumber = 0;
//            self.selectViewNumber = 0;
//            [self requestData];
//        }
//            break;
//        case 1:
//        {
//            TaskMaskView *maskView = [[TaskMaskView alloc] init];
//            maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//            maskView.delegate = self;
//            [maskView addTextButtonWithArrayText:@[@"我发出的任务",@"我接收的任务"] withPosition:1];
//            self.selectViewNumber = 1;
//        }
//            break;
//        case 2:
//        {
//            self.selectViewNumber = 2;
//            switch (self.centerSelectNumber) {
//                case 0:
//                {
//                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
//                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//                    maskView.delegate = self;
//                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已经完成"] withPosition:2];
//                }
//                    break;
//                case 1:
//                {
//                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
//                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//                    maskView.delegate = self;
//                    [maskView addTextButtonWithArrayText:@[@"未发布",@"未完成",@"已经完成"] withPosition:2];
//                }
//                    break;
//                case 2:
//                {
//                    TaskMaskView *maskView = [[TaskMaskView alloc] init];
//                    maskView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//                    maskView.delegate = self;
//                    [maskView addTextButtonWithArrayText:@[@"未完成",@"已经完成"] withPosition:2];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - TaskListCellDelegate
-(void)clickNameWithUserID:(NSString *)userID{
    
    SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
    User *tapUser = [[User alloc] init];
    tapUser.userid = userID;
    vc.user = tapUser;
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark - TaskMaskViewDelegate
//-(void)selectButtonWithNumber:(int)number{
//    //    SMLog(@"%d",number);
////    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    switch (self.selectViewNumber) {
//        case 0:
//        {
//            
//        }
//            break;
//        case 1:
//        {
//            [self.selectView setFirstButtonSelect:NO];
//            switch (number) {
//                case 0:
//                {
//                    
//                    self.leftSelectNumber = 0;
//                    self.centerSelectNumber = 1;
//                    self.rightSelectNumber = 0;
//                    //                    self.selectViewNumber = 1;
//                    
//                    [self.selectView setSecondButtonSelectWithText:@"我发出的任务"];
//                    [self.selectView setThirdButtonSelectWithText:@"发布状态"];
//                    [self requestData];
//                }
//                    break;
//                case 1:
//                {
//                    self.leftSelectNumber = 0;
//                    self.centerSelectNumber = 2;
//                    self.rightSelectNumber = 0;
//                    //                    self.selectViewNumber = 1;
//                    [self.selectView setSecondButtonSelectWithText:@"我接收的任务"];
//                    [self.selectView setThirdButtonSelectWithText:@"发布状态"];
//                    [self requestData];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        case 2:
//        {
//            [self.selectView setFirstButtonSelect:NO];
//            self.leftSelectNumber = 0;
//            switch (self.centerSelectNumber) {
//                case 0:
//                {
//                    switch (number) {
//                        case 0:
//                        {
//                            self.rightSelectNumber = 1;
//                            [self.selectView setThirdButtonSelectWithText:@"未发布"];
//                            [self requestData];
//                        }
//                            break;
//                        case 1:
//                        {
//                            self.rightSelectNumber = 2;
//                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
//                            [self requestData];
//                        }
//                            break;
//                        case 2:
//                        {
//                            self.rightSelectNumber = 3;
//                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
//                            [self requestData];
//                        }
//                        default:
//                            break;
//                    }
//                }
//                    break;
//                case 1:
//                {
//                    switch (number) {
//                        case 0:
//                        {
//                            self.rightSelectNumber = 1;
//                            [self.selectView setThirdButtonSelectWithText:@"未发布"];
//                            [self requestData];
//                        }
//                            break;
//                        case 1:
//                        {
//                            self.rightSelectNumber = 2;
//                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
//                            [self requestData];
//                            
//                        }
//                            break;
//                        case 2:
//                        {
//                            self.rightSelectNumber = 3;
//                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
//                            [self requestData];
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//                }
//                    break;
//                case 2:
//                {
//                    switch (number) {
//                        case 0:
//                        {
//                            self.rightSelectNumber = 2;
//                            [self.selectView setThirdButtonSelectWithText:@"未完成"];
//                            [self requestData];
//                        }
//                            break;
//                        case 1:
//                        {
//                            self.rightSelectNumber = 3;
//                            [self.selectView setThirdButtonSelectWithText:@"已经完成"];
//                            [self requestData];
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//                }
//                    break;
//                default:
//                    break;
//            }
//            
//        }
//            break;
//        default:
//            break;
//    }
//}

//-(void)clickNameWithUserID:(NSString *)userID{
//    SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
//    User *tapUser = [[User alloc] init];
//    tapUser.userid = userID;
//    vc.user = tapUser;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)requestData{
//    NSString *type = nil;
//    NSInteger offset = 10000;
//    NSString *lastTime = nil;
//    NSString *status = nil;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
    [[SKAPI shared] queryMissionList:type andOffset:offset andLastTimestamp:lastTime andStatus:status andKeyword:self.keyWords block:^(id result, NSError *error) {
        [MBProgressHUD hideHUD];
        if(!error){
            SMLog(@"queryMissionList  result  %@ ",result);
            NSMutableArray *tempArray = [NSMutableArray array];
            for (TaskListModel *model in result) {
                TaskListViewModel *viewModel = [[TaskListViewModel alloc] init];
                viewModel.cellData = model;
                [tempArray addObject:viewModel];
            }
            weakSelf.dataArray = tempArray;
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD hideHUD];
            SMLog(@"queryMissionList  error  %@",error);
            SMShowErrorNet;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailInfoViewController *vc = [TaskDetailInfoViewController new];
    TaskListViewModel *viewModel = self.dataArray[indexPath.row];
    vc.taskID = viewModel.cellData.schedule.id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)taskSearchWithStr:(NSString *)str{
    self.keyWords = [str copy];
}

-(void)setKeyWords:(NSString *)keyWords{
    _keyWords= [keyWords copy];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self.headerView setSearchTextWithStr:keyWords];
    [self requestData];
}

-(TaskSearchHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[TaskSearchHeaderView alloc] init];
        _headerView.delegate = self;
        
//        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view);
//            make.left.equalTo(self.view);
//            make.right.equalTo(self.view);
//            make.height.equalTo(@(40*SMMatchHeight));
//        }];
        
    }
    return _headerView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        MJWeakSelf
        
    }
    return _tableView;
}

//-(TaskListTopSelectView *)selectView{
//    if (_selectView == nil) {
//        _selectView = [[TaskListTopSelectView alloc] init];
//        _selectView.delegate = self;
////        [self.view addSubview:_selectView];
//        MJWeakSelf
//        [_selectView setButtonTextWithArray:@[@"全部",@"任务状态",@"发布状态"]];
//        [_selectView setButtonSelectWithNumber:0];
//        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.view).with.offset(40*SMMatchWidth);
////            make.top.equalTo(self.headerView.mas_bottom);
//            make.left.equalTo(weakSelf.view);
//            make.right.equalTo(weakSelf.view);
//            make.height.equalTo(@(40*SMMatchWidth));
//        }];
//    }
//    return _selectView;
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
