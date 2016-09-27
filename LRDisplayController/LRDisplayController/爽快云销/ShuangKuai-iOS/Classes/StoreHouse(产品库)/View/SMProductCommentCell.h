//
//  SMProductCommentCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProductCommentCell : UITableViewCell

@property (nonatomic ,assign)CGFloat cellHeight;

+ (instancetype)productCommentCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
