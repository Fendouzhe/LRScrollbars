//
//  SMShelfManagerScrollProduct.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfManagerScrollProduct.h"
#import <UIImageView+WebCache.h>
#import "SMNewProduct.h"


#define IconWidth 90 *SMMatchWidth
#define Margin 10
@interface SMShelfManagerScrollProduct ()


@property (nonatomic ,assign)BOOL rightItemSelected;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouHeight;
@end

@implementation SMShelfManagerScrollProduct

+ (instancetype)shelfManagerScrollProduct{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

//- (void)setF:(FavoritesDetail *)f{
//    _f = f;
//    self.productName.text = f.itemName;
//    self.price.text = [NSString stringWithFormat:@"¥%.2f",f.value2.floatValue];
//    SMLog(@"f.itemName  %@",f.itemName);
//    NSString *imagePath = [f.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=%zd",90 *4 ,90 *4 , 50]];
//    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
//}

- (void)setProduct:(SMNewProduct *)product{  
    _product = product;
    NSLog(@"product.itemName = %@ product.finalPrice=%@ product.imagePath = %@",product.itemName,product.finalPrice,product.imagePath);
    self.productName.text = product.itemName;
//    SMLog(@"product.price  %@   product.finalPrice  %@",product.price,product.finalPrice);
    self.price.text = [NSString stringWithFormat:@"¥%.2f",product.finalPrice.floatValue];
//    SMLog(@"f.itemName  %@",f.itemName);
    NSString *imagePath = [product.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=%zd",IconWidth *4 ,IconWidth *4 , 100]];
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
    
    
    if (self.product.rightItemSelected) {
        self.gouBtn.hidden = NO;
    }else{
        self.gouBtn.hidden = YES;
    }
    
    
    //SMLog(@"self.product.rightItemSelected   %zd",self.product.rightItemSelected);
    
    if (product.gouSelected == YES) {
        self.gouBtn.selected = YES;
    }else{
        self.gouBtn.selected = NO;
    }
}

- (void)awakeFromNib{
    self.productName.backgroundColor = KControllerBackGroundColor;
    self.price.backgroundColor = KControllerBackGroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productTap)];
    [self addGestureRecognizer:tap];
    
    self.gouBtn.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newShelfManagerDelete:) name:KNewShelfManagerDeleteNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewAllProductSelectedDelete:) name:KNewAllProductSelectedDelete object:nil];

    self.iconHeight.constant = 90 *SMMatchHeight;
    self.gouWidth.constant = 28 *SMMatchWidth;
    self.gouHeight.constant = 28 *SMMatchHeight;
    
}


- (void)NewAllProductSelectedDelete:(NSNotification *)noti{
    
    NSString *isAllSelected = noti.userInfo[KNewAllProductSelectedDeleteKey];
    if (isAllSelected.integerValue == YES) {  //如果选择了全选
        
        self.gouBtn.selected = YES;
        self.product.gouSelected = YES;
    }else{
        self.gouBtn.selected = NO;
        self.product.gouSelected = NO;
    }
    
}

- (void)newShelfManagerDelete:(NSNotification *)noti{
    NSString *rightItemSelected = noti.userInfo[KNewShelfManagerDeleteNotiKey];
//    self.rightItemSelected = rightItemSelected;
    self.product.rightItemSelected = rightItemSelected.integerValue;
    SMLog(@"rightItemSelected   %@",rightItemSelected);
    
    // 判断是否需要隐藏勾勾
    if (rightItemSelected.integerValue == YES) {
        self.gouBtn.hidden = NO;
        
    }else{
//        self.gouBtn.selected = NO;
        
        self.gouBtn.hidden = YES;
    }
    
    self.product.gouSelected = NO;
    self.gouBtn.selected = NO;
}


//当前View点击事件,发送通知给代理跳转到商品详情控制器
- (void)productTap{
    SMLog(@"productTap ");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KScrollingProductNotiKey] = self.product;
    SMLog(@"self.f   %@",self.product);
    [[NSNotificationCenter defaultCenter] postNotificationName:KScrollingProductNoti object:self userInfo:dict];
}

//选择按钮点击
- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.product.gouSelected = !self.product.gouSelected;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    SMLog(@"NSStringFromCGRect(self.productIcon.frame)   %@",NSStringFromCGRect(self.productIcon.frame));
}
@end
