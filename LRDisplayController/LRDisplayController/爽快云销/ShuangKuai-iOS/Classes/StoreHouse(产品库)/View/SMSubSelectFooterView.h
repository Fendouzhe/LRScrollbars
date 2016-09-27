//
//  SMSubSelectFooterView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)(void);

@interface SMSubSelectFooterView : UIView

@property(nonatomic ,copy)NSString * productID;

@property(nonatomic ,copy)NSMutableArray * favIDArray;

@property(nonatomic,strong)RefreshBlock refreshBlock;

@property(nonatomic,assign)BOOL isdown;

@property(nonatomic,assign)NSInteger type;



@end
