//
//  QueryPromotionListPostModel.h
//  ShuangKuai-iOS
//
//  Created by Changeden on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//


#import <Foundation/Foundation.h>
//    NSDictionary *parameters = @{@"type": [NSString stringWithFormat: @"%ld", type]
//                                 , @"keyword": keyword
//                                 , @"status": [NSString stringWithFormat: @"%ld", status]
//                                 , @"offset": [NSString stringWithFormat: @"%ld", offset]
//                                 , @"lastTimeStamp": [NSString stringWithFormat: @"%ld", lastTimestamp]};
@interface QueryPromotionListPostModel : NSObject
@property (nonatomic,assign) int offset;/**<  */
@property (nonatomic,assign) int lastTimeStamp;/**<  */

@end
