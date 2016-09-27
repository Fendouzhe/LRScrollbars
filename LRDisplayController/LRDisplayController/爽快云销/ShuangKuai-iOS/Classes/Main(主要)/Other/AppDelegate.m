//
//  AppDelegate.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 11/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "AppDelegate.h"
#import "SMLoginViewController.h"
#import "SMNavigationViewController.h"
#import "UIWindow+Extension.h"
#import <MagicalRecord/MagicalRecord.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
                       
#import <Pingpp.h>
#import <AVOSCloud/AVOSCloud.h>

////bugtags SDK 头文件
//#import <Bugtags/Bugtags.h>

//bugly
#import <Bugly/Bugly.h>
#import <Bugly/BuglyConfig.h>

//检查更新第三方
#import <Harpy.h>

#import "SMTaskLogViewController.h"

#import "UIBarButtonItem+Extension.h"


#import <GTSDK/GeTuiSdk.h>
//#import "GeTuiSdk.h"

#import "SMPlaySound.h"
#import "SMPartnerConnectViewController.h"

//个推  
#define KAppId @"YQilu3YWaY8JCwjmzHIAHA"
#define KAppKey @"O7ZQJrsrEZ5x3741GQwOb8"
#define KAppSecret @"neZvcefRfJ7ejy9lpInlz2"

#import <AFNetworking.h>
#import "CustomNotView.h"
#import "SingtonManager.h"

#import <RongIMKit/RongIMKit.h>

#import "Aspects.h"
#import "NSDictionary+JsonToString.h"

#ifndef __OPTIMIZE__
#import "RRFPSBar.h"
#endif

#import "SMTogetherBuyWebVc.h"
#import "SMActiveWebVc.h"
#import "SMSeckillWebController.h"

#import "SMNewPersonInfoController.h"
#import "SMProductTool.h"
#import "LocalHotProductTool.h"


@interface AppDelegate ()<UIAlertViewDelegate,GeTuiSdkDelegate,HarpyDelegate>

//本地推送提醒
@property(nonatomic,strong)UIAlertView * localalertView;

//远程推送的提醒
@property(nonatomic,strong)UIAlertView * apnsAlertView;


@property(nonatomic,assign)BOOL isAPNs;

@property(nonatomic,strong)SMNavigationViewController *nav;

@end

@implementation AppDelegate

- (SMTabBarViewController *)tabbar{
    if (_tabbar == nil) {
        _tabbar = [[SMTabBarViewController alloc] init];
    }
    return _tabbar;
}

- (NSMutableArray *)pushDataArr{
    if (_pushDataArr == nil) {
        _pushDataArr = [NSMutableArray array];
    }
    return _pushDataArr;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //帧率Label
#ifndef __OPTIMIZE__
#ifdef DEBUG
//    [[RRFPSBar sharedInstance] setHidden:NO];
#endif
#endif
    
    [self.window switchRootViewController];
    //测试
    //self.window.rootViewController = [[SMNavigationViewController alloc] initWithRootViewController:[SMNewPersonInfoController new]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"save.sqlite"];
    
    [NSDictionary aspect_hookSelector:NSSelectorFromString(@"weibosdk_WBSDKJSONString")
                                withOptions:AspectPositionInstead
                                usingBlock:^(id<AspectInfo> info)
    {
                return [(NSDictionary*)[info instance] dictionaryToJson];
    }
                                     error:nil];
    
    //加入分享代码
    [ShareSDK registerApp:@"e46917d44dfc"//@"bb99d97d7830"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo://微博
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat://微信
                 [appInfo SSDKSetupWeChatByAppId:@"wxcd3e446097afd2e7"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
             case SSDKPlatformTypeQQ://qq
                 [appInfo SSDKSetupQQByAppId:@"1105226969"//@"1105013093"
                                      appKey:@"BAtgNmYosCFnsBvK"//@"WoWiRqqEAei992UQ"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

    
    //聊天
    [AVOSCloud setApplicationId:@"J3vvyVr4XSdwsuqeyNYsQ3X4"
                      clientKey:@"iosPcUgnKRn0KmwtjveJSIkC"];
    
//    [AVIMClient setUserOptions:@{
//                                 AVIMUserOptionUseUnread: @(YES)
//                                 }];
    //AVOSCloudCrashRep
    
//    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    
//    [AVOSCloud setLastModifyEnabled:YES];
    
    
    [[RCIM sharedRCIM] initWithAppKey:KRongTokenStr];
    //设置头像
//    CGFloat width = 48;
//    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(width, width);
//    [RCIM sharedRCIM].portraitImageViewCornerRadius = width * 0.5;
//    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(width, width);
    //聊天会话列表头像圆形
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //聊天界面头像圆形
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //设置接收消息代理
    //[RCIM sharedRCIM].receiveMessageDelegate = self;
    
//    BugtagsOptions *options = [[BugtagsOptions alloc] init];
//    options.trackingCrashes = YES; // 具体可设置的属性请查看 Bugtags.h
//    [Bugtags startWithAppKey:@"4f60c668a0dd3ba0f97c03e55ccc2df4" invocationEvent:BTGInvocationEventNone options:options];
    
    //bug 第三方集成
//    BuglyConfig * buglyCon = [BuglyConfig  defaultConfig];
    //非正常退出开关打开
//    buglyCon.unexpectedTerminatingDetectionEnable = YES;
//    [Bugly startWithAppId:@"900021825" config:buglyCon];
    [Bugly startWithAppId:@"900021825" config:nil];
    
    //[self performSelector:@selector(crash) withObject:nil afterDelay:3.0];
    
    //接收到本地通知
    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo= notification.userInfo;
    SMLog(@"userInfo = %@",userInfo);
    

    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:KAppId appKey:KAppKey appSecret:KAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
//    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
    self.isAPNs = NO;
    
    //监听网络
    [self monitorHttp];
    
    
    //为了更好的用户体验，在走网络请求的时候，我们会在顶部加以提示：
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //测试场景推广推送红点显示及pageControl页码动画
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:ShowSceneTabbarBageNotification object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KPingTuanPage}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KHuoDongYaoQingPage}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KMiaoShaPage}];
//        
//        //创建本地推送
//        [self setupSceneLocalNot:@"拼团有新商品上架啦!" type:71 activeId:@"6a3ee0d537464be5a00f78951b46f2e2"];
//        [self setupSceneLocalNot:@"有新秒杀活动啦!" type:72 activeId:@"8e1e18fe5b8e4607bf5f464f9eb19cd7"];
//        [self setupSceneLocalNot:@"有新活动邀请啦!" type:73 activeId:@"91fbe6eda3254ddebeebf27123320411"];
//        //这个是测试的那个红色提示横条
//        CustomNotView * not = [[CustomNotView alloc]init];
//        [not showBody:@"有新消息啦!"];
//    });

    
    ///测试2 推送通知本地存储
//    for (int i = 1; i <= 3; ++i) {
//        PushModel *model = [[PushModel alloc] init];
//        model.type = 70 + i;
//        [self.pushDataArr addObject:model];
//    }
    
    ///删除已读推送消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeReadedPushMessageNoti:) name:RemoveReadedPushMessageNotification object:nil];
    
    return YES;
}
///删除已读的推送消息通知监听
- (void)removeReadedPushMessageNoti:(NSNotification *)notice{
    NSDictionary *dict = notice.userInfo;
    NSInteger type = [dict[@"type"] integerValue];
    [self.pushDataArr enumerateObjectsUsingBlock:^(PushModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.type == type) {
            [self.pushDataArr removeObject:model];
        }
    }];
    if (self.pushDataArr.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }
    [self.pushDataArr enumerateObjectsUsingBlock:^(PushModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        SMLog(@"剩余推送消息model.type = %lu",model.type);
    }];
}

///*!
// 接收消息的回调方法
// 
// @param message     当前接收到的消息
// @param left        还剩余的未接收的消息数，left>=0
// 
// @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
// 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
// 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
// */
//- (void)onRCIMReceiveMessage:(RCMessage *)message
//                        left:(int)left{
//}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //[[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动 --》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //TODO: 添加远程推送跳转
    if (userInfo) {
        SMLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
        
        //    SMPartnerConnectViewController * vc = [SMPartnerConnectViewController new];
        
        //    if (notificationPayload) {
        //        //从leancloud 推送过来的消息
        //        //需要刷新内存数据
        //        //换了账号  清除聊天记录列表
        //        //[vc requestData];
        //        [self.notesViewController.navigationController pushViewController:vc animated:YES];
        //    }
    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //注册个推
    [GeTuiSdk registerDeviceToken:myToken];
    
    self.deviceToken = deviceToken;
    
    //注册AVOS
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    //融云
    [[RCIMClient sharedRCIMClient] setDeviceToken:myToken];
    
    SMLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [GeTuiSdk registerDeviceToken:@""];
    
    SMLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    SMLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 不管是前台还是后台  leancloud都在这有接收到新消息提示
    //问题来了  怎么区分是后台点击进入 或者是直接前台接收到   如果是前台接收到只做提示  不跳转  后台接收到 跳转到对话界面 并都拉取新收据
    
    //static NSInteger i=0;
    SMLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    application.applicationIconBadgeNumber = 0; // 标签
    
    
    self.isAPNs = YES;
    
//     SMPartnerConnectViewController * vc = [SMPartnerConnectViewController new];
    
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        //从leancloud 推送过来的消息
        //需要刷新内存数据
        //换了账号  清除聊天记录列表
        if (application.applicationState == UIApplicationStateActive) {
            //前台不跳转，震动提示
//            SMPlaySound *playSound =[[SMPlaySound alloc] initForPlayingVibrate];
//            [playSound play];
            //[vc requestData];
            
        }else{
            //跳转
            //[vc requestData];

//            if (![self.notesViewController isKindOfClass:[SMPartnerConnectViewController class]]) {
//                [self.notesViewController.navigationController pushViewController:vc animated:YES];
//            }
            
        }
        
    }else{
        //从个推推过的数据
            if ([userInfo[@"aps"][@"alert"][@"body"] integerValue] == 401) {
                    self.apnsAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此账号在其他设备上登录,如非本人操作,请修改密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [self.apnsAlertView show];
                
//            AppDelegate * appde = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [appde.client closeWithCallback:^(BOOL succeeded, NSError *error) {
//                    if (!error) {
//                        SMLog(@"%zd",succeeded);
//                    }else{
//                        SMLog(@"%@",error);
//                    }
//                }];
                
                }else{
                    //样式可以自定义
                    self.apnsAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"][@"body"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [self.apnsAlertView show];
        }
    }
  
}

//#pragma mark - GeTuiSdkDelegate
/**
 *  SDK登入成功返回clientId
 *
 *  @param clientId 标识用户的clientId
 *  说明:启动GeTuiSdk后，SDK会自动向个推服务器注册SDK，当成功注册时，SDK通知应用注册成功。
 *  注意: 注册成功仅表示推送通道建立，如果appid/appkey/appSecret等验证不通过，依然无法接收到推送消息，请确保验证信息正确。
 */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    SMLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appdelegate.geTuiClientId = clientId;
    
    //添加企业图片及宣传视频后失效（SMTabarViewController还未被创建，如果企业没有企业图片及宣传视频则有效）
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectGetuiNotification object:nil userInfo:@{@"geTuiClientId":clientId}];
    
//    [[SKAPI shared] bindClientId:appdelegate.geTuiClientId block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"%@",result);
//        }else{
//            SMLog(@"%@",error);
//        }
//    }];
    
}

/**
 *  SDK遇到错误消息返回error
 *
 *  @param error SDK内部发生错误，通知第三方，返回错误
 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    SMLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/**
 *  SDK通知收到个推推送的透传消息
 *
 *  @param payloadData 推送消息内容
 *  @param taskId      推送消息的任务id
 *  @param msgId       推送消息的messageid
 *  @param offLine     是否是离线消息，YES.是离线消息
 *  @param appId       应用的appId
 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息

    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    //>>>[GexinSdk ReceivePayload]:taskId=OSL-0824_vKUVUIs1qd67M2X6WH2dh2,messageId:d09057a1fbba4ff9ae4f30e826e83642,payloadMsg:{"body":"6a3ee0d537464be5a00f78951b46f2e2","description":"拼团有新产品上架","type":71}
    //>>>[GexinSdk ReceivePayload]:taskId=OSL-0824_muaaai45zf71JHrIG38a77,messageId:b1e9f88c15104d929b4afeb2e12f1938,payloadMsg:{"body":"8096b747177541afae3b2e794b8ad62e","description":"有新的活动邀请","type":73}
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    SMLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    //SMLog(@"currentThread = %@",[NSThread currentThread]);//{number = 1, name = main} 
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
//    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
    
    //消息来了  发送通知刷新unread
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUnreadNotification object:nil];
    
    PushModel * model = [PushModel mj_objectWithKeyValues:payloadMsg];
    //场景推广的拼团，秒杀，活动邀请通知存储
    if (model.type == 71 || model.type == 72 || model.type == 73) {
        [self.pushDataArr addObject:model];
    }
    //解析出模型  按照type  进行判断处理
    SMLog(@"model.type = %zd model.description = %@ model.mydescription = %@",model.type,model.description,model.mydescription);
    switch (model.type) {
        case 401:{
            //为账号在其他的地方登陆
            self.apnsAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此账号在其他设备上登录,如非本人操作,请修改密码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.apnsAlertView show];
            
        }
            
            break;
        case PushType_Tweet:{
            //有爽快圈内容
        }
            
            break;
        case PushType_Tweet_Comment:{
            //爽快圈评论
        }
            
            break;
        case PushType_Tweet_Upvote:{
            //爽快圈点赞
        }
            
            break;
        case PushType_Tweet_Repost:{
            //爽快圈转发
        }
            
            break;
        case 10:{
            //新的订单
//            NSArray * array = [NSDictionary mj_keyValuesArrayWithObjectArray:@[model]];
//            NSDictionary * dic = [array lastObject];
            //创建本地推送
            [self setupLocalNot:@"您有一条新的订单生成" andType:10];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc]init];
            [not showBody:@"您有一条新订单生成"];
        }
            
            break;
        case 11:{
            //新的订单
            //            NSArray * array = [NSDictionary mj_keyValuesArrayWithObjectArray:@[model]];
            //            NSDictionary * dic = [array lastObject];
            //创建本地推送
            [self setupLocalNot:@"您有一条订单被关闭" andType:11];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc]init];
            [not showBody:@"您有一条订单被关闭"];
        }
            
            break;
        case 12:{
            //新的订单
            //            NSArray * array = [NSDictionary mj_keyValuesArrayWithObjectArray:@[model]];
            //            NSDictionary * dic = [array lastObject];
            //创建本地推送
            [self setupLocalNot:@"您有一条订单已发货" andType:12];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc]init];
            [not showBody:@"您有一条订单已发货"];
        }
            
            break;
        case 30:{//请求添加好友验证
            //创建本地推送
            [self setupLocalNot:@"请求添加好友验证" andType:30];
            
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请求添加好友验证" message:dic[@"remark"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"通过" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //执行通过好友申请
                [self agreeFirend:1 and:dic[@"userA"]];
            }];
            // 创建按钮
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                // 点击按钮后的方法直接在这里面写
                [self agreeFirend:0 and:dic[@"userA"]];
            }];
            UIAlertAction *overLookAction = [UIAlertAction actionWithTitle:@"忽略" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [alertController addAction:overLookAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case 31:{//添加好友失败
            //创建本地推送
            [self setupLocalNot:@"添加好友失败" andType:31];
            
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加好友失败" message:dic[@"name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            }];

            [alertController addAction:okAction];
          
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case 32:{//添加好友成功
            //创建本地推送
            [self setupLocalNot:@"添加好友成功" andType:32];
            
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加好友成功" message:dic[@"name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
            }];

            [alertController addAction:okAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case 40:{//新的团队任务
            //创建本地推送
            [self setupLocalNot:@"新的团队任务" andType:40];
            
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新的团队任务" message:dic[@"title"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //跳转到任务界面
            }];
            // 创建按钮
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {}];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case 41:{//团队任务进度更新
            //创建本地推送
            [self setupLocalNot:@"团队任务进度更新" andType:41];
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"团队任务进度更新" message:dic[@"title"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //跳转到任务界面
            }];
            // 创建按钮
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                // 点击按钮后的方法直接在这里面写
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case 42:{//新的任务提醒
            //创建本地推送
            [self setupLocalNot:@"新的任务提醒" andType:42];
            NSDictionary * dic = (NSDictionary *)model.body;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新的任务提醒" message:dic[@"title"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //跳转到任务界面
            }];
            // 创建按钮
            // 注意取消按钮只能添加一个
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                // 点击按钮后的方法直接在这里面写
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
            
            break;
        case -1:{
           //获取首页 循环播放的消息--废弃
//            NSDictionary * dic = (NSDictionary *)model.body;
//            Msg * msg = [Msg new];
//            msg.content = dic[@"content"];
//            [self.OneVC.adArray insertObject:msg atIndex:0];
//            [self.OneVC.tableView reloadData];
        }
            
            break;
        case 50:{
            //产品下架咯
            //创建本地推送
            [self setupLocalNot:@"您的微柜台有一件产品下架了" andType:50];
            NSDictionary * dic = (NSDictionary *)model.body;
            if (![(NSString *)model.body length]) {
                dic = @{
                        @"title" : @"空信息"
                        };
            }
//            if ([dic objectForKey:@"title"]) {  //objectForKey will return nil if a key doesn't exists.
//                
//                dic = @{
//                        @"title" : @"空信息"
//                        
//                        };
//                // contains key
//            }
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您的微柜台有一件产品下架了" message:dic[@"title"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:okAction];
            
            [self.notesViewController presentViewController:alertController animated:YES completion:nil];
        }
        case KPingTuan_71:{//拼团有新产品上架
            //显示场景推广tabbar红点
            //[[NSNotificationCenter defaultCenter] postNotificationName:ShowSceneTabbarBageNotification object:nil userInfo:nil];
            //自定义Tabbar
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
            //显示场景推广内部模块pageControl动画
            [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KPingTuanPage}];
            //显示场景推广滚动标题栏消息点
            [[NSNotificationCenter defaultCenter] postNotificationName:AddTitleScrollViewTitleBageNotification object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%d",KNewPingTuanPage]}];
            
            //创建本地推送
            [self setupSceneLocalNot:model.mydescription type:71 activeId:model.body];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc] init];
            [not showBody:model.mydescription];
        }
            break;
        case KMiaoSha_72:{//秒杀有新产品上架
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KMiaoShaPage}];
            //显示场景推广滚动标题栏消息点
            [[NSNotificationCenter defaultCenter] postNotificationName:AddTitleScrollViewTitleBageNotification object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%d",KNewMiaoShaPage]}];
            //创建本地推送
            [self setupSceneLocalNot:model.mydescription type:72 activeId:model.body];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc] init];
            [not showBody:model.mydescription];
        }
            break;
        case KHuoDongYaoQing_73:{//有新的活动邀请
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KHuoDongYaoQingPage}];
            //显示场景推广滚动标题栏消息点
            [[NSNotificationCenter defaultCenter] postNotificationName:AddTitleScrollViewTitleBageNotification object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%d",KNewHuoDongYaoQingPage]}];
            //创建本地推送
            [self setupSceneLocalNot:model.mydescription type:73 activeId:model.body];
            //这个是测试的那个红色提示横条
            CustomNotView * not = [[CustomNotView alloc] init];
            [not showBody:model.mydescription];

        }
            break;
        default:
            break;
    }
    
}
/**
 *  SDK通知发送上行消息结果，收到sendMessage消息回调
 *
 *  @param messageId “sendMessage:error:”返回的id
 *  @param result    成功返回1, 失败返回0
 *  说明: 当调用sendMessage:error:接口时，消息推送到个推服务器，服务器通过该接口通知sdk到达结果，result为 1 说明消息发送成功
 *  注意: 需第三方服务器接入个推,SendMessage 到达第三方服务器后返回 1
 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    SMLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/**
 *  SDK运行状态通知
 *
 *  @param aStatus 返回SDK运行状态
 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    SMLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/**
 *  SDK设置关闭推送模式回调
 *
 *  @param isModeOff 关闭模式，YES.服务器关闭推送功能 NO.服务器开启推送功能
 *  @param error     错误回调，返回设置时的错误信息
 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        SMLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    SMLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //后台运行
    //AppDelegate * appde = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //前台运行
    
//    AppDelegate * appde = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appde.client openWithCallback:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            SMLog(@"%zd",succeeded);
//        }else{
//            SMLog(@"%@",error);
//        }
//    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [MagicalRecord cleanUp];
    
}



#pragma mark - 接收本地通知
//应用在前台时调用 --- 接收或者点击本地消息都会调用该方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    SMLog(@"Application did receive local notifications---%@",notification.userInfo);
    //应用在前台时
//    if (application.applicationState == UIApplicationStateInactive) {
//        
//    }
    
//     //取消某个特定的本地通知
//    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//        NSString *notiID = noti.userInfo[@"Name"];
//        NSString *receiveNotiID = notification.userInfo[@"Name"];
//        if ([notiID isEqualToString:receiveNotiID]) {
//            [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            return;
//        }
//    }
//    self.localalertView  = [[UIAlertView alloc] initWithTitle:@"任务日程" message:  notification.userInfo[@"Name"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//    [self.localalertView show];
    
    //NSLog(@"type = %@ fireDate = %@  currentDate = %@",notification.userInfo[@"type"],notification.fireDate,[NSDate date]);

    NSDictionary *dict = notification.userInfo;
//    NSString *sfiredateformat=[NSMutableString stringWithString:dict[@"firedateformat"]];
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:sfiredateformat];
    //用户点击了
    //if([[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] timeIntervalSinceDate:notification.fireDate]>1){
        //当前时间大于接收到通知的时间说明是用户点击了本地通知，在这里进行界面跳转
    if([[NSDate date] timeIntervalSinceDate:notification.fireDate]>1){
        {
//        if ([dict[@"type"] integerValue] == 71) {
//            //拼团
//            SMTogetherBuyWebVc *vc = [[SMTogetherBuyWebVc alloc] init];
//            SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
//            vc.pId = dict[@"id"];
//            vc.isPush = YES;
//            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//            
//        }else if ([dict[@"type"] integerValue] == 72) {
//            //秒杀
//            SMSeckillWebController *vc = [[SMSeckillWebController alloc] init];
//            SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
//            vc.pId = dict[@"id"];
//            vc.isPush = YES;
//            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//        }else if ([dict[@"type"] integerValue] == 73) {
//            //活动邀请
//            SMActiveWebVc *vc = [[SMActiveWebVc alloc] init];
//            SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
//            vc.pId = dict[@"id"];
//            vc.isPush = YES;
//            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
//        }
        }
        //选中场景推广让控制器创建才能接收通知
        SMTabBarViewController *tabarVc = (SMTabBarViewController *)self.window.rootViewController;
        tabarVc.selectedIndex = 1;
        //需要延时控制器才能进行跳转
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ScenePromotionNewMessageNotification object:nil userInfo:dict];
        });
        
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == self.localalertView) {
        //本地推送事件
        if (buttonIndex == 0) {
            //这边做相应的跳转
            //如果不是当前页面就跳转
            if (![self.notesViewController isKindOfClass:[SMTaskLogViewController class]]) {
                SMTaskLogViewController * vc = [SMTaskLogViewController new];
                
                AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [application.notesViewController.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (alertView == self.apnsAlertView){
        if (buttonIndex == 0) {
            
//            [[SKAPI shared] signOut:^(id result, NSError *error) {
//                if (!error) {
//                    SMLog(@"退出帐号result = %@",result);
////            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat]; //取消微信登录授权
//                    [[RCIM sharedRCIM] disconnect:NO];
//
//                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSecret];
//                    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
//                    SMLoginViewController *logVc = [[SMLoginViewController alloc] init];
//                    SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:logVc];
//
////                    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
////                    [application.notesViewController presentViewController:vc animated:YES completion:nil];
//
//                    self.window.rootViewController = nav;
//                    
//                }else{
//                    
//                    SMLog(@"退出帐号 失败 error = %@",error);
//                }
//            }];
            
            //重新写入版本
            NSString *key = @"CFBundleVersion";
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            
            [[RCIM sharedRCIM] disconnect:NO];
            
            [self deleteFMDB];
            
            [self deleteCach];
            
            //清除商品数据
            [SMProductTool deleteData:nil];
            [LocalHotProductTool deleteData:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAppLoginBgImage];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAppLoginVideoUrl];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KAccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KRefreshToken];
            
            //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserAccount];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSecret];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
            
            //存头像
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIcon];
            //是否已签协议
            //[[NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"KUserIsSigned"];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserInfo];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserTelephoneNum];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserWorkPhone];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserID];
            //保存公司id
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyId];
            //保存公司名字
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyName];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserEngCompanyName];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserCompanyAddress];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserName];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUSerComPanyLogoPath];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserSex];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserIndustry];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserChatToken];
            ///当前柜台id
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfName];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KCurrentShelfBgImage];
            
            SMLoginViewController *logVc = [[SMLoginViewController alloc] init];
            SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:logVc];
            self.window.rootViewController = nav;
 
        }
        
    }else{
        
        if (buttonIndex == 0) {
            
        }else{
            //打开系统网络设置
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
    
}

 
- (void)deleteFMDB{  //删除置顶路径的某个指定文件   这里删除的是数据库文件 /Users/yuzhongkeji/Library/Developer/CoreSimulator/Devices/281BCDA2-A81C-4838-BEEE-EC23F6886BF6/data/Containers/Data/Application/E68CEEE1-8617-4ACB-A588-19568AEDB4CB/Documents/my.sqlite
 
     NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
     
     NSFileManager *fileMgr = [NSFileManager defaultManager];
     [fileMgr removeItemAtPath:filePath error:NULL];
 }
 
- (void)deleteCach{  //删除 指定文件夹下面的所有文件夹 （这里删除的是 图片缓存 cach，这个只能删除次文件夹下的文件夹 ，如果是具体的某个文件 ，删不了，例如 xxx.plist）
 
     NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
 
     NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
 
     SMLog ( @"cachpath = %@" , cachPath);
 
     for ( NSString * p in files) {
 
     NSError * error = nil ;
 
     NSString * path = [cachPath stringByAppendingPathComponent :p];
 
      if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
 
         [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
 
      }
 
   }

 }

 
 

//监听网络状态
-(void)monitorHttp{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                [MBProgressHUD showError:@"未识别的网络"];

            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:{
//                [MBProgressHUD showError:@"不可达的网络(未连接)"];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"似乎已断开与网络的连接,请检查网络设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                SMLog(@"2G,3G,4G...的网络");
                [MBProgressHUD showSuccess:@"2G,3G,4G...的网络"];
                //检查更新
                //[[Harpy sharedInstance] checkVersion];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                SMLog(@"wifi的网络");
                [MBProgressHUD showSuccess:@"wifi的网络"];
                //检查更新
                //[[Harpy sharedInstance] checkVersion];
            }
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
}
//同意好友添加请求
-(void)agreeFirend:(NSInteger)status and:(NSString *)userId{
    
    [[SKAPI shared] acceptFriend:userId andMemo:@"" andStatus:status block:^(id result, NSError *error) {
            if (!error) {
//                //发通知给好友列表页面，让它刷新好友页面
//                [[NSNotificationCenter defaultCenter] postNotificationName:KReloadFriendsNote object:nil];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败，请重新添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
//                SMLog(@"error    %@",error);
            }
        }];
}

-(void)addFirend:(NSString *)userId andRemark:(NSString *)remark{
    [[SKAPI shared] addFriend:userId andRemark:remark block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"%@",result);
        }else{
            SMLog(@"%@",error);
        }
    }];
}

///本地推送
-(void)setupLocalNot:(NSString *)body andType:(NSInteger)type{
    [self setupSceneLocalNot:body type:type activeId:nil];
}

///场景推广本地通知
-(void)setupSceneLocalNot:(NSString *)body type:(NSInteger)type activeId:(NSString *)activeId{
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置通知的提醒时间
    // 使用本地时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    //触发时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];

    // 设置重复间隔
    //notification.repeatInterval = kCFCalendarUnitDay;
    //notification.repeatInterval = 0;
    // 设置提醒的文字内容
    notification.alertBody  = [NSString stringWithFormat:@"%@",body];
    //notification.alertAction = NSLocalizedString(self.inputTextField.text, nil);
    
    // 通知提示音 使用默认的
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //设置点击通知启动图
    notification.alertLaunchImage = @"750.png";
    // 设置应用程序右上角的提醒个数
    //notification.applicationIconBadgeNumber = 0;
    
    //这里添加识别
    // 设定通知的userInfo，用来标识该通知
    NSDictionary *userInfo = nil;
    if (activeId.length) {
        userInfo = @{@"type":[NSString stringWithFormat:@"%zd",type],
                     @"id":activeId,
                     @"firedateformat":@"yyyy-MM-dd HH:mm:ss"};
    }else{
        userInfo = @{@"type":[NSString stringWithFormat:@"%zd",type],
                     @"firedateformat":@"yyyy-MM-dd HH:mm:ss"};
    }
    notification.userInfo = userInfo;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    }
    
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//ping++
//ios8及以下  支付回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url

  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    
    SMLog(@"annotation = %@",annotation);
    
    return canHandleURL;
}

//ios9  支付回调
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}

@end
