//
//  SMConfirmPaymentCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConfirmPaymentCell.h"

@interface SMConfirmPaymentCell ()
/**
 *  对勾按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *gouBtn;
/**
 *  产品照片
 */
@property (weak, nonatomic) IBOutlet UIImageView *productView;
/**
 *  产品名字
 */
@property (weak, nonatomic) IBOutlet UILabel *productName;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
/**
 *  现价
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;

/**
 *  运费
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (nonatomic,assign)NSInteger count;

@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@end

@implementation SMConfirmPaymentCell

+ (instancetype)cellWithTanleView:(UITableView *)tableView{
    
    static NSString *ID = @"confirmPaymentCell";
    SMConfirmPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMConfirmPaymentCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/**
 *  点对勾按钮
 */
- (IBAction)gouBtnClick:(UIButton *)sender {
    self.gouBtn.selected = !self.gouBtn.selected;
    
    self.cart.isSelect = self.gouBtn.selected;
    
    NSDictionary *parameters = @{@"productId": self.cart.productId
                                 , @"amount":[NSNumber numberWithInteger:self.count],@"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    //生成一个参数
    if ([self.delegate respondsToSelector:@selector(ConfirmPaymentCellSelectBtnClick:andParameters:)]) {
        [self.delegate ConfirmPaymentCellSelectBtnClick:self.cart andParameters:parameters];
    }
    
}

/**
 *  点加数量
 */
- (IBAction)plusBtnClick:(UIButton *)sender {
    self.count ++ ;
    //总数
    self.buyCountLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    //运费
    self.totalPrice.text = [NSString stringWithFormat:@"%.2lf",[_cart.shippingFee doubleValue]*_count];
    
    NSDictionary *parameters = @{@"productId": self.cart.productId
                                 , @"amount":[NSNumber numberWithInteger:self.count],@"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    if ([self.delegate respondsToSelector:@selector(ConfirmPaymentCellPlusBtnClick:andParameters:)]) {
        [self.delegate ConfirmPaymentCellPlusBtnClick:self.cart andParameters:parameters];
    }
}
/**
 *  点减数量
 */
- (IBAction)minusBtnClick:(UIButton *)sender {
    
    if (self.count==1) {
        return;
    }
    
    self.count -- ;
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    
    //运费
    self.totalPrice.text = [NSString stringWithFormat:@"%.2lf",[_cart.shippingFee doubleValue]*_count];
    
    NSDictionary *parameters = @{@"productId": self.cart.productId
                                 , @"amount":[NSNumber numberWithInteger:self.count],@"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    if ([self.delegate respondsToSelector:@selector(ConfirmPaymentCellMinusBtnClick:andParameters:)]) {
        [self.delegate ConfirmPaymentCellMinusBtnClick:self.cart andParameters:parameters];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCart:(Cart *)cart{
    //赋值
    _cart = cart;
    
    if (cart.isSelect) {
        self.gouBtn.selected = YES;
    }else{
        self.gouBtn.selected = NO;
    }
    
//    NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:cart.imagePath];
//    NSString *imageStr = arrPrice[0];
//    NSString *imageStr = cart.imagePath;
    
    
    NSString *imageStr;
    if ([cart.imagePath rangeOfString:@"["].location == NSNotFound) { //字符串内没有“[”
        imageStr = cart.imagePath;
    }else{  //字符串内含有“[”
        NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:cart.imagePath];
        imageStr = arrPrice[0];
    }
    
    SMLog(@"imageStr  setCart    %@    cart.imagePath  %@",imageStr,cart.imagePath);
    [self.productView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"220"]];
    
    self.productName.text = cart.productName;
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"%ld",cart.amount];
    
    self.originalPrice.text = [NSString stringWithFormat:@"原价:¥%.2lf",[cart.productPrice doubleValue]];
    
    SMLog(@"self.specPrice  setCart  %@",self.specPrice);
    if (self.specPrice) {
//        NSString *price = [self.specPrice substringFromIndex:1];//截掉前面的“¥”符号
        self.currentPrice.text = [NSString stringWithFormat:@"现价:¥%.2f",self.specPrice.floatValue];
//        SMLog(@"price.floatValue  %@   ",price);
    }else{
        self.currentPrice.text = [NSString stringWithFormat:@"现价:¥%.2lf",[cart.productFinalPrice doubleValue]];
        SMLog(@"cart.productFinalPrice  %@",cart.productFinalPrice);
    }
    
    if (self.specName) {
        self.specLabel.text = self.specName;
    }else{
        self.specLabel.text = @"";
    }
    
    self.totalPrice.text = [NSString stringWithFormat:@"%.2lf",[cart.shippingFee doubleValue]];
    
    self.count = cart.amount;
}

- (void)setSpecPrice:(NSString *)specPrice{
    _specPrice = specPrice;
    
    self.currentPrice.text = [NSString stringWithFormat:@"现价:¥%.2f",self.specPrice.floatValue];
}
@end
