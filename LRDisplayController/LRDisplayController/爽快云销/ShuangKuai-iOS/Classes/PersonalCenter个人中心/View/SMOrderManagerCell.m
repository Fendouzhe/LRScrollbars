//
//  SMOrderManagerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderManagerCell.h"

@interface SMOrderManagerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

@property (weak, nonatomic) IBOutlet UIView *grayLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiantouW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiantouH;



@end

@implementation SMOrderManagerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"orderManagerCell";
    SMOrderManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMOrderManagerCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    self.currentPriceLabel.textColor = KRedColorLight;
//    self.originalPriceLabel.textColor = [UIColor lightGrayColor];
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
    self.jiantou.hidden = YES;
    
    self.iconWidth.constant = 86 *SMMatchWidth;
    self.jiantouW.constant = 15 *SMMatchWidth;
    self.jiantouH.constant = 15 *SMMatchWidth;
    
    self.nameLabel.font = KDefaultFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//刷新cell的UI
-(void)refrshUI:(OrderProduct *)product
{
    [self.originalPriceLabel setAttributedText:[self originalpricelable:[NSNumber numberWithDouble:product.price]]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",product.productName];
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥ %.2lf",product.finalPrice];
    
    //[self.iconView sd_setImageWithURL:[NSURL URLWithString:product.imagePath]];
    if (product.sku) {
        self.specificationsLable.text = product.sku;
    }else{
        self.specificationsLable.text = @"";
    }
    
    if ([self.specificationsLable.text isEqualToString:@"0"]) {
        self.specificationsLable.hidden = YES;
    }else{
        self.specificationsLable.hidden = NO;
    }
    
    [self.iconView setShowActivityIndicatorView:YES];
    [self.iconView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:product.imagePath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

//原价中划横线
-(NSAttributedString*)originalpricelable:(NSNumber *)price
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：%.2lf",price.doubleValue] attributes:dict];
    return attributeStr;
    
}

@end
