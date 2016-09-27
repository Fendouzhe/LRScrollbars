//
//  SearchChatMessageCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCMessage;
@interface SearchChatMessageCell : UITableViewCell
@property (nonatomic,strong) RCMessage *cellData;/**<  */
@property (nonatomic,strong) UILabel *mainLabel;/**< <#属性#> */
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
