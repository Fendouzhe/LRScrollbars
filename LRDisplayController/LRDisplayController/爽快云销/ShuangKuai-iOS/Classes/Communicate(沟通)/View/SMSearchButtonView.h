//
//  SMSearchButtonView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSearchButtonViewDelegate <NSObject>

@optional
-(void)searchButtonClick;
@end

@interface SMSearchButtonView : UIView
@property (nonatomic,weak) id<SMSearchButtonViewDelegate> delegate;/**< 代理 */
@end
