//
//  Utils.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSData *)compressImage:(UIImage *)image;

+ (MBProgressHUD *)createHUD;

+ (void)tip:(NSString *)tipStr;

+ (void)clearCookie:(NSString *)key;

+ (void)clearCookieStorage;

+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp;

//将服务器返回的时间戳转化成时间
+ (NSString *)getTimeFromTimestamp2:(NSString *)timestamp;

+ (NSString *)getWeekdayAndTimeFromTimestamp:(NSString *)timestamp;

+ (NSString *)createOauthUrlForCode:(NSString *)appId andRedirectUrl:(NSString *)redirectUrl
                        andMoreinfo:(BOOL)moreinfo;
@end