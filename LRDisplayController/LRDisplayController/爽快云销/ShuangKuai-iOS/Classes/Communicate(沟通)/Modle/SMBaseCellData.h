//
//  SMBaseCellData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBaseCellData : NSObject
@property (nonatomic,copy) NSString *title;/**< 标题 */
@property (nonatomic,copy) NSString *detailText;/**< 详细信息 */
@property (nonatomic,copy) NSString *titleImage;/**< 标题图像名称 */
@property (nonatomic,copy) NSString *detailImage;/**< 尾部图像 */
@property (nonatomic,copy) CellOption cellOption;/**< block块 */
@end
