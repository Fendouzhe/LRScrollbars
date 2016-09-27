//
//  SMPersonInfoNav.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)();
typedef void(^editBlock)();
typedef void(^settingBlock)();
typedef void(^iconClickBlock)();

@interface SMPersonInfoNav : UIView

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (nonatomic ,copy)backBlock backBlock;/**< <#注释#> */
@property (nonatomic ,copy)editBlock editBlock;/**< <#注释#> */
@property (nonatomic ,copy)settingBlock settingBlock;/**< <#注释#> */
@property (nonatomic ,copy)iconClickBlock iconClickBlock;/**< <#注释#> */
+ (instancetype)personInfoNav;

@end
