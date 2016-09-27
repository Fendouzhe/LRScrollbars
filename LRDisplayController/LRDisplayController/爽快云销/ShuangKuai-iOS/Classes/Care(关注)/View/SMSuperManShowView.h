//
//  SMSuperManShowView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSuperManShowView : UIView

@property (nonatomic ,assign)NSInteger flag;

@property (nonatomic ,strong)UIImage *bgImage;

+ (instancetype)superManShowView;

@property(nonatomic,strong)User * user;
@end
