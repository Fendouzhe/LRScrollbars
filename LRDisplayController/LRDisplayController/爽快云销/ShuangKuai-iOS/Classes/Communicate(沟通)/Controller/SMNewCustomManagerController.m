//
//  SMNewCustomManagerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewCustomManagerController.h"
#import "SMNewCustomerManagerCell.h"
#import "SMStateAndLevelCell.h"
#import "SMNewCustomerViewController.h"
#import "SMCustomerDetailViewController.h"

@interface SMNewCustomManagerController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SMCustomerDetailViewControllerDelegate,SMNewCustomerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UIButton *levelBtn;

@property (weak, nonatomic) IBOutlet UIView *leftRedLine;

@property (weak, nonatomic) IBOutlet UIView *midRedLine;

@property (weak, nonatomic) IBOutlet UIView *rightRedLine;

@property (weak, nonatomic) IBOutlet UITextField *searchField;


//点击搜索出来的tableview
@property (weak, nonatomic) IBOutlet UITableView *tableViewChoose;
//显示全部数据的tableview
@property (weak, nonatomic) IBOutlet UITableView *tableViewNormal;

@property (nonatomic ,strong)NSMutableArray *arrNormal;

@property (nonatomic ,strong)NSArray *arrStateMenu;

@property (nonatomic ,strong)NSArray *arrLevelMenu;

@property (nonatomic ,strong)MBProgressHUD *HUD;

@end

@implementation SMNewCustomManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self topBtnClick:self.allBtn];
    
    [self setup];
    
    
}

- (void)setup{
    SMShowPrompt(@"正在玩命加载数据...");
    self.HUD = HUD;
    
    self.arrStateMenu = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    self.arrLevelMenu = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
}

- (void)setupNav{
    self.title = @"客户管理";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"创建" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    rightBtn.width = 50;
//    rightBtn.height = 30;
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick{
    SMLog(@"点击了 创建");
    SMNewCustomerViewController *vc = [SMNewCustomerViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMNewCustomerViewControllerDelegate
- (void)refreshData{
    [self topBtnClick:self.allBtn];
}

- (IBAction)allBtnClick:(id)sender {
    [self topBtnClick:sender];
}

- (IBAction)stateBtnClick:(id)sender {
    [self topBtnClick:sender];
}

- (IBAction)levelBtnClick:(id)sender {
    [self topBtnClick:sender];
}

- (void)topBtnClick:(UIButton *)sender{
    self.allBtn.selected = NO;
    self.stateBtn.selected = NO;
    self.levelBtn.selected = NO;
    sender.selected = YES;
    self.leftRedLine.hidden = !self.allBtn.selected;
    self.midRedLine.hidden = !self.stateBtn.selected;
    self.rightRedLine.hidden = !self.levelBtn.selected;
    if (sender.tag == 0) {
        self.tableViewNormal.hidden = NO;
        self.tableViewChoose.hidden = YES;
    }else{
        self.tableViewNormal.hidden = YES;
        self.tableViewChoose.hidden = NO;
    }
    
    [self getDataWithBtnClickTag:sender.tag];
}

- (void)getDataWithBtnClickTag:(NSInteger)tag{
//    if (tag == 0) {  //展示普通tableView
//        [[SKAPI shared] queryCustomer:@"" andGrade:-1 andStatus:-1 andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//            if (!error) {
//                self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
//                SMLog(@"self.arrNormal   %@",self.arrNormal);
//                [self.tableViewNormal reloadData];
//                [self.HUD hide:YES];
//            }else{
//                SMLog(@"error  %@",error);
//            }
//        }];
//    }else{
//        [self.tableViewChoose reloadData];
//    }
    if (tag == 0) { //展示普通tableView
        [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:10 andType:-1 block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  queryCustomer  %@",result);
                self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
                SMLog(@"self.arrNormal   %@",self.arrNormal);
                [self.tableViewNormal reloadData];
                [self.HUD hide:YES];
            }else{
                SMLog(@"error   %@",error);
            }
        }];
    }else{
        [self.tableViewChoose reloadData];
    }
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewNormal) {
        return self.arrNormal.count;
    }else if (tableView == self.tableViewChoose && self.stateBtn.selected){
        return self.arrStateMenu.count;
    }else if (tableView == self.tableViewChoose && self.levelBtn.selected){
        return self.arrLevelMenu.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewNormal) {
        SMNewCustomerManagerCell *cell = [SMNewCustomerManagerCell cellWithTableView:tableView];
        cell.cus = self.arrNormal[indexPath.row];
        return cell;
    }else{
        SMStateAndLevelCell *cell = [SMStateAndLevelCell cellWithTableView:tableView];
        if (self.stateBtn.selected) {
            cell.stateOrLevel = self.arrStateMenu[indexPath.row];
        }else if (self.levelBtn.selected){
            cell.stateOrLevel = self.arrLevelMenu[indexPath.row];
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewNormal) {
        return 75;
    }else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewNormal) {
        SMCustomerDetailViewController *vc = [SMCustomerDetailViewController new];
        vc.delegate = self;
        vc.cus = self.arrNormal[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == self.tableViewChoose){
        
        if (self.stateBtn.selected) {
            [self searchDataWithState:indexPath.row andLebel:-1];
        }else if (self.levelBtn.selected){
            [self searchDataWithState:-1 andLebel:indexPath.row];
        }
        self.tableViewChoose.hidden = YES;
        self.tableViewNormal.hidden = NO;
    }
}

- (void)searchDataWithState:(NSInteger)state andLebel:(NSInteger)level{
    SMLog(@"state   %zd   level  %zd",state,level);
//    [[SKAPI shared] queryCustomer:@"" andGrade:level andStatus:state andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//        if (!error) {
//            self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
//            SMLog(@"self.arrNormal   %@",self.arrNormal);
//            [self.tableViewNormal reloadData];
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
    
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:level andTarget:@"" andLastTimeStamp:-1 andOffset:10 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
            SMLog(@"self.arrNormal   %@",self.arrNormal);
            [self.tableViewNormal reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

//删除功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableViewNormal) {
            Customer *cus = self.arrNormal[indexPath.row];
            SMLog(@"cus.id  %@",cus.id);
            [[SKAPI shared] deleteCustomer:cus.id block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"result  %@",result);
                    [self.arrNormal removeObjectAtIndex:indexPath.row];
                    [self.tableViewNormal reloadData];
                }else{
                    SMLog(@"error   %@",error);
                }
            }];
        }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if ([string isEqualToString:@"\n"]) {
//        [[SKAPI shared] queryCustomer:self.searchField.text andGrade:-1 andStatus:-1 andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//            if (!error) {
//                self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
//                SMLog(@"self.arrNormal   %@",self.arrNormal);
//                [self.tableViewNormal reloadData];
//            }else{
//                SMLog(@"error  %@",error);
//            }
//        }];
//    }
    
    if ([string isEqualToString:@"\n"]) {
        [[SKAPI shared] queryCustomer:self.searchField.text andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-2 andOffset:10 andType:-1 block:^(id result, NSError *error) {
            if (!error) {
                self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
                SMLog(@"self.arrNormal   %@",self.arrNormal);
                [self.tableViewNormal reloadData];
            }else{
                SMLog(@"error  %@",error);
            }
        }];
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- SMCustomerDetailViewControllerDelegate
- (void)refreshTableView{
//    [[SKAPI shared] queryCustomer:@"" andGrade:-1 andStatus:-1 andLastTimeStamp:-1 andOffset:50 block:^(id result, NSError *error) {
//        if (!error) {
//            self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
//            for (Customer *cus in self.arrNormal) {
//                SMLog(@"cus.status   %zd",cus.status);
//            }
//            SMLog(@"self.arrNormal   %zd",self.arrNormal);
//            [self.tableViewNormal reloadData];
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
    
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:10 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            self.arrNormal = [Customer mj_objectArrayWithKeyValuesArray:[result valueForKey:@"result"]];
            for (Customer *cus in self.arrNormal) {
                SMLog(@"cus.status   %zd",cus.status);
            }
            SMLog(@"self.arrNormal   %zd",self.arrNormal);
            [self.tableViewNormal reloadData];
            
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *)arrNormal{
    if (_arrNormal == nil) {
        _arrNormal = [NSMutableArray array];
    }
    return _arrNormal;
}

@end
