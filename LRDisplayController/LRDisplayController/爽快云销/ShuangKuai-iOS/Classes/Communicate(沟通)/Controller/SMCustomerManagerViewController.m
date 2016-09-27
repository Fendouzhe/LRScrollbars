//
//  SMCustomerManagerViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/18.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerManagerViewController.h"
#import "SMCustomerTableViewCell.h"
#import "SMChooseStateTableViewCell.h"
#import "SMNewCustomerViewController.h"
#import "SMCustomerDetailViewController.h"
#import "LocalCustomer+CoreDataProperties.h"
#import "AppDelegate.h"


@interface SMCustomerManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *upView;

@property (weak, nonatomic) IBOutlet UIView *downView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UIButton *customerStateBtn;

@property (weak, nonatomic) IBOutlet UIButton *customerLevelBtn;

@property (weak, nonatomic) IBOutlet UIView *customerStateUnderLine;

@property (weak, nonatomic) IBOutlet UIView *allUnderLine;

@property (weak, nonatomic) IBOutlet UIView *customerLevelLine;

/**
 *  全部 按钮下的tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

/**
 *  客户状态下的tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *stateTableView;
/**
 *  选择客户状态时的tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *chooseStateTableView;

//搜索出来的数据
@property(nonatomic,copy)NSMutableArray * searchArray;

//正常显示的数据
@property(nonatomic,copy)NSMutableArray * datasArray;

@property(nonatomic,assign)BOOL isSearch;

@property(nonatomic,copy)NSArray * stateArray;
@property(nonatomic,copy)NSArray * levelArray;

@property(nonatomic,assign)BOOL isStateSearch;
@property(nonatomic,assign)BOOL isLevelSearch;

@property (nonatomic ,strong)NSArray *arrAll;

@end

@implementation SMCustomerManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setup];
    
    [self setUpTableView];
    
    [self getData];
    
    [self observeSearchField];
}

- (void)getData{
//    [[SKAPI shared] queryCustomer:@"" andGrade:-1 andStatus:-1 andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result queryCustomer  %@",[result valueForKey:@"result"]);
//            NSArray *arrDatas = [result valueForKey:@"result"];
//            self.arrAll = [Customer mj_objectArrayWithKeyValuesArray:arrDatas];
//            
//        }else{
//            SMLog(@"error   %@",error);
//        }
//    }];
    
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:10 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result queryCustomer  %@",[result valueForKey:@"result"]);
            NSArray *arrDatas = [result valueForKey:@"result"];
            self.arrAll = [Customer mj_objectArrayWithKeyValuesArray:arrDatas];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)setUpTableView{
    self.stateTableView.hidden = YES;
    self.chooseStateTableView.hidden = YES;
    
//    self.stateTableView.backgroundColor = [UIColor yellowColor];
//    self.allTableView.backgroundColor = [UIColor greenColor];
//    self.chooseStateTableView.backgroundColor = [UIColor redColor];
}
- (void)setupNav{
    self.title = @"客户管理";
    
    //加号
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = KDefaultFontBig;
    [rightBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    rightBtn.width = 44;
    rightBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setup{
    self.upView.backgroundColor = KControllerBackGroundColor;
    self.downView.backgroundColor = KControllerBackGroundColor;
    
    //几个按钮及下面横线的文字颜色
    [self.allBtn setTitleColor:KRedColor forState:UIControlStateSelected];
    [self.customerStateBtn setTitleColor:KRedColor forState:UIControlStateSelected];
    [self.customerLevelBtn setTitleColor:KRedColor forState:UIControlStateSelected];
    
    self.allUnderLine.backgroundColor = KRedColor;
    self.customerStateUnderLine.backgroundColor = KRedColor;
    self.customerLevelLine.backgroundColor = KRedColor;
    
    self.allBtn.selected = YES;
    self.customerStateUnderLine.hidden = YES;
    self.customerLevelLine.hidden = YES;
    

    
    // 放大镜
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"放大镜"];
    searchIcon.width = 28;
    searchIcon.height = 28;
    searchIcon.contentMode = UIViewContentModeCenter;
    self.searchField.leftView = searchIcon;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
//    self.searchField.keyboardType = UIKeyboardTypeWebSearch;
    self.searchField.delegate = self;
    
}

#pragma mark -- 点击事件
- (void)rightItemDidClick{
    SMLog(@"点击了 加号 按钮");
    SMNewCustomerViewController *newVc = [[SMNewCustomerViewController alloc] init];
    [self.navigationController pushViewController:newVc animated:YES];
}

- (IBAction)allBtnClick:(UIButton *)sender {
    SMLog(@"点击了 全部 按钮");
    [self topBtnsClick:sender];
}

- (IBAction)customerStateBtnClick:(UIButton *)sender {
    SMLog(@"点击了 客户状态 按钮");
    [self topBtnsClick:sender];
}

- (IBAction)customerLevelBtnClick:(UIButton *)sender {
    SMLog(@"点击了 客户分级 按钮");
    [self topBtnsClick:sender];
}

- (void)topBtnsClick:(UIButton *)btn{
//    if (btn.tag == 1 && btn.selected == YES) {
//        self.chooseStateTableView.hidden = NO;
//        self.stateTableView.hidden = YES;
//        self.allTableView.hidden = YES;
//        return;
//    }
    
    self.allBtn.selected = NO;
    self.customerStateBtn.selected = NO;
    self.customerLevelBtn.selected = NO;
    btn.selected = YES;
    
    self.allUnderLine.hidden = !self.allBtn.selected;
    self.customerStateUnderLine.hidden = !self.customerStateBtn.selected;
    self.customerLevelLine.hidden = !self.customerLevelBtn.selected;
    
    if (btn.tag == 1){
        self.chooseStateTableView.hidden = YES;
        self.stateTableView.hidden = NO;
        self.allTableView.hidden = YES;
        
        self.isStateSearch = NO;
        [self.stateTableView reloadData];
        self.isLevelSearch = NO;
        [self.chooseStateTableView reloadData];
        
    }else if (btn.tag == 0){
        self.chooseStateTableView.hidden = YES;
        self.stateTableView.hidden = YES;
        self.allTableView.hidden = NO;
        self.isLevelSearch = NO;
        self.isStateSearch = NO;
        [self.chooseStateTableView reloadData];
        [self.stateTableView reloadData];
    }else if(btn.tag == 2)
    {
        self.chooseStateTableView.hidden = NO;
        self.stateTableView.hidden = YES;
        self.allTableView.hidden = YES;
        self.isLevelSearch = NO;
        [self.chooseStateTableView reloadData];
        self.isStateSearch = NO;
        [self.stateTableView reloadData];
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 10;
    
//    if (tableView == self.stateTableView&&self.isStateSearch) {
//        return self.searchArray.count;
//    }else
//    {
//        if (tableView == self.stateTableView) {
//            return self.stateArray.count;
//        }
//        
//        if (tableView == self.allTableView) {
//            if (self.isSearch) {
//                return self.searchArray.count;
//            }else
//            {
//                return self.datasArray.count;
//            }
//        }
//        
//        if (tableView == self.chooseStateTableView&&self.isLevelSearch) {
//            return self.searchArray.count;
//        }else
//        {
//            return self.levelArray.count;
//        }
//    }
    if (tableView == self.allTableView) {
        return self.arrAll.count;
    }else if (tableView == self.stateTableView){
        
    }else if (tableView == self.chooseStateTableView){
        
    }
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (tableView == self.allTableView) {
//        SMCustomerTableViewCell* cell = [SMCustomerTableViewCell cellWithTableView:tableView];
//        if (self.isSearch) {
//            [cell refreshUI:self.searchArray[indexPath.row]];
//        }else
//        {   if(self.datasArray.count>indexPath.row)
//           {
//               [cell refreshUI:[self.datasArray objectAtIndex:[self.datasArray count]-1-indexPath.row]];
//           }
//        }
//        return cell;
        
        SMCustomerTableViewCell* cell = [SMCustomerTableViewCell cellWithTableView:tableView];
        if (self.isSearch) {
            [cell refreshUI:self.arrAll[indexPath.row]];
        }else{
            if(self.datasArray.count>indexPath.row){
            [cell refreshUI:[self.datasArray objectAtIndex:[self.datasArray count]-1-indexPath.row]];
            }
        }
        return cell;
        
    }else if (tableView == self.stateTableView){
        if (!self.isStateSearch) {
            SMChooseStateTableViewCell* cell = [SMChooseStateTableViewCell cellWithTableView:tableView];
            cell.stateLable.text = self.stateArray[indexPath.row];
            return cell;
        }else
        {
             SMCustomerTableViewCell* cell = [SMCustomerTableViewCell cellWithTableView:tableView];
            if (self.searchArray.count>indexPath.row) {
                [cell refreshUI:self.searchArray[indexPath.row]];
            }
            
            return cell;
        }
        
        
    }else if (tableView == self.chooseStateTableView){
        if (!self.isLevelSearch) {
            SMChooseStateTableViewCell* cell = [SMChooseStateTableViewCell cellWithTableView:tableView];
            cell.stateLable.text = self.levelArray[indexPath.row];
            return cell;
        }else
        {
            SMCustomerTableViewCell* cell = [SMCustomerTableViewCell cellWithTableView:tableView];
            if (self.searchArray.count>indexPath.row) {
                [cell refreshUI:self.searchArray[indexPath.row]];
            }
            return cell;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView == self.allTableView || (tableView == self.stateTableView&&self.isStateSearch)||(tableView== self.chooseStateTableView&&self.isLevelSearch)) {
//        SMCustomerDetailViewController *customerDetailVc = [[SMCustomerDetailViewController alloc] init];
//        if ((tableView == self.stateTableView&&self.isStateSearch)||(tableView== self.chooseStateTableView&&self.isLevelSearch)||self.isSearch) {
//            customerDetailVc.localCustomer = self.searchArray[indexPath.row];
//        }else
//        {
//            customerDetailVc.localCustomer = self.datasArray[self.datasArray.count-1-indexPath.row];
//        }
//        [self.navigationController pushViewController:customerDetailVc animated:YES];
//    }
//    
//    if (tableView == self.stateTableView) {
////        self.isStateSearch = YES;
////        [self.searchArray removeAllObjects];
////        NSArray * array = [LocalCustomer MR_findByAttribute:@"status" withValue:[NSString stringWithFormat:@"%ld",indexPath.row]];
////        for (LocalCustomer* local in array) {
////            [self.searchArray addObject:local];
////        }
////        [self.stateTableView reloadData];
//        
//        self.isStateSearch = YES;
//        [[SKAPI shared] queryCustomer:@"" andGrade:-1 andStatus:indexPath.row andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//            if (!error) {
//                SMLog(@"result  queryCustomer   %@",result);
//            }else{
//                SMLog(@"error   %@",error);
//            }
//        }];
//
//    }
//    
//    if (tableView == self.chooseStateTableView) {
////        self.isLevelSearch = YES;
////        NSArray * arr = [LocalCustomer MR_findAll];
////        [self.searchArray removeAllObjects];
////        for (LocalCustomer * localCustomer in arr) {
////            if ([localCustomer.level isEqualToNumber:[NSNumber numberWithInteger:indexPath.row]]) {
////                [self.searchArray addObject:localCustomer];
////            }
////        }
////        [self.chooseStateTableView reloadData];
//
//        
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView == self.allTableView || (tableView == self.stateTableView&&self.isStateSearch)||(tableView== self.chooseStateTableView&&self.isLevelSearch)) {
        CGFloat height;
        if (isIPhone5) {
            height = 65;
        }else if (isIPhone6){
            height = 65 *KMatch6;
        }else if (isIPhone6p){
            height = 65 *KMatch6p;
        }
        return height;
    }
    return 44;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchField resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.searchField resignFirstResponder];
        SMLog(@"%@",self.searchField.text);
        
    }
    return YES;
}

-(void)observeSearchField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldchange) name:UITextFieldTextDidChangeNotification object:self.searchField];
}
-(void)searchFieldchange
{
    SMLog(@"正在搜索%@",self.searchField.text);
    self.isSearch = YES;
    [self.searchArray removeAllObjects];
    NSArray * array = [LocalCustomer MR_findAll];
    for (LocalCustomer * localCustomer in array) {
        if ([localCustomer.fullname rangeOfString:self.searchField.text].location!=NSNotFound||[localCustomer.name rangeOfString:self.searchField.text].location!=NSNotFound) {
            [self.searchArray addObject:localCustomer];
        }
    }
    [self.allTableView reloadData];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.searchField.text isEqualToString:@""]|| self.searchArray.count==0) {
        self.isSearch = NO;
        [self.allTableView reloadData];
    }
    
}
-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.isLevelSearch = NO;
        self.isStateSearch = NO;
        [self loaddatasArray];
       // [self.allTableView reloadData];
        [self.stateTableView reloadData];
        [self.chooseStateTableView reloadData];
    });
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

-(NSArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    }
    return _stateArray;
}
-(NSArray *)levelArray
{
    if (!_levelArray) {
        _levelArray = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
    }
    return _levelArray;
}

//删除功能 有瑕疵
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if(tableView == self.allTableView){
            LocalCustomer * localCustomer = self.datasArray[self.datasArray.count-1-indexPath.row];
            NSArray* arr = [LocalCustomer MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
            for (LocalCustomer * customer  in arr) {
                if ([customer.id isEqualToString:localCustomer.id]) {
                    [customer MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
            
        } 
        if (tableView==self.stateTableView) {
            LocalCustomer * localCustomer = self.searchArray[self.searchArray.count-1-indexPath.row];
            NSArray* arr = [LocalCustomer MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
            for (LocalCustomer * customer  in arr) {
                if ([customer.id isEqualToString:localCustomer.id]) {
                    [customer MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
        }else if (tableView == self.chooseStateTableView)
        {
            LocalCustomer * localCustomer = self.searchArray[self.searchArray.count-1-indexPath.row];
            NSArray* arr = [LocalCustomer MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
            for (LocalCustomer * customer  in arr) {
                if ([customer.id isEqualToString:localCustomer.id]) {
                    [customer MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
        }
        [self.datasArray removeObjectAtIndex:self.datasArray.count-1-indexPath.row];
        if (self.isStateSearch||self.isLevelSearch) {
          [self.searchArray removeObjectAtIndex:self.searchArray.count-1-indexPath.row];
        }
        [self.allTableView reloadData];
        [self.stateTableView reloadData];
        [self.chooseStateTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.allTableView || (tableView == self.stateTableView&&self.isStateSearch)||(tableView== self.chooseStateTableView&&self.isLevelSearch))
    {
        return YES;
    }
    return NO;
}
-(void)loaddatasArray
{
    [self.datasArray removeAllObjects];
    NSArray * array = [LocalCustomer MR_findAll];
    for (LocalCustomer * customer in array) {
        [self.datasArray addObject:customer];
    }
    [self.allTableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchField];
}
@end
