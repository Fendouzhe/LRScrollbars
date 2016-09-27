//
//  SMWantBuyCustomerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMWantBuyCustomerController.h"
#import "SMWantBuyCustomerCell.h"
#import "SMSequenceView.h"
#import <MessageUI/MessageUI.h>
#import "CustomerDetailInfoViewController.h"
#import "SMShippingController.h"

#define oneRowHeight 32

@interface SMWantBuyCustomerController ()<UITableViewDelegate,UITableViewDataSource,SMSequenceViewDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic ,strong)UIView *bottomView;/**< 最下面的一行view */

@property (nonatomic ,strong)UIButton *allChooseBtn;/**< 全选发短信 按钮*/
@property (nonatomic ,strong)UIButton *allBtn;/**< 筛选地方的 全部按钮 */

@property (nonatomic ,strong)UIButton *customerLevel;/**< 客户级别 */

@property (nonatomic ,strong)UIView *chooseMenu;/**< 全部，客户级别，意向级别  那一行view */

@property (nonatomic ,strong)NSMutableArray *arrData;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *wantBuybtn;/**< <#注释#> */

//@property (nonatomic ,strong)UIWindow *window;/**< <#注释#> */

@property (nonatomic ,strong)UIView *wantBuyMenu;/**< 点击意向等级弹出的选择试图 */

@property (nonatomic ,strong)UIView *customerLevelMenu;/**< 点击客户级别弹出的选择试图 */

@property (nonatomic ,strong)NSArray *arrWantBuy;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrLevel;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrPhoneNums;/**< 装电话号的数组 */

@property (nonatomic ,strong)MFMessageComposeViewController *messageVc;/**< <#注释#> */

@property (nonatomic ,strong)UIView *cheatView;/**< 蒙板 */

@property (nonatomic ,assign)NSInteger wantBuyLevelNum; /**< 意向等级级别  012 分别对应ABC */
@property (nonatomic ,assign)NSInteger customerLevelNum; /**< 客户级别  0123 分别对应 Vip，大，中，小 */

@end

@implementation SMWantBuyCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.window = [[UIApplication sharedApplication].windows lastObject];
    
    self.wantBuyLevelNum = -1;
    self.customerLevelNum = -1;
    
    [self setupBottomView];
    
    [self setupChooseMenu];
    
    [self setupTableView];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:KAllCustomerDidChangeSuccess object:nil];
    
}



- (void)getData{
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:100 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            SMLog(@"result  queryCustomer  %@",result);
//            [result objectForKey:@"result"];
            NSMutableArray *dataArr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            
            [dataArr enumerateObjectsUsingBlock:^(Customer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.sumOrder == 0) {
                    [self.arrData addObject:obj];
                }
            }];
            [self.tableView reloadData];
        }else{
            [HUD hide:YES];
            SMLog(@"error  %@",error);
            [MBProgressHUD showError:@"网络异常"];
        }
    }];
}

- (void)loadView{
    [super loadView];
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    bgview.backgroundColor = [UIColor whiteColor];
    self.view = bgview;
}

#pragma mark --<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMWantBuyCustomerCell *cell = [SMWantBuyCustomerCell cellWithTableView:tableView];
    cell.customer = self.arrData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 *SMMatchHeight;
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

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        // 删除数组中对应的模型
        //        [self.contacts removeObjectAtIndex:indexPath.row];
        //        [self.arrData removeObjectAtIndex:indexPath.row];
        
        Customer *cus = self.arrData[indexPath.row];
        
        [[SKAPI shared] deleteCustomer:cus.id block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  deleteCustomer  %@",result);
                [self.arrData removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView reloadData];
            }else{
                SMLog(@"error  %@",error);
                [MBProgressHUD showError:@"网络异常"];
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
//    self.chooseMenu.backgroundColor = [UIColor redColor];
    
    //意向等级
    UIButton *wantBuybtn = [[UIButton alloc] init];
    self.wantBuybtn = wantBuybtn;
    [self.chooseMenu addSubview:wantBuybtn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *wantBuyStr = [[NSAttributedString alloc] initWithString:@" 意向等级" attributes:dict];
    [wantBuybtn setAttributedTitle:wantBuyStr forState:UIControlStateNormal];
    [wantBuybtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    
    NSNumber *wantBuyWidth = [NSNumber numberWithFloat:KScreenWidth / 3.0];
    [wantBuybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.chooseMenu.mas_centerX);
        make.top.equalTo(self.chooseMenu.mas_top).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.width.equalTo(wantBuyWidth);
    }];
    [wantBuybtn addTarget:self action:@selector(wantBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //全部按钮
    UIButton *allBtn = [[UIButton alloc] init];
    [self.chooseMenu addSubview:allBtn];
    self.allBtn = allBtn;
    allBtn.selected = YES;
    NSAttributedString *allStr = [[NSAttributedString alloc] initWithString:@"全部" attributes:dict];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = KDefaultFont;
    dict2[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *allStr2 = [[NSAttributedString alloc] initWithString:@"全部" attributes:dict2];
    
    [allBtn setAttributedTitle:allStr forState:UIControlStateNormal];
    [allBtn setAttributedTitle:allStr2 forState:UIControlStateSelected];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.chooseMenu.mas_top).with.offset(0);
        make.left.equalTo(self.chooseMenu.mas_left).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.right.equalTo(wantBuybtn.mas_left).with.offset(0);
    }];
    [allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //客户级别
    UIButton *customerLevel = [[UIButton alloc] init];
    self.customerLevel = customerLevel;
    [self.chooseMenu addSubview:customerLevel];
    NSAttributedString *customerLevelStr = [[NSAttributedString alloc] initWithString:@" 客户级别" attributes:dict];
    [customerLevel setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [customerLevel setAttributedTitle:customerLevelStr forState:UIControlStateNormal];
    [customerLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.chooseMenu.mas_top).with.offset(0);
        make.right.equalTo(self.chooseMenu.mas_right).with.offset(0);
        make.bottom.equalTo(self.chooseMenu.mas_bottom).with.offset(0);
        make.left.equalTo(wantBuybtn.mas_right).with.offset(0);
    }];
    [customerLevel addTarget:self action:@selector(customerLevelClick) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark -- 点击事件

- (void)customerLevelClick{
    SMLog(@"点击了 客户级别 排序");
//    [_wantBuyMenu removeFromSuperview];
//    _wantBuyMenu = nil;
//    if (_customerLevelMenu) {
//        [_customerLevelMenu removeFromSuperview];
//        _customerLevelMenu = nil;
//        return;
//    }
    [self.view addSubview:self.cheatView];
    [self.view addSubview:self.customerLevelMenu];
    
}

- (void)allBtnClick{
    SMLog(@"点击了 全部 排序");
    self.wantBuybtn.selected = NO;
    self.customerLevel.selected = NO;
    self.allBtn.selected = YES;
    self.wantBuyLevelNum = -1;
    self.customerLevelNum = -1;
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:-1 andLevel:-1 andTarget:@"" andLastTimeStamp:-1 andOffset:1000 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            SMLog(@"result queryCustomer %@",result);
            [self.arrData removeAllObjects];
            NSMutableArray *dataArr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [dataArr enumerateObjectsUsingBlock:^(Customer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.sumOrder == 0) {
                    [self.arrData addObject:obj];
                }
            }];
            [self.tableView reloadData];
        }else{
            SMLog(@"error  queryCustomer  %@",error);
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常"];
        }
    }];
}

- (void)wantBuyBtnClick{
    SMLog(@"点击了 意向等级 排序");
//    [_customerLevelMenu removeFromSuperview];
//    _customerLevelMenu = nil;
//    if (_wantBuyMenu) {
//        [_wantBuyMenu removeFromSuperview];
//        _wantBuyMenu = nil;
//        return;
//    }
    [self.view addSubview:self.cheatView];
    [self.view addSubview:self.wantBuyMenu];
    
}

- (void)cheatViewTap{
    [_customerLevelMenu removeFromSuperview];
    _customerLevelMenu = nil;
    [_wantBuyMenu removeFromSuperview];
    _wantBuyMenu = nil;
    [_cheatView removeFromSuperview];
    _cheatView = nil;
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

- (void)sendMessage{
    [self.arrPhoneNums removeAllObjects];
    
    for (Customer *cus in self.arrData) {
        if (cus.isSelected) {
            [self.arrPhoneNums addObject:cus.phone];
        }
    }
    
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
        if ([self.delegate respondsToSelector:@selector(presentVc:)]) {
            [self.delegate presentVc:controller];
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

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if ([self.delegate respondsToSelector:@selector(dismissVc)]) {
        [self.delegate dismissVc];
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

- (void)allChooseBtnClick:(UIButton *)btn{
    SMLog(@"点击了 全选按钮");
    btn.selected = !btn.selected;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KWantBuyVCAllChooseKey] = [NSString stringWithFormat:@"%zd",btn.selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:KWantBuyVCAllChoose object:self userInfo:dict];
    
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = KControllerBackGroundColor;
    }
    return _tableView;
}

- (UIView *)cheatView{
    if (_cheatView == nil) {
        
        _cheatView = [[UIView alloc] init];
        _cheatView.backgroundColor = [UIColor blackColor];
        _cheatView.alpha = 0.05;
        _cheatView.frame = self.view.bounds;
        _cheatView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
        [_cheatView addGestureRecognizer:tap];
    }
    return _cheatView;
}

- (UIView *)wantBuyMenu{
    if (_wantBuyMenu == nil) {
        _wantBuyMenu = [[UIView alloc] init];
        CGFloat y = CGRectGetMaxY([self.chooseMenu convertRect:self.wantBuybtn.frame toView:self.view]);
        _wantBuyMenu.frame = CGRectMake(KScreenWidth / 3.0, y, KScreenWidth / 3.0, oneRowHeight *SMMatchHeight *3);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        dict[NSFontAttributeName] = KDefaultFont;
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] init];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.arrWantBuy[i] attributes:dict];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            btn.tag = 10 + i;
            [_wantBuyMenu addSubview:btn];
            [btn addTarget:self action:@selector(chooseWantBuyLevel:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 32 *SMMatchHeight *i, KScreenWidth / 3.0, oneRowHeight *SMMatchHeight);
            btn.layer.borderColor = KGrayColorSeparatorLine.CGColor;
            btn.layer.borderWidth = 0.5;
            btn.backgroundColor = [UIColor whiteColor];
        }
        
    }
    return _wantBuyMenu;
}

- (UIView *)customerLevelMenu{
    if (_customerLevelMenu == nil) {
        _customerLevelMenu = [[UIView alloc] init];
        CGFloat y = CGRectGetMaxY([self.chooseMenu convertRect:self.customerLevel.frame toView:self.view]);
        _customerLevelMenu.frame = CGRectMake(KScreenWidth / 3.0 *2, y, KScreenWidth / 3.0, oneRowHeight *SMMatchHeight *4);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        dict[NSFontAttributeName] = KDefaultFont;
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [[UIButton alloc] init];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.arrLevel[i] attributes:dict];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            btn.tag = 20 + i;
            [_customerLevelMenu addSubview:btn];
            [btn addTarget:self action:@selector(chooseCustomerLevel:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 32 *SMMatchHeight *i, KScreenWidth / 3.0, oneRowHeight *SMMatchHeight);
            btn.layer.borderColor = KGrayColorSeparatorLine.CGColor;
            btn.layer.borderWidth = 0.5;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    return _customerLevelMenu;
}

- (void)chooseCustomerLevel:(UIButton *)btn{
    
    NSInteger chooseTag = btn.tag - 20;
    [self refreshCustomerBtn:chooseTag];
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:self.wantBuyLevelNum andLevel:chooseTag andTarget:@"" andLastTimeStamp:-1 andOffset:50 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            SMLog(@"result queryCustomer %@",result);
            //self.arrData = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [self.arrData removeAllObjects];
            NSMutableArray *dataArr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [dataArr enumerateObjectsUsingBlock:^(Customer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.sumOrder == 0) {
                    [self.arrData addObject:obj];
                }
            }];
            [self.tableView reloadData];
        }else{
            SMLog(@"error  queryCustomer  %@",error);
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常"];
        }
    }];
    
    [_customerLevelMenu removeFromSuperview];
    _customerLevelMenu = nil;
    [_cheatView removeFromSuperview];
    _cheatView = nil;
}

- (void)chooseWantBuyLevel:(UIButton *)btn{
    NSInteger chooseTag = btn.tag - 10;
    [self refreshWantBuyBtnTitle:chooseTag];
    
    SMLog(@"chooseTag  %zd  self.customerLevelNum  %zd",chooseTag,self.customerLevelNum);
    SMShowPrompt(@"加载中...");
    [[SKAPI shared] queryCustomer:@"" andBuyRating:chooseTag andLevel:self.customerLevelNum andTarget:@"" andLastTimeStamp:-1 andOffset:50 andType:-1 block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            SMLog(@"result queryCustomer %@",result);
            //self.arrData = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [self.arrData removeAllObjects];
            NSMutableArray *dataArr = [Customer mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [dataArr enumerateObjectsUsingBlock:^(Customer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.sumOrder == 0) {
                    [self.arrData addObject:obj];
                }
            }];
            [self.tableView reloadData];
        }else{
            [HUD hide:YES];
            SMLog(@"error  queryCustomer  %@",error);
            [MBProgressHUD showError:@"网络异常"];
        }
    }];
    
    [_wantBuyMenu removeFromSuperview];
    _wantBuyMenu = nil;
    [_cheatView removeFromSuperview];
    _cheatView = nil;
}

- (void)refreshWantBuyBtnTitle:(NSInteger)chooseTag{
    self.wantBuyLevelNum = chooseTag;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *wantBuyStr;
    if (chooseTag == 0) {
        wantBuyStr = [[NSAttributedString alloc] initWithString:@" 意向等级(A)" attributes:dict];
    }else if (chooseTag == 1){
        wantBuyStr = [[NSAttributedString alloc] initWithString:@" 意向等级(B)" attributes:dict];
    }else if (chooseTag == 2){
        wantBuyStr = [[NSAttributedString alloc] initWithString:@" 意向等级(C)" attributes:dict];
    }
    [self.wantBuybtn setAttributedTitle:wantBuyStr forState:UIControlStateSelected];
    self.wantBuybtn.selected = YES;
    self.allBtn.selected = NO;
}

- (void)refreshCustomerBtn:(NSInteger)chooseTag{
    self.customerLevelNum = chooseTag;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *levelStr;
    
    if (chooseTag == 0) {
        levelStr = [[NSAttributedString alloc] initWithString:@" 客户级别(VIP)" attributes:dict];
    }else if (chooseTag == 1){
        levelStr = [[NSAttributedString alloc] initWithString:@" 客户级别(大)" attributes:dict];
    }else if (chooseTag == 2){
        levelStr = [[NSAttributedString alloc] initWithString:@" 客户级别(中)" attributes:dict];
    }else if (chooseTag == 3){
        levelStr = [[NSAttributedString alloc] initWithString:@" 客户级别(小)" attributes:dict];
    }
    [self.customerLevel setAttributedTitle:levelStr forState:UIControlStateSelected];
    self.customerLevel.selected = YES;
    self.allBtn.selected = NO;
}

- (NSArray *)arrWantBuy{
    if (_arrWantBuy == nil) {
        _arrWantBuy = @[@"A",@"B",@"C"];
    }
    return _arrWantBuy;
}

- (NSArray *)arrLevel{
    if (_arrLevel == nil) {
        _arrLevel = @[@"VIP客户",@"大型客户",@"中型客户",@"小型客户"];
    }
    return _arrLevel;
}

- (NSMutableArray *)arrPhoneNums{
    if (_arrPhoneNums == nil) {
        _arrPhoneNums = [NSMutableArray array];
    }
    return _arrPhoneNums;
}

- (NSMutableArray *)arrData{
    if (_arrData == nil) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}
@end
