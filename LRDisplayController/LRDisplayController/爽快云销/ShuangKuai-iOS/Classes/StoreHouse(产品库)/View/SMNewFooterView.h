//
//  SMNewFooterView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMJoinGoodsShelfDelegate <NSObject>

-(void)joinBtnClick;

- (void)buyNowBtnDidClick;

- (void)goToCounterDidClick;

@end
@interface SMNewFooterView : UIView

@property (strong, nonatomic) IBOutlet UIButton *footerBtn;

@property (nonatomic,strong)id<SMJoinGoodsShelfDelegate> delegate;

@end
