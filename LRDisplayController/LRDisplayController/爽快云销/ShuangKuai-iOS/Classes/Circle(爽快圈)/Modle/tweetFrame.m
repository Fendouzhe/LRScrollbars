//
//  tweetFrame.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "tweetFrame.h"
#import "SMTweetPhotosView.h"


#define SMTweetCellBorderW 10
#define SMTweetCellBorderLeftRight 10

@interface tweetFrame ()



@end


@implementation tweetFrame

//传入参数：字符串、字体、限制的最大宽度，就返回这个字符串 所占的size 大小
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //设置内容最宽 只能到maxW ，但是高度不限制。
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

// 这个是对于单行的字符串内容
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

#pragma mark 重写 模型的set 方法，当外部给这个模型赋值的时候 ，就同时计算出，cell内部的各个小控件的 frame
- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    SMLog(@"setTweet");
    
    //头像
    CGFloat iconWH = 40;
    CGFloat iconX = SMTweetCellBorderW;
    CGFloat iconY = SMTweetCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称部分
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + SMTweetCellBorderW;
    CGSize nameSize = [self sizeWithText:tweet.userName font:KDefaultFont];
    CGFloat nameY = iconY + (iconWH - nameSize.height)*0.5;//iconY + 5;
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    SMLog(@"self.nameLabelF   %@   self.user.name   %@ ",NSStringFromCGRect(self.nameLabelF),self.tweet.userName);
    
    //地址
    CGFloat addressX = nameX;
    CGFloat addressY = CGRectGetMaxY(self.nameLabelF) + SMTweetCellBorderW / 2.0;
    CGSize addressSize = [tweet.address sizeWithFont:KDefaultFontSmall];
    self.addressLabelF = (CGRect){{addressX,addressY},addressSize};
    
    //发表爽快圈的时间
    NSString *timeStr =  [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",tweet.createAt]];
    CGSize timeSize = [timeStr sizeWithFont:KDefaultFontSmall];
    CGFloat timeX = KScreenWidth - SMTweetCellBorderLeftRight - timeSize.width;
    CGFloat timeY = 2;//CGRectGetMinY(self.addressLabelF);
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};

    
    //爽快圈正文（自己发的）
    CGFloat contentX = SMTweetCellBorderLeftRight;
    //拿到头像和时间的最大一个Y 值
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF) + SMTweetCellBorderW, CGRectGetMaxY(self.timeLabelF) + SMTweetCellBorderW);
    
    CGFloat maxW = KScreenWidth - 2 * SMTweetCellBorderLeftRight;
    CGSize contentSize = [self sizeWithText:tweet.content font:KDefaultFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    
    //配图
    CGFloat originalH = 0;//下面会重新赋值
    
    if (tweet.datas.count && tweet.type == 0) {//原创,有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + SMTweetCellBorderW;
        
        CGSize photosSize = [SMTweetPhotosView sizeWithCount:(int)tweet.datas.count];
        
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + SMTweetCellBorderW;
        
    }else{
        //没有配图的情况，设置所有内容的总Y
        originalH = CGRectGetMaxY(self.contentLabelF) + SMTweetCellBorderW;
    }
    
    //原创爽快圈 那个整体的view
    CGFloat originalX = 0;
    CGFloat originalY = SMTweetCellBorderW;
    self.originalViewF = CGRectMake(originalX, originalY, KScreenWidth, originalH);
    
    CGFloat toolbarY = 0.0;
    //被转发爽快圈整体
    if (tweet.type == 1) {//如果返回数据中有转发的微博
        
        //转发爽快圈的长方形整体
        CGFloat retweetViewX = iconX;
        CGFloat retweetViewY = CGRectGetMaxY(self.contentLabelF) + SMTweetCellBorderW;
        CGFloat retweetViewW = KScreenWidth - 2 * SMTweetCellBorderLeftRight;
        CGFloat retweetViewH = 55;
        self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        
        //转发整体中的左边image
        CGFloat leftIconH = 42;
        CGFloat leftIconW = 50;
        CGFloat leftIconY = (retweetViewH - leftIconH) / 2.0;
        CGFloat leftIconX = 5;
        
        self.leftIconF = CGRectMake(leftIconX, leftIconY, leftIconW, leftIconH);
        
        // 转发整体view 中右边的文字
        CGFloat rightContentLabelX = leftIconX + leftIconW + leftIconX;
        CGFloat rightContentLabelY = leftIconY + leftIconX;
        CGFloat rightContentLabelW = retweetViewW - leftIconW - leftIconX *3;
        CGFloat rightContentLabelH = leftIconH - rightContentLabelY *2;
        self.rightContentLabelF = CGRectMake(rightContentLabelX, rightContentLabelY, rightContentLabelW, rightContentLabelH);
        
        
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    }else{
        SMLog(@"photos =          %lf",CGRectGetMaxY(self.photosViewF));
        //toolbarY = CGRectGetMaxY(self.originalViewF);
        NSInteger count = tweet.datas.count;
        
        
        if (tweet.datas.count) {
//            if (CGRectGetMaxY(self.originalViewF)>148) {
//                toolbarY = CGRectGetMaxY(self.originalViewF);
//            }else{
//                SMLog(@"photos =          %lf",CGRectGetMaxY(self.photosViewF));
//                toolbarY = CGRectGetMaxY(self.originalViewF)+CGRectGetMaxY(self.photosViewF)+SMTweetCellBorderW;
//            }
            toolbarY = SMTweetCellBorderW+CGRectGetMaxY(self.contentLabelF)+(KScreenWidth-4*SMTweetCellBorderW)/3*((count-1)/3+1)+((count-1)/3+1)*SMTweetCellBorderW+SMTweetCellBorderW;
        }else{
            toolbarY = CGRectGetMaxY(self.originalViewF);
        }
        
        
    }
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = KScreenWidth;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
    
    //SMLog(@"%lf",self.cellHeight);
}


@end
