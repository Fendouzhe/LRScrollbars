//
//  TaskDetailMainViewFrame.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
//@property (nonatomic,strong) UILabel *nameLabel;/**< 标题 */
//@property (nonatomic,strong) UILabel *timeLabel;/**< 时间 */
//@property (nonatomic,strong) UILabel *introLabel;/**< 详情 */
//@property (nonatomic,strong) UILabel *deadlineLabel;/**< 截止时间 */
//@property (nonatomic,strong) UIButton *participantButton;/**< 不能点击的按钮，参与人与前面的按钮 */
//@property (nonatomic,strong) UICollectionView *collectionView;/**< 头像部分 */

#import <Foundation/Foundation.h>
@class SMFatherTask;
@interface TaskDetailMainViewFrame : NSObject
@property (nonatomic,strong) SMFatherTask *cellData;/**< cellData */
@property (nonatomic,strong) NSArray *userArray;/**< 数组,SMParticipant */
@property (nonatomic,assign) CGRect iconImageViewFrame;/**<  */
@property (nonatomic,assign) CGRect nameLabelFrame;/**<  */
@property (nonatomic,assign) CGRect timeLabelFrame;/**<  */
@property (nonatomic,assign) CGRect mainLabelFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect introLabelFrame;/**<  */
@property (nonatomic,assign) CGRect deadlineImageFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect deadlineLabelFrame;/**<  */
//@property (nonatomic,assign) CGRect participantButtonFrame;/**<  */
//@property (nonatomic,assign) CGRect collectionViewFrame;/**<  */
@property (nonatomic,assign) CGFloat cellHeight;/**<  */
@property (nonatomic,assign) CGRect statusButtonFrame;/**<  */
@property (nonatomic,assign) CGRect personsImageViewFrame;/**< 人物列表 */
@property (nonatomic,assign) CGRect linkLabelFrame;/**< 人物 */
-(void)setFrameWithTask:(SMFatherTask *)cellData withArray:(NSArray *)userArray;
@end
