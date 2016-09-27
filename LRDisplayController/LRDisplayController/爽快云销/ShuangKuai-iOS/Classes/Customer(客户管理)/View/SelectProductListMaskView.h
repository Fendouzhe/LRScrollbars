//
//  SelectProductListMaskView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectProductListMaskViewDelegate <NSObject>

@optional
-(void)maskViewClickWithNumber:(NSInteger)number;
@end

@interface SelectProductListMaskView : UIView
@property (nonatomic,weak) id<SelectProductListMaskViewDelegate> delegate;/**< 代理 */
-(void)addButtonWithTitle:(NSArray *)titleArray;
-(void)setButtonWithTopFrame:(CGRect)topFrame;
@end
