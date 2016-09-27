//
//  SMCarouselView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCarouselViewDelegate <NSObject>

- (void)headerViewDidClickedPage:(NSInteger)page;

@end

@interface SMCarouselView : UIView

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,weak)id<SMCarouselViewDelegate> delegate;

- (instancetype)initWithModel:(Product *)product;


@end
