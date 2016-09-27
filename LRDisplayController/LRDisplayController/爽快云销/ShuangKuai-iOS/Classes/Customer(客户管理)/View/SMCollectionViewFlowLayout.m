//
//  SMCollectionViewFlowLayout.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCollectionViewFlowLayout.h"

@interface SMCollectionViewFlowLayout ()

@property (nonatomic,assign) CGSize contenSize;

@end

@implementation SMCollectionViewFlowLayout

- (CGSize)collectionViewContentSize{
    CGSize size = [super collectionViewContentSize];
    self.collectionView.frame = CGRectMake(0, 10, size.width, size.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addCollectionViewBottom" object:self];
    return size;
}

@end
