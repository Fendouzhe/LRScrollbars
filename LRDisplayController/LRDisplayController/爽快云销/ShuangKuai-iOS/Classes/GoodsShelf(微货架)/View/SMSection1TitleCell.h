//
//  SMSection1TitleCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSection1TitleCellDelegate <NSObject>

- (void)moreBtnDidCLick;

@end

@interface SMSection1TitleCell : UITableViewCell

@property (nonatomic ,weak)id<SMSection1TitleCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
