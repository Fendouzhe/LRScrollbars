//
//  SMMyTemCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditIdArrayBlock)(BOOL isadd);
typedef void(^AlertBlock)(void);
@interface SMMyTemCell : UITableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@property(nonatomic,strong)User * user;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)EditIdArrayBlock editIdArrayBlock;

//是否为选中
@property(nonatomic,assign)BOOL isSelect;

//按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic,copy)AlertBlock alertblock;

@end
