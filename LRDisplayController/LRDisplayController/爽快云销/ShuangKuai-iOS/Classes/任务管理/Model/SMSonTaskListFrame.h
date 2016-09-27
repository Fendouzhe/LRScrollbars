//
//  SMSonTaskListFrame.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMSonTaskList;
@interface SMSonTaskListFrame : NSObject

@property (nonatomic ,strong)SMSonTaskList *list;/**< <#注释#> */

@property (nonatomic ,assign)CGRect titleF; /**< 小任务label */

@property (nonatomic ,assign)CGRect contentF; /**< 内容 对应 remark */

@property (nonatomic ,assign)CGRect participantViewF; /**< 参与人view */

@property (nonatomic ,assign)CGRect participantF; /**< 参与人label */

@property (nonatomic ,assign)CGRect btn0F; /**< 头像按钮 */
@property (nonatomic ,assign)CGRect btn1F; /**< 头像按钮 */
@property (nonatomic ,assign)CGRect btn2F; /**< 头像按钮 */
@property (nonatomic ,assign)CGRect btn3F; /**< 头像按钮 */
@property (nonatomic ,assign)CGRect btn4F; /**< 头像按钮 */
@property (nonatomic ,assign)CGRect btn5F; /**< 头像按钮 */

@property (nonatomic ,assign)CGRect statusBtnF; /**< 显示状态的 */

@property (nonatomic ,assign)CGRect grayLineF; /**< <#注释#> */

@property (nonatomic ,assign)CGFloat cellHeight; /**< 整个cell高度 */



@end
