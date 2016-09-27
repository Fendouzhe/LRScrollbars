//
//  SMCircelMainTextCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircelMainTextCell.h"
#import "tweetFrame.h"
#import <UIButton+WebCache.h>


@interface SMCircelMainTextCell ()
/**
 *  名字
 */
@property (nonatomic ,strong)UILabel *nameLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;

@end

@implementation SMCircelMainTextCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"circelMainTextCell";
    SMCircelMainTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMCircelMainTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        UIButton *iconBtn = [[UIButton alloc] init];
        [self.contentView addSubview:iconBtn];
        self.iconBtn = iconBtn;
        [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //评论内容
        UILabel *commentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        commentLabel.font = KDefaultFont;
        commentLabel.numberOfLines = 0;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.font = KDefaultFontSmall;
        
        
    }
    return self;
}

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

- (void)iconBtnClick:(UIButton *)btn{
    SMLog(@"点击了  评论里的头像");
}

- (void)setComment:(TweetComment *)comment{
//    _comment = comment;
//    SMLog(@"comment     %@",comment);
//    SMLog(@"TweetComment *comment   %@  comment.userName %@",comment,comment.userName);
    //头像
    CGFloat margin = 10;
    CGFloat iconWH = 45;
    //[self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:comment.portrait] forState:UIControlStateNormal];
    
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:comment.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.iconBtn.layer.cornerRadius = 22.5;
    self.iconBtn.layer.masksToBounds = YES;
    
    //NSData * data =  [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    
    //[self.iconBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    
    self.iconBtn.frame = CGRectMake(margin, margin, iconWH, iconWH);
    
    //名字
    self.nameLabel.text = comment.userName;
    //NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    //self.nameLabel.text = name;
    CGSize nameSize = [self sizeWithText:comment.userName font:[UIFont systemFontOfSize:15]];
    CGFloat nameLabelX = margin + iconWH + margin;
    CGFloat nameLabelY = margin + margin / 3;
    self.nameLabel.frame = (CGRect){{nameLabelX,nameLabelY},nameSize};
    
    //评论内容
    self.commentLabel.text = comment.content;
    CGFloat commentLabelX = margin + iconWH + margin;
    CGFloat commentLabelY = CGRectGetMaxY(self.nameLabel.frame) + margin;
    CGFloat maxW = KScreenWidth - commentLabelX - margin;
    CGSize commentSize = [self sizeWithText:comment.content font:KDefaultFont maxW:maxW];
    self.commentLabel.frame = (CGRect){{commentLabelX,commentLabelY},commentSize};
    
    
    //时间
    NSString *timeStr = [NSString stringWithFormat:@"%zd",comment.createAt];
    NSString *time = [Utils getTimeFromTimestamp:timeStr];
    self.timeLabel.text = time;
    CGSize timeSize = [self sizeWithText:time font:KDefaultFontSmall];
    CGFloat timeX = KScreenWidth - margin - timeSize.width;
    CGFloat timeY = nameLabelY;
    self.timeLabel.frame = (CGRect){{timeX,timeY},timeSize};
    
    //cell高度
//    self.cellHeight = MAX(CGRectGetMaxY(self.iconBtn.frame), CGRectGetMaxY(self.commentLabel.frame));
//    SMLog(@"MAX (A,B)  %zd,   %zd",CGRectGetMaxY(self.iconBtn.frame) ,CGRectGetMaxY(self.commentLabel.frame));
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
