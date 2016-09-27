//
//  Bonus.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bonus : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) double money;

@property (nonatomic, assign) double createAt;

@property (nonatomic, retain) NSString *sourceId;

@property (nonatomic, retain) NSString *fromUserName;
@end
