//
//  SubTaskViewModel.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

//@property (nonatomic,copy) NSString *title;/**< 标题 */
//@property (nonatomic,copy) NSString *intro;/**< 详情 */
//@property (nonatomic,strong) NSArray *userArray;/**< 接受任务的人,User */

#import <Foundation/Foundation.h>

@class SMSonTask;
@interface SubTaskViewModel : NSObject
@property (nonatomic,strong) SMSonTask *cellData;/**< cellData */
@property (nonatomic,strong) NSArray *userArray;/**< 数组,SMParticipant */
@property (nonatomic,assign) CGRect backgroundFrame;/**< 背景标题 */
@property (nonatomic,assign) CGRect titleFrame;/**< 标题 */
@property (nonatomic,assign) CGRect introFrame;/**<  */
//@property (nonatomic,assign) CGRect participantButtonFrame;/**<  */
//@property (nonatomic,assign) CGRect collectionViewFrame;/**<  */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */
@property (nonatomic,assign) CGRect statusButtonFrame;/**<  */
@property (nonatomic,assign) CGRect personsImageViewFrame;/**< 人物列表 */
@property (nonatomic,assign) CGRect linkLabelFrame;/**< 人物 */
@property (nonatomic,assign) CGRect deathLineImageViewFrame;/**< <#属性#> */
@property (nonatomic,assign) CGRect deathLineLabelFrame;/**< 截止时间 */
-(void)setFrameWithTask:(SMSonTask *)cellData withArray:(NSArray *)userArray;
@end
