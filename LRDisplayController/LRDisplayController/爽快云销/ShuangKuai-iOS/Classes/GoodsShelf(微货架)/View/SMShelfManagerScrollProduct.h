//
//  SMShelfManagerScrollProduct.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMNewProduct;
@interface SMShelfManagerScrollProduct : UIView

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *price;

//@property (nonatomic ,strong)FavoritesDetail *f;

@property (nonatomic ,strong)SMNewProduct *product;

+ (instancetype)shelfManagerScrollProduct;

@end
