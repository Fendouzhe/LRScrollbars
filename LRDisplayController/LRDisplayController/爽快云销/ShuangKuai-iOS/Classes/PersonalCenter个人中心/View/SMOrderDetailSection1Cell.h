//
//  SMOrderDetailSection1Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderDetailSection1Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
