//
//  SMOrderDetailFooterView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Pushblock)(UIViewController * vc);

@interface SMOrderDetailFooterView : UIView


@property (strong, nonatomic) IBOutlet UIButton *revisedPricebtn;

@property (strong, nonatomic) IBOutlet UIButton *modifyFreightBtn;

@property (strong, nonatomic) IBOutlet UIButton *closeOrderBtn;

@property(nonatomic,strong)Pushblock pushBlock;

@property(nonatomic,assign)NSInteger state;

@end
