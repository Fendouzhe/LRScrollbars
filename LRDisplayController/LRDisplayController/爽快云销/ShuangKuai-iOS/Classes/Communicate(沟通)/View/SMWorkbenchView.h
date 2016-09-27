//
//  SMWorkbenchView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMWorkbenchViewDelegate <NSObject>

- (void)workbenchViewDidClickWithTag:(NSInteger)tag;

@end

@interface SMWorkbenchView : UIView

@property (nonatomic ,weak)id<SMWorkbenchViewDelegate> deledate;

- (instancetype)initWithImage:(UIImage *)image andName:(NSString *)name andTag:(NSInteger)tag;

@end
