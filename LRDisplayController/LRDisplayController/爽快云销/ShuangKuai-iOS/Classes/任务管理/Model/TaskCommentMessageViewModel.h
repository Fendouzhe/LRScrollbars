//
//  TaskCommentMessageViewModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
//@property (nonatomic,strong) UILabel *nameLabel;/**< 名字 */
//@property (nonatomic,strong) UILabel *timeLabel;/**< 时间 */
//@property (nonatomic,strong) UILabel *introLabel;/**< 内容详情 */

#import <Foundation/Foundation.h>
@class TaskCommentMessage;
@interface TaskCommentMessageViewModel : NSObject
@property (nonatomic,strong) TaskCommentMessage *cellData;/**<  */
@property (nonatomic,assign) CGRect iconImageViewFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect nameLabelFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect timeLabelFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect introLabelFrame;/**< <#属性#> */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */
@end
