//
//  SMActionCollectionViewCell2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMActionCollectionViewCell2.h"
#import "NSString+Extension.h"

@interface SMActionCollectionViewCell2 ()
/**
 *  商品图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/**
 *  商品名字label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  当前价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
/**
 *  佣金
 */
@property (weak, nonatomic) IBOutlet UILabel *CommissionLabel;

@end

@implementation SMActionCollectionViewCell2

+ (instancetype)actionCollectionViewCell2{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMActionCollectionViewCell2" owner:nil options:nil] lastObject];
}


//可以考虑使用代理为点击事件做事情
- (IBAction)iconBtnClick:(UIButton *)sender {
    SMLog(@"点击了 商品图片 按钮");
}

- (void)awakeFromNib {
    CGFloat nameLabelH = [self.nameLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat currentPriceH = [self.currentPriceLabel.text textSizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat commisionH = [self.CommissionLabel.text textSizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    self.cellHeight = 5 + nameLabelH + 9 + currentPriceH + 9 + commisionH + 9;
    self.iconBtn.adjustsImageWhenHighlighted = NO;
    
    //字体加中划线
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"原价：￥500" attributes:dict];
    [self.originalPriceLabel setAttributedText:attributeStr];
    
    self.currentPriceLabel.textColor = KRedColor;
}

-(void)refreshUI:(Activity *)activity
{
    
}

-(NSAttributedString *)setlineWithString:(NSString *)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：￥%@",string] attributes:dict];
    return attributeStr;
}
@end
