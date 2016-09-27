//
//  SMHomePageCellSection0.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMHomePageCellSection0Delegate <NSObject>

- (void)addBtnDidClick;

- (void)homePageCellSection0DataClickWithIndex:(NSInteger)index;

@end

@interface SMHomePageCellSection0 : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,weak)id<SMHomePageCellSection0Delegate> delegate;/**< 点击添加 */

@property (nonatomic ,assign)CGFloat cell0Height; /**< 今日收入的高度 */

@property (nonatomic ,strong)NSArray *arrDatas;/**<  */

@end
