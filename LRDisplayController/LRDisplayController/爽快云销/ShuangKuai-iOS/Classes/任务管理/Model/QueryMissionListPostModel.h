//
//  QueryMissionListPostModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
//    NSDictionary *parameters = @{@"type": [NSString stringWithFormat: @"%ld", type]
//                                 , @"keyword": keyword
//                                 , @"status": [NSString stringWithFormat: @"%ld", status]
//                                 , @"offset": [NSString stringWithFormat: @"%ld", offset]
//                                 , @"lastTimeStamp": [NSString stringWithFormat: @"%ld", lastTimestamp]};
@interface QueryMissionListPostModel : NSObject
@property (nonatomic,copy) NSString *type;/**< 类型 */
@property (nonatomic,copy) NSString *keyword;/**< 关键字 */
@property (nonatomic,copy) NSString *status;/**< 状态 */
@property (nonatomic,assign) int offset;/**<  */
@property (nonatomic,assign) int lastTimeStamp;/**<  */
@end
