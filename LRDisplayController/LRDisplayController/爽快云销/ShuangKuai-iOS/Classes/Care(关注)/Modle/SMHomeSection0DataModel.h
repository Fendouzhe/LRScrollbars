//
//  SMHomeSection0DataModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMHomeSection0DataModel : NSObject

//id = 101;
//value = 0.00;
//name = 总收入;
//type = 2;

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *value;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger type;

@end
