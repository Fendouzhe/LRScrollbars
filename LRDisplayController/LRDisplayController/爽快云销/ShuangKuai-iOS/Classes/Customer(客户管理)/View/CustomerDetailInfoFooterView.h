//
//  CustomerDetailInfoFooterView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerDetailInfoFooterViewDelegate <NSObject>

@optional
-(void)addNewNoteButtonClickWithStr:(NSString *)text;
@end

@interface CustomerDetailInfoFooterView : UIView
@property (nonatomic,weak) id<CustomerDetailInfoFooterViewDelegate> delegate;/**<  */
@end
