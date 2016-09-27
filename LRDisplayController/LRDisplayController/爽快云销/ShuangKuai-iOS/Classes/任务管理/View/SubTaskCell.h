//
//  SubTaskCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubTaskCellDelegate <NSObject>

@optional
-(void)statusButtonClickWithStatus:(int)status withSonTaskID:(NSString *)taskId;
-(void)clickNameWithUserID:(NSString *)userID;
@end


@class SubTaskViewModel;
@interface SubTaskCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *index;/**< <#属性#> */
@property (nonatomic,weak) id<SubTaskCellDelegate> delegate;/**<  */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setCellData:(SubTaskViewModel *)cellData WithParticipantArray:(NSArray *)participantArray;
@end
