//
//  CollectionViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionTableViewCellDelegate <NSObject>

@optional
//点击用户头像
-(void)clickUserWithUserID:(NSString *)userID;
//添加组成员
-(void)addGroupMemberClick;
//删除组成员
-(void)delGroupMemberClick;
@end

@class SMGroupChatDetailData;
@interface CollectionTableViewCell : UITableViewCell
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@property (nonatomic,weak) id<CollectionTableViewCellDelegate> delegate;/**< 代理 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
