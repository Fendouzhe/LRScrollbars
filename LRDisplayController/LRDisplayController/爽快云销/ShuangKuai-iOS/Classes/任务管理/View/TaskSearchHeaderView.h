//
//  TaskSearchHeaderView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskSearchHeaderViewDelegate <NSObject>

@optional
-(void)taskSearchWithStr:(NSString *)str;
@end

@interface TaskSearchHeaderView : UIView
-(void)setSearchTextWithStr:(NSString *)str;
@property (nonatomic,strong) UITextField *textField;/**<  */
@property (nonatomic,weak) id<TaskSearchHeaderViewDelegate> delegate;/**< <#属性#> */
@end
