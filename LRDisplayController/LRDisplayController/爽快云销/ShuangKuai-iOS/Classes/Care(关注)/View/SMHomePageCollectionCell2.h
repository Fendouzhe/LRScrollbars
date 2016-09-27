//
//  SMHomePageCollectionCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMHomePageCollectionCell2Delegate <NSObject>

- (void)addBtnDidClick;

@end

@interface SMHomePageCollectionCell2 : UICollectionViewCell

@property (nonatomic ,weak)id<SMHomePageCollectionCell2Delegate> delegate;/**<  监听添加按钮点击事件 */

@end
