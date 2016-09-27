//
//  SMCommunicateViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommunicateViewController.h"
#import "SMSearchBar.h"
#import "SMLeftItemBtn.h"
#import "SMScanerBtn.h"
#import "SMCommunicateBtn.h"
#import "SMPartnerConnectViewController.h"
#import "SMTaskLogViewController.h"
#import "SMSellLogTableViewController.h"
#import "SMCustomContactViewController.h"
#import "SMCustomerManagerViewController.h"
#import "SMSignInViewController.h"
#import "SMScannerViewController.h"
#import "SMPersonCenterViewController.h"
#import "SMSearchViewController.h"
#import "SMDiscountCouponViewController.h"

#import "SMOrderManagerViewController.h"
#import "SMShelfTemplateViewController.h"
#import "SMNewOrderManagerViewController.h"
#import "AppDelegate.h"
#import "UIButton+Badge.h"
#import "LocalConversation.h"
#import "SMWorkbenchView.h"
#import "SMPersonInfoViewController.h"
#import "UIView+Badge.h"
#import "SingtonManager.h"
#import "SMPartnerController.h"
#import "SMNewCustomManagerController.h"
#import "SMNewPartnerConnectViewController.h"


typedef enum : NSUInteger {
    communicateTypePartner,
    communicateTypeTask,
    communicateTypeSell,
    communicateTypeCustomer,
    communicateTypeCustomerOnline,
    communicateTypeSignIn,
    communicateTypeDiscountCoupon
} communicateType;

@interface SMCommunicateViewController ()<UITextFieldDelegate,SMWorkbenchViewDelegate>

@property (nonatomic ,strong)SMSearchBar *searchBar;
/**
 *  左边头像item
 */
@property (nonatomic ,strong)SMLeftItemBtn *leftIconBtn;
//伙伴连线
@property(nonatomic,strong)SMWorkbenchView *partnerView;
//客服连线
@property(nonatomic,strong)SMWorkbenchView *customerOnlineView;
//订单管理
@property (nonatomic ,strong)SMWorkbenchView *orderView;
//客户管理
@property (nonatomic ,strong)SMWorkbenchView *CustomerView;
//柜台管理
@property (nonatomic ,strong)SMWorkbenchView *CounterView;
//分销团队
@property (nonatomic ,strong)SMWorkbenchView *RetailView;
//任务日志
@property (nonatomic ,strong)SMWorkbenchView *taskView;
//优惠券
@property (nonatomic ,strong)SMWorkbenchView *discountCouponView;
//签到
@property (nonatomic ,strong)SMWorkbenchView *signInView;
@end

@implementation SMCommunicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUI];
    
    //self.tabBarItem.badgeValue = @"";
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadge) name:@"PartnerBadgeRefresh" object:nil];
    
}

//刷新角标
-(void)refreshBadge{
    NSArray * array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    NSInteger badge = 0;
    for (LocalConversation * localConversation in array) {
        badge = badge + localConversation.unread.integerValue;
    }
    
//    [self.partnerBtn.functionBtn showBadgeWith:[NSString stringWithFormat:@"%ld",badge]];
//    if (badge == 0) {
//        [self.partnerBtn.functionBtn removeBadge];
//    }
    [self.partnerView removeBadge];
    
    [self.partnerView showBadgeWith:[NSString stringWithFormat:@"%zd",badge]];
    if (badge > 99) {
        [self.partnerView showBadgeWith:@"99+"];
    }
    if (badge == 0) {
        [self.partnerView removeBadge];
    }
    
    NSArray * arrayCustomer = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    NSInteger badgeCustomer = 0;
    for (LocalConversation * localConversation in arrayCustomer) {
        badgeCustomer = badgeCustomer+localConversation.unread.integerValue;
    }
    [self.customerOnlineView removeBadge];
    
    [self.customerOnlineView showBadgeWith:[NSString stringWithFormat:@"%zd",badgeCustomer]];
    if (badgeCustomer > 99) {
        [self.customerOnlineView showBadgeWith:@"99+"];
    }
    if (badgeCustomer == 0) {
        [self.customerOnlineView removeBadge];
    }
}
#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.leftIconBtn.customImageView.image = image;
    }
    
    SingtonManager * sington = [SingtonManager sharedManager];
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    //刷新上面的角标
 // 设置伙伴连线的角标
    NSArray * array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    NSInteger badge = 0;
    for (LocalConversation * localConversation in array) {
        badge = badge+localConversation.unread.integerValue;
    }

    [self.partnerView removeBadge];
    [self.partnerView showBadgeWith:[NSString stringWithFormat:@"%ld",badge+sington.friendNum]];
    
    if (badge+sington.friendNum > 99) {
       [self.partnerView showBadgeWith:@"99+"];
    }
    if (badge+sington.friendNum == 0) {
        [self.partnerView removeBadge];
    }
// 设置客服连线的角标
    NSArray * arrayCustomer = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    NSInteger badgeCustomer = 0;
    for (LocalConversation * localConversation in arrayCustomer) {
        badgeCustomer = badgeCustomer+localConversation.unread.integerValue;
    }
    [self.customerOnlineView removeBadge];
    
    [self.customerOnlineView showBadgeWith:[NSString stringWithFormat:@"%ld",badgeCustomer]];
    if (badgeCustomer > 99) {
        [self.customerOnlineView showBadgeWith:@"99+"];
    }
    if (badgeCustomer == 0) {
        [self.customerOnlineView removeBadge];
    }

    // 设置订单管理的角标
    [self.orderView removeBadge];

    [self.orderView showBadgeWith:[NSString stringWithFormat:@"%ld",sington.orderNum]];
    
    if (sington.orderNum == 0) {
        [self.orderView removeBadge];
    }
    // 设置任务日程的角标
    [self.taskView removeBadge];
    
    [self.taskView showBadgeWith:[NSString stringWithFormat:@"%zd",sington.jobNum]];
    
    if (sington.jobNum == 0) {
        [self.taskView removeBadge];
    }
    
    if (sington.friendNum+sington.orderNum+sington.jobNum+badge+badgeCustomer>0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}

- (void)setupUI{
    CGFloat width = KScreenWidth / 3.0;
    CGFloat height = width;
    SMLog(@"%zd   %zd",width,height);
    //伙伴连线
//    SMCommunicateBtn *partnerBtn = [SMCommunicateBtn communicateBtnWithImage:@"huobanlianxian" title:@"伙伴连线"];
//    [self.view addSubview:partnerBtn];
//    self.partnerBtn = partnerBtn;
//    partnerBtn.frame = CGRectMake(0, 0, width , height);
//    partnerBtn.tag = communicateTypePartner;
//    partnerBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [partnerBtn.functionBtn addTarget:self action:@selector(partnerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *partnerView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"huobanlianxian"] andName:@"伙伴连线" andTag:0];
    self.partnerView = partnerView;
    [self.view addSubview:partnerView];
    partnerView.frame = CGRectMake(0, 0, width, height);
    partnerView.deledate = self;

    
    //客服连线
//    SMCommunicateBtn *customerOnlineBtn = [SMCommunicateBtn communicateBtnWithImage:@"kefugoutong" title:@"客服连线"];
//    [self.view addSubview:customerOnlineBtn];
//    customerOnlineBtn.frame = CGRectMake(width , 0, width, height);
//    customerOnlineBtn.tag = communicateTypeCustomerOnline;
//    customerOnlineBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [customerOnlineBtn.functionBtn addTarget:self action:@selector(customerOnlineBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [customerOnlineBtn.functionBtn showBadgeWith:@"999"];
    
    SMWorkbenchView *customerOnlineView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"kefugoutong"] andName:@"客服连线" andTag:1];
    self.customerOnlineView = customerOnlineView;
    [self.view addSubview:customerOnlineView];
    customerOnlineView.frame = CGRectMake(width , 0, width, height);
    customerOnlineView.deledate = self;
    
    //销售日志   (改为订单管理)
    
//    SMCommunicateBtn *sellBtn = [SMCommunicateBtn communicateBtnWithImage:@"订单管理" title:@"订单管理"];
//    [self.view addSubview:sellBtn];
//    sellBtn.frame = CGRectMake(width *2, 0, width, height);
//    sellBtn.tag = communicateTypeSell;
//    sellBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [sellBtn.functionBtn addTarget:self action:@selector(sellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *orderView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"订单管理"] andName:@"订单管理" andTag:2];
    self.orderView = orderView;
    [self.view addSubview:orderView];
    orderView.frame = CGRectMake(width *2, 0, width, height);
    orderView.deledate = self;
    
//    [orderView showBadgeWith:@"99"];
    //客户管理
//    SMCommunicateBtn *CustomerBtn = [SMCommunicateBtn communicateBtnWithImage:@"kehuguanli" title:@"客户管理"];
//    [self.view addSubview:CustomerBtn];
//    CustomerBtn.frame = CGRectMake(0, height, width, height);
//    CustomerBtn.tag = communicateTypeCustomer;
//    CustomerBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [CustomerBtn.functionBtn addTarget:self action:@selector(CustomerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    SMWorkbenchView *CustomerView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"kehuguanli"] andName:@"客户管理" andTag:3];
    self.CustomerView = CustomerView;
    [self.view addSubview:CustomerView];
    CustomerView.frame = CGRectMake(0, height, width, height);
    CustomerView.deledate = self;
    
    //新增的柜台管理
//    SMCommunicateBtn * CounterBtn = [SMCommunicateBtn communicateBtnWithImage:@"柜台管理" title:@"柜台管理"];
//    [self.view addSubview:CounterBtn];
//    CounterBtn.frame = CGRectMake(width, height, width, height);
//    CounterBtn.tag = communicateTypeTask;
//    CounterBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [CounterBtn.functionBtn addTarget:self action:@selector(CounterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *CounterView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"柜台管理"] andName:@"柜台管理" andTag:4];
    self.CounterView = CounterView;
    [self.view addSubview:CounterView];
    CounterView.frame = CGRectMake(width, height, width, height);
    CounterView.deledate = self;
    
    //分销团队  （暂时隐藏）
//    SMCommunicateBtn * RetailBtn  = [SMCommunicateBtn communicateBtnWithImage:@"分销团队" title:@"分销团队"];
//    [self.view addSubview:RetailBtn];
//    RetailBtn.frame = CGRectMake(2*width, height, width, height);
//    RetailBtn.tag = communicateTypeTask;
//    RetailBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [RetailBtn.functionBtn addTarget:self action:@selector(RetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger level2= [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    if (!level2) {
        //1级
        SMWorkbenchView *RetailView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"分销团队"] andName:@"合伙人" andTag:5];
        self.RetailView = RetailView;
        [self.view addSubview:RetailView];
        RetailView.frame = CGRectMake(width *2,2* height, width, height);
        RetailView.deledate = self;
    }
    
    
    //任务日志
//    SMCommunicateBtn *taskBtn = [SMCommunicateBtn communicateBtnWithImage:@"任务日程" title:@"任务日程"];
//    [self.view addSubview:taskBtn];
//    taskBtn.frame = CGRectMake(width, height *2, width, height);
//    taskBtn.tag = communicateTypeTask;
//    taskBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [taskBtn.functionBtn addTarget:self action:@selector(taskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *taskView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"任务日程"] andName:@"任务日程" andTag:7];
    self.taskView = taskView;
    [self.view addSubview:taskView];
    taskView.frame = CGRectMake(0, height *2, width, height);
    taskView.deledate = self;
    
    //新增优惠券界面
//    SMCommunicateBtn *discountCoupon = [SMCommunicateBtn communicateBtnWithImage:@"youhuiquanduihuan" title:@"优惠券兑换"];
//    [self.view addSubview:discountCoupon];
//    discountCoupon.frame = CGRectMake(0, 2*height, width, height);
//    discountCoupon.tag = communicateTypeDiscountCoupon;
//    discountCoupon.functionBtn.adjustsImageWhenHighlighted = NO;
//    [discountCoupon.functionBtn addTarget:self action:@selector(discountCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *discountCouponView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"youhuiquanduihuan"] andName:@"优惠券兑换" andTag:6];
    self.discountCouponView = discountCouponView;
    [self.view addSubview:discountCouponView];
    discountCouponView.frame = CGRectMake(2*width, height, width, height);
    discountCouponView.deledate = self;
    
    //签到
//    SMCommunicateBtn *signInBtn = [SMCommunicateBtn communicateBtnWithImage:@"qiandao" title:@"外勤签到"];
//    [self.view addSubview:signInBtn];
//    signInBtn.frame = CGRectMake(width *2,2* height, width, height);
//    signInBtn.tag = communicateTypeCustomerOnline;
//    signInBtn.functionBtn.adjustsImageWhenHighlighted = NO;
//    [signInBtn.functionBtn addTarget:self action:@selector(signInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SMWorkbenchView *signInView = [[SMWorkbenchView alloc] initWithImage:[UIImage imageNamed:@"qiandao"] andName:@"外勤签到" andTag:8];
    self.signInView = signInView;
    [self.view addSubview:signInView];
    signInView.frame = CGRectMake(width ,2* height, width, height);
    signInView.deledate = self;
    
    
    //灰色横线
    UILabel *label1 = [[UILabel alloc] init];
    [self.view addSubview:label1];
    label1.backgroundColor = SMColor(226, 228, 229);
    label1.frame = CGRectMake(0, height, KScreenWidth, 1);
    
    UILabel *label2 = [[UILabel alloc] init];
    [self.view addSubview:label2];
    label2.backgroundColor = SMColor(226, 228, 229);
    label2.frame = CGRectMake(0, height *2, KScreenWidth, 1);
    
    UILabel *label3 = [[UILabel alloc] init];
    [self.view addSubview:label3];
    label3.backgroundColor = SMColor(226, 228, 229);
    label3.frame = CGRectMake(width, 0, 1, 3 *height);
    
    UILabel *label4 = [[UILabel alloc] init];
    [self.view addSubview:label4];
    label4.backgroundColor = SMColor(226, 228, 229);
    label4.frame = CGRectMake(width *2, 0, 1, 3 *height);
    
    if (!level2) {
        UILabel *label5 = [[UILabel alloc] init];
        [self.view addSubview:label5];
        label5.backgroundColor = SMColor(226, 228, 229);
        label5.frame = CGRectMake(0, 3*height, KScreenWidth,1);
    }else{
        UILabel *label5 = [[UILabel alloc] init];
        [self.view addSubview:label5];
        label5.backgroundColor = SMColor(226, 228, 229);
        label5.frame = CGRectMake(0, 3*height, 2*width,1);
    }
    
    
    //修复退出登录显示的问题
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

#pragma mark -- SMWorkbenchViewDelegate
- (void)workbenchViewDidClickWithTag:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            SMLog(@"点击了 伙伴连线 按钮");
//            SMPartnerConnectViewController *partnerVc = [[SMPartnerConnectViewController alloc] init];
            SMNewPartnerConnectViewController *partnerVc = [[SMNewPartnerConnectViewController alloc] init];
            [self.navigationController pushViewController:partnerVc animated:YES];
        }
            break;
        case 1:
        {
            SMLog(@"点击了 客服连线 按钮");
            SMCustomContactViewController *customVc = [[SMCustomContactViewController alloc] init];
            [self.navigationController pushViewController:customVc animated:YES];
        }
            break;
        case 2:
        {
            SMLog(@"点击了 订单管理 按钮");
            SMNewOrderManagerViewController * orderManager = [SMNewOrderManagerViewController new];
            [self.navigationController pushViewController:orderManager animated:YES];
        }
            break;
        case 3:
        {
            SMLog(@"点击了 客户管理按钮");
//            SMCustomerManagerViewController *customerVc = [[SMCustomerManagerViewController alloc] init];
//            [self.navigationController pushViewController:customerVc animated:YES];
            SMNewCustomManagerController *vc = [SMNewCustomManagerController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            SMLog(@"点击了 柜台管理 按钮");
            //跳转到柜台管理(原先的货架模板)
            SMShelfTemplateViewController *shelfVc = [[SMShelfTemplateViewController alloc] init];
            [self.navigationController pushViewController:shelfVc animated:YES];
        }
            break;
        case 5:
        {
            SMLog(@"点击了 分销团队  按钮");
            //    暂时还没有

            SMPartnerController *vc = [[SMPartnerController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            SMLog(@"点击了 优惠劵兑换 按钮");
            SMDiscountCouponViewController * discount = [[SMDiscountCouponViewController alloc]init];
            [self.navigationController pushViewController:discount animated:YES];
        }
            break;
        case 7:
        {
            SMLog(@"点击了 任务日程 按钮");
            SMTaskLogViewController *taskLogVc = [[SMTaskLogViewController alloc] init];
            [self.navigationController pushViewController:taskLogVc animated:YES];
        }
            break;
        case 8:
        {
            SMLog(@"点击了 签到 按钮");
            SMSignInViewController *signInVc = [[SMSignInViewController alloc] init];
            [self.navigationController pushViewController:signInVc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark -- 按钮点击跳转事件
- (void)partnerBtnClick{
    SMLog(@"点击了 伙伴连线 按钮");
//    SMPartnerConnectViewController *partnerVc = [[SMPartnerConnectViewController alloc] init];
    SMNewPartnerConnectViewController *partnerVc = [[SMNewPartnerConnectViewController alloc] init];
    [self.navigationController pushViewController:partnerVc animated:YES];
}

- (void)taskBtnClick{
    SMLog(@"点击了 任务日程 按钮");
    SMTaskLogViewController *taskLogVc = [[SMTaskLogViewController alloc] init];
    [self.navigationController pushViewController:taskLogVc animated:YES];
}

- (void)sellBtnClick{
    SMLog(@"点击了 订单管理 按钮");
//    SMSellLogTableViewController *sellLogVc = [[SMSellLogTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:sellLogVc animated:YES];
//    SMOrderManagerViewController * orderManager = [SMOrderManagerViewController new];
//    [self.navigationController pushViewController:orderManager animated:YES];
    SMNewOrderManagerViewController * orderManager = [SMNewOrderManagerViewController new];
    [self.navigationController pushViewController:orderManager animated:YES];
}

- (void)CustomerBtnClick{
    SMLog(@"点击了 客户管理按钮");
    SMCustomerManagerViewController *customerVc = [[SMCustomerManagerViewController alloc] init];
    [self.navigationController pushViewController:customerVc animated:YES];
}

- (void)customerOnlineBtnClick{
    SMLog(@"点击了 客服连线 按钮");
    SMCustomContactViewController *customVc = [[SMCustomContactViewController alloc] init];
    [self.navigationController pushViewController:customVc animated:YES];
}

- (void)signInBtnClick{
    SMLog(@"点击了 签到 按钮");
    SMSignInViewController *signInVc = [[SMSignInViewController alloc] init];
    [self.navigationController pushViewController:signInVc animated:YES];
}

-(void)discountCouponBtnClick
{
    SMLog(@"点击了 优惠劵兑换 按钮");
    SMDiscountCouponViewController * discount = [[SMDiscountCouponViewController alloc]init];
    [self.navigationController pushViewController:discount animated:YES];
}

-(void)CounterBtnClick
{
    SMLog(@"点击了 柜台管理 按钮");
    //跳转到柜台管理(原先的货架模板)
    SMShelfTemplateViewController *shelfVc = [[SMShelfTemplateViewController alloc] init];
    [self.navigationController pushViewController:shelfVc animated:YES];
}

-(void)RetailBtnClick
{
    SMLog(@"点击了 分销团队  按钮");
//    暂时还没有
#warning 没出效果图
    
}


- (void)setupNav{
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftIconBtn = leftItemBtn;
    leftItemBtn.width = 32;
    leftItemBtn.height = 22;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索栏
    SMSearchBar *searchBar = [SMSearchBar searchBar];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.returnKeyType = UIReturnKeySearch;
    
    //给搜索栏的显示长度做一个适配
    CGFloat width = 180;
    if (isIPhone5) {
        width = 210;
    }else if (isIPhone6){
        width = 270;
    }else if (isIPhone6p){
        width = 300;
    }
    searchBar.width = width;
    searchBar.height = 28;
    
    //self.navigationItem.titleView = searchBar;
    self.title = @"工作台";
    
    //二维码
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)leftItemDidClick:(UIButton *)btn{
    [self.searchBar resignFirstResponder];
    SMLog(@"点击了左上角的头像按钮  %@",[btn class]);
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击了扫描二维码
 */
- (void)scanerBtnDidClick{
    [self.searchBar resignFirstResponder];
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [self.searchBar resignFirstResponder];
        SMLog(@"点击了键盘的搜索键  ，执行搜索代码");
    }
    return YES;
}

//当搜索栏开始输入文字编辑的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
