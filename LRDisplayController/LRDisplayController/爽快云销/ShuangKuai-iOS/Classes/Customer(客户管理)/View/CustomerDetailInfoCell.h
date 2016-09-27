//
//  CustomerDetailInfoCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerDetailInfoCellDelegate <NSObject>

@optional
/**
 *  cell按钮
 *
 *  @param index  cell的index,赋值
 *  @param number 从后面到前面
 */
-(void)cellButtonClickWithIndex:(NSIndexPath *)index withButtonNumber:(int)number;
@end

@class CustomerDetailBaseModel,CustomerDetailBigFrameModel;
@interface CustomerDetailInfoCell : UITableViewCell
@property (nonatomic,strong) CustomerDetailBaseModel *cellData;/**< model */
@property (nonatomic,strong) NSIndexPath *cellIndex;/**< cellIndex */
@property (nonatomic,strong) CustomerDetailBigFrameModel *frameCellData;/**< bigModel */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,weak) id<CustomerDetailInfoCellDelegate> delegate;/**<  */
@end
