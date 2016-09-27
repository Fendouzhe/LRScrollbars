//
//  TaskDetailMainViewFrame.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskDetailMainViewFrame.h"
//#import "TaskDetailMain.h"
#import "NSString+Extension.h"
#import "SMFatherTask.h"
#import "SMParticipant.h"

//@property (nonatomic,assign) CGRect iconImageViewFrame;/**<  */
//@property (nonatomic,assign) CGRect nameLabelFrame;/**<  */
//@property (nonatomic,assign) CGRect timeLabelFrame;/**<  */
//@property (nonatomic,assign) CGRect introLabelFrame;/**<  */
//@property (nonatomic,assign) CGRect deadlineLabelFrame;/**<  */
//@property (nonatomic,assign) CGRect participantButtonFrame;/**<  */
//@property (nonatomic,assign) CGRect collectionViewFrame;/**<  */
//@property (nonatomic,assign) CGFloat cellHeight;/**<  */

@implementation TaskDetailMainViewFrame
//-(void)setCellData:(SMFatherTask *)cellData{
//    
//}

-(void)setFrameWithTask:(SMFatherTask *)cellData withArray:(NSArray *)userArray{
    _cellData = cellData;
    _userArray = userArray;
    
    UIFont *font = KDefaultFont;
    if (isIPhone6p) {
        font = [UIFont systemFontOfSize:13];
    }
    
    UIFont *font1 = KDefaultFontBig;
    if (isIPhone6p) {
        font1 = [UIFont systemFontOfSize:16];
    }
    
    CGFloat iconImageViewFrameX = 10;
    CGFloat iconImageViewFrameY = 10;
    CGFloat iconImageViewFrameW = 40;
    CGFloat iconImageViewFrameH = iconImageViewFrameW;
    self.iconImageViewFrame = CGRectMake(iconImageViewFrameX, iconImageViewFrameY, iconImageViewFrameW, iconImageViewFrameH);
    
    CGFloat nameLabelFrameX = CGRectGetMaxX(self.iconImageViewFrame)+10;
    CGFloat nameLabelFrameY = 15;
    CGSize nameLabelFrameSize = [cellData.uName textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(KScreenWidth - nameLabelFrameX - 100, MAXFLOAT)];
    self.nameLabelFrame = CGRectMake(nameLabelFrameX, nameLabelFrameY, nameLabelFrameSize.width, nameLabelFrameSize.height);
    
    CGFloat timeLabelFrameX = nameLabelFrameX;
    CGFloat timeLabelFrameY = CGRectGetMaxY(self.nameLabelFrame)+5;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[cellData.createAt integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    self.timeLabel.text = [formatter stringFromDate:date1];
    CGSize timeLabelFrameSize = [[formatter stringFromDate:date1] textSizeWithFont:KDefaultFontSmall maxSize:CGSizeMake(KScreenWidth - timeLabelFrameX - 100, MAXFLOAT)];
    self.timeLabelFrame = CGRectMake(timeLabelFrameX, timeLabelFrameY, timeLabelFrameSize.width, timeLabelFrameSize.height);
    
    CGFloat mainLabelFrameX = 20;
    CGFloat mainLabelFrameY = CGRectGetMaxY(self.timeLabelFrame)+10;
    CGFloat mainLabelFrameW = KScreenWidth - mainLabelFrameX - 10;
    CGFloat mainLabelFrameH = [@" " textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(mainLabelFrameW, MAXFLOAT)].height;
    self.mainLabelFrame = CGRectMake(mainLabelFrameX, mainLabelFrameY, mainLabelFrameW, mainLabelFrameH);
    
    CGFloat introLabelFrameX = 20;
    CGFloat introLabelFrameY = CGRectGetMaxY(self.mainLabelFrame)+5;
    if (!cellData.remark.length) {
        cellData.remark = @" ";
    }
    
    CGSize introLabelFrameSize = [[NSString stringWithFormat:@"任务内容:%@",cellData.remark] textSizeWithFont:font maxSize:CGSizeMake(KScreenWidth - introLabelFrameX - 10, MAXFLOAT)];
    self.introLabelFrame = CGRectMake(introLabelFrameX, introLabelFrameY, introLabelFrameSize.width, introLabelFrameSize.height);
    
    CGFloat deadlineImageFrameX = introLabelFrameX;
    CGFloat deadlineImageFrameY = CGRectGetMaxY(self.introLabelFrame)+5;
    CGFloat deadlineImageFrameW = 15;
    CGFloat deadlineImageFrameH = deadlineImageFrameW;
    self.deadlineImageFrame = CGRectMake(deadlineImageFrameX, deadlineImageFrameY, deadlineImageFrameW, deadlineImageFrameH);
    
    
    CGFloat deadlineLabelFrameX = CGRectGetMaxX(self.deadlineImageFrame);
    CGFloat deadlineLabelFrameY = deadlineImageFrameY;
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[cellData.schTime integerValue]];
    CGSize deadlineLabelFrameSize = [[NSString stringWithFormat:@"截止时间:%@",[formatter stringFromDate:date2]] textSizeWithFont:font maxSize:CGSizeMake(KScreenWidth - timeLabelFrameX - 100, MAXFLOAT)];
    self.deadlineLabelFrame = CGRectMake(deadlineLabelFrameX, deadlineLabelFrameY, deadlineLabelFrameSize.width, deadlineLabelFrameSize.height);
    
//    CGFloat participantButtonFrameX = introLabelFrameX;
//    CGFloat participantButtonFrameY = CGRectGetMaxY(self.introLabelFrame)+5;
//    CGFloat participantButtonFrameW = 60;
//    CGFloat participantButtonFrameH = 20;
//    self.participantButtonFrame = CGRectMake(participantButtonFrameX, participantButtonFrameY, participantButtonFrameW, participantButtonFrameH);
    
    
    //    CGFloat cellW = 30;
    //    CGFloat cellSpacing = 5;
    //    CGFloat itemSpacing = 5;
    //    CGFloat collectionViewFrameX = CGRectGetMaxX(self.participantButtonFrame)+5;
    //    CGFloat collectionViewFrameY = participantButtonFrameY;
    //    CGFloat collectionViewFrameW = KScreenWidth - collectionViewFrameX - 10;
    //    int numbers = (int)((collectionViewFrameW + cellSpacing) / (cellW + cellSpacing));//一行放多少个
    //    NSArray *array = cellData.users;
    //    int lineNumbers = (int)((array.count)/numbers+1);
    //    CGFloat collectionViewFrameH = cellW * lineNumbers+(lineNumbers-1)*itemSpacing;
    //    self.collectionViewFrame = CGRectMake(collectionViewFrameX, collectionViewFrameY, collectionViewFrameW, collectionViewFrameH);
    
    
    //    self.cellHeight = CGRectGetMaxY(self.collectionViewFrame)+10;
    
    
    
    CGFloat statusButtonFrameW = 75 *SMMatchWidth;
    CGFloat statusButtonFrameX = KScreenWidth - statusButtonFrameW - 10;
    CGFloat statusButtonFrameY = 10;
    CGFloat statusButtonFrameH = 25 *SMMatchHeight;
    self.statusButtonFrame = CGRectMake(statusButtonFrameX, statusButtonFrameY, statusButtonFrameW, statusButtonFrameH);
    
    CGFloat personsImageViewFrameX = introLabelFrameX;
    CGFloat personsImageViewFrameY = CGRectGetMaxY(self.deadlineLabelFrame)+5;
    //    CGSize personsImageViewFrameSize = [@"" textSizeWithFont:KDefaultFont maxSize:CGSizeMake(KScreenWidth - personsImageViewFrameX - 10, MAXFLOAT)];
    //    self.personsImageViewFrame = CGRectMake(personsImageViewFrameX, personsImageViewFrameY, personsImageViewFrameSize.width, personsImageViewFrameSize.height);
    CGFloat personsImageViewFrameW = 15;
    CGFloat personsImageViewFrameH = personsImageViewFrameW;
    self.personsImageViewFrame = CGRectMake(personsImageViewFrameX, personsImageViewFrameY, personsImageViewFrameW, personsImageViewFrameH);
    
    CGFloat linkLabelFrameX = CGRectGetMaxX(self.personsImageViewFrame);
    CGFloat linkLabelFrameY = personsImageViewFrameY;
    NSMutableString *tempStr = [NSMutableString stringWithString:@"参与人:"];
//    for (SMParticipant *user in userArray) {
    for (int i = 0; i < userArray.count; i++) {
        if (i > 0) {
            [tempStr appendString:@", "];
        }
        [tempStr appendString:[userArray[i] name]];
    }
    
    CGSize linkLabelFrameSize = [tempStr textSizeWithFont:font maxSize:CGSizeMake(KScreenWidth - personsImageViewFrameX - 10, MAXFLOAT)];
    self.linkLabelFrame = CGRectMake(linkLabelFrameX, linkLabelFrameY, linkLabelFrameSize.width, linkLabelFrameSize.height);
    self.cellHeight = CGRectGetMaxY(self.linkLabelFrame)+10;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //设置内容最宽 只能到maxW ，但是高度不限制。
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
