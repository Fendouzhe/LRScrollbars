//
//  CommissionLog.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
//佣金提现记录模型
@interface CommissionLog : NSObject

@property (nonatomic, retain) NSString *id;
//审批通过时间
@property (nonatomic, retain) NSString *approveAt;
//银行卡号
@property (nonatomic, retain) NSString *bankCard;
//银行名称
@property (nonatomic, retain) NSString *bankName;
//申请的提现佣金数
@property (nonatomic, assign) double commission;
@end
