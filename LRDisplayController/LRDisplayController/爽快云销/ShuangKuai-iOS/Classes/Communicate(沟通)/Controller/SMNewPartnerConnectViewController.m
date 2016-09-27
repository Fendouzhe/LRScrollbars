//
//  SMNewPartnerConnectViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
/**
 *  伙伴连线控制器
 *
 */
#import "SMNewPartnerConnectViewController.h"
#import "SMTitleView.h"
#import "SMMessageListViewController.h"
#import "SMConnectPersonController.h"
#import "SMSearchButtonView.h"
#import "SMDropView.h"
#import "SMNewConnectPersonController.h"
#import "SMAddContactPersonViewController.h"
#import "SMScannerViewController.h"
#import "SMNewAddGroupChatViewController.h"
#import "TempAppShareObject.h"
#import "SMSearchViewController.h"
#import "SMLoginViewController.h"

@interface SMNewPartnerConnectViewController ()<SMDropViewDelegate,SMSearchButtonViewDelegate>
@property (nonatomic , strong) SMMessageListViewController *messageListViewController;/**< 消息列表 */

@property (nonatomic,strong) SMNewConnectPersonController *connectPersonController;/**< 联系人列表 */
@property (nonatomic ,strong)UIButton *rightBtn;
@property(nonatomic,strong)SMTitleView * titleView;
@property (nonatomic,strong) SMSearchButtonView *topView;/**< 顶部搜索框 */

@end

@implementation SMNewPartnerConnectViewController

-(SMSearchButtonView *)topView{
    if (_topView == nil) {
        _topView = [[SMSearchButtonView alloc] init];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}
#pragma mark --- SMSearchButtonViewDelegate
-(void)searchButtonClick{
    if (self.connectPersonController.view.hidden == YES) {
        //搜索聊天记录
        SMSearchViewController *vc = [[SMSearchViewController alloc] init];
        vc.categoryType = 10;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //搜索联系人
        SMSearchViewController *vc = [[SMSearchViewController alloc] init];
        vc.categoryType = 6;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageCountNoti:) name:UnreadMessageCountNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needPushGroupChatViewController) name:NeedPostGroupChatViewController object:nil];
    [self setupNav];
    [self setupUI];
    
    //会奔溃
//    SMLoginViewController *vc = [[SMLoginViewController alloc] init];
//    [vc login];
    
}


- (void)setupNav{
    //    self.title = @"伙伴连线";
    
    //自定义titleView
    SMTitleView * titleView = [SMTitleView CreatNavSwipTitleViewWithLeftTitle:@"消息" andRight:@"联系人" andViewController:self];
    self.titleView = titleView;
    [titleView leftBtnClickAction:^{
        SMLog(@"伙伴联系点击左边按钮");
        
        [titleView hiddenLeftSpot];
        
        self.messageListViewController.view.hidden = NO;
        
        self.connectPersonController.view.hidden = YES;
    }];
    [titleView rightBtnClickAction:^{
        SMLog(@"伙伴联系点击右边按钮");
        
        self.messageListViewController.view.hidden = YES;
        
        self.connectPersonController.view.hidden = NO;
    }];
    
    [titleView hiddenRightSpot];
    
    if (!self.isSearchPartner && !self.isSearchContact && !self.isSearchFriend) {
        //添加联系人
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjialianxirrenRed"] forState:UIControlStateNormal];
        rightBtn.width = 22;
        rightBtn.height = 22;
        self.rightBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    //针对搜索做的处理
    if (self.isSearchContact) {
        self.titleView.rightButton.selected = YES;
        self.titleView.leftButton.selected = NO;
        self.titleView.rightBlcok();
        self.titleView.hidden = YES;
        self.title = @"伙伴连线";
        self.topView.hidden = YES;
//        self.topConstraint.constant = -45;
    }
    
    if (self.isSearchPartner) {
        self.titleView.rightButton.selected = NO;
        self.titleView.leftButton.selected = YES;
        self.titleView.leftBlcok();
        self.titleView.hidden = YES;
        self.title = @"联系人";
//        self.topViewHeight.constant = 0;
        self.topView.hidden = YES;
//        self.topConstraint.constant = -45;
    }else if(!self.isSearchFriend){
//        [self requestFriend];
    }else{
        self.titleView.rightButton.selected = NO;
        self.titleView.leftButton.selected = YES;
        self.titleView.rightBlcok();
        self.titleView.hidden = YES;
        self.title = @"添加朋友";
//        self.topViewHeight.constant = 0;
        self.topView.hidden = YES;
//        self.topConstraint.constant = -45;
//        [self requestStrange];
    }
    
}

- (void)rightItemClick{
    SMLog(@"点击了 添加联系人");
    SMDropView *menu = [SMDropView menu];
    menu.delegate = self;
    
    //    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    //    vc.view.height = 44 *3;
    //    menu.contentController = vc;
    
    [menu showFrom:self.rightBtn];
}

- (void)setupUI{
    
    self.topView.backgroundColor = KControllerBackGroundColor;
//    if (isIPhone5) {
//        self.topViewHeight.constant = 45;
//    }else if (isIPhone6){
//        self.topViewHeight.constant = 45 *KMatch6Height;
//    }else if (isIPhone6p){
//        self.topViewHeight.constant = 45 *KMatch6pHeight;
//    }
//    self.searchBtn.layer.cornerRadius = SMCornerRadios;
//    self.searchBtn.clipsToBounds = YES;
    MJWeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(@(45*SMMatchWidth));
    }];
    
    //消息列表
    self.messageListViewController = [[SMMessageListViewController alloc] init];
    [self addChildViewController:self.messageListViewController];
    [self.view addSubview:self.messageListViewController.view];

    [self.messageListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    //联系人列表
    self.connectPersonController = [[SMNewConnectPersonController alloc] init];
    [self addChildViewController:self.connectPersonController];
    [self.view addSubview:self.connectPersonController.tableView];
    
    [self.connectPersonController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.messageListViewController.view);
    }];
    
    self.connectPersonController.view.hidden = YES;
    
}

#pragma mark -- 右上角View的点击事件代理
- (void)addBtnDidClick{
    SMLog(@"点击了 添加朋友");
    SMAddContactPersonViewController *addVc = [[SMAddContactPersonViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)deleteBtnDidClick{
    SMLog(@"点击了 扫一扫");
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)groupBtnDidClick{
    SMLog(@"点击了 发起群聊");
    //    SMAddGroupChatViewController *vc = [[SMAddGroupChatViewController alloc] init];
    SMNewAddGroupChatViewController *vc = [[SMNewAddGroupChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)unreadMessageCountNoti:(NSNotification *)notice{
    int count = [notice.userInfo[@"count"] intValue];
    if (count > 0) {
        [self.titleView showLeftSpot];
    }else{
        [self.titleView hiddenLeftSpot];
    }
}

-(void)needPushGroupChatViewController{
    UIViewController *vc = (UIViewController *)[TempAppShareObject shareInstance].tempGroupVC;
    [self.navigationController pushViewController:vc animated:YES];
    [TempAppShareObject shareInstance].tempGroupVC = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
