//
//  SMNewsController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewsController : UIViewController

/**
 *  搜索的数据
 */
@property(nonatomic,copy)NSString * keyWord;

@property (nonatomic ,strong)UITableView *tableView;

@end
