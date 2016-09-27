//
//  SMTaskContentCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSonTask.h"
#import "SMSonTaskList.h"
@class SMFatherTask;
@interface SMTaskContentCell : UITableViewCell

@property (nonatomic ,strong)UITextView *inputView;/**< 输入框 */

@property (nonatomic ,strong)UILabel *holderLabel;/**< 充当输入框的placeHolder */

@property (nonatomic ,strong)SMFatherTask *fatherTask;/**< 父任务模型 */

//@property (nonatomic ,strong)SMSonTask *sonTask;/**< 子任务模型 */
@property (nonatomic ,strong)SMSonTaskList *list;/**< 子任务模型 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
