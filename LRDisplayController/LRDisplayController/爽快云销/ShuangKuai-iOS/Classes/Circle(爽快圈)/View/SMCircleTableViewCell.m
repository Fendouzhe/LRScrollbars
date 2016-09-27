//
//  SMCircleTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/27.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircleTableViewCell.h"

@interface SMCircleTableViewCell ()

/**
 *  头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  来源
 */
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
/**
 *  日期时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/**
 *  发表内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  分享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/**
 *  评论按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/**
 *  点赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;



@end

@implementation SMCircleTableViewCell

+ (instancetype)cellWithtableView:(UITableView *)tableView{
    
    static NSString *ID = @"circleTableViewCell";
    SMCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCircleTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    self.iconBtn.adjustsImageWhenHighlighted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)iconBtnClick:(UIButton *)sender {
    SMLog(@"点了 头像按钮");
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    SMLog(@"点了 分享按钮");
}

- (IBAction)commentBtnClick:(UIButton *)sender {
    SMLog(@"点了 评论按钮");
}

- (IBAction)goodBtnClick:(UIButton *)sender {
    SMLog(@"点了 点赞按钮");
}

-(void)refreshUI:(Tweet *)tweet
{
    self.contentLabel.text = tweet.content;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd hh:mm"];
    NSString *  locationString=[dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:tweet.createAt]];
    
    self.dateLabel.text = locationString;
    self.fromLabel.text = tweet.address;
    
    [self.goodBtn setTitle:[NSString stringWithFormat:@"%zd",tweet.upvotes] forState:UIControlStateNormal];
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%zd",tweet.reposts] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%zd",tweet.comments] forState:UIControlStateNormal];
}
@end
