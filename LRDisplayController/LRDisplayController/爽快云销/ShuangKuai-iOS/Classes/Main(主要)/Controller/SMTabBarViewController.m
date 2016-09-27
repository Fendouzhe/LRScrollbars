//
//  SMTabBarViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/9.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTabBarViewController.h"
#import "SMTabBarViewController.h"
#import "SMNavigationViewController.h"

#import "SMCareViewController.h"
#import "SMStoreHouseViewController.h"
#import "SMGoodsShelfViewController.h"
#import "SMCommunicateViewController.h"
#import "SMCircleHomeViewController.h"
#import "SMNewGoodsShelfViewController.h"
#import "SMPopularizeController.h"
#import "SMShoppingController.h"
#import "SMCounterController.h"
#import "SMHomePageController.h"
#import "SMNewHomePageController.h"
#import "SMScenePromotionController2.h"
#import "SMNewPromotionController.h"

#import "SMBindPhoneController.h"
#import "SMNavigationViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <RongIMKit/RongIMKit.h>
#import <AVIMClient.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>
#import "AppDelegate.h"
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>
#import "LocalAd.h"
#import "LocalNews.h"
#import "LocalUser.h"
#import "LocalTweet.h"
#import "LocalUser1.h"
#import "LocalCoupon.h"
#import "LocalCompany.h"
#import "LocalProduct.h"
#import "LocalWorkLog.h"
#import "LocalActivity.h"
#import "LocalBankCard.h"
#import "LocalCustomer.h"
#import "LocalCommission.h"
#import "LocalChatMessage.h"
#import "LocalChatMessageFrame.h"
#import "LocalCommissionLog.h"
#import "LocalConversation.h"
#import "LocalFavorites.h"
#import "LocalFavoritesDetail.h"
#import "LocalOrderProduct.h"
#import "LocalSalesOrder.h"
#import "LocalSchedule.h"
#import "LocalScheduleCompose.h"
#import "LocalSearchHistory.h"
#import "LocaltweetFrame.h"
#import "LocalStorehouse.h"
#import "SMLoginViewController.h"
#import "SMCareViewController.h"
#import "SingtonManager.h"
#import "BXTabBar.h"
#import "BXTabBarButton.h"

#define kTabbarHeight 49
#define guitai @"柜台"

@interface SMTabBarViewController ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,UITabBarControllerDelegate,BXTabBarDelegate>

@property (nonatomic, assign) NSInteger lastSelectIndex;
@property (nonatomic, strong) UIView *redPoint;
/** view */
@property (nonatomic, strong) BXTabBar *mytabbar;

@property (nonatomic, strong) id popDelegate;
/** 保存所有控制器对应按钮的内容（UITabBarItem）*/
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation SMTabBarViewController

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


/*!
 IMKit连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    SMLog(@"融云连接状态：%ld",(long)status);
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBar.hidden = YES;
//    // 把系统的tabBar上的按钮干掉
//    [self.tabBar removeFromSuperview];
//    // 把系统的tabBar上的按钮干掉
//    for (UIView *childView in self.tabBar.subviews) {
//        if (![childView isKindOfClass:[BXTabBar class]]) {
//            [childView removeFromSuperview];
//            
//        }
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    //自动登录情况需要重启服务器，添加授权访问服务器
    //[[SKAPI shared] resetting];
    //[[SKAPI shared] relist];

    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].connectionStatusDelegate = self;
//    //连接融云
//    [self connectRongCloud];
//    //连接个推
    [self connectGetuiNoti:nil];
    
    //初始化控制器
//    //SMCareViewController *homeVc = [[SMCareViewController alloc] init];
//    //SMHomePageController *homeVc = [[SMHomePageController alloc] init];
    SMNewHomePageController *homeVc = [[SMNewHomePageController alloc] init];
    [self addChildVc:homeVc title:@"分销" image:@"fenxiao-n" selectedImage:@"fenxiao-s"];

//    //SMPopularizeController *popularizeVc = [[SMPopularizeController alloc] init];
//    SMScenePromotionController2 *popularizeVc = [[SMScenePromotionController2 alloc] init];
    SMNewPromotionController *popularizeVc = [[SMNewPromotionController alloc] init];
    [self addChildVc:popularizeVc title:@"推广" image:@"tuiguan-n" selectedImage:@"tuiguan-s"];

    SMCounterController *shelfVc = [[SMCounterController alloc] init];
    [self addChildVc:shelfVc title:guitai image:@"shangcheng-nn" selectedImage:@"shangcheng-ss"];

    SMShoppingController *shoppingVc = [[SMShoppingController alloc] init];
    [self addChildVc:shoppingVc title:@"商城" image:@"shangcheng-n" selectedImage:@"shangcheng-s"];

//    SMCircleHomeViewController *circleVc = [[SMCircleHomeViewController alloc] init];
//    [self addChildVc:circleVc title:@"能量圈" image:@"shangji-n" selectedImage:@"shangji-s"];
    
    
    //[self logFont];
    //连接哥推通知监听 新版版添加启动视频后失效
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectGetuiNoti:) name:ConnectGetuiNotification object:nil];
    
//    //系统tabbar 显示场景推广红点通知监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSceneTabbarBageNoti:) name:ShowSceneTabbarBageNotification object:nil];
//    //移除场景推广红点通知监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSceneTabbarBageNoti:) name:RemoveSceneTabbarBageNotification object:nil];
    
    // 自定义tabBar
    [self setUpTabBar];
    
    
    
}

#pragma mark - 自定义tabBar
- (void)setUpTabBar {
    BXTabBar *tabBar = [[BXTabBar alloc] init];
    // 存储UITabBarItem
    tabBar.items = self.items;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_background"]];
    tabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabBar];
    //去掉tabBar分割线
    self.tabBar.backgroundImage = [[UIImage alloc]init];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    self.mytabbar = tabBar;
    //自定义Tabbar 显示消息红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbarBageNoti:) name:ShowTabbarBageNotification object:nil];
    //自定义Tabbar 移除消息红点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTabbarBageNoti:) name:RemoveTabbarBageNotification object:nil];
}

/** tabBarTag */
static NSInteger const BXTabBarTag = 12000;
///自定义Tabbar 显示消息红点
- (void)showTabbarBageNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    NSInteger index = [dict[@"index"] integerValue];
    BXTabBarButton *button = [self.mytabbar viewWithTag:index + BXTabBarTag];
    //[button showButtonBadge];
    button.badgeValue = @"1";//显示红点
}
///自定义Tabbar 移除消息红点
- (void)removeTabbarBageNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    NSInteger index = [dict[@"index"] integerValue];
    BXTabBarButton *button = [self.mytabbar viewWithTag:index + BXTabBarTag];
    //[button removeBadge];
    button.badgeValue = @"0";//隐藏红点
}

////显示场景推广红点
//- (void)showSceneTabbarBageNoti:(NSNotification *)notice{
//    [self.tabBar showBadgeOnItemIndex:1];
//
//}
////移除场景推广红点通知监听
//- (void)removeSceneTabbarBageNoti:(NSNotification *)notice{
//    [self.tabBar hideBadgeOnItemIndex:1];
//}

//输出字体
- (void)logFont{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        SMLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
            SMLog(@" Font name: %@",[fontNames objectAtIndex:indFont]);
        }  
    }
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    childVc.tabBarItem.title = title;
    //旧版--中间凸起
//    if ([title isEqualToString:guitai]) {
//        //设置tabBarItem 的图片
//        NSInteger width = 44;
//        childVc.tabBarItem.image = [[[UIImage imageNamed:image] scaleToSize:CGSizeMake(width, width)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        childVc.tabBarItem.selectedImage = [[[UIImage imageNamed:selectedImage] scaleToSize:CGSizeMake(width, width)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }else{
//        //设置tabBarItem 的图片
//        childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
    
    //设置tabBarItem 的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置tabBarItem 的字体
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = SMColor(27, 27, 40);
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = SMColor(193, 0, 25);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 记录所有控制器对应按钮的内容
    [self.items addObject:childVc.tabBarItem];
    // 先给外面传进来的小控制器 包装 一个导航控制器
    SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    
}

#pragma mark - BXTabBarDelegate方法
// 监听tabBar上按钮的点击
- (void)tabBar:(BXTabBar *)tabBar didClickBtn:(NSInteger)index
{
    [super setSelectedIndex:index];
    //self.selectedIndex = index;
}


/**
 *  让myTabBar选中对应的按钮
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    // 通过mytabbar的通知处理页面切换
    self.mytabbar.seletedIndex = selectedIndex;
}


///连接融云
- (void)connectRongCloud{
//    SMLoginViewController *vc = [[SMLoginViewController alloc] init];
//    [vc login];
    
    //这里先要判断  密码是否正确  再登录
    
    [[SKAPI shared] signInWithAccount:[[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount] andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret] andSocial:@"" block:^(id result, NSError *error) {
        
        //[[SKAPI shared] relist];
        
        if (!error) {
            User *user = [User mj_objectWithKeyValues:[result valueForKey:@"user"]];
            
            [[RCIM sharedRCIM] connectWithToken:user.rcToken success:^(NSString *userId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                    [RCIM sharedRCIM].currentUserInfo = userInfo;
                    //        [[RCIM sharedRCIM] setUserInfoDataSource:weakSelf];
                    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KUserChatID];
                });

                SMLog(@"融云连接成功 result = %@ error = %@",result,error);
            } error:^(RCConnectErrorCode status) {
                SMLog(@"融云连接错误 status = %lu  result = %@ error = %@",status,result,error);
            } tokenIncorrect:^{
                SMLog(@"token错误");
            }];
            //保存启动图片数据和视频路径
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.appLoginBg]];
            if (data) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:KAppLoginBgImage];
            }
            [[NSUserDefaults standardUserDefaults] setObject:user.appLoginVideo forKey:KAppLoginVideoUrl];
            
        }

    }];
}
///连接哥推
- (void)connectGetuiNoti:(NSNotification *)notice{
    //哥推等
    AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //NSString *geTuiClientId = notice.userInfo[@"geTuiClientId"];
    NSString *geTuiClientId = nil;
    if (appdelegate.geTuiClientId) {
        geTuiClientId = appdelegate.geTuiClientId;
    }else{
        geTuiClientId = notice.userInfo[@"geTuiClientId"];
    }
    SMLog(@"geTuiClientId = %@",geTuiClientId);
    //注册聊天的Client
    if (geTuiClientId) {
        [[SKAPI shared] bindClientId:geTuiClientId block:^(id result, NSError *error) {
            if (!error) {
                NSLog(@"哥推连接成功：%@",result);
            }else{
                NSLog(@"哥推连接失败：%@",error);
            }
        }];
    }
}


/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    //NSLog(@"currentThread = %@",[NSThread currentThread]);
    //子线程需要回到主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //工作台显示红点 系统tabBar
        //[self.tabBar showBadgeOnItemIndex:0];
        //自定义tabBar
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:self userInfo:@{@"index":@"0"}];
        if (message.conversationType == ConversationType_DISCUSSION) {
            //客服连线显示红点
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowBageNotification object:nil userInfo:@{@"tag":KKeFuLianXianTag}];
            
        }else{
            //伙伴连线显示红点
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowBageNotification object:nil userInfo:@{@"tag":KHuoBanLianXianTag}];
        }
        
    });
}




@end
