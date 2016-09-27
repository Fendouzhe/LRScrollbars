//
//  CreatNewCustomerBaseModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatNewCustomerBaseModel : NSObject
@property (nonatomic,copy) NSString *title;/**< 标题 */
@property (nonatomic,copy) NSString *detailText;/**< 尾部 */
@property (nonatomic,strong) NSString *placeText;/**< place文本 */
@property (nonatomic,copy) CellOption option;/**< block */
@end
