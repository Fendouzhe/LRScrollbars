//
//  SMOrderFootterView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMOrderFootterViewDelegate <NSObject>

- (void)followBtnDidClick:(SalesOrder *)salesOrder;

- (void)followBtnDidClick:(NSString *)sn andStatus:(NSInteger)status;

@end

@interface SMOrderFootterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *CommissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *postageLabel;

@property (weak, nonatomic) IBOutlet UILabel *reciverNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followStauteBtn;

@property (weak, nonatomic) IBOutlet UIView *underGrayView;

@property (nonatomic ,weak)id<SMOrderFootterViewDelegate> delegate;

@property (nonatomic,assign)NSInteger type;

+ (instancetype)orderFootterView;

@property(nonatomic,strong)SalesOrder * salesOrder;

-(void)refreshUI:(SalesOrder *)order;

@end
