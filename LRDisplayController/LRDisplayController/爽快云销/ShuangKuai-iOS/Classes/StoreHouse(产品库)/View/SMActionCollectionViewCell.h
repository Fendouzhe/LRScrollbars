//
//  SMActionCollectionViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMActionCollectionViewCell : UICollectionViewCell

/**
 *  活动图片，最顶部的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
/**
 *  参加人数
 */
@property (weak, nonatomic) IBOutlet UILabel *joinPersonNum;

@property (nonatomic ,strong)NSTimer *timer;

@property (nonatomic ,strong)Activity *activity;

+ (instancetype)actionCollectionViewCell;

-(void)refreshUI:(Activity *)activity;

@end
