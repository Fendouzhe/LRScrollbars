//
//  SMRightItemView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMRightItemViewDelegate <NSObject>
@optional
- (void)searchBtnDidClick;

- (void)scanerBtnDidClick;

@end

@interface SMRightItemView : UIView

@property (nonatomic ,weak)id<SMRightItemViewDelegate> delegate;

//从关注页面创建的，则放大镜和二维码用白色图片
@property (nonatomic ,assign)BOOL isCreatedByCareVC;

@property (nonatomic ,assign)BOOL isCreatedByShoppingVC; /**< 从微商城界面创建的  显示分享图标 */

+ (instancetype)rightItemView;



@end
