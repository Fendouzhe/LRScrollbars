//
//  SMProductVideoTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProductVideoTableViewCell : UITableViewCell

@property(nonatomic,strong)UIWebView * webView;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)loadVideo:(NSString *)iframe;

@end
