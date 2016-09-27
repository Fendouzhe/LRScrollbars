//
//  SMSearchHeaderView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^refreshUIblock)(NSMutableArray* array);

@interface SMSearchHeaderView : UIView

@property (nonatomic ,strong)UITextField *searchField;

+ (instancetype)searchHeaderView;


@property(nonatomic,strong)refreshUIblock refreshblock;

@end
