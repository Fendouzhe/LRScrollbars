//
//  SMTemplateCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/8.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Favorites;
@protocol SMTemplateCellDelegate <NSObject>

- (void)rightBtnDidClick:(UIButton *)rightBtn;

@end

@interface SMTemplateCell : UITableViewCell

@property (nonatomic ,assign)NSInteger numOfShelf;

@property (nonatomic ,strong)Favorites *favorate;
/**
 *  左边的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/**
 *  右边的使用状态按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic ,weak)id<SMTemplateCellDelegate> delegate;

/**
 *   cell左边的勾勾按钮
 */
@property (nonatomic ,strong)UIButton *gouBtn;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

//+ (instancetype)cellWithTableView:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath;
/**
 *  cell右移代码
 */
- (void)managerBtnClick;
/**
 *  cell还原状态代码
 */
- (void)managerBtnClickAgain;

@end
