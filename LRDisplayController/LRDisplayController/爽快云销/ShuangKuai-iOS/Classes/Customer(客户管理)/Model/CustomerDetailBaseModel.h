//
//  CustomerDetailBaseModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, DetailTextAlignment) {
    DetailTextAlignmentLeft,
    DetailTextAlignmentCenter,
    DetailTextAlignmentRight
};
@interface CustomerDetailBaseModel : NSObject
@property (nonatomic,copy) NSString *iconImage;/**< icon图标 */
@property (nonatomic,copy) NSString *title;/**< 标题 */
@property (nonatomic,copy) NSString *detailText;/**< 尾部 */
@property (nonatomic,copy) CellOption option;/**< block */
@property (nonatomic,assign) DetailTextAlignment textAlignment;/**< 文本对齐向 */
@property (nonatomic,copy) NSString *time;/**< 时间 */

@end
