//
//  YLFristVCHeardView.h
//  云联惠
//
//  Created by 薛养灿 on 15/10/13.
//  Copyright © 2015年 薛养灿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLFristVCHeardViewDelegate <NSObject>

- (void)headerViewDidClickedPage:(NSInteger)page imagePath:(NSString *)imagePath;

@end

@interface YLFristVCHeardView : UIView

@property (nonatomic ,weak)id<YLFristVCHeardViewDelegate> delegate;

@end
