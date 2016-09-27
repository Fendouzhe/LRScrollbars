//
//  SMAdvertisementCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAdvertisementCell : UITableViewCell



+ (instancetype)cellWithTableview:(UITableView *)tableView;


-(void)refreshUI:(NSArray * )array;
@end
