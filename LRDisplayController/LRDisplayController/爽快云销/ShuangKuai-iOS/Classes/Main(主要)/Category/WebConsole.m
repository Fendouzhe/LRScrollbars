//
//  WebConsole.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/30.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "WebConsole.h"

@implementation WebConsole

+ (void)enable{
    [NSURLProtocol registerClass:[WebConsole class]];
}

+ (BOOL) canInitWithRequest:(NSURLRequest *)request{
    if ([[[request URL] host] isEqualToString:@"share_detail"]){
        SMLog(@"canInitWithRequest   %@", [[[request URL] path] substringFromIndex: 1]);
    }    
    return FALSE;
}

@end
