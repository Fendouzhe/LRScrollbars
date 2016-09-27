//
//  SMOrderDetailFootterView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderDetailFootterView.h"

@implementation SMOrderDetailFootterView

+ (instancetype)orderDetailFootterView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMOrderDetailFootterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.backgroundColor = KControllerBackGroundColor
}
@end
