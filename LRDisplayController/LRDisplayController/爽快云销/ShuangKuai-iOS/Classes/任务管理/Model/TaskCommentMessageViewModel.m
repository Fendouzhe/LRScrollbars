//
//  TaskCommentMessageViewModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,assign) CGRect iconImageViewFrame;/**< <#属性#> */
//@property (nonatomic,assign) CGRect nameLabelFrame;/**< <#属性#> */
//@property (nonatomic,assign) CGRect timeLabelFrame;/**< <#属性#> */
//@property (nonatomic,assign) CGRect introLabelFrame;/**< <#属性#> */
//@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */

#import "TaskCommentMessageViewModel.h"
#import "TaskCommentMessage.h"
#import "NSString+Extension.h"

@implementation TaskCommentMessageViewModel
-(void)setCellData:(TaskCommentMessage *)cellData{
    _cellData = cellData;
    CGFloat offY = 2;
    CGFloat iconImageViewFrameX = 10;
    CGFloat iconImageViewFrameY = 5;
    CGFloat iconImageViewFrameW = KTaskInfoIconWidth;
    CGFloat iconImageViewFrameH = iconImageViewFrameW;
    self.iconImageViewFrame = CGRectMake(iconImageViewFrameX, iconImageViewFrameY, iconImageViewFrameW, iconImageViewFrameH);
    CGFloat nameLabelFrameX = CGRectGetMaxX(self.iconImageViewFrame)+5;
    CGFloat nameLabelFrameY = iconImageViewFrameY + offY ;
    CGFloat nameLabelFrameW = KScreenWidth - nameLabelFrameX - 100;
    CGFloat nameLabelFrameH = [@" " textSizeWithFont:KDefaultFontMiddle maxSize:CGSizeMake(nameLabelFrameW, MAXFLOAT)].height;
    self.nameLabelFrame = CGRectMake(nameLabelFrameX, nameLabelFrameY, nameLabelFrameW, nameLabelFrameH);
    CGFloat timeLabelFrameX = nameLabelFrameX;
    CGFloat timeLabelFrameW = nameLabelFrameW;
    CGFloat timeLabelFrameH = [@" " textSizeWithFont:KDefaultFont12 maxSize:CGSizeMake(timeLabelFrameW, MAXFLOAT)].height;
    CGFloat timeLabelFrameY = CGRectGetMaxY(self.iconImageViewFrame) - timeLabelFrameH - offY;
    self.timeLabelFrame = CGRectMake(timeLabelFrameX, timeLabelFrameY, timeLabelFrameW, timeLabelFrameH);
    CGFloat introLabelFrameX = 10;
    CGFloat introLabelFrameY = CGRectGetMaxY(self.iconImageViewFrame)+10;
    CGFloat introLabelFrameW = KScreenWidth - 20;
    CGSize introLabelFrameSize = [cellData.content textSizeWithFont:KDefaultFont maxSize:CGSizeMake(introLabelFrameW, MAXFLOAT)];
    self.introLabelFrame = CGRectMake(introLabelFrameX, introLabelFrameY, introLabelFrameSize.width, introLabelFrameSize.height);
    self.cellHeight = CGRectGetMaxY(self.introLabelFrame)+5;
}
@end
