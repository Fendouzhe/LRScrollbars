//
//  CreatNewCustomerViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CreatNewCustomerViewController.h"
#import "CreatNewCustomerCell.h"
#import "CreatNewCustomerNormalModel.h"
#import "CreatNewCustomerArrowModel.h"
#import "CreatNewCustomerBaseModel.h"
#import "SelectProductListViewController.h"
#import "IntentionLevelViewController.h"
#import "CustomerLevelViewController.h"
#import "CreatNewCustomerTextField.h"
#import "EditCustomerController.h"

@interface CreatNewCustomerViewController ()<SelectProductListViewControllerDelegate,IntentionLevelViewControllerDelegate,CustomerLevelViewControllerDelegate,EditCustomerControllerDelegate>
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@property (nonatomic,copy) NSString *selectProduct;/**< 选择的商品 */
@property (nonatomic,copy) NSString *intentionLevelStr;/**< 意向等级 */
@property (nonatomic,copy) NSString *customerLevelStr;/**< 客户等级 */
@property (nonatomic,copy) NSString *tagArray;/**< 标签列表,分割符号为, */
@property (nonatomic,strong) UIButton *rightBtn;/**< 右上角的按钮 */
@end

@implementation CreatNewCustomerViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *whiteView = [[UIView alloc] init];
    self.tableView.tableFooterView = whiteView; 
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (self.customer == nil) {
        self.title = @"新建客户";
        MJWeakSelf
        CreatNewCustomerNormalModel *model01 = [[CreatNewCustomerNormalModel alloc] init];
        model01.title = @"客户名称";
        model01.placeText = @"请输入客户名称";
        
        CreatNewCustomerNormalModel *model02 = [[CreatNewCustomerNormalModel alloc] init];
        model02.title = @"客户电话";
        model02.placeText = @"请输入客户电话";
        
        CreatNewCustomerNormalModel *model03 = [[CreatNewCustomerNormalModel alloc] init];
        model03.title = @"客户地址";
        model03.placeText = @"请输入客户地址";
        
        CreatNewCustomerNormalModel *model04 = [[CreatNewCustomerNormalModel alloc] init];
        model04.title = @"客户邮箱";
        model04.placeText = @"请输入客户邮箱";
        
        CreatNewCustomerArrowModel *model05 = [[CreatNewCustomerArrowModel alloc] init];
        model05.title = @"意向商品";
        model05.detailText = @"请选择意向商品";
        model05.option = ^(){
            SelectProductListViewController *vc = [[SelectProductListViewController alloc] init];
            vc.delegate = weakSelf;
            if(weakSelf.selectProduct.length){
                NSArray *tempArray = [weakSelf.selectProduct componentsSeparatedByString:@","];
                vc.oldSelectArray = tempArray;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        CreatNewCustomerArrowModel *model06 = [[CreatNewCustomerArrowModel alloc] init];
        model06.title = @"意向购买等级";
        model06.detailText = @"请选择意向购买等级";
        model06.option = ^(){
            IntentionLevelViewController *vc = [[IntentionLevelViewController alloc] init];
            vc.delegate = self;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        
        CreatNewCustomerArrowModel *model07 = [[CreatNewCustomerArrowModel alloc] init];
        model07.title = @"客户标签";
        model07.detailText = @"请选择客户标签";
        model07.option = ^(){
            EditCustomerController *vc = [[EditCustomerController alloc] init];
            vc.delegate = weakSelf;
            if (weakSelf.tagArray.length) {
                NSArray *tempArray = [weakSelf.tagArray componentsSeparatedByString:@","];
                vc.oldTagArray = tempArray;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        CreatNewCustomerArrowModel *model08 = [[CreatNewCustomerArrowModel alloc] init];
        model08.title = @"客户级别";
        model08.detailText = @"请选择客户级别";
        model08.option = ^(){
            CustomerLevelViewController *vc = [[CustomerLevelViewController alloc] init];
            vc.delegate = self;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        self.dataArray = @[model01,model02,model03,model04,model05,model06,model07,model08];
        [self.tableView reloadData];
    }
    
    if (!self.rightBtn) {
        
//        UIButton *rightBtn = [[UIButton alloc] init];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//        dict[NSForegroundColorAttributeName] = KRedColorLight;
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
//        [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
////        rightBtn.width = 30;
////        rightBtn.height = 22;
//        [rightBtn sizeToFit];
//        rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        rightBtn.backgroundColor = [UIColor yellowColor];
//        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        self.navigationItem.rightBarButtonItem = rightItem;
//        self.rightBtn = rightBtn;
        
        [self createSaveButton];
    }
    
    self.view.backgroundColor = KControllerBackGroundColor;
}
///创建保存按钮
- (void)createSaveButton{
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    //        rightBtn.width = 30;
    //        rightBtn.height = 22;
    [rightBtn sizeToFit];
//    rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    rightBtn.backgroundColor = [UIColor yellowColor];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightBtn = rightBtn;
}

-(void)rightItemClick{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.customer){
        
        NSString *str01 = [self.dataArray[0] detailText];
        
        NSString *str02 = [self.dataArray[1] detailText];
        
        NSString *str03 = [self.dataArray[2] detailText];;
        
        NSString *str04 = [self.dataArray[3] detailText];;
        
        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isMatchPhone = [pred evaluateWithObject:str02];
        
        if(!str01.length){
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }
        
        if (!str02.length) {
            [MBProgressHUD showError:@"请输入手机号"];
        }
        
        if (!isMatchPhone) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            return;
        }
        
        
        Customer *customer = self.customer;
        customer.name = str01;
        customer.phone = str02;
        customer.address = str03;
        customer.email = str04;
        
        customer.purpose = self.selectProduct;
        
        customer.buyRating = [self.intentionLevelStr integerValue];
        customer.level = [self.customerLevelStr integerValue];
        customer.target = self.tagArray;
        MJWeakSelf
        [[SKAPI shared] updateCustomer:customer block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"更新用户成功");
                if ([weakSelf.delegate respondsToSelector:@selector(saveNewCustomerSuccessWithCustomer:)]) {
                    [weakSelf.delegate saveNewCustomerSuccessWithCustomer:customer];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KAllCustomerDidChangeSuccess object:weakSelf];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                SMLog(@"更新用户失败");
                [MBProgressHUD showError:@"更新用户失败"];
            }
        }];
    }else{
        NSString *str01 = [self.dataArray[0] detailText];
        
        NSString *str02 = [self.dataArray[1] detailText];
        
        NSString *str03 = [self.dataArray[2] detailText];;
        
        NSString *str04 = [self.dataArray[3] detailText];;
        
        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isMatchPhone = [pred evaluateWithObject:str02];
        
        if(!str01.length){
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }
        
        if (!str02.length) {
            [MBProgressHUD showError:@"请输入手机号"];
        }
        
        if (!isMatchPhone) {
            [MBProgressHUD showError:@"请输入正确的手机号码"];
            return;
        }
        
        
        
        Customer *customer = [[Customer alloc] init];
        customer.name = str01;
        customer.phone = str02;
        customer.address = str03;
        customer.email = str04;
        customer.purpose = self.selectProduct;
        
        SMLog(@"self.selectProduct %@",self.selectProduct);
        if (self.intentionLevelStr == nil) {
            customer.buyRating = -1;
        }else{
            customer.buyRating = [self.intentionLevelStr integerValue];
        }
        
        SMLog(@"customer.buyRating  %zd  self.intentionLevelStr  %@",customer.buyRating,self.intentionLevelStr);
        if (self.customerLevelStr == nil) {
            customer.level = -1;
        }else{
            customer.level = [self.customerLevelStr integerValue];
        }
        
        
        SMLog(@"customer.level  %zd  self.customerLevelStr  %@",customer.level,self.customerLevelStr);
        customer.target = self.tagArray;
        MJWeakSelf
        
        SMLog(@"customer.name  %@  customer.phone  %@  customer.address  %@  customer.email  %@  customer.purpose  %@",customer.name,customer.phone,customer.address,customer.email,customer.purpose);
        [[SKAPI shared] createCustomer:customer block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"新建用户成功");
//                if ([weakSelf.delegate respondsToSelector:@selector(creatNewCustomerSuccess)]) {
//                    [weakSelf.delegate creatNewCustomerSuccess];
//                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KAllCustomerDidChangeSuccess object:weakSelf];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                SMLog(@"新建用户失败");
                if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"该手机客户已经存在"]) {
                    [MBProgressHUD showError:@"该手机客户已经存在"];
                }else{
                    [MBProgressHUD showError:@"新建客户失败"];
                }
                
                
            }
        }];
    }
    
}

-(void)setCustomer:(Customer *)customer{
    _customer = customer;
    
    
//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
////    rightBtn.width = 30;
////    rightBtn.height = 22;
//    [rightBtn sizeToFit];
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    self.rightBtn = rightBtn;
    
    [self createSaveButton];
    
    self.title = @"编辑客户资料";
    MJWeakSelf
    CreatNewCustomerNormalModel *model01 = [[CreatNewCustomerNormalModel alloc] init];
    model01.title = @"客户名称";
    model01.placeText = @"请输入客户名称";
    model01.detailText = customer.name;
    
    CreatNewCustomerNormalModel *model02 = [[CreatNewCustomerNormalModel alloc] init];
    model02.title = @"客户电话";
    model02.placeText = @"请输入客户电话";
    model02.detailText = customer.phone;
    
    CreatNewCustomerNormalModel *model03 = [[CreatNewCustomerNormalModel alloc] init];
    model03.title = @"客户地址";
    model03.placeText = @"请输入客户地址";
    model03.detailText = customer.address;
    
    CreatNewCustomerNormalModel *model04 = [[CreatNewCustomerNormalModel alloc] init];
    model04.title = @"客户邮箱";
    model04.placeText = @"请输入客户邮箱";
    model04.detailText = customer.email;
    
    CreatNewCustomerArrowModel *model05 = [[CreatNewCustomerArrowModel alloc] init];
    model05.title = @"意向商品";
    
    NSArray *productArray = [customer.purpose componentsSeparatedByString:@","];
    if ([customer.purpose isEqualToString:@""]) {
        model05.detailText = @"请选择意向商品";
    }else{
        model05.detailText = [NSString stringWithFormat:@"%lu个",(unsigned long)productArray.count];
    }
    
    self.selectProduct = customer.purpose;
    model05.option = ^(){
        SelectProductListViewController *vc = [[SelectProductListViewController alloc] init];
        vc.delegate = weakSelf;
        if(weakSelf.selectProduct.length){
            NSArray *tempArray = [weakSelf.selectProduct componentsSeparatedByString:@","];
            vc.oldSelectArray = tempArray;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    CreatNewCustomerArrowModel *model06 = [[CreatNewCustomerArrowModel alloc] init];
    model06.title = @"意向购买等级";
//    model06.detailText = @"请选择意向购买等级";
    self.intentionLevelStr = [NSString stringWithFormat:@"%ld",(long)customer.buyRating];
    switch (customer.buyRating) {
        case 0:
        {
            model06.detailText = @"A";
        }
            break;
        case 1:
        {
            model06.detailText = @"B";
        }
            break;
        case 2:
        {
            model06.detailText = @"C";
        }
            break;
        default:
            model06.detailText = @"请选择意向购买等级";
            break;
    }
    model06.option = ^(){
        IntentionLevelViewController *vc = [[IntentionLevelViewController alloc] init];
        vc.delegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    CreatNewCustomerArrowModel *model07 = [[CreatNewCustomerArrowModel alloc] init];
    model07.title = @"客户标签";
    
    if (customer.target.length) {
        model07.detailText = customer.target;
        self.tagArray = customer.target;
    }else{
        model07.detailText = @"请选择客户标签";
        self.tagArray = @"";
    }
    
    model07.option = ^(){
        EditCustomerController *vc = [[EditCustomerController alloc] init];
        vc.delegate = weakSelf;
        if (weakSelf.tagArray.length) {
            NSArray *tempArray = [weakSelf.tagArray componentsSeparatedByString:@","];
            vc.oldTagArray = tempArray;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    CreatNewCustomerArrowModel *model08 = [[CreatNewCustomerArrowModel alloc] init];
    model08.title = @"客户级别";
//    model08.detailText = @"请选择客户级别";
    self.customerLevelStr = [NSString stringWithFormat:@"%ld",(long)customer.level];
    switch (customer.level) {
        case 0:
        {
            model08.detailText = @"Vip";
        }
            break;
        case 1:
        {
            model08.detailText = @"大型客户";
        }
            break;
        case 2:
        {
            model08.detailText = @"中型客户";
        }
            break;
        case 3:
        {
            model08.detailText = @"小型客户";
        }
            break;
        default:
            model08.detailText = @"请选择客户级别";
            break;
    }
    model08.option = ^(){
        CustomerLevelViewController *vc = [[CustomerLevelViewController alloc] init];
        vc.delegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.dataArray = @[model01,model02,model03,model04,model05,model06,model07,model08];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate tableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatNewCustomerCell *cell = [CreatNewCustomerCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    CreatNewCustomerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CreatNewCustomerBaseModel *cellData = self.dataArray[indexPath.row];
    if ([cellData isKindOfClass:[CreatNewCustomerNormalModel class]]) { //上面部分
        [cell.textField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if ([cellData isKindOfClass:[CreatNewCustomerArrowModel class]]) {
        if (cellData.option) {
            cellData.option();
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}

#pragma mark - SelectProductListViewControllerDelegate 标签
-(void)chooseProduct:(NSArray *)selectArray{
    
    CreatNewCustomerBaseModel *model = self.dataArray[4];
    if (selectArray.count) {
        model.detailText = [NSString stringWithFormat:@"%lu个",(unsigned long)selectArray.count];
        NSMutableString *tempStr = [NSMutableString string];
        for (int i = 0; i < selectArray.count; i++) {
            if (i == 0) {
                Product *product = selectArray[i];
                [tempStr appendString:product.id];
            }else{
                Product *product = selectArray[i];
                [tempStr appendFormat:@",%@",product.id];
            }
        }
//        model.detailText = [tempStr copy];
        self.selectProduct = [tempStr copy];
    }else{
        model.detailText = @"";
        self.selectProduct = @"";
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
}




#pragma mark - IntentionLevelViewControllerDelegate
-(void)chooseIntentionLevel:(NSString *)level{
    CreatNewCustomerBaseModel *model = self.dataArray[5];
    model.detailText = level;
//    self.intentionLevelStr = level;
    if ([level isEqualToString:@"A"]) {
        self.intentionLevelStr = @"0";
    }else if([level isEqualToString:@"B"]){
        self.intentionLevelStr = @"1";
    }else if([level isEqualToString:@"C"]){
        self.intentionLevelStr = @"2";
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - CustomerLevelViewControllerDelegate
-(void)chooseCustomerLevel:(NSString *)level{
    CreatNewCustomerBaseModel *model = self.dataArray[7];
    model.detailText = level;
//    self.customerLevelStr = level;
    if ([level isEqualToString:@"vip"]) {
        self.customerLevelStr = @"0";
    }else if([level isEqualToString:@"大型客户"]){
        self.customerLevelStr = @"1";
    }else if([level isEqualToString:@"中型客户"]){
        self.customerLevelStr = @"2";
    }else if([level isEqualToString:@"小型客户"]){
        self.customerLevelStr = @"3";
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:7 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - EditCustomerControllerDelegate
-(void)selectTagArray:(NSArray *)selectArray{
//    self.tagArray = selectArray;
    CreatNewCustomerBaseModel *model = self.dataArray[6];
    NSMutableString *mutableStr = [NSMutableString string];
    for (int i = 0; i < selectArray.count; i++) {
        if (i == 0) {
            [mutableStr appendString:selectArray[i]];
        }else{
            [mutableStr appendFormat:@",%@",selectArray[i]];
        }
    }
    self.tagArray = [mutableStr copy];
    model.detailText = self.tagArray;
    NSIndexPath *index = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}
@end
