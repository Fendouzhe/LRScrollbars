//
//  SMSettingTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSettingTableViewCellDelegate <NSObject>

@optional
-(void)switchButtonClick:(BOOL)on;
@end

@class SMBaseCellData;
@interface SMSettingTableViewCell : UITableViewCell
@property (nonatomic,strong) SMBaseCellData *cellData;/**< cell模型 */
@property (nonatomic,weak) id<SMSettingTableViewCellDelegate> delegate;/**< 代理 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
