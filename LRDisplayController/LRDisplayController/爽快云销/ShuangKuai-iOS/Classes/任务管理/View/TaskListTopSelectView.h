//
//  TaskListTopSelectView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskListTopSelectViewDelegate <NSObject>

@optional
-(void)topSelectButtonClick:(int)number;
@end
@class RightImageButton;
@interface TaskListTopSelectView : UIView

@property (nonatomic,weak) id<TaskListTopSelectViewDelegate> delegate;/**< 代理 */
-(void)setButtonTextWithArray:(NSArray *)array;
-(void)setButtonSelectWithNumber:(int)number;
-(void)setSecondButtonSelectWithText:(NSString *)text;
-(void)setThirdButtonSelectWithText:(NSString *)text;
-(void)setFirstButtonSelect:(BOOL)select;
@property (nonatomic,strong) RightImageButton *secondButton;/**< 第二个按钮 */
@property (nonatomic,strong) RightImageButton *thirdButton;/**< 第三个按钮 */
@end
