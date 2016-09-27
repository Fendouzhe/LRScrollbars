//
//  SMNewFav.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNewFav : NSObject

@property (nonatomic ,copy)NSString *favId;

@property (nonatomic ,copy)NSString *favName;

@property (nonatomic ,strong)NSArray *items;

@property (nonatomic ,copy)NSString *bgImage;

@end
