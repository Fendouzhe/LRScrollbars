//
//  SMBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/4.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMBottomView.h"

@implementation SMBottomView

+ (instancetype)bottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMBottomView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.backgroundColor = KControllerBackGroundColor;
}
@end
