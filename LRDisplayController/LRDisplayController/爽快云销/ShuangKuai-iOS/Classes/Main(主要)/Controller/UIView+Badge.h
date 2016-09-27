//
//  UIView+Badge.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Badge)

//显示
-(void)showBadgeWith:(NSString *)BadgeVulue;

-(void)showBadge;

//删除
-(void)removeBadge;

@end
