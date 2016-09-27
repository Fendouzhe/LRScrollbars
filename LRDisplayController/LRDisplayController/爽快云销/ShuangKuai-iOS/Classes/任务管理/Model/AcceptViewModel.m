//
//  AcceptViewModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "AcceptViewModel.h"

@implementation AcceptViewModel
-(void)setAcceptArray:(NSArray *)acceptArray{
    _acceptArray = acceptArray;
    CGFloat x = 10;
    CGFloat cellSpacing = 5;
    CGFloat itemSpacing = 5;
    CGFloat cellW = KTaskInfoIconWidth;
    CGFloat w = KScreenWidth - 2*x;
    int numbers = (int)((w + cellSpacing) / (cellW + cellSpacing));//一行放多少个
    int lineNumbers = (int)((acceptArray.count)/numbers+1);
    CGFloat cellHeight = cellW * lineNumbers+(lineNumbers-1)*itemSpacing;
    self.cellHeight = cellHeight+10;
}
@end
