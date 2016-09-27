//
//  SMChooseTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMChooseTableViewCellDelegate <NSObject>

- (void)choosePhoneNum:(UIButton *)phoneNumBtn;

@end

@interface SMChooseTableViewCell : UITableViewCell
//左边号码-
@property (nonatomic ,copy)NSString *leftNum;
//右边号码
@property (nonatomic ,copy)NSString *rightNum;

@property (nonatomic ,weak)id<SMChooseTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
