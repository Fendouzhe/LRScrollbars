//
//  TaskCommentInputView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define minHeight 36

#define maxHeight 128

@protocol TaskCommentInputViewDelegate <NSObject>

@optional
-(void)postCommentWithStr:(NSString *)str;
@end

@interface TaskCommentInputView : UIView
@property (nonatomic,weak) id<TaskCommentInputViewDelegate> delegate;/**< <#属性#> */

@property (strong, nonatomic)UITextView *textField;

@property(nonatomic,strong)UILabel *placeHolderLabel;

@property (nonatomic,strong) UIButton *button;/**< 发送按钮 */

@end
