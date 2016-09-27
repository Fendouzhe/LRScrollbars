//
//  SMScenePromotionBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScenePromotionBottomView.h"



@implementation SMScenePromotionBottomView

+ (instancetype)scenePromotionBottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMScenePromotionBottomView" owner:nil options:nil] lastObject];
}


@end
