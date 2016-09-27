//
//  CustomerDetailBigFrameModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailBigFrameModel.h"
#import "CustomerDetailJustHeightModel.h"
#import "CustomerDetailBaseModel.h"
#import "NSString+Extension.h"
#define fontSize 15
@implementation CustomerDetailBigFrameModel


-(void)setCellModel:(CustomerDetailJustHeightModel *)cellModel{
    _cellModel = cellModel;
    CGSize sizeMain = [cellModel.title textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth, MAXFLOAT)];
    CGFloat w = KScreenWidth - sizeMain.width - 30 - 30 - 10;
    CGSize textSize = [cellModel.detailText textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(w, MAXFLOAT)];
    if ((textSize.height + 20) < 50*SMMatchWidth) {
        self.cellHeight = 50*SMMatchWidth;
    }else{
        self.cellHeight = textSize.height + 20;
    }
}

@end
