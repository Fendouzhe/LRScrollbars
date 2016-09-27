//
//  SMExtendedCell2.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMExtendedCell2Delegate <NSObject>

- (void)sizeBtnDidClick:(UIButton *)btn;

@end

@interface SMExtendedCell2 : UITableViewCell

@property (nonatomic ,assign)CGFloat totalHeight;

@property (nonatomic ,weak)id<SMExtendedCell2Delegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
