//
//  SMPartnerCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPartnerCellDelegate <NSObject>

- (void)chatBtnDidClick;

@end

@interface SMPartnerCell : UITableViewCell

@property (nonatomic ,weak)id<SMPartnerCellDelegate> delegate;

+ (instancetype)cellWithTanleView:(UITableView *)tableView;

@end
