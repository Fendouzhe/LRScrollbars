//
//  SMNumShelfViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNumShelfViewController : UIViewController

@property (nonatomic ,copy)NSString *shelfName;
/**
 *  微货架名字(可自定义)
 */
@property (weak, nonatomic) IBOutlet UILabel *shelfNameLabel;

@property (nonatomic ,strong)Favorites *favorite;

@property (nonatomic ,assign)NSInteger currentShelfNum;

@end
