//
//  SMShelfHotProductController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMShelfHotProductControllerDelegate <NSObject>

- (void)goToProductDetailVC:(NSString *)productID and:(Favorites *)fav;

- (void)moreProductDidClick;

- (void)hideHUD;
@end

@interface SMShelfHotProductController : UIViewController

@property (nonatomic ,weak)id<SMShelfHotProductControllerDelegate> delegate;

@property (nonatomic ,strong)Favorites *fav;

@end
