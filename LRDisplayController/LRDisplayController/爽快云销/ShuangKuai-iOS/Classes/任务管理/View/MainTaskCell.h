//
//  MainTaskCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainTaskCellDelegate <NSObject>

@optional
-(void)statusButtonClickWithStatus:(int)status;
-(void)mainTaskCellclickNameWithUserID:(NSString *)userId;
@end

@class TaskDetailMainViewFrame,SMParticipant;
@interface MainTaskCell : UITableViewCell
//@property (nonatomic,strong) TaskDetailMainViewFrame *cellData;/**< cellData */
@property (nonatomic,weak) id<MainTaskCellDelegate> delegate;/**< <#属性#> */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setCellData:(TaskDetailMainViewFrame *)cellData WithParticipantArray:(NSArray *)participantArray;
@end
