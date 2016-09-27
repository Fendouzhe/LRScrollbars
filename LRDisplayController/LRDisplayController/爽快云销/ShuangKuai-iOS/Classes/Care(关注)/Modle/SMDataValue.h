//
//  SMDataValue.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDataValue : NSObject

@property (nonatomic ,copy)NSString *name;/**<     */

@property (nonatomic ,assign)NSInteger type;/**<  */

//@property (nonatomic ,strong)NSNumber *value; /**<  */
@property (nonatomic ,copy)NSString *value;/**< <#注释#> */

@end
