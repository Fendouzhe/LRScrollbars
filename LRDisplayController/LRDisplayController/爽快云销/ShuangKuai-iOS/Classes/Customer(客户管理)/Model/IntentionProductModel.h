//
//  IntentionProductModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntentionProductModel : NSObject
@property (nonatomic,copy) NSString *imageUrl;/**< 头像地址 */
@property (nonatomic,copy) NSString *title;/**< 标题 */
@property (nonatomic,copy) NSString *price;/**< 价格 */
@property (nonatomic,copy) NSString *brokerage;/**< 佣金 */
@end
