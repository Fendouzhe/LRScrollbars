//
//  SMOldCustomerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOldCustomerController.h"
#import "SMOldCustomerCell.h"
#import <MessageUI/MessageUI.h>
#import "CustomerDetailInfoViewController.h"
@interface SMOldCustomerController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>

@property (nonatomic ,strong)UIView *bottomView;/**<  */

@property (nonatomic ,strong)UIView *chooseMenu;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *allChooseBtn;/**< 全选群发短信 */

@property (nonatomic ,strong)UIButton *allBtn;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *orderCountBtn;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrData;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrPhoneNums;/**< 装电话号的数组 */

@property (nonatomic ,strong)MFMessageComposeViewController *messageVc;/**< <#注释#> */

@end

@implementation SMOldCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBottomView];
    
    [self setupChooseMenu];
    
    [self setupTableView];
    
    [self getDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDatas) name:KAllCustomerDidChangeSuccess object:nil];
}

- (void)getDatas{
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:1000 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            [self.arrData removeAllObjects];  // 先移出之前数据 防止重复添加
            SMLog(@"result  getDatas %@",result);
            NSArray *arr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            
            for (Customer *cus in arr) {
                if (cus.sumOrder > 0) {  //如果订单数不为0   才是老客户
                    [self.arrData addObject:cus];
                }
            }
            
            [self.tableView reloadData];
        }else{
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常!"];
            SMLog(@"error  %@",error);
        }
    }];
}

#pragma mark --<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMOldCustomerCell *cell = [SMOldCustomerCell cellWithTableView:tableView];
    cell.customer = self.arrData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectorCustom) {
        Customer *tom = self.arrData[indexPath.row];
        SMLog(@"%@__%@__%@--%@",tom.name,tom.fullname,tom.phone,tom.address);
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomMessageNotification object:nil userInfo:@{@"name":tom.name,
                                                                                                                   @"phone":tom.phone,
                                                                                                                   @"address":tom.address}];
        [self.pushNav popViewControllerAnimated:YES];
    }else{
        CustomerDetailInfoViewController *vc = [[CustomerDetailInfoViewController alloc] init];
        vc.customer = self.arrData[indexPath.row];
        SMLog(@"self.navigationController = %@",self.navigationController);
        [self.pushNav pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 *SMMatchHeight;
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        // 删除数组中对应的模型
//        [self.contacts removeObjectAtIndex:indexPath.row];
//        [self.arrData removeObjectAtIndex:indexPath.row];
        
        Customer *cus = self.arrData[indexPath.row];
        
        [[SKAPI shared] deleteCustomer:cus.id block:^(id result, NSError *error) {
            if (!error) {
                [self.arrData removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView reloadData];
            }else{
                SMLog(@"error  %@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

/**
 *  告诉tableView第indexPath行要执行怎么操作
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)setupTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
}

- (void)loadView{
    [super loadView];
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    bgview.backgroundColor = [UIColor whiteColor];
    self.view = bgview;
}

- (void)setupChooseMenu{
    self.chooseMenu = [[UIView alloc] init];
    [self.view addSubview:self.chooseMenu];
    NSNumber *chooseMenuHeight = [NSNumber numberWithFloat:38 *SMMatchHeight];
    [self.chooseMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(chooseMenuHeight);
    }];
    
    //订单数量
    UIButton *orderCountBtn = [[UIButton alloc] init];
    self.orderCountBtn = orderCountBtn;
    [self.chooseMenu addSubview:orderCountBtn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    NSMutableDictionary *dictSeleted = [NSMutableDictionary dictionary];
    dictSeleted[NSForegroundColorAttributeName] = KRedColorLight;
    dictSeleted[NSFontAttributeName] = KDefaultFont;
    
    NSAttributedString *orderCountStr = [[NSAttributedString alloc] initWithString:@" 订单数量" attributes:dict];
    [orderCountBtn setAttributedTitle:orderCountStr forState:UIControlStateNormal];
    [orderCountBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    
    NSAttributedString *orderCountStrSelected = [[NSAttributedString alloc] initWithString:@" 订单数量" attributes:dictSeleted];
    [orderCountBtn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
    [orderCountBtn setAttributedTitle:orderCountStrSelected forState:UIControlStateSelected];
    
    NSNumber *orderWidth = [NSNumber numberWithFloat:KScreenWidth / 2.0];
    [orderCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.chooseMenu.mas_right).with.offset(0);
        make.top.equalTo(self.chooseMenu.mas_top).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.width.equalTo(orderWidth);
    }];
    [orderCountBtn addTarget:self action:@selector(orderCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //全部按钮
    UIButton *allBtn = [[UIButton alloc] init];
    self.allBtn = allBtn;
    [self.chooseMenu addSubview:allBtn];
    NSAttributedString *allStr = [[NSAttributedString alloc] initWithString:@"全部" attributes:dict];
    [allBtn setAttributedTitle:allStr forState:UIControlStateNormal];
    
    NSAttributedString *allStrSelected = [[NSAttributedString alloc] initWithString:@"全部" attributes:dictSeleted];
    [allBtn setAttributedTitle:allStrSelected forState:UIControlStateSelected];
    allBtn.selected = YES;
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.chooseMenu.mas_top).with.offset(0);
        make.left.equalTo(self.chooseMenu.mas_left).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.right.equalTo(orderCountBtn.mas_left).with.offset(0);
    }];
    [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //灰色横线
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = KGrayColorSeparatorLine;
    [self.chooseMenu addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.chooseMenu.mas_right).with.offset(0);
        make.left.equalTo(self.chooseMenu.mas_left).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
}

- (void)sendMessage{
    [self.arrPhoneNums removeAllObjects];
    
    for (Customer *cus in self.arrData) {
        if (cus.isSelected) {
            SMLog(@"cus.phone  %@",cus.phone);
            [self.arrPhoneNums addObject:cus.phone];
        }
        
    }
    
    SMLog(@"self.arrPhoneNums  %@",self.arrPhoneNums);
    if (self.arrPhoneNums.count > 0) {
        [self showMessageView:self.arrPhoneNums title:@"test" body:@""];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选中一个客户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        self.messageVc = controller;
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        if ([self.delegate respondsToSelector:@selector(presentVc2:)]) {
            [self.delegate presentVc2:controller];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
//{
//    if( [MFMessageComposeViewController canSendText] )
//    {
//        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
//        self.messageVc = controller;
//        controller.recipients = phones;
//        controller.navigationBar.tintColor = [UIColor redColor];
//        controller.body = body;
//        controller.messageComposeDelegate = self;
//        if ([self.delegate respondsToSelector:@selector(presentVc:)]) {
//            [self.delegate presentVc:controller];
//        }
//        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"该设备不支持短信功能"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if ([self.delegate respondsToSelector:@selector(dismissVc2)]) {
        [self.delegate dismissVc2];
    }
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}


#pragma mark -- 点击事件
- (void)allBtnClick:(UIButton *)btn{
    SMLog(@"点击了 全部 排序");
    self.orderCountBtn.selected = NO;
    if (self.allBtn.selected) {
        return;
    }
    self.allBtn.selected = YES;
    
    if (self.allBtn.selected) {
        [self getDatas];
    }
}

- (void)orderCountBtnClick:(UIButton *)btn{
    SMLog(@"点击了 订单数量 排序");
    self.allBtn.selected = NO;
    self.orderCountBtn.selected = !self.orderCountBtn.selected;
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:1000 andType:self.orderCountBtn.selected block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            [self.arrData removeAllObjects];  // 先移出之前数据 防止重复添加
            SMLog(@"result  getDatas %@",result);
            NSArray *arr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            for (Customer *cus in arr) {
                if (cus.sumOrder > 0) {  //如果订单数不为0   才是老客户
                    [self.arrData addObject:cus];
                }
            }
            [self.tableView reloadData];
        }else{
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常!"];
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)setupBottomView{
    
    //bottomview
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@49);
    }];
    
    //群发短信
    UIButton *SMSBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"群发短信" attributes:dict];
    [SMSBtn setAttributedTitle:str forState:UIControlStateNormal];
    SMSBtn.backgroundColor = KRedColorLight;
    [self.bottomView addSubview:SMSBtn];
    NSNumber *SMSWidth = [NSNumber numberWithFloat:93 *SMMatchWidth];
    [SMSBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [SMSBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.bottomView.mas_right).with.offset(0);
        make.top.equalTo(self.bottomView.mas_top).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_bottom).with.offset(0);
        make.width.equalTo(SMSWidth);
    }];
    
    //全选 按钮
    self.allChooseBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = KDefaultFontBig;
    dict2[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@" 全选" attributes:dict2];
    [self.allChooseBtn setImage:[UIImage imageNamed:@"勾gray"] forState:UIControlStateNormal];
    [self.allChooseBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    
    [self.allChooseBtn setImage:[UIImage imageNamed:@"勾red"] forState:UIControlStateSelected];
    [self.allChooseBtn setAttributedTitle:str2 forState:UIControlStateSelected];
    //    [self.allChooseBtn setTitle:@" 全选" forState:UIControlStateSelected];
    //    [self.allChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.allChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    self.allChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bottomView addSubview:self.allChooseBtn];
    
    [self.allChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(SMSBtn.mas_left).with.offset(0);
        make.top.equalTo(self.bottomView.mas_top).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(self.bottomView.mas_left).with.offset(10);
    }];
    [self.allChooseBtn addTarget:self action:@selector(allChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //灰色横线
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = KGrayColorSeparatorLine;
    [self.bottomView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(SMSBtn.mas_left).with.offset(0);
        make.top.equalTo(self.bottomView.mas_top).with.offset(0);
        make.left.equalTo(self.bottomView.mas_left).with.offset(0);
        make.height.equalTo(@1);
    }];
    
}

- (void)allChooseBtnClick:(UIButton *)btn{
    SMLog(@"点击了 全选按钮");
    btn.selected = !btn.selected;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KOldCustomerAllChooseKey] = [NSString stringWithFormat:@"%zd",btn.selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:KOldCustomerAllChoose object:self userInfo:dict];
    
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.separatorColor = KControllerBackGroundColor;
    }
    return _tableView;
}

- (NSMutableArray *)arrData{
    if (_arrData == nil) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

- (NSMutableArray *)arrPhoneNums{
    if (_arrPhoneNums == nil) {
        _arrPhoneNums = [NSMutableArray array];
    }
    return _arrPhoneNums;
}

@end
