//
//  SMScanerBtn.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMScanerBtn : UIButton

//从关注页面创建的，则放大镜和二维码用白色图片
@property (nonatomic ,assign)BOOL isCreatedByCareVC;

@property (nonatomic ,assign)BOOL isCreatedByShoppingVC; /**< 从微商城界面创建的 */

+ (instancetype)scanerBtn;

@end
