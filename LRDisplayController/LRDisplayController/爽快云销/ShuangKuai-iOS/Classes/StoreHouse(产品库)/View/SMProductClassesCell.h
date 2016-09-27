//
//  SMProductClassesCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classify.h"

typedef void(^showBlock)(NSString * classId);
@class skuSelected;
@interface SMProductClassesCell : UITableViewCell

@property (nonatomic ,assign)CGFloat cellHeight;

@property (nonatomic ,strong)skuSelected *skuS;

//用来接收分类数组
@property (nonatomic,copy)NSMutableArray * classifyArray;

@property (nonatomic,strong)showBlock showblock;


//+ (instancetype)cellWithTableView:(UITableView *)tableView;

//+ (instancetype)cellWithTableView:(UITableView *)tableView andModel:(skuSelected *)skuS;


+ (instancetype)cellWithTableView:(UITableView *)tableView andModel:(NSArray *)skuS;


@end
