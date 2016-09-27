//
//  SMShelfProductCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMShelfProductCell : UICollectionViewCell

@property (nonatomic ,strong)NSMutableArray *arrDelete;

@property (nonatomic ,strong)FavoritesDetail *favDetail;

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

- (void)manageBtnClick;

- (void)manageBtnClickAgain;

+ (instancetype)shelfProductCell;

@end
