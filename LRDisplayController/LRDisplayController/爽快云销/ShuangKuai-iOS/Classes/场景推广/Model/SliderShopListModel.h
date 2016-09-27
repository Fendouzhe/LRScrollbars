//
//  SliderShopListModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SliderShopListModel : NSObject
@property (nonatomic,copy) NSString *imageUrl;/**< <#属性#> */
@property (nonatomic,copy) NSString *title;/**< <#属性#> */
@property (nonatomic,copy) NSString *price;/**< <#属性#> */
@property (nonatomic,strong) NSString *oldPrice;/**< <#属性#> */
@property (nonatomic,assign) BOOL grabEnd;/**< 抢购完毕 */
@property (nonatomic,assign) int personNumber;/**< 抢购人数 */
@end
