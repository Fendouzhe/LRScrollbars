//
//  SMNewShelfManager.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMNewFav;
@interface SMNewShelfManager : NSObject

@property (nonatomic ,copy)NSString *bgImage;

//@property (nonatomic ,strong)SMNewFav *Fav;

@property (nonatomic ,strong)NSArray *favorites;

@end
