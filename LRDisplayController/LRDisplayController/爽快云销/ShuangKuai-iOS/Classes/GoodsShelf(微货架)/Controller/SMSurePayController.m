//
//  SMSurePayController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSurePayController.h"
#import "SMShippingController.h"
#import <UIImageView+WebCache.h>
#import "SMProductDetailController.h"
#import "SMNetworkViewController.h"
#import "SMPayViewController.h"

@interface SMSurePayController ()

@property (weak, nonatomic) IBOutlet UILabel *buyerName;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *address;


@property (weak, nonatomic) IBOutlet UIButton *gouBtn;


@property (weak, nonatomic) IBOutlet UILabel *productName;
//套餐价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//红色价格
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
//邮费
@property (weak, nonatomic) IBOutlet UILabel *Postage;
 //留言
@property (weak, nonatomic) IBOutlet UITextView *memo;

@property (weak, nonatomic) IBOutlet UILabel *allPrice;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;

//点击手势
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (weak, nonatomic) IBOutlet UIView *productView;

@property (weak, nonatomic) IBOutlet UIView *gotoNetInfoView;

@property (nonatomic ,strong)Product *product;

@property (nonatomic, retain) NSNumber *finalPrice;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productIconWidth;
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *memoHeight;

@end

@implementation SMSurePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    [self match];
    
    [self setupDatas];
    
    [self addNotifications];
    
    self.grayView.backgroundColor = KControllerBackGroundColor;
    self.gouBtn.selected = YES;
    

}

- (void)match{
    if (isIPhone5) {
        self.topViewHeight.constant = 75;
        self.productViewHeight.constant = 85;
        self.memoHeight.constant = 90;
    }else if (isIPhone6){
        self.topViewHeight.constant = 75 *KMatch6Height;
        self.productViewHeight.constant = 85 *KMatch6Height;
        self.memoHeight.constant = 90 *KMatch6Height;
    }else if (isIPhone6p){
        self.topViewHeight.constant = 75 *KMatch6pHeight;
        self.productViewHeight.constant = 85 *KMatch6pHeight;
        self.memoHeight.constant = 90 *KMatch6pHeight;
    }
    self.productIconWidth.constant = self.productViewHeight.constant;
}

- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardFront:) name:@"KCardFrontUploadSeccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardBack:) name:@"KCardBackUploadSeccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardHand:) name:@"KCardHandCardUploadSeccess" object:nil];
}

- (void)getCardHand:(NSNotification *)noti{
    self.token3 = noti.userInfo[@"KCardHandCardUploadSeccessKey"];
    
}

- (void)getCardBack:(NSNotification *)noti{
    self.token2 = noti.userInfo[@"KCardBackUploadSeccessKey"];
}

- (void)getCardFront:(NSNotification *)noti{
    self.token1 = noti.userInfo[@"KCardFrontUploadSeccessKey"];
}


- (void)setupDatas{
    NSString *buyer = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
    self.buyerName.text = [NSString stringWithFormat:@"收货人:%@",buyer];
    self.phoneNum.text = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
    NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
    NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
    self.address.text = [provinceStr stringByAppendingString:detailAddress];
    
    UITapGestureRecognizer *tapTopView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTap)];
    [self.addressView addGestureRecognizer:tapTopView];
    
    
    
    [[SKAPI shared] queryProductById:self.productID block:^(Product *product, NSError *error) {
        if (!error) {
            
            NSString *imagePath = [NSString mj_objectArrayWithKeyValuesArray:product.imagePath].firstObject;
            [self.productIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
            self.productName.text = product.name;
            self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",product.finalPrice];
            self.allPrice.text = [NSString stringWithFormat:@"￥%@",product.finalPrice];
            self.finalPrice = product.finalPrice;
            if (!product.shippingFee.integerValue) {//如果邮费为0
                self.Postage.text = @"包邮";
            }else{
                self.Postage.text = [NSString stringWithFormat:@"￥%@",product.shippingFee];
            }
        }else{
            SMLog(@"error  queryProductById  %@",error);
        }
    }];
    UITapGestureRecognizer *tapProductView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productViewTap)];
    [self.productView addGestureRecognizer:tapProductView];
    
    
    UITapGestureRecognizer *tapGotoNetInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetInfoTap)];
    [self.gotoNetInfoView addGestureRecognizer:tapGotoNetInfo];
    
}

#pragma mark -- 点击事件

- (void)gotoNetInfoTap{
    SMNetworkViewController *vc = [[SMNetworkViewController alloc] init];
    vc.productID = self.productID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)productViewTap{
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    vc.product = self.product;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)topViewTap{
    SMLog(@"点击了地址信息 跳到地址界面");
    SMShippingController *vc = [SMShippingController new];
    vc.isDianxin = YES;
    vc.productID = self.productID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sureBtnClick:(id)sender {
    SMLog(@"点击了确认");
    if (!self.gouBtn.selected) { //如果没有选中商品的对勾按钮
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选中要购买的商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"doc1_token"] = self.token1;
    dict[@"doc2_token"] = self.token2;
    dict[@"doc3_token"] = self.token3;
    dict[@"idCard"] = self.cardNum;
    dict[@"real_name"] = self.name;
    dict[@"phone"] = self.phoneNumPara;
    SMLog(@"self.phoneNumPara   %@",self.phoneNumPara);
    SMLog(@"token1  %@   %@    %@  self.spec.id  %@",self.token1,self.token2,self.token3,self.spec.id);
    NSArray *arrSpec;
    if (self.spec) {
        arrSpec = [NSArray arrayWithObject:self.spec.id];
    }else{
        arrSpec = [NSArray arrayWithObject:self.specId];
    }
    SMLog(@"arrSpec  sureBtnClick  %@",arrSpec);
    [[SKAPI shared] settleOrderByBuyer:self.buyerName.text andBuyerPhone:self.phoneNum.text andAddress:self.address.text andBuyerTel:@"" andMemo:self.memo.text andProductIds:arrSpec andAmount:@1 andExtra:dict block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            SMPayViewController * pay = [SMPayViewController new];
            pay.orderStr = result[@"result"][@"masterOrderSn"];
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}


- (IBAction)gouBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.gouBtn.selected) {
        self.allPrice.text = [NSString stringWithFormat:@"￥%@",self.finalPrice];
    }else{
        self.allPrice.text = @"￥0";
    }
}

@end
