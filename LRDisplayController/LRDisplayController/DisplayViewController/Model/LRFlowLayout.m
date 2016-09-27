//
//  LRFlowLayout.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRFlowLayout.h"

@implementation LRFlowLayout

//系统方法
- (void)prepareLayout{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    if (self.collectionView.bounds.size.height) {
        //设置为collectionView大小
        self.itemSize = self.collectionView.bounds.size;
    }
    //设置水平滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
