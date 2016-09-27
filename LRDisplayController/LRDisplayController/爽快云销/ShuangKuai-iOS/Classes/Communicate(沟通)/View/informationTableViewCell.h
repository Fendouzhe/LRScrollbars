//
//  informationTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informationTableViewCell : UITableViewCell

-(void)refreshUIWithUser:(User * )user andRemark:(NSString *)remark;
@property(nonatomic,strong)User * user;

@property(nonatomic,strong)Information * info;
@end
