//
//  SMLoginViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/9.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLoginViewController : UIViewController


/**
 *  输入手机号码的textField
 */
@property (nonatomic ,strong)UITextField *phoneField;
/**
 *  输入密码的field
 */
@property (nonatomic ,strong)UITextField *secretField;


@property (nonatomic,assign)BOOL isOut;

- (BOOL)isLogin;

//登录--对外方法--登录融云，哥推等
- (void)login;


@end
