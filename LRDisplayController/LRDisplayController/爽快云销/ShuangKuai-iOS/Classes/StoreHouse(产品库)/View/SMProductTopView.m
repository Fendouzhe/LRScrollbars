//
//  SMProductTopView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductTopView.h"
#import "sku.h"

@interface SMProductTopView ()

@property (nonatomic ,strong)NSString *chooseStr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewMargin;

@property (weak, nonatomic) IBOutlet UILabel *sellCount;

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@end

@implementation SMProductTopView

+ (instancetype)productTopView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMProductTopView" owner:nil options:nil] lastObject];
}


- (IBAction)cancel {
    [[NSNotificationCenter defaultCenter] postNotificationName:KProductDetailCancelNote object:nil];
}

-(void)setProduct:(Product *)product{
    _product = product;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.product.finalPrice.floatValue];
    self.stockLabel.text = [NSString stringWithFormat:@"库存%zd件",self.product.stock];
    self.sellCount.text = [NSString stringWithFormat:@"销售量:%zd",product.sales];
    NSString *original = [NSString stringWithFormat:@"原价:%.2f",product.price.floatValue];
    [self.originalPrice setAttributedText:[self lineWithString:original]];
}

-(NSAttributedString *)lineWithString:(NSString *)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string] attributes:dict];
    return attributeStr;
}

- (void)setArrSkus:(NSArray *)arrSkus{
    _arrSkus = arrSkus;
    for (sku *sku in self.arrSkus) {
        SMLog(@"sku.text  %@",sku.text);
        self.chooseStr = [self.chooseStr stringByAppendingString:[NSString stringWithFormat:@"  %@",sku.text]];
        
    }
    self.chooseLabel.text = self.chooseStr;
}

- (void)awakeFromNib{
    self.chooseStr = @"请选择";
    CGFloat wh;
    if (isIPhone5) {
        wh = 90;
    }else if (isIPhone6){
        wh = 90 * KMatch6Height;
    }else if (isIPhone6p){
        wh = 90 * KMatch6pHeight;
    }
    
    self.topViewMargin.constant = wh + 20;
    self.bottomViewMargin.constant = wh + 20;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specificationsClick:) name:@"KSpecifications" object:nil];
}

- (void)specificationsClick:(NSNotification *)noti{
    ProductSpec *spec = noti.userInfo[@"KSpecificationsKey"];
    SMLog(@"spec.price   %@",spec.price);
    if (spec.price) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",spec.price.floatValue];
    }
    if (spec.stock) {
        self.stockLabel.text = [NSString stringWithFormat:@"库存%zd件",spec.stock];
    }
}

@end
