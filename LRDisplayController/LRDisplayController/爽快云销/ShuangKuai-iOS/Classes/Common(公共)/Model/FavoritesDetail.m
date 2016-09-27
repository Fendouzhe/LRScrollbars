//
//  FavoritesDetail.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "FavoritesDetail.h"

@interface FavoritesDetail()

@end


@implementation FavoritesDetail

+ (instancetype)modalWithAdimage:(NSString *)adImage itemName:(NSString *)itemName currentPrice:(NSNumber *)currentPrice{
    
    FavoritesDetail *f = [[FavoritesDetail alloc] init];
    f.adImage = adImage;
    f.itemName = itemName;
    f.value2 = currentPrice;
    return f;
}

@end
