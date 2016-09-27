//
//  SMCircelMainTextCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class tweetFrame;
@interface SMCircelMainTextCell : UITableViewCell

/**
 *  头像
 */
@property (nonatomic ,strong)UIButton *iconBtn;

/**
 *  评论
 */
@property (nonatomic ,strong)UILabel *commentLabel;

@property (nonatomic ,assign) CGFloat cellHeight;

@property (nonatomic ,strong)TweetComment *comment;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
