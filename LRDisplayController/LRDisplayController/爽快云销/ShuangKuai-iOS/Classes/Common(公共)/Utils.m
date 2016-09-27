//
//  Utils.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSData *)compressImage:(UIImage *)image
{
    CGSize size = [self scaleSize:image.size];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSUInteger maxFileSize = 500 * 1024;
    CGFloat compressionRatio = 0.7f;
    CGFloat maxCompressionRatio = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, compressionRatio);
    
    while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
        compressionRatio -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compressionRatio);
    }
    
    return imageData;
}

+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    } else {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    return HUD;
}

+ (void)tip:(NSString *)tipStr {
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = [NSString stringWithFormat:@"%@", tipStr];
    [HUD hide:YES afterDelay:1];
}

+ (void)clearCookie:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    
}

+ (void)clearCookieStorage {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:cookie];
    }
}

//将服务器返回的时间戳转化成时间
+ (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

//将服务器返回的时间戳转化成时间
+ (NSString *)getTimeFromTimestamp2:(NSString *)timestamp
{
    if (timestamp.length>10) {
        timestamp = [timestamp substringToIndex:10];
    }
    //SMLog(@"timestamp = %@",timestamp);
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [objDateformat stringFromDate: date];
}

+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)getWeekdayAndTimeFromTimestamp:(NSString *)timestamp {
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%@ %@", [weekdays objectAtIndex:theComponents.weekday]
            , [objDateformat stringFromDate: date]];
}

//https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx0cc9d5092f1a711c&scope=snsapi_base&response_type=code&redirect_uri=http%3A%2F%2Fm.shuangkuai.co%2Fshuangkuai_app%2Fsk_sales.html%3FfavId%3D36965fd3-d61b-4f74-8cea-df69bfb230e8&state=STATE%23wechat_redirect

//https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx0cc9d5092f1a711c&state=STATE%23wechat_redirect&scope=snsapi_base&response_type=code&redirect_uri=http%3A%2F%2Fm.shuangkuai.co%2Fshuangkuai_app%2Fsk_sales.html%3FfavId%3Dd46d7e26-f006-11e5-bb99-2c44fd7fa090%26t%3D1467102541603

+ (NSString *)createOauthUrlForCode:(NSString *)appId andRedirectUrl:(NSString *)redirectUrl
                        andMoreinfo:(BOOL)moreinfo {
    
    NSString *baseUrl = @"https://open.weixin.qq.com/connect/oauth2/authorize";
    NSString *appIdStr = [NSString stringWithFormat:@"?appid=%@",appId];
    NSString *stateStr = @"&state=STATE%23wechat_redirect";
    NSString *scope;
    if (moreinfo) {
        scope = @"snsapi_userinfo";
    }else{
        scope = @"snsapi_base";
    }
    NSString *scopeStr = [NSString stringWithFormat:@"&scope=%@",scope];
    NSString *responseStr = [NSString stringWithFormat:@"&response_type=code&redirect_uri=%@",redirectUrl];
    
    NSString *endStr1 = [baseUrl stringByAppendingString:appIdStr];
    NSString *endStr2 = [endStr1 stringByAppendingString:stateStr];
    NSString *endStr3 = [endStr2 stringByAppendingString:scopeStr];
    NSString *endStr4 = [endStr3 stringByAppendingString:responseStr];
    
    return endStr4;
}
@end
