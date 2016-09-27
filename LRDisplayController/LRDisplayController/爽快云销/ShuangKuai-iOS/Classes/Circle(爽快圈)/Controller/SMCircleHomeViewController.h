//
//  SMCircleHomeViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/28.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCircleHomeViewController : UITableViewController


- (void)loadDatas;

@property(nonatomic,assign)BOOL isSearch;

@property(nonatomic,copy)NSString * keyWord;

@end
