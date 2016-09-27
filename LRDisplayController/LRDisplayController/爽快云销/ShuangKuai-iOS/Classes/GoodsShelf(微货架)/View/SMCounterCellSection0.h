//
//  SMCounterCellSection0.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCounterCellSection0Delegate <NSObject>

- (void)partnerViewDidClick;
- (void)cutShelfViewDidClick;
- (void)orderViewDidClick;
- (void)cartViewDidClick;

@end

@interface SMCounterCellSection0 : UITableViewCell

@property (nonatomic ,weak)id<SMCounterCellSection0Delegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
