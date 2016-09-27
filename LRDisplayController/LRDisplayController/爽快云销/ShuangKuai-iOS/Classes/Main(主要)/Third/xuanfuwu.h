//
//  xuanfuwu.h
//  悬浮物
//
//  Created by 施永辉 on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DownLoadBlock) ();

@protocol xuanfuwuDelegate <NSObject>

- (void)xuanfuwuDidClick;

@end


@interface xuanfuwu : UIView

@property (nonatomic ,assign) CGPoint startPoint;//触摸起始点

@property (nonatomic ,assign) CGPoint endPoint;//触摸结束点

@property (nonatomic ,copy) DownLoadBlock downLoadBlock;

@property (nonatomic ,weak)id<xuanfuwuDelegate> delegate;/**< 代理 */

@end
