//
//  SMMobileVerificationViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/3.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMobileVerificationViewController : UIViewController


@property(nonatomic,copy)NSString * cardNum;
@property(nonatomic,copy)NSString * cardName;
@property(nonatomic,copy)NSString * idCareNum;
@property (nonatomic ,copy)NSString *subBank;/**< <#注释#> */


//@property (nonatomic ,assign)NSInteger type; /**< 0 注册接口   1 普通发短信接口 */

@end
