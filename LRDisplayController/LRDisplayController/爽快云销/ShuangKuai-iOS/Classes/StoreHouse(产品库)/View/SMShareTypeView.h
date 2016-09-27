//
//  SMShareTypeView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^websiteBlock)(NSInteger tag);
typedef void(^qrcodeBlock)(NSInteger tag);
typedef void(^cancelBlock)(NSInteger tag);
@interface SMShareTypeView : UIView

@property (nonatomic ,copy)websiteBlock websiteBlock;/**< 分享链接 */
@property (nonatomic ,copy)qrcodeBlock qrcodeBlock;/**< 分享二维码 */
@property (nonatomic ,copy)cancelBlock cancelBlock;/**< 取消 */

+ (instancetype)shareTypeView;

@end
