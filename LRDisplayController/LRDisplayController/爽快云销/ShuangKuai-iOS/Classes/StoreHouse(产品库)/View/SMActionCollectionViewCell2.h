//
//  SMActionCollectionViewCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMActionCollectionViewCell2 : UICollectionViewCell

@property (nonatomic ,assign) CGFloat cellHeight;

+ (instancetype)actionCollectionViewCell2;


-(void)refreshUI:(Activity*)activity;
@end
