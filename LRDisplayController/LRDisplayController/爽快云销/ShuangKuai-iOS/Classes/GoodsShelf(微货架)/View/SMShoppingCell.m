//
//  SMShoppingCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShoppingCell.h"

@interface SMShoppingCell ()

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UIImageView *productView;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@property (weak, nonatomic) IBOutlet UILabel *currentPrice;

@property (nonatomic,assign)NSInteger count;

//规格
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UIView *grayLine;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minusW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plusW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouH;


@end

@implementation SMShoppingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"shoppingCell";
    SMShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMShoppingCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//减商品
- (IBAction)minusBtnClick:(UIButton *)sender {
    //点击一次  调用一次接口  服务器 该商品 数量减少
    if (self.count) {
        self.count--;
        self.buyNumLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    }
    
    //生成一个参数
    NSDictionary *parameters = @{@"productId": self.cart.productId
                                 , @"amount":[NSNumber numberWithInteger:self.count],@"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    if ([self.delegate respondsToSelector:@selector(shoppingCellMinusBtnClick:andParameters:)]) {
        [self.delegate shoppingCellMinusBtnClick:self.cart andParameters:parameters];
    }
    
    
    
}

//加商品
- (IBAction)plusBtnClick:(UIButton *)sender {
    //点击一次  调用一次接口  服务器 该商品 数量增加
    
    self.count ++ ;
    
    self.buyNumLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    
    
    //生成一个参数
    NSDictionary *parameters = @{@"productId": self.cart.productId
                                 , @"amount":[NSNumber numberWithInteger:self.count],@"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    if ([self.delegate respondsToSelector:@selector(shoppingCellPlusBtnClick:andParameters:)]) {
        [self.delegate shoppingCellPlusBtnClick:self.cart andParameters:parameters];
    }
    
}

// 删除
- (IBAction)deleteBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shoppingCellDeleteBtnClick:)]) {
        [self.delegate shoppingCellDeleteBtnClick:self.cart];
    }
}

//选中
- (IBAction)gouBtnClick:(UIButton *)sender {
    
    if ([self.cart.classModel isEqualToString:@"trip"]) {
        return;
    }
    self.gouBtn.selected = !self.gouBtn.selected;
    
    self.cart.isSelect = self.gouBtn.selected;
    
    //生成一个参数
    NSDictionary *parameters = @{@"productId":self.cart.productId,
                                 @"classModel":self.cart.classModel,
                                 @"amount":[NSNumber numberWithInteger:self.count],
                                 @"selected":[NSNumber numberWithInteger:self.gouBtn.selected]};
    
    
    if ([self.delegate respondsToSelector:@selector(shoppingCellSelectBtnClick:andParameters:)]) {
            [self.delegate shoppingCellSelectBtnClick:self.cart andParameters:parameters];
        }
}


- (void)awakeFromNib {
    // Initialization code
    
    self.gouW.constant = 30 *SMMatchWidth;
    self.gouH.constant = 30 *SMMatchWidth;
    self.iconW.constant = 80 *SMMatchWidth;
    self.minusW.constant = 30 *SMMatchWidth;
    self.plusW.constant = 30 *SMMatchWidth;
    self.deleteW.constant = 45 *SMMatchWidth;
    self.deleteH.constant = 45 *SMMatchWidth;
    
    self.productName.font = KDefaultFont;
    self.specLabel.font = KDefaultFont;
    self.buyNumLabel.font = KDefaultFont;
    self.currentPrice.font = KDefaultFont;
    self.originalPrice.font = KDefaultFontBig;
    
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
}

-(void)setCart:(Cart *)cart{
    _cart = cart;
    //SMLog(@"cart.classModel = %@",cart.classModel);
    //旅游产品隐藏
    if ([self.cart.classModel isEqualToString:@"trip"]) {
        self.gouBtn.hidden = YES;
    }else{
        self.gouBtn.hidden = NO;
    }
    //赋值
    if (cart.isSelect) {
        self.gouBtn.selected = YES;
    }else{
        self.gouBtn.selected = NO;
    }
    SMLog(@"cart.sku  setCart  %@",cart.sku);
    if ([cart.sku isEqualToString:@"null"]) {
        self.specLabel.text = @"";
    }else{
        self.specLabel.text = cart.sku;
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productclick)];
    self.productView.userInteractionEnabled = YES;
    [self.productView addGestureRecognizer:tap];
    
    NSArray *arrPrice = [NSString mj_objectArrayWithKeyValuesArray:cart.imagePath];
    NSString *imageStr = arrPrice[0];
    
    [self.productView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 completed:nil];
    self.productView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.productName.text = cart.productName;
    
    self.buyNumLabel.text = [NSString stringWithFormat:@"%ld",cart.amount];
    
    self.originalPrice.text = [NSString stringWithFormat:@"现价:%.2lf",[cart.productFinalPrice doubleValue]];
    
    
    NSString *yuanjia = [NSString stringWithFormat:@"原价:%.2lf",[cart.productPrice doubleValue]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:yuanjia attributes:dict];
    [self.currentPrice setAttributedText:str];
    
    self.count = cart.amount;
}
-(void)productclick{
    SMLog(@"点击商品图片");
    
    if ([self.delegate respondsToSelector:@selector(shoppingCellProductImageBtnClick:)]) {
        [self.delegate shoppingCellProductImageBtnClick:self.cart];
    }
}
@end
