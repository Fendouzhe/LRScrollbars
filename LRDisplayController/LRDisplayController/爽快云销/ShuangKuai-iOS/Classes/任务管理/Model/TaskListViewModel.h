//
//  TaskListViewModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
//@property (nonatomic,strong) UILabel *nameLabel;/**< 名字 */
//@property (nonatomic,strong) UILabel *timeLabel;/**< 任务发布时间 */
//@property (nonatomic,strong) UILabel *deadlineLabel;/**< 截止时间 */
//@property (nonatomic,strong) UICollectionView *collectionView;/**< 参与人 */
//@property (nonatomic,strong) UILabel *publishTypeLabel;/**< 发布状态 */

#import <Foundation/Foundation.h>
@class TaskListModel,MLLinkLabel;
@interface TaskListViewModel : NSObject
@property (nonatomic,strong) TaskListModel *cellData;/**< 模型 */
@property (nonatomic,assign) CGRect iconImageFrame;/**< 头像Frame */
@property (nonatomic,assign) CGRect nameLabelFrame;/**< 名字Frame */
@property (nonatomic,assign) CGRect deadlineImageFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect timeLabelFrame;/**< 时间Frame */
@property (nonatomic,assign) CGRect mainLabelFrame;/**< 标题 */
@property (nonatomic,assign) CGRect introLabelFrame;/**< 任务详情 */
@property (nonatomic,assign) CGRect deadlineFrame;/**< 截止时间Frame */
@property (nonatomic,assign) CGRect participantLabelFrame;/**< 参与人Frame */
@property (nonatomic,assign) CGRect publishTypeLabelFrame;/**< 发布状态 */
@property (nonatomic,strong) MLLinkLabel *linkLabel;/**<  */
@property (nonatomic,assign) CGRect lineViewFrame;/**< 分割线 */
@property (nonatomic,assign) CGRect childNumberLabelFrame;/**<  */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */
@end
