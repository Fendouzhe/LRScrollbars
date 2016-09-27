//
//  SMBindPhoneController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@protocol SMBindPhoneControllerDelegate <NSObject>

- (void)bindingSuccess:(User *)user;

@end

@interface SMBindPhoneController : UIViewController

@property (nonatomic ,weak)id<SMBindPhoneControllerDelegate> delegate;

@property (nonatomic ,copy)NSString *openID;

@property (nonatomic ,copy)NSString *accessToken;

@property (nonatomic ,strong)SSDKUser *user;

@end
