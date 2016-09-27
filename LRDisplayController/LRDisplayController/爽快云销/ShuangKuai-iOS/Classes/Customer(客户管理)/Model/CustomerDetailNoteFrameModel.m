//
//  CustomerDetailNoteFrameModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailNoteFrameModel.h"
#import "CustomerDetailBaseModel.h"
#import "NSString+Extension.h"
@interface CustomerDetailNoteFrameModel ()

@end

@implementation CustomerDetailNoteFrameModel
//-(void)setCellData:(CustomerDetailBaseModel *)cellData{
//    _cellData = cellData;
//    CGSize size = [@"" textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth, MAXFLOAT)];
//    self.mainLabelFrame = CGRectMake(0, 5, KScreenWidth, size.height);
//    CGSize size1 = [cellData.detailText textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
//    self.detailLabelFrame = CGRectMake(10, size.height+10, KScreenWidth-20, size1.height);
//    self.cellHeight = size.height + size1.height+20;
//}

-(void)setCellData:(WorkLog *)cellData{
    _cellData = cellData;
    CGSize size = [@"" textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth, MAXFLOAT)];
    self.mainLabelFrame = CGRectMake(0, 5, KScreenWidth, size.height);
    CGSize size1 = [cellData.content textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
    self.detailLabelFrame = CGRectMake(10, size.height+10, KScreenWidth-20, size1.height);
    self.cellHeight = size.height + size1.height+20;
}
@end
