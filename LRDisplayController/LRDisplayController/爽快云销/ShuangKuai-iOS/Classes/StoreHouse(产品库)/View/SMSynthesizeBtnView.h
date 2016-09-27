//
//  SMSynthesizeBtnView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSynthesizeBtnViewClickDelegate <NSObject>

-(void)priceBtnClick:(UIButton *)btn;

-(void)trustBtnClick:(UIButton *)btn;

@end

@interface SMSynthesizeBtnView : UIView<SMSynthesizeBtnViewClickDelegate>

@property (strong, nonatomic) IBOutlet UIButton *priceBtn;

@property (strong, nonatomic) IBOutlet UIImageView *arrowHeadImageView;

//代表着是价格排序还是佣金排序
@property(nonatomic,assign)BOOL isPrice;

@property(nonatomic,strong) id<SMSynthesizeBtnViewClickDelegate> delegate;

@end
