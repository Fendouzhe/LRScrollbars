//
//  BankCard.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : NSObject

@property (nonatomic ,assign)NSInteger type; /**< 类型 1银行卡 2 支付宝 */

@property (nonatomic ,copy)NSString *userId;/**< 用户Id */

@property (nonatomic ,copy)NSString *account;/**< 支付宝账号或银行卡号 */

@property (nonatomic ,copy)NSString *userName;/**< 账号姓名 */

@property (nonatomic ,copy)NSString *bankName;/**< 银行名 */

@property (nonatomic ,copy)NSString *subBank;/**< 支行名 */

@property (nonatomic ,copy)NSString *idCard;/**< 身份证 */

@property (nonatomic ,assign)NSInteger Integer; /**< status */

@property (nonatomic ,assign)NSInteger createAt; /**< 创建时间 */

@property (nonatomic ,copy)NSString *phone;/**< 手机号 */

////银行卡
//@property (nonatomic, retain) NSString *bankCard;
//
////银行卡名
//@property (nonatomic, retain) NSString *bankName;

@end
