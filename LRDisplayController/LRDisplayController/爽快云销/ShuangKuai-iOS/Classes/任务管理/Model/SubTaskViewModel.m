//
//  SubTaskViewModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,assign) CGRect backgroundFrame;/**< 背景标题 */
//@property (nonatomic,assign) CGRect titleFrame;/**< 标题 */
//@property (nonatomic,assign) CGRect introFrame;/**<  */
//@property (nonatomic,assign) CGRect participantButtonFrame;/**<  */
//@property (nonatomic,assign) CGRect collectionViewFrame;/**<  */
//@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */

#import "SubTaskViewModel.h"
#import "SMSonTask.h"
#import "NSString+Extension.h"

@implementation SubTaskViewModel
//-(void)setCellData:(SMSonTask *)cellData{
//    
//}

-(void)setFrameWithTask:(SMSonTask *)cellData withArray:(NSArray *)userArray{
    _cellData = cellData;
    _userArray = userArray;
    CGFloat backgroundFrameX = 20;
    CGFloat backgroundFrameY = 0;
    CGFloat backgroundFrameW = KScreenWidth - backgroundFrameX - 10;
    CGFloat backgroundFrameH ;
    
    UIFont *font = KDefaultFont;
    if (isIPhone6p) {
        font = [UIFont systemFontOfSize:13];
    }
    
    UIFont *fontSmall = KDefaultFontSmall;
    if (isIPhone6p) {
        fontSmall = [UIFont systemFontOfSize:11];
    }
    
    CGFloat titleFrameX = backgroundFrameX + 10;
    CGFloat titleFrameY = 0;
    if (!cellData.title.length) {
        cellData.title = @" ";
    }
    CGSize titleFrameSize = [cellData.title textSizeWithFont:fontSmall maxSize:CGSizeMake(KScreenWidth - titleFrameX - 100, MAXFLOAT)];
    self.titleFrame = CGRectMake(titleFrameX, titleFrameY, KScreenWidth - titleFrameX - 10, titleFrameSize.height);
    
    CGFloat introFrameX = backgroundFrameX + 20;
    CGFloat introFrameY = CGRectGetMaxY(self.titleFrame)+5;
    if (!cellData.remark.length) {
        cellData.remark = @" ";
    }
    CGSize introFrameSize = [[NSString stringWithFormat:@"任务内容:%@",cellData.remark]  textSizeWithFont:font maxSize:CGSizeMake(KScreenWidth-introFrameX-10, MAXFLOAT)];
    self.introFrame = CGRectMake(introFrameX, introFrameY, introFrameSize.width, introFrameSize.height);
    
//    CGFloat participantButtonFrameX = introFrameX;
//    CGFloat participantButtonFrameY = CGRectGetMaxY(self.introFrame)+5;
//    CGFloat participantButtonFrameW = 60;
//    CGFloat participantButtonFrameH = 20;
//    self.participantButtonFrame = CGRectMake(participantButtonFrameX, participantButtonFrameY, participantButtonFrameW, participantButtonFrameH);
    
//    CGFloat cellW = 30;
//    CGFloat cellSpacing = 5;
//    CGFloat itemSpacing = 5;
//    CGFloat collectionViewFrameX = CGRectGetMaxX(self.participantButtonFrame)+5;
//    CGFloat collectionViewFrameY = participantButtonFrameY;
//    CGFloat collectionViewFrameW = KScreenWidth - collectionViewFrameX - 10;
//    int numbers = (collectionViewFrameW + cellSpacing) / (cellW + cellSpacing);
//    NSArray *array = cellData.users;
//    int lineNumbers = (int)((array.count)/numbers+1);
//    CGFloat collectionViewFrameH = cellW * lineNumbers+(lineNumbers-1)*itemSpacing;
//    self.collectionViewFrame = CGRectMake(collectionViewFrameX, collectionViewFrameY, collectionViewFrameW, collectionViewFrameH);
    
//    self.cellHeight = CGRectGetMaxY(self.collectionViewFrame)+10;
//    backgroundFrameH = self.cellHeight;
//    self.backgroundFrame = CGRectMake(backgroundFrameX, backgroundFrameY, backgroundFrameW, backgroundFrameH);
    
    CGFloat statusButtonFrameY = 10;
    CGFloat statusButtonFrameW = 60 *SMMatchWidth;
    CGFloat statusButtonFrameH = 20 *SMMatchHeight;
    CGFloat statusButtonFrameX = KScreenWidth - statusButtonFrameW - 20;
    self.statusButtonFrame = CGRectMake(statusButtonFrameX, statusButtonFrameY, statusButtonFrameW, statusButtonFrameH);
    
    CGFloat deathLineImageViewFrameX = introFrameX;
    CGFloat deathLineImageViewFrameY = CGRectGetMaxY(self.introFrame)+5;
    CGFloat deathLineImageViewFrameW = 15;
    CGFloat deathLineImageViewFrameH = deathLineImageViewFrameW;
    self.deathLineImageViewFrame = CGRectMake(deathLineImageViewFrameX, deathLineImageViewFrameY, deathLineImageViewFrameW, deathLineImageViewFrameH);
    
    CGFloat deathLineLabelFrameX = CGRectGetMaxX(self.deathLineImageViewFrame);
    CGFloat deathLineLabelFrameY = deathLineImageViewFrameY;
    CGFloat deathLineLabelFrameW = KScreenWidth - deathLineLabelFrameX - 10;
    CGFloat deathLineLabelFrameH = [@" " textSizeWithFont:font maxSize:CGSizeMake(deathLineLabelFrameW, MAXFLOAT)].height;
    self.deathLineLabelFrame = CGRectMake(deathLineLabelFrameX, deathLineLabelFrameY, deathLineLabelFrameW, deathLineLabelFrameH);
    
    CGFloat personsImageViewFrameX = introFrameX;
    CGFloat personsImageViewFrameY = CGRectGetMaxY(self.deathLineImageViewFrame)+5;
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
    CGSize linkLabelFrameSize = [tempStr textSizeWithFont:font maxSize:CGSizeMake(KScreenWidth - personsImageViewFrameX - 20, MAXFLOAT)];
    self.linkLabelFrame = CGRectMake(linkLabelFrameX, linkLabelFrameY, linkLabelFrameSize.width, linkLabelFrameSize.height);
    self.cellHeight = CGRectGetMaxY(self.linkLabelFrame)+10;
    backgroundFrameH = self.cellHeight;
    self.backgroundFrame = CGRectMake(backgroundFrameX, backgroundFrameY, backgroundFrameW, backgroundFrameH);

}
@end
