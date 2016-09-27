//
//  SMPintuanCollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPintuanCollectionViewCell.h"
#import "SMGroupbuyDetailList.h"

@interface SMPintuanCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originPrice;
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;
@property (weak, nonatomic) IBOutlet UIButton *twoRenTuanButton;
@property (weak, nonatomic) IBOutlet UIButton *goKaiTuanButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

///图片高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstrait;
///商品名高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNameHeightConstrait;
///价格高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeightConstrait;
///商品名顶部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNameTopConstrait;
///价格顶部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTopConstrait;
///按钮顶部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstrait;
@end

@implementation SMPintuanCollectionViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    //禁止按钮点击
    self.buttonBgView.userInteractionEnabled = NO;
    
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//    self.bgView.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    self.bgView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    self.bgView.layer.shadowRadius = 2;//阴影半径，默认3
//    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    self.layer.shadowRadius = 2;//阴影半径，默认3
    
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewHeightConstrait.constant = 145 * KMatch;
    self.productNameHeightConstrait.constant = 16 * KMatch;
    self.priceHeightConstrait.constant = 16 * KMatch;
    self.productNameTopConstrait.constant = 6*KMatch;
    self.priceTopConstrait.constant = 6*KMatch;
    self.buttonTopConstrait.constant = 7*KMatch;
    
    self.productNameLabel.font = KDefaultFont13Match;
    self.currentPrice.font = KDefaultFont13Match;
    self.originPrice.font = KDefaultFont13Match;
    
    
    self.buttonBgView.layer.cornerRadius = 4;
    self.buttonBgView.layer.masksToBounds = YES;
    self.currentPrice.textColor = KRedColorLight;
    self.originPrice.textColor = [UIColor lightGrayColor];
    self.twoRenTuanButton.backgroundColor = KBlackColorLight;
    self.goKaiTuanButton.backgroundColor = KRedColorLight;
    

}

- (void)setModel:(SMGroupbuyDetailList *)model{
    _model = model;
    self.productNameLabel.text = model.productName;
    self.currentPrice.text = [NSString stringWithFormat:@"¥%.2f",model.finalPrice];
    //self.originPrice.text = [NSString stringWithFormat:@"¥%lu",model.price];
    [self.originPrice setAttributedText:[self lineWithString:[NSString stringWithFormat:@"%.2f",model.price]]];
    
    NSArray *imagePathArr = [NSString mj_objectArrayWithKeyValuesArray:model.imagePath];
    NSString *imageStr = imagePathArr[0];
    //加载指示器
    [self.imageView setShowActivityIndicatorView:YES];
    [self.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

- (IBAction)twoRenTuanButtonClick:(UIButton *)sender {
}

- (IBAction)goKaiTuanButtonClick:(id)sender {
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
