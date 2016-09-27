//
//  SMProductClassesHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductClassesHeaderView.h"

@implementation SMProductClassesHeaderView

+ (instancetype)productClassesHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMProductClassesHeaderView" owner:nil options:nil] lastObject];
}



- (IBAction)rightBtnClick:(id)sender {
    SMLog(@"点击了 header的右边按钮");

}

-(void)setClassify:(Classify *)classify{
    _classify = classify;
    self.leftLabel.text = [classify name];
}
@end
