//
//  TaskInfoSelectView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskInfoSelectViewDelegate <NSObject>

@optional
-(void)taskInfoMessageSelectWithNumber:(int)number;
@end

@interface TaskInfoSelectView : UIView
@property (nonatomic,assign) NSInteger selectTag;/**< <#属性#> */
@property (nonatomic,assign) NSInteger type;/**< <#属性#> */
@property (nonatomic,weak) id<TaskInfoSelectViewDelegate> delegate;/**< <#属性#> */

@property (nonatomic,assign) NSInteger recevieNumber;

@property (nonatomic,assign) NSInteger commentNumber;

-(void)setSelectNumber:(int)number;

@end
