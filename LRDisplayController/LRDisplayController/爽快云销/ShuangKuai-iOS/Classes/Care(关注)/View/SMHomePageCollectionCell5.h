//
//  SMHomePageCollectionCell5.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMHomePageCollectionCell5Delegate <NSObject>

- (void)moreBtnDidClick:(UIButton *)btn;

@end

@interface SMHomePageCollectionCell5 : UICollectionViewCell

@property (nonatomic ,weak)id<SMHomePageCollectionCell5Delegate> delegate;/**< 监听更多按钮点击事件 */

@end
