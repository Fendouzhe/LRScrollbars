//
//  SMChooseParticipantCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMFriend;
@interface SMChooseParticipantCell : UITableViewCell

@property (nonatomic ,strong)SMFriend *friendModel;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *gouBtn;/**< 对勾按钮 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
