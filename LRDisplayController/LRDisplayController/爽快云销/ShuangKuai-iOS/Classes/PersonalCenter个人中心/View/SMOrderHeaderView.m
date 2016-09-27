//
//  SMOrderHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderHeaderView.h"

@implementation SMOrderHeaderView

+ (instancetype)orderHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMOrderHeaderView" owner:nil options:nil] lastObject];
}
-(void)HeardWithOrder:(NSString *)order andTimer:(NSString *)timer
{
    self.orderNum.text = order;
    //时间的格式未知 可能需要格式转换
    self.timeLabel.text = timer;    
}

@end
