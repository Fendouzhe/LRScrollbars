//
//  EventInvitatModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventInvitatModel : NSObject
@property (nonatomic,copy) NSString *imageUrl;/**< <#属性#> */
@property (nonatomic,copy) NSString *title;/**< <#属性#> */

@property (nonatomic,copy) NSString *timeStr;/**< 时间属性，纯字符串 */

@property (nonatomic,assign) NSInteger personNumber;/**< <#属性#> */

@property (nonatomic,copy) NSString *linkUrl;/**< <#属性#> */

@end
