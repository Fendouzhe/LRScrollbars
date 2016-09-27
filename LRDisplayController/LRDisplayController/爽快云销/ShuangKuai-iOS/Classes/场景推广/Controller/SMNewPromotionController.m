//
//  SMNewPromotionController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/19.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewPromotionController.h"
#import "SMScannerViewController.h"

#import "SMTogetherBuyController.h"
#import "SMSeckillListController.h"
#import "EventInvitationsViewController.h"
#import "SMArticleController.h"
#import "SMPosterListVc.h"
#import "SMArticleListController.h"
#import "SMTogetherBuyWebVc.h"
#import "SMSeckillWebController.h"
#import "SMActiveWebVc.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "SMNewPersonInfoController.h"
#import "SMLeftItemBtn.h"
#import "LRDisplayTitleLabel.h"
#import "SMTuiDataWebController.h"
#import "SMTogetherBuy2Controller.h"

@interface SMNewPromotionController ()

@property (nonatomic ,strong)SMLeftItemBtn *leftItemBtn;

@end

@implementation SMNewPromotionController


//场景推送本地消息点击
- (void)scenePromotionNewMessageNoti:(NSNotification *)notice{
    
    NSDictionary *dict = notice.userInfo;
    if ([dict[@"type"] integerValue] == KPingTuan_71) {
        //拼团
        SMTogetherBuyWebVc *vc = [[SMTogetherBuyWebVc alloc] init];
        vc.pId = dict[@"id"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if ([dict[@"type"] integerValue] == KMiaoSha_72) {
        //秒杀
        SMSeckillWebController *vc = [[SMSeckillWebController alloc] init];
        vc.pId = dict[@"id"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([dict[@"type"] integerValue] == KHuoDongYaoQing_73) {
        //活动邀请
        SMActiveWebVc *vc = [[SMActiveWebVc alloc] init];
        vc.pId = dict[@"id"];
        vc.titleName = @"活动邀请";
        [self.navigationController pushViewController:vc animated:NO];
    }
}

///获取场景推广未读推送消息
- (void)unreadPushMessage{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDataArr.count>0) {
        //系统tabbar 显示场景推广tabbar红点
        //[[NSNotificationCenter defaultCenter] postNotificationName:ShowSceneTabbarBageNotification object:nil userInfo:nil];
        //自定义tabbar
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }
    [appDelegate.pushDataArr enumerateObjectsUsingBlock:^(PushModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        switch (model.type) {
                
            case KPingTuan_71:{//拼团有新产品上架
                //旧
                //[[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KPingTuanPage}];
                //新
                LRDisplayTitleLabel *label = (LRDisplayTitleLabel *)self.titleLabels[KNewPingTuanPage];
                [label showBadge];
            }
                break;
            case KMiaoSha_72:{//秒杀有新产品上架
                //旧
                //[[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KMiaoShaPage}];
                //新
                LRDisplayTitleLabel *label = (LRDisplayTitleLabel *)self.titleLabels[KNewMiaoShaPage];
                [label showBadge];
                
            }
                break;
            case KHuoDongYaoQing_73:{//有新的活动邀请
                //旧
                //[[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KHuoDongYaoQingPage}];
                //新
                LRDisplayTitleLabel *label = (LRDisplayTitleLabel *)self.titleLabels[KNewHuoDongYaoQingPage];
                [label showBadge];
                
            }
            default:
                break;
        }
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"场景营销";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self setup];
    
    [self setupNav];
    
    //监听本地通知点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scenePromotionNewMessageNoti:) name:ScenePromotionNewMessageNotification object:nil];
    
    //添加滚动标题栏消息红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTitleScrollViewTitleBageNoti:) name:AddTitleScrollViewTitleBageNotification object:nil];
    //移除滚动标题栏消息红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTitleScrollViewTitleBageNoti:) name:RemoveTitleScrollViewTitleBageNotification object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取本地存储的远程推送通知
    [self unreadPushMessage];
}

- (void)setup{
    
    self.isfullScreen = NO;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    //添加所有子控制器
    [self setUpAllViewController];
    
    self.normalColor = KBlackColorLight;
    self.selectColor = KRedColorLight;
    self.selectIndex = 0;
}

- (void)setupNav{
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftItemBtn = leftItemBtn;
    CGFloat wh;
    if (isIPhone5) {
        wh = KIconWH;
    }else if (isIPhone6){
        wh = KIconWH *KMatch6;
    }else if (isIPhone6p){
        wh = KIconWH * KMatch6p;
    }else if (KScreenHeight == 480){
        wh = KIconWH;
    }
    
    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //推广数据
    UIBarButtonItem *shuju = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tuiData"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(tuiDataButtnClick)];
    //二维码扫描
    UIBarButtonItem *saoMiao = [[UIBarButtonItem alloc] initWithImage:[[[UIImage imageNamed:@"saomiaoGray"] scaleToSize:ScaleToSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanerBtnDidClick)];
    self.navigationItem.rightBarButtonItems = @[shuju,saoMiao];
}



///移除滚动标题栏消息红点
- (void)removeTitleScrollViewTitleBageNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    NSInteger index = [dict[@"index"] integerValue];
    LRDisplayTitleLabel *label = (LRDisplayTitleLabel *)self.titleLabels[index];
    [label removeBadge];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDataArr.count == 0) {
        //移除自定义Tabbar 场景推广 Tabbar消息红点  
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }
}
///添加滚动标题栏消息红点
- (void)addTitleScrollViewTitleBageNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    NSInteger index = [dict[@"index"] integerValue];
    LRDisplayTitleLabel *label = (LRDisplayTitleLabel *)self.titleLabels[index];
    [label showBadge];
    
    [self unreadPushMessage];
}

///点击了左上角的头像按钮
- (void)leftItemDidClick:(UIButton *)leftBtn{
    //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
///点击了扫描二维码的按钮
- (void)scanerBtnDidClick{
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

///推广数据按钮点击
- (void)tuiDataButtnClick{
    SMTuiDataWebController *vc = [[SMTuiDataWebController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 添加所有子控制器
- (void)setUpAllViewController{

    //SMTogetherBuyController *wordVc1 = [[SMTogetherBuyController alloc] init];
    SMTogetherBuy2Controller *wordVc1 = [[SMTogetherBuy2Controller alloc] init];
    wordVc1.title = @"拼团促销";
    [self addChildViewController:wordVc1];
    
    EventInvitationsViewController *wordVc3 = [[EventInvitationsViewController alloc] init];
    wordVc3.title = @"活动邀请";
    [self addChildViewController:wordVc3];
    
    SMSeckillListController *wordVc2 = [[SMSeckillListController alloc] init];
    wordVc2.title = @"秒杀抢购";
    [self addChildViewController:wordVc2];
    
    SMArticleListController *wordVc4 = [[SMArticleListController alloc] init];
    wordVc4.title = @"微文传播";
    [self addChildViewController:wordVc4];
    
    SMPosterListVc *wordVc5 = [[SMPosterListVc alloc] init];
    wordVc5.title = @"海报推广";
    [self addChildViewController:wordVc5];
    
}



@end
