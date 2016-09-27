//
//  SMCircelCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tweetFrame;

typedef void(^iconBlock)(void);
@interface SMCircelCell : UITableViewCell

/**
 *  转发爽快圈的整体view
 */
@property (nonatomic ,strong)UIView *retweetView;
/**
 *  被转发爽快圈的 标题图片
 */
@property (nonatomic ,strong)UIButton *retweetTitleImage;
/**
 *  被转发爽快圈的标题
 */
@property (nonatomic ,strong)UILabel *retweetTitle;

@property (nonatomic ,strong)tweetFrame *tweetFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)iconBlock iconblock;

@end
