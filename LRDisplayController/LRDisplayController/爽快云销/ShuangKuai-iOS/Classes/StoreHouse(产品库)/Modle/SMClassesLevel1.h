//
//  SMClassesLevel1.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassesLevel1 : NSObject

@property (nonatomic ,copy)NSString *sort;/**< 暂时没用 */

@property (nonatomic ,copy)NSString *id;/**< id */

@property (nonatomic ,copy)NSString *companyId;/**< 公司id */
@property (nonatomic ,copy)NSString *level;/**< 等级 */
@property (nonatomic ,copy)NSString *name;/**< 分类名  */
@property (nonatomic ,copy)NSString *parentId;/**< 1级这个都是0  */

@property (nonatomic ,strong)NSArray *arrLevel2s;/**< 装分类2级的 */


@end
