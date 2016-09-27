//
//  SMPersonInfoSectionHeaderView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPersonInfoSectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(instancetype)sharedSectionHeaderView;

@end
