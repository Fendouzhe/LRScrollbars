//
//  TaskMaskView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskMaskViewDelegate <NSObject>

@optional
-(void)selectButtonWithNumber:(int)number;
@end

@interface TaskMaskView : UIView

@property (nonatomic,weak) id<TaskMaskViewDelegate> delegate;/**< 代理 */

/**
 *  设置文字
 *
 *  @param array    文字数组
 *  @param position 方位，0，1，2左中右
 */
-(void)addTextButtonWithArrayText:(NSArray *)array withPosition:(int)position;
@end
