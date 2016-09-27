//
//  UIWindow+Extension.m
//  微博00
//
//  Created by iOS on 15/9/25.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "SMTabBarViewController.h"
#import "SMGuideViewController.h"
#import "SMLoginViewController.h"
#import "SMNavigationViewController.h"
#import "SMAVController.h"
#import "SMVideoViewController.h"

@implementation UIWindow (Extension)

//切换根控制器
- (void)switchRootViewController{
    
    NSString *key = @"UserBuild";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    if ([currentVersion isEqualToString:lastVersion]) {//如果不是最新版本，直接进入tabBarController
        //如果已经登录过
        //SMLog(@"KUserSecret = %@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret]);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret] length]) {
            
            NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginVideoUrl];
            NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginBgImage];
            //没有启动图片和宣传视频
            if (!imageData && url.length == 0) {
                SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
                self.rootViewController = vc;
            }else{
                //SMAVController *vc = [[SMAVController alloc] init];
                SMVideoViewController *vc = [[SMVideoViewController alloc] init];
                self.rootViewController = vc;
            }
            //测试
//            SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
//            self.rootViewController = vc;
            
        }else{
            
            SMLoginViewController *logVc = [[SMLoginViewController alloc] init];
            SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:logVc];
            self.rootViewController = nav;
        }
        
//        SMLoginViewController *logVc = [[SMLoginViewController alloc] init];
//        SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:logVc];
//        self.rootViewController = nav;
        
//        SMAVController *vc = [[SMAVController alloc] init];
//        SMNavigationViewController *nav = [[SMNavigationViewController alloc] initWithRootViewController:vc];
//        self.rootViewController = nav;
        
    }else{//如果是最新版本，进入新特性界面
        
        self.rootViewController =[[SMGuideViewController alloc] init];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
