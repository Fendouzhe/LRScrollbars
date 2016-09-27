//
//  SMCounterProductCollectCellNew.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCounterProductCollectCellNew.h"
#import "SMShelfManagerScrollProduct.h"
#import "SMNewProduct.h"

#define IconWidth 90 *SMMatchWidth
#define Margin 10

@interface SMCounterProductCollectCellNew()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouHeight;

@end

@implementation SMCounterProductCollectCellNew


-(void)setCellType:(SMCollectionViewType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case SMCollectionViewTypeAdd:
        {
            //添加按钮view
            self.productIcon.image = [UIImage imageNamed:@"加-(2)"];
            self.productName.text = @"";
            self.price.text = @"";
            self.gouBtn.hidden = YES;

        }
            break;
        case SMCollectionViewTypeNormal:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.productName.backgroundColor = KControllerBackGroundColor;
    self.price.backgroundColor = KControllerBackGroundColor;
    
    self.gouBtn.hidden = YES;
    //柜台管理点击通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newShelfManagerDelete:) name:KNewShelfManagerDeleteNoti object:nil];
    //柜台管理全选通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewAllProductSelectedDelete:) name:KNewAllProductSelectedDelete object:nil];
    
    self.iconHeight.constant = 90 *SMMatchHeight;
    self.gouWidth.constant = 28 *SMMatchWidth;
    self.gouHeight.constant = 28 *SMMatchHeight;
    
}

//柜台管理全选通知监听
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
//柜台管理点击通知监听
- (void)newShelfManagerDelete:(NSNotification *)noti{
    //防止添加按钮出现打钩按钮
    if (self.cellType == SMCollectionViewTypeAdd) {
        //self.gouBtn.hidden = YES;
        return;
    }
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

- (void)setProduct:(SMNewProduct *)product{
    _product = product;
    self.productName.text = product.itemName;
    self.price.text = [NSString stringWithFormat:@"¥%.2f",product.finalPrice.floatValue];
    NSString *imagePath = [product.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=%zd",IconWidth *4 ,IconWidth *4 , 100]];
    [self.productIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
    
    if (self.product.rightItemSelected) {
        self.gouBtn.hidden = NO;
    }else{
        self.gouBtn.hidden = YES;
    }
    
    if (product.gouSelected == YES) {
        self.gouBtn.selected = YES;
    }else{
        self.gouBtn.selected = NO;
    }
}


//选择按钮点击
- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.product.gouSelected = !self.product.gouSelected;
    
}


@end
