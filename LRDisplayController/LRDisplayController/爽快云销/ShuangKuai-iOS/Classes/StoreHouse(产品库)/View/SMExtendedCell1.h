//
//  SMExtendedCell1.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMExtendedCell1Delegate <NSObject>

- (void)colorBtnDidClick:(UIButton *)btn;

@end

@interface SMExtendedCell1 : UITableViewCell

@property (nonatomic ,assign)CGFloat totalHeight;

@property (nonatomic ,weak)id<SMExtendedCell1Delegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
