//
//  SMShareMenu.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@protocol SMShareMenuDelegate <NSObject>
////分享到微信好友
//- (void)shareToWechatFreind:(SSDKPlatformType)type;
////分享到微信朋友圈
//- (void)shareToWechatTimeLine:(SSDKPlatformType)type;
////分享到QQ好友
//- (void)shareToQQFreind:(SSDKPlatformType)type;
////分享到QQ空间
//- (void)shareToQQZone:(SSDKPlatformType)type;
////分享到微信收藏
//- (void)shareToWechatFav:(SSDKPlatformType)type;
////分享到新浪微博
//- (void)shareToSina:(SSDKPlatformType)type;
////分享短信
//- (void)shareToSMS:(SSDKPlatformType)type;

- (void)shareBtnDidClick:(SSDKPlatformType)type;

- (void)cancelBtnDidClick;

@end

@interface SMShareMenu : UIView

@property (nonatomic ,weak)id<SMShareMenuDelegate> delegate;

@property (nonatomic ,assign)BOOL isCreatedByArticle; /**< 从文章分享页面创建的   就只显示分享到微信好友，微信朋友圈 */

+ (instancetype)shareMenu;

- (void)onlyShowWeiXinShare;

@end
