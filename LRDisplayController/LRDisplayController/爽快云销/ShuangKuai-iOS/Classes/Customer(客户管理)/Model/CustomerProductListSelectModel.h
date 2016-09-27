//
//  CustomerProductListSelectModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerProductListBaseModel.h"

@interface CustomerProductListSelectModel : CustomerProductListBaseModel
@property (nonatomic,assign,getter=isSelect) BOOL select;/**< 选中状态 */
@end
