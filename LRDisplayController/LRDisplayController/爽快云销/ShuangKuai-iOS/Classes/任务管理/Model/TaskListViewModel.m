//
//  TaskListViewModel.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskListViewModel.h"
#import "TaskListModel.h"
#import "NSString+Extension.h"
#import "MLLinkLabel.h"
#import "MainTaskParticipant.h"
#import "SMParticipant.h"

@implementation TaskListViewModel
-(void)setCellData:(TaskListModel *)cellData{
    _cellData = cellData;
    
    UIFont *font = KDefaultFont;
    if (isIPhone6p) {
        font = [UIFont systemFontOfSize:13];
    }
    
    UIFont *font1 = KDefaultFontBig;
    if (isIPhone6p) {
        font1 = [UIFont systemFontOfSize:16];
    }
    
    CGFloat iconImageX = 20;
    CGFloat iconImageY = 10;
    CGFloat iconImageW = 40;
    CGFloat iconImageH = iconImageW;
    self.iconImageFrame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    CGFloat nameLabelX = CGRectGetMaxX(self.iconImageFrame)+10;
    CGFloat nameLabelY = 20;
    CGFloat nameLabelW = KScreenWidth - nameLabelX - 80;
    CGFloat nameLabelH = [@" " textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(100, MAXFLOAT)].height;
    self.nameLabelFrame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat publishTypeLabelFrameX = KScreenWidth - 70;
    CGFloat publishTypeLabelFrameY = 10;
    CGFloat publishTypeLabelFrameW = 60;
    CGFloat publishTypeLabelFrameH = nameLabelH;
    self.publishTypeLabelFrame = CGRectMake(publishTypeLabelFrameX, publishTypeLabelFrameY, publishTypeLabelFrameW, publishTypeLabelFrameH);
    
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(self.nameLabelFrame);
    CGFloat timeLabelW = nameLabelW;
    CGFloat timeLabelH = [@" " textSizeWithFont:KDefaultFontSmall maxSize:CGSizeMake(100, MAXFLOAT)].height;
    self.timeLabelFrame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat mainLabelFrameX = 30;
    CGFloat mainLabelFrameY = CGRectGetMaxY(self.timeLabelFrame)+10;
    CGFloat mainLabelFrameW = KScreenWidth - mainLabelFrameX - 10;
    CGFloat mainLabelFrameH = [@" " textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(mainLabelFrameW, MAXFLOAT)].height;
    self.mainLabelFrame = CGRectMake(mainLabelFrameX, mainLabelFrameY, mainLabelFrameW, mainLabelFrameH);
    
    CGFloat introLabelX = 30;
    CGFloat introLabelY = CGRectGetMaxY(self.mainLabelFrame)+10;
    CGFloat introLabelW = KScreenWidth - introLabelX - 10;
    CGFloat introLabelH = [[NSString stringWithFormat:@"任务内容:%@",cellData.schedule.remark] textSizeWithFont:KDefaultFont maxSize:CGSizeMake(introLabelW, MAXFLOAT)].height;
    self.introLabelFrame = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    
    CGFloat deadlineImageFrameX = introLabelX;
    CGFloat deadlineImageFrameY = CGRectGetMaxY(self.introLabelFrame)+5;
    CGFloat deadlineImageFrameW = 16 ;
    CGFloat deadlineImageFrameH = deadlineImageFrameW;
    self.deadlineImageFrame = CGRectMake(deadlineImageFrameX, deadlineImageFrameY, deadlineImageFrameW, deadlineImageFrameH);
    
    CGFloat deadlineX= CGRectGetMaxX(self.deadlineImageFrame);
    CGFloat deadlineY = CGRectGetMaxY(self.introLabelFrame)+5;
    CGFloat deadlineW = KScreenWidth - deadlineX - 10;
    CGFloat deadlineH = [@" " textSizeWithFont:KDefaultFont maxSize:CGSizeMake(deadlineW, MAXFLOAT)].height;
    self.deadlineFrame = CGRectMake(deadlineX, deadlineY, deadlineW, deadlineH);
    MLLinkLabel *linkLabel = [[MLLinkLabel alloc] init];
    linkLabel.numberOfLines = 0;
    linkLabel.font = KDefaultFont;
    linkLabel.textColor = KGrayColor;
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"canyuren"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"参与人:"]];
    
    self.linkLabel = linkLabel;
    for (int i = 0; i<cellData.usersList.count; i++) {
        if (i>0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        SMParticipant *data = cellData.usersList[i];
        [attributedText appendAttributedString:[self addNameAttributedStringWithModel:data]];
    }
    linkLabel.attributedText = attributedText;
    CGFloat linkLabelX = introLabelX;
    CGSize linkLabelSize = [linkLabel preferredSizeWithMaxWidth:(KScreenWidth-10-linkLabelX)];
    
    CGFloat linkLabelY = CGRectGetMaxY(self.deadlineFrame) +5;
    self.participantLabelFrame = CGRectMake(linkLabelX, linkLabelY, linkLabelSize.width, linkLabelSize.height);
    
    CGFloat childNumberLabelFrameX = introLabelX;
    CGFloat childNumberLabelFrameY = CGRectGetMaxY(self.participantLabelFrame)+5;
    CGSize childNumberLabelFrameSize = [[NSString stringWithFormat:@"子任务数:%ld",(long)cellData.schedule.childSchedule] textSizeWithFont:KDefaultFont maxSize:CGSizeMake(KScreenWidth - childNumberLabelFrameX - 10 , MAXFLOAT)];
    self.childNumberLabelFrame = CGRectMake(childNumberLabelFrameX, childNumberLabelFrameY, KScreenWidth - childNumberLabelFrameX - 10, childNumberLabelFrameSize.height);
    
    
    self.cellHeight = CGRectGetMaxY(self.childNumberLabelFrame)+10;
    self.lineViewFrame = CGRectMake(0, self.cellHeight - 2, KScreenWidth, 0.5);
}

-(NSMutableAttributedString *)addNameAttributedStringWithModel:(SMParticipant *)task{

    NSString *text = task.name;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : task.id} range:[task.name  rangeOfString:task.name]];
    return attString;
}
@end
