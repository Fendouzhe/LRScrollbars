//
//  AppDelegate.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 11/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMClient.h>
#import <RongIMKit/RongIMKit.h>
#import "SMCareViewController.h"
#import "SMTabBarViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,
RCIMReceiveMessageDelegate>

@property (strong, nonatomic) UIWindow *window;

//记录当前所在控制器
@property (nonatomic,strong)UIViewController * notesViewController;

//创建的会话ID
//@property(nonatomic,strong)AVIMClient * client;
//个推的id
@property(nonatomic,copy)NSString * geTuiClientId;
//手机设备token
@property(nonatomic,strong)NSData * deviceToken;
//记录银行卡界面，用于返回
@property(nonatomic,strong)UIViewController * boundCardVC;

@property(nonatomic,strong)SMTabBarViewController * tabbar;

@property(nonatomic,strong)SMCareViewController * OneVC;

@property(nonatomic,strong)NSMutableArray *pushDataArr;


@end

