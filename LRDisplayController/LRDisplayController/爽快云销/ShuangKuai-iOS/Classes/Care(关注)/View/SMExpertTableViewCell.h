//
//  SMExpertTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^pushBlock)(void);
@interface SMExpertTableViewCell : UITableViewCell


-(void)refreshUI:(User *)user andPlace:(NSInteger)No;

@property(nonatomic,strong)pushBlock pushblock;

@end
