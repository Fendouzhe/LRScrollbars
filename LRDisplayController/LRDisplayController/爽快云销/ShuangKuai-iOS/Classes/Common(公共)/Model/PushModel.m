//
//  PushModel
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "PushModel.h"

@interface PushModel()

@end


@implementation PushModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"mydescription"];
        [super setValue:value forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end
