//
//  SMComposeViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^refreshBlock)(void);

@interface SMComposeViewController : UIViewController


@property(nonatomic,copy)refreshBlock refreshBlock;

@end
