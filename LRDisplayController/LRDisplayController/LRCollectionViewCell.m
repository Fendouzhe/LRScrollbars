//
//  LRCollectionViewCell.m
//  LRDisplayController
//
//  Created by 宇中 on 2016/11/9.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRCollectionViewCell.h"

@implementation LRCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"解决了bug");
    }
    return self;
}


- (void)dealloc{
    NSLog(@"88");
}

- (instancetype)init{
    return self;
}

@end
