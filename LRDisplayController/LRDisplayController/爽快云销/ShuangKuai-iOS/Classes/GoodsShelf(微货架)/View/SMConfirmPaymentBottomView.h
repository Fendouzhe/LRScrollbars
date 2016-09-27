//
//  SMConfirmPaymentBottomView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SMConfirmPaymentBottomViewClickDelegate <NSObject>

-(void)ConfirmPaymentBottomViewRetainClick:(UIButton *)btn;

@end

@interface SMConfirmPaymentBottomView : UIView



+ (instancetype)confirmPaymentBottomView;

@property(nonatomic,strong)id<SMConfirmPaymentBottomViewClickDelegate> delegate;

@property(nonatomic,copy)NSDictionary * dataDic;

@property(nonatomic,copy)NSMutableArray * dataArray;
@end
