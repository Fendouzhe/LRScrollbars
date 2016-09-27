//
//  SMAllProductTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMAllProductTableViewCell.h"

@implementation SMAllProductTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"allProductTableViewCell";
    SMAllProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMAllProductTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    //字体加中划线
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"原价：￥500" attributes:dict];
    [self.originalPrice setAttributedText:attributeStr];
    
    self.currentPrice.textColor = KRedColor;
}

- (void)setProduct:(Product *)product{
    _product = product;
    self.commissionLabel.text = [NSString stringWithFormat:@"￥%.1f",product.commission.doubleValue];
    self.currentPrice.text = [NSString stringWithFormat:@"￥%.1f",product.finalPrice.doubleValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：￥%.1f  ",product.price.doubleValue] attributes:dict];
    [self.originalPrice setAttributedText:attributeStr];
    
    self.productName.text = product.name;
    
    NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
    NSString *imageStr = arrPrice[0];
    
    //[self.productIconView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    [self.productIconView setShowActivityIndicatorView:YES];
    [self.productIconView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.productIconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

@end
