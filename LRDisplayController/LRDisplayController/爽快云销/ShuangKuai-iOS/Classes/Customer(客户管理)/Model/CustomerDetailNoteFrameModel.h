//
//  CustomerDetailNoteFrameModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CustomerDetailBaseModel;
@interface CustomerDetailNoteFrameModel : NSObject
@property (nonatomic,strong) WorkLog *cellData;/**<  */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell 高度 */
@property (nonatomic,assign) CGRect mainLabelFrame;/**< 时间 */
@property (nonatomic,assign) CGRect detailLabelFrame;/**< 详情 */
@end
