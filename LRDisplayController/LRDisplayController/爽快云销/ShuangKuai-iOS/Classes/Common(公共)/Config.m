//
//  Config.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "Config.h"
#import <SSKeychain.h>

NSString * const kDomain = @"ShuangKuai";
NSString * const kPhone = @"phone";//account

NSString * const kUserID = @"userID";
NSString * const kEmail = @"email";

NSString * const kUserName = @"name";
NSString * const kPortrait = @"portrait";
NSString * const kImagePortrait = @"imagePortrait";
NSString * const kCommission = @"commission";

NSString * const kJointime = @"jointime";
NSString * const kIntro = @"intro";
NSString * const kSex = @"sex";

@implementation Config

+ (void)saveAccount:(NSString *)account andPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kPhone];
    [userDefaults synchronize];
    
    [SSKeychain setPassword:password forService:kDomain account:account];
}

+ (void)updateMyInfo:(User *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.name forKey:kUserName];
    
    [userDefaults setObject:user.email forKey:kEmail];
    [userDefaults setObject:user.portrait forKey:kPortrait];
    [userDefaults setObject:user.phone forKey:kPhone];
    [userDefaults setObject:user.createAt forKey:kJointime];
    [userDefaults setObject:user.commission forKey:kCommission];
    [userDefaults setObject:user.intro forKey:kIntro];
    [userDefaults setObject:user.userid forKey:kUserID];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
    [userDefaults setObject:data forKey:kImagePortrait];
    [userDefaults synchronize];
}

+ (User *)getUsersInformation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefaults objectForKey:kUserName];
    NSString *email = [userDefaults objectForKey:kEmail];
    NSString *phone = [userDefaults objectForKey:kPhone];
    NSString *createAt = [userDefaults objectForKey:kJointime];
    NSString *intro = [userDefaults objectForKey:kIntro];
    NSString *commission = [userDefaults objectForKey:kCommission];
    
    User *user = [[User alloc] init];
    user.name = userName;
    user.email = email;
    user.phone = phone;
    user.createAt = createAt;
    user.intro = intro;
    user.imagePortrait = [userDefaults objectForKey:kImagePortrait];
//    if (!user.imagePortrait) {
//        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
//        user.imagePortrait = data;
//    } else {
//        user.imagePortrait = [userDefaults objectForKey:kPortrait];;
//    }
//    user.commission = commission;
    return user;
}
@end
