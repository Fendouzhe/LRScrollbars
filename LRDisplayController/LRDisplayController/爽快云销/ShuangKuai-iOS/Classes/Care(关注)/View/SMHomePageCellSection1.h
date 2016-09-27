//
//  SMHomePageCellSection1.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHomePageCollectionCell4.h"


@protocol SMHomePageCellSection1Delegate <NSObject>

- (void)moreBtnDidClick2:(UIButton *)btn;

- (void)itemDidSelected:(NSInteger)type;

@end

@interface SMHomePageCellSection1 : UITableViewCell

@property (nonatomic ,weak)id<SMHomePageCellSection1Delegate> delegate;/**< 点击更多 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong)SMHomePageCollectionCell4 *cell4;/**< <#注释#> */

@property (nonatomic ,assign)BOOL isOpen; /**< 处于展开状态 */

@end
