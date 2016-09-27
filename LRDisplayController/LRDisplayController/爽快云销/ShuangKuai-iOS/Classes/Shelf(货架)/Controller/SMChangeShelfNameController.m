//
//  SMChangeShelfNameController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChangeShelfNameController.h"
#import "AppDelegate.h"

@interface SMChangeShelfNameController ()

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation SMChangeShelfNameController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self setupNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)setupNav{
    self.title = @"更改微货架名字";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 40;
    rightBtn.height = 25;
    //        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClick{
    SMLog(@"点击了 保存 按钮");
    SMLog(@"self.arrProductDatas  %@ ----self.arrActionDatas  %@----- self.arrDiscountDatas  %@",self.arrProductDatas,self.arrActionDatas,self.arrDiscountDatas);
    SMLog(@"self.shelfID  %@",self.shelfID);
    
//    NSMutableArray *arrPro = [NSMutableArray array];
//    for (FavoritesDetail *f in self.arrProductDatas) {
//        [arrPro addObject:f.itemId];
//    }
//    
//    NSMutableArray *arrAct = [NSMutableArray array];
//    for (FavoritesDetail *f in self.arrActionDatas) {
//        [arrAct addObject:f.itemId];
//    }
//    
//    NSMutableArray *arrDis = [NSMutableArray array];
//    for (FavoritesDetail *f in self.arrDiscountDatas) {
//        SMLog(@"f.itemId   %@",f.itemId);
//        [arrDis addObject:f.itemId];
//    }
//    
//    [[SKAPI shared] createItem2MyStorage:self.shelfID andName:self.inputField.text andProductIds:arrPro andActivityIds:arrAct andCouponIds:arrDis block:^(id result, NSError *error) {
//        
//        if (!error) {
//            SMLog(@"result   %@",result);
//            if ([self.delegate respondsToSelector:@selector(saveSuccessName:)]) {
//                [self.delegate saveSuccessName:self.inputField.text];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            SMLog(@"error   %@",error);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，更改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }];
    
    [[SKAPI shared] updateStorage:self.inputField.text andFavId:self.shelfID andImageToken:@"" block:^(id result, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(saveSuccessName:)]) {
                [self.delegate saveSuccessName:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
    
}
@end
