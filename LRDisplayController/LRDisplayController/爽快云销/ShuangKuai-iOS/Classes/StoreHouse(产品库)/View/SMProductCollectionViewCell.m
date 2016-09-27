//
//  SMProductCollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductCollectionViewCell.h"

@interface SMProductCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *lineRight;

@property (weak, nonatomic) IBOutlet UIView *lineBottom;

@property (weak, nonatomic) IBOutlet UIView *lineTop;

@property (weak, nonatomic) IBOutlet UIView *lineLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (strong, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation SMProductCollectionViewCell

+ (instancetype)productCollectionViewCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SMProductCollectionViewCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.shadowView.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.shadowView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.shadowView.layer.shadowRadius = 2;//阴影半径，默认3
    
    //字体加中划线
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"原价：￥500" attributes:dict];
    [self.originalPriceLabel setAttributedText:attributeStr];
    
    self.currentPriceLabel.textColor = KRedColor;
    
    self.lineTop.backgroundColor = SMColor(182, 183, 184);
    self.lineBottom.backgroundColor = SMColor(182, 183, 184);
    self.lineLeft.backgroundColor = SMColor(182, 183, 184);
    self.lineRight.backgroundColor = SMColor(182, 183, 184);
    
    self.lineTop.alpha = 0.3;
    self.lineBottom.alpha = 0.3;
    self.lineLeft.alpha = 0.3;
    self.lineRight.alpha = 0.3;
    
    self.productImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.productImageView.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageHeight.constant = 154 *SMMatchHeight;
    self.layer.cornerRadius = SMCornerRadios;
    self.clipsToBounds = YES;
    
}

- (void)setProduct:(Product *)product{
    _product = product;
    //SMLog(@"setProduct    %@",product);
    self.commissionLabel.text = [NSString stringWithFormat:@"￥%.2f",product.commission.doubleValue];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",product.finalPrice.doubleValue];
    self.productNameLabel.text = product.name;
    
    [self.originalPriceLabel setAttributedText:[self lineWithString:[NSString stringWithFormat:@"%.2f",product.price.doubleValue]]];
    
    NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath];
    NSString *imageStr = arrPrice[0];
    
    
    CGFloat width;
    CGFloat height;
    if (isIPhone5) {
        width = 146;
        height = 154;
    }else if (isIPhone6){
        width = 146 *KMatch6;
        height = 154 *KMatch6;
    }else if (isIPhone6p){
        width = 146 *KMatch6p;
        height = 154 *KMatch6p;
    }
    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width *2,height *2];
    NSString *str = [imageStr stringByAppendingString:strEnd];
    
    //[self.productImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    //加载指示器
    [self.productImageView setShowActivityIndicatorView:YES];
    [self.productImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    
    
}

-(NSAttributedString *)lineWithString:(NSString *)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:%@",string] attributes:dict];
    return attributeStr;
}


@end
