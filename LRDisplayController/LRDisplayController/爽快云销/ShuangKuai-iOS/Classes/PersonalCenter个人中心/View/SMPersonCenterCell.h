//
//  SMPersonCenterCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPersonCenterCellDelegate <NSObject>

- (void)iconBtnDidClick;

- (void)circleBtnDidClick;

- (void)caredBtnDidClick;

- (void)erWeiMaDidClick;

@end

@interface SMPersonCenterCell : UITableViewCell
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *circleNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *caredCompanyNumBtn;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,weak)id<SMPersonCenterCellDelegate> delegate;

@end
