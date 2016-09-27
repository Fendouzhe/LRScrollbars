//
//  SMNewProductDetaiCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewProductDetaiCell.h"

@interface SMNewProductDetaiCell ()


@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end


@implementation SMNewProductDetaiCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    
    static NSString *ID = @"newProductDetaiCell";
    SMNewProductDetaiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMNewProductDetaiCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setFav:(Favorites *)fav{
    _fav = fav;
    self.infoLabel.text = [NSString stringWithFormat:@"%@(已有%@件商品)",fav.name,fav.products];
    self.gouBtn.selected = fav.gouIsSelected;
    self.gouBtn.layer.cornerRadius = SMCornerRadios;
    self.gouBtn.clipsToBounds = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.infoLabel.font = KDefaultFont;
    self.gouBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
