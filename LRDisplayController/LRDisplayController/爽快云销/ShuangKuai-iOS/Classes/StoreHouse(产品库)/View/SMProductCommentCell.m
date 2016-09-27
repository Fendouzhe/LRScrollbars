//
//  SMProductCommentCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductCommentCell.h"
#import "NSString+Extension.h"

@interface SMProductCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentDetailLabel;

@end

@implementation SMProductCommentCell

+ (instancetype)productCommentCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMProductCommentCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"productCommentCell";
    SMProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMProductCommentCell productCommentCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)awakeFromNib {
    
    NSString *commentDetailStr = @"衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！衣服很好卖，订单很多，颜色也很赞！";
    self.commentDetailLabel.text = commentDetailStr;
    CGFloat detailLabelHeight = [commentDetailStr textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
    CGFloat nameLabelH = [self.nameLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
    self.cellHeight = 15 + nameLabelH + 10 + detailLabelHeight + 14;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
