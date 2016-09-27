//
//  SMOrderHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)orderHeaderView;

- (void)HeardWithOrder:(NSString*)order andTimer:(NSString *)timer;

@end
