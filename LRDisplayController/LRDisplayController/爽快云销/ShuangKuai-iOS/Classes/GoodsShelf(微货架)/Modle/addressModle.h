//
//  addressModle.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/9.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressModle : NSObject

@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString * phone;
//连在一起的地址
@property(nonatomic,copy)NSString * address;
//留言
@property(nonatomic,copy)NSString * mome;

@end
