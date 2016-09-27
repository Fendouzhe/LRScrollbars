//
//  Config.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Config : NSObject

+ (void)saveAccount:(NSString *)account andPassword:(NSString *)password;

+ (void)updateMyInfo:(User *)user;

+ (User *)getUsersInformation;
@end