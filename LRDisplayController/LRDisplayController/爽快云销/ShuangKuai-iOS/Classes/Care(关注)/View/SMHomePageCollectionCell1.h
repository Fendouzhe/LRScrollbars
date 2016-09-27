//
//  SMHomePageCollectionCell1.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMHomeSection0DataModel;
@class SMDataStation;
@class SMDataValue;
@interface SMHomePageCollectionCell1 : UICollectionViewCell

//新版模型
@property (nonatomic ,strong)SMHomeSection0DataModel *dataModel;

//旧版
@property (nonatomic ,strong)SMDataStation *data;/**< data */

@property (nonatomic ,strong)SMDataValue *value;/**<  */


- (void)hideRightView;

- (void)showRightView;

@end
