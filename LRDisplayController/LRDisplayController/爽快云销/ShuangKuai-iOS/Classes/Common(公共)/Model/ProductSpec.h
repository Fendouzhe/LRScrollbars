//
//  ProductSpec.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductSpec : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *key;

@property (nonatomic, retain) NSNumber *price;

@property (nonatomic, assign) NSInteger stock;
@end
