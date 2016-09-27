//
//  SMNewHotProductCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewHotProductCell.h"
#import <UIImageView+WebCache.h>

@interface SMNewHotProductCell ()

@property (weak, nonatomic) IBOutlet UIView *grayVIew;

//产品名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *price;


//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeight;


@end

@implementation SMNewHotProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"newHotProductCell";
    SMNewHotProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMNewHotProductCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (void)setProduct:(Product *)product{
    _product = product;
    CGFloat imageHeight;
    if (isIPhone5) {
        imageHeight = 175;
    }else if (isIPhone6){
        imageHeight = 175 *KMatch6Height;
    }else if (isIPhone6p){
        imageHeight = 175 *KMatch6pHeight;
    }
    CGFloat imageWidth = KScreenWidth;
    
//    NSString *imageStr =  [NSString mj_objectArrayWithKeyValuesArray:product.imagePath].firstObject;
    NSString *imageStr = product.adImage;
    NSString *imageStrAppen = [imageStr stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=60",imageHeight *2,imageWidth *2]];
    SMLog(@"imageStrAppen  %@",imageStrAppen);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStrAppen] placeholderImage:[UIImage imageNamed:@"220"]];
    
    self.nameLabel.text = product.name;
    self.price.text = [NSString stringWithFormat:@"￥:%.2lf",[product.finalPrice doubleValue]];
    
}

- (void)setFavoritesDetail:(FavoritesDetail *)favoritesDetail{
    _favoritesDetail = favoritesDetail;
    
    CGFloat imageHeight;
    if (isIPhone5) {
        imageHeight = 175;
    }else if (isIPhone6){
        imageHeight = 175 *KMatch6Height;
    }else if (isIPhone6p){
        imageHeight = 175 *KMatch6pHeight;
    }
    CGFloat imageWidth = KScreenWidth;
    
    NSString *imageStr = favoritesDetail.adImage;
    NSString *imageStrAppen = [imageStr stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=60",imageHeight *2,imageWidth *2]];
    SMLog(@"imageStrAppen  %@",imageStrAppen);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStrAppen] placeholderImage:[UIImage imageNamed:@"220"]];
    
    self.nameLabel.text = favoritesDetail.itemName;
    self.price.text = [NSString stringWithFormat:@"￥:%.2lf",[favoritesDetail.value2 doubleValue]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.grayVIew.backgroundColor = KControllerBackGroundColor;
    self.price.layer.cornerRadius = SMCornerRadios;
    self.price.clipsToBounds = YES;
//    self.price.backgroundColor = [UIColor greenColor];
    self.price.textColor = KRedColorLight;
    self.priceHeight.constant = KScreenHeight / K5Height * 1.0 * 36;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
}


@end
