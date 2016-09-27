//
//  SMProductClassesHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classify.h"
@interface SMProductClassesHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property(nonatomic,strong)Classify * classify;

+ (instancetype)productClassesHeaderView;

@end
