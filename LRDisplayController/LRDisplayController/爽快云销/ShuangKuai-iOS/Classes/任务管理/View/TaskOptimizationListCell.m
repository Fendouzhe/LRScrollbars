//
//  TaskOptimizationListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskOptimizationListCell.h"

@interface TaskOptimizationListCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
@property (nonatomic,strong) UILabel *nameLabel;/**< 名字 */
@property (nonatomic,strong) UILabel *timeLabel;/**< 时间 */
@property (nonatomic,strong) UILabel *mainLabel;/**< 标题 */
@property (nonatomic,strong) UILabel *introLabel;/**< 详情 */
@property (nonatomic,strong) UILabel *deathLabel;/**< 截至时间 */
@property (nonatomic,strong) UIButton *completeStatusButton;/**< 状态 */
@end

@implementation TaskOptimizationListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        self.mainLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mainLabel];
        
        self.introLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.introLabel];
        
        self.deathLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.deathLabel];
        
        self.completeStatusButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.completeStatusButton];
    }
    return self;
}

-(void)setCellData:(TaskListModel *)cellData{
    _cellData = cellData;
    
}

@end
