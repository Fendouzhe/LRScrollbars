//
//  SMDetailProductSection1Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductSection1Cell.h"

@implementation SMDetailProductSection1Cell

+ (instancetype)detailProductSection1Cell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMDetailProductSection1Cell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;{
    
    static NSString *ID = @"detailProductSection1Cell";
    SMDetailProductSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMDetailProductSection1Cell detailProductSection1Cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)awakeFromNib {
    // Initialization code
    self.grayLine.backgroundColor = KControllerBackGroundColor;
}

- (void)setProduct:(Product *)product{
    _product = product;
    NSString *companyName = product.companyName.length>0?product.companyName:@"";
    self.nameLabel.text = [NSString stringWithFormat:@"提供商：%@",companyName];
    
//    NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
//    NSString *imageStr = arrPrice[0];
    
    //[self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    [self.iconView setShowActivityIndicatorView:YES];
    [self.iconView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:product.companyLogoPath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
