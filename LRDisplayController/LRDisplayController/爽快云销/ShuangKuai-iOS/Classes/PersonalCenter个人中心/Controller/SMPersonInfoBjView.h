//
//  SMPersonInfoBjView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPersonInfoBjView : UIView

@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UIImageView *bjIcon;

+ (instancetype)personInfoBjView;

@end
