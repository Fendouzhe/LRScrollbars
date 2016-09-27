//
//  SMSearchFooterView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchFooterView.h"

@implementation SMSearchFooterView

+ (instancetype)searchFooterView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSearchFooterView" owner:nil options:nil] lastObject];
}

- (IBAction)clearRecordBtnClick {
    if ([self.delegate respondsToSelector:@selector(clearRecordBtnDidClick)]) {
        [self.delegate clearRecordBtnDidClick];
    }
}


@end
