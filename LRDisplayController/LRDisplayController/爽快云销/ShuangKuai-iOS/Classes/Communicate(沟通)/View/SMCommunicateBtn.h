//
//  SMCommunicateBtn.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCommunicateBtn : UIView

@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@property (weak, nonatomic) IBOutlet UILabel *founctionTitle;

+(instancetype)communicateBtn;

+ (instancetype)communicateBtnWithImage:(NSString *)imageName title:(NSString *)title;

@end
