//
//  SMCircleTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/27.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCircleTableViewCell : UITableViewCell

+ (instancetype)cellWithtableView:(UITableView *)tableView;


-(void)refreshUI:(Tweet *)tweet;
@end
