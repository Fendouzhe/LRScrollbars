//
//  TaskDetailInfoViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskDetailInfoViewController.h"
#import "SMFatherTask.h"
#import "SMSonTask.h"
#import "SMParticipant.h"
#import "TaskDetailMainViewFrame.h"
#import "SubTaskViewModel.h"
#import "MainTaskCell.h"
#import "SubTaskCell.h"
#import "ChildScheduleModel.h"
#import "TaskCommentMessage.h"
#import "TaskCommentMessageViewModel.h"
#import "AcceptViewCell.h"
#import "AcceptViewModel.h"
#import "TaskCommentCell.h"
#import "TaskCommentInputView.h"
#import "TaskInfoSelectView.h"
#import "SMCreatTaskController.h"
#import "SMPersonInfoViewController.h"
#import "SMNewPersonInfoController.h"

@interface TaskDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TaskInfoSelectViewDelegate,TaskCommentInputViewDelegate,SWTableViewCellDelegate,MainTaskCellDelegate,SMCreatTaskControllerDelegate,SubTaskCellDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;/**< 表格 */
@property (nonatomic,strong) UITableView *tableView;/**< <#属性#> */
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@property (nonatomic,assign) int selectButtonType;/**< 按钮,0接收数组，1评论详情 */
@property (nonatomic,strong) NSArray *taskFatherArray;/**< 父任务数组 */
@property (nonatomic,strong) NSArray *taskSonArray;/**< 子任务数组 */
@property (nonatomic,strong) NSArray *receiveArray;/**< 接收数组, */
@property (nonatomic,strong) NSArray *postArray;/**< 评论的数组,TaskCommentMessageViewModel */

@property (nonatomic,strong) TaskCommentInputView *footerView;/**< <#属性#> */

//@property (nonatomic,strong) NSArray *fatherParticipantArray;/**<  */
//@property (nonatomic,strong) NSArray *sonParticipantArray;/**<  */
@end

@implementation TaskDetailInfoViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"任务详情";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToolBarHeightNotification:) name:ChangeToolBarHeightNotification object:nil];
    
//    [self setupNav];
    
}

//监听发送工具条高度改变回调
- (void)changeToolBarHeightNotification:(NSNotification *)notice{
    
    CGFloat offHeight = [notice.userInfo[@"offHeight"] integerValue];
    
//    self.footerView.height += offHeight;
//    
//    self.footerView.y -= offHeight;
    
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(@(self.footerView.y - offHeight));
        make.height.equalTo(@(self.footerView.height + offHeight));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    SMLog(@"self.schedule  %@  self.schedule.userId  %@  userId  %@",self.schedule,self.schedule.userId,userId);
    
    if ([userId isEqualToString:self.schedule.userId]) {
        UIButton *rightBtn = [[UIButton alloc] init];
        //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjialianxirrenRed"] forState:UIControlStateNormal];
        //    rightBtn.width = 22;
        //    rightBtn.height = 22;
        //    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"bianji_red"] forState:UIControlStateNormal];
        [rightBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
        [rightBtn sizeToFit];
        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }

}


-(void)rightItemClick{
    //TODO: 编辑
    // self.taskID
    
    
    SMCreatTaskController *vc = [[SMCreatTaskController alloc] init];
    vc.fatherId = self.taskID;
    vc.delegate = self;
    vc.isBeingUpdating = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyBoardChange:(NSNotification *)noti{
    SMLog(@"%@,\n%f",noti.userInfo,KScreenHeight);
    MJWeakSelf
    CGRect keyboardEndFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat h = self.footerView.height;//40*SMMatchWidth;

    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(@(keyboardEndFrame.origin.y-h-64));
        make.height.equalTo(@(h));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.footerView.mas_top);
        //make.edges.equalTo(weakSelf.view);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}



-(void)requestData{
    MJWeakSelf
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    [[SKAPI shared] queryMission:self.taskID block:^(id result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (!error) {
            [MBProgressHUD showSuccess:@"加载完成！"];
            SMLog(@"result 66666666 = %@",result);
            [SMFatherTask mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"users" : [NSString class]
                         };
            }];
            SMFatherTask *fatherTask = [SMFatherTask mj_objectWithKeyValues:[result valueForKey:@"schedule"]];
            NSArray *fatherArray = [SMParticipant mj_objectArrayWithKeyValuesArray:[result valueForKey:@"usersList"]];
            TaskDetailMainViewFrame *fatherTaskViewFrame = [[TaskDetailMainViewFrame alloc] init];
//            fatherTaskViewFrame.cellData = fatherTask;
//            fatherTaskViewFrame.userArray = fatherArray;
            [fatherTaskViewFrame setFrameWithTask:fatherTask withArray:fatherArray];
            [ChildScheduleModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"childUser" : [SMParticipant class]
                         };
            }];
            [SMSonTask mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"users" : [NSString class],
                         @"complateStatus" : [NSString class],
                         @"receiveStatus" : [NSString class]
                         };
            }];
            NSArray *sonTaskArray = [ChildScheduleModel mj_objectArrayWithKeyValuesArray:[result valueForKey:@"childScheduleList"]];
            NSMutableArray *tempSonFrameArray = [NSMutableArray array];
            for (int i = 0; i<sonTaskArray.count; i++) {
                SubTaskViewModel *viewModel = [[SubTaskViewModel alloc] init];
//                viewModel.cellData = [sonTaskArray[i] childSchedule];
//                viewModel.userArray = [sonTaskArray[i] childUser];
                ChildScheduleModel *model = sonTaskArray[i];
                [viewModel setFrameWithTask:model.childSchedule withArray:[sonTaskArray[i] childUser]];
                [tempSonFrameArray addObject:viewModel];
            }
            
            fatherTask.sonTaskNumber = sonTaskArray.count;
//            weakSelf.taskArray = @[@[fatherTaskViewFrame],tempSonFrameArray];
            weakSelf.taskFatherArray = @[fatherTaskViewFrame];
            weakSelf.taskSonArray = tempSonFrameArray;
            NSArray *commentArray = [TaskCommentMessage mj_objectArrayWithKeyValuesArray:[result valueForKey:@"ScheduleDetailList"]];
            NSMutableArray *taskCommentMessageViewModelArray = [NSMutableArray array];
            for (TaskCommentMessage *message in commentArray) {
                TaskCommentMessageViewModel *messageFrame = [[TaskCommentMessageViewModel alloc] init];
                messageFrame.cellData = message;
                [taskCommentMessageViewModelArray addObject:messageFrame];
            }
            //评论列表
            weakSelf.postArray = taskCommentMessageViewModelArray;
            
            NSArray *receiveArray = [SMParticipant mj_objectArrayWithKeyValuesArray:[result valueForKey:@"receiveUserList"]];
//            weakSelf.receiveArray = receiveArray;
            AcceptViewModel *acceptViewModel = [[AcceptViewModel alloc] init];
            acceptViewModel.acceptArray = receiveArray;
            //接收人列表
            weakSelf.receiveArray = @[acceptViewModel];
            
//            switch (weakSelf.selectButtonType) {
//                case 0:
//                {
//                    if (_receiveArray == nil) {
//                        weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray];
//                    }else{
//                        weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray,_receiveArray];
//                    }
//                    
//                    [weakSelf.tableView reloadData];
//                }
//                    break;
//                case 1:
//                {
//                    if (_postArray == nil) {
//                        weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray];
//                    }else{
//                        weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray,_postArray];
//                    }
//                    [weakSelf.tableView reloadData];
//                }
//                    break;
//                default:
//                    break;
//            }
            
            
            if (_receiveArray != nil && _postArray == nil) {
                weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray,_receiveArray];
            }else if (_receiveArray == nil && _postArray != nil){
                weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray,_postArray];
            }else if (_receiveArray != nil && _postArray != nil){
                weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray,_receiveArray,_postArray];
            }else{
                 weakSelf.dataArray = @[@[fatherTaskViewFrame],tempSonFrameArray];
            }
            
            [weakSelf.tableView reloadData];
            
        }else{
            [MBProgressHUD showError:@"加载失败，请重试"];
        }
    }];
}

-(void)setTaskID:(NSString *)taskID{
    _taskID = [taskID copy];
    [self requestData];
}

-(void)selectButtonNumber:(int)number{
    switch (number) {
        case 0:
        {
            self.dataArray = @[self.taskFatherArray,self.taskSonArray,self.receiveArray];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.dataArray = @[self.taskFatherArray,self.taskSonArray,self.postArray];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0://主任务
        {
            MainTaskCell *cell = [MainTaskCell cellWithTableView:tableView];
            cell.delegate = self;
            TaskDetailMainViewFrame *frame = self.dataArray[indexPath.section][0];
            [cell setCellData:frame WithParticipantArray:frame.userArray];
            return cell;
        }
            break;
        case 1://子任务
        {
            SubTaskCell *cell = [SubTaskCell cellWithTableView:tableView];
            cell.index = indexPath;
            cell.delegate = self;
            SubTaskViewModel *frame = self.dataArray[indexPath.section][indexPath.row];
            [cell setCellData:frame WithParticipantArray:frame.userArray];
            return cell;
        }
            break;
//        case 2:
//        {
////            switch (self.selectButtonType) {
////                case 0:
////                {
////                    AcceptViewCell *cell = [AcceptViewCell cellWithTableView:tableView];
////                    cell.cellData = self.receiveArray[indexPath.row];
////                    return cell;
////                }
////                    break;
////                case 1:
////                {
////                    TaskCommentCell *cell = [TaskCommentCell cellWithTableView:tableView];
////                    cell.rightUtilityButtons = [self rightButtons];
////                    cell.delegate = self;
////                    cell.cellData = self.postArray[indexPath.row];
////                    return cell;
////                }
////                    break;
////                default:
////                    return nil;
////                    break;
////            }
//
//        }
//            break;
        case 2://接收人
        {

            AcceptViewCell *cell = [AcceptViewCell cellWithTableView:tableView];
            cell.cellData = self.receiveArray[indexPath.row];
            return cell;
  
        }
            break;
        case 3://评论列表
        {

            TaskCommentCell *cell = [TaskCommentCell cellWithTableView:tableView];
            cell.rightUtilityButtons = [self rightButtons];
            cell.delegate = self;
            cell.cellData = self.postArray[indexPath.row];
            return cell;

        }
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            TaskDetailMainViewFrame *frame = self.dataArray[indexPath.section][0];
            return frame.cellHeight;
        }
            break;
        case 1:
        {
            SubTaskViewModel *frame = self.dataArray[indexPath.section][indexPath.item];
            return frame.cellHeight;
        }
            break;
//        case 2:
//        {
////            switch (self.selectButtonType) {
////                case 0:
////                {
////                    AcceptViewModel *acceptViewModel = self.receiveArray[indexPath.row];
////                    return acceptViewModel.cellHeight;
////                }
////                    break;
////                case 1:
////                {
////                    TaskCommentMessageViewModel *viewModel = self.postArray[indexPath.row];
////                    return viewModel.cellHeight;
////                }
////                    break;
////                default:
////                    return 0;
////                    break;
////            }
//            
//        }
        case 2:
        {

            AcceptViewModel *acceptViewModel = self.receiveArray[indexPath.row];
            return acceptViewModel.cellHeight;
  
        }
        case 3:
        {

            TaskCommentMessageViewModel *viewModel = self.postArray[indexPath.row];
            return viewModel.cellHeight;

        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 0.1;
            break;
        case 2:
            return 30*SMMatchWidth;
        case 3:
            return 0.1;
        default:
            return 0.1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:@"Delete"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:KRedColorLight title:@"删除"];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            TaskCommentCell *taskCell = (TaskCommentCell *)cell;
            TaskDetailMainViewFrame *fatherFrame = self.taskFatherArray[0];
            NSString *taskID = fatherFrame.cellData.id;
//            NSInteger type = fatherFrame.cellData.status;
            NSString *commentID = taskCell.cellData.cellData.id;
            MJWeakSelf
            [[SKAPI shared] deleteMissionComment:taskID andCommentId:commentID block:^(id result, NSError *error) {
                if (!error) {
                    [weakSelf requestData];
                }else{
                    
                }
            }];
        }
            break;
            
        default:
            break;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        TaskInfoSelectView *view = [[TaskInfoSelectView alloc] init];
//        [view setSelectNumber:self.selectButtonType];
//        view.selectTag = self.selectButtonType;
        AcceptViewModel *acceptViewModel = self.receiveArray[0];
        view.recevieNumber = acceptViewModel.acceptArray.count;
        view.commentNumber = self.postArray.count;
        view.delegate = self;
        return view;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 3) {
//        [MBProgressHUD  showSuccess:@"左划可以删除评论数据!"];
//    }
    [self.view endEditing:YES];
}

#pragma mark - SMCreatTaskControllerDelegate
-(void)editTaskSuccess{
    [self requestData];
}

#pragma mark - MainTaskCellDelegate
//点击任务状态按钮
-(void)statusButtonClickWithStatus:(int)status{
    
    switch (status) {//点击发布
        case 0:
        {
            TaskDetailMainViewFrame *frame = self.taskFatherArray[0];
            NSDate *data1 = [NSDate dateWithTimeIntervalSince1970:[frame.cellData.schTime integerValue]];
            NSDate *data2 = [NSDate dateWithTimeIntervalSinceNow:0];
            if ([data1 timeIntervalSinceDate:data2] < 0.0) {
                [MBProgressHUD showError:@"任务已经截至"];
                return;
            }
            MJWeakSelf
            [[SKAPI shared] publishMission:self.taskID block:^(id result, NSError *error) {
                if (!error) {
                    [weakSelf requestData];
                }else{
                }
            }];
        }
            break;
        case 1:  //点击完成任务 修改至 已完成状态
        {
            MJWeakSelf
            [[SKAPI shared] accomplishMission:self.taskID block:^(id result, NSError *error) {
                if (!error) {
                    [weakSelf requestData];
                    self.block();
                }else{
//                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
                }
            }];
        }
            break;
        default:
            break;
    }
}

-(void)mainTaskCellclickNameWithUserID:(NSString *)userId{
    SMLog(@"userID = %@",userId);
    //SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:NSStringFromClass([SMPersonInfoViewController class]) bundle:nil];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    User *user = [[User alloc] init];
    user.userid = userId;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SubTaskCellDelegate
//点击子任务的完成任务按钮
-(void)statusButtonClickWithStatus:(int)status withSonTaskID:(NSString *)taskId{
    SMLog(@"status = %d taskId = %@",status,taskId);
    MJWeakSelf
    [[SKAPI shared] accomplishMission:taskId block:^(id result, NSError *error) {
        NSLog(@"accomplishMission = %@  error = %@",result,error);
        if (!error) {
            [weakSelf requestData];
            //刷新上一个控制器数据
            self.block();
        }else{
//                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}
//点击名字
-(void)clickNameWithUserID:(NSString *)userID{
    SMLog(@"userID = %@",userID);
    //SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:NSStringFromClass([SMPersonInfoViewController class]) bundle:nil];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    User *user = [[User alloc] init];
    user.userid = userID;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - TaskInfoSelectViewDelegate
-(void)taskInfoMessageSelectWithNumber:(int)number{
    
    switch (number) {
        case 0://点击接收
        {
//            self.selectButtonType = 0;
//            self.dataArray = @[self.taskFatherArray,self.taskSonArray,self.receiveArray];
//            [self.tableView reloadData];
            MJWeakSelf
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view);
            }];
            self.footerView.hidden = YES;
        }
            break;
        case 1://点击评论
        {
//            self.selectButtonType = 1;
//            self.dataArray = @[self.taskFatherArray,self.taskSonArray,self.postArray];
//            [self.tableView reloadData];
            
            
            MJWeakSelf
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.view);
                make.right.equalTo(weakSelf.view);
                make.top.equalTo(weakSelf.view);
                make.bottom.equalTo(weakSelf.footerView.mas_top);
            }];
//            [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(weakSelf.view);
//                make.right.equalTo(weakSelf.view);
//                make.top.equalTo(weakSelf.tableView.mas_bottom);
//                make.bottom.equalTo(weakSelf.view);
//            }];
            self.footerView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - TaskCommentInputViewDelegate
-(void)postCommentWithStr:(NSString *)str{
    //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    TaskDetailMainViewFrame *fatherFrame = self.taskFatherArray[0];
    NSString *taskID = fatherFrame.cellData.id;
    NSInteger type = fatherFrame.cellData.status;
    MJWeakSelf
    [[SKAPI shared] addMissionComment:taskID andContent:str andType:type block:^(id result, NSError *error) {
        NSLog(@"result = %@ error = %@",result,error);
        if(!error){

            CGFloat offY = self.footerView.textField.height - minHeight;
            self.footerView.textField.height -= offY;
            //self.footerView.button.bottom = self.footerView.textField.bottom;
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeToolBarHeightNotification object:nil userInfo:@{@"offHeight":@(-offY)}];
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.view layoutIfNeeded];
//            }];
            self.footerView.textField.text = nil;
            self.footerView.placeHolderLabel.hidden = NO;
            [self.view endEditing:YES];
            [weakSelf requestData];
        
        }else{
            
        }
    }];
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        
//        UIView *whiteView = [[UIView alloc] init];
//        whiteView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJWeakSelf
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.view);
//        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.footerView.mas_top);
        }];
        self.footerView.hidden = NO;
    }
    return _tableView;
}

-(TaskCommentInputView *)footerView{
    if (_footerView == nil) {
        _footerView = [[TaskCommentInputView alloc] init];
        _footerView.delegate = self;
        [self.view addSubview:_footerView];
        MJWeakSelf
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
            make.height.equalTo(@(44.5));
        }];
    }
    return _footerView;
}

@end
