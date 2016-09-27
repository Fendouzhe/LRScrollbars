//
//  SMCheatView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pushBlock)(UIViewController * Vc);

@interface SMCheatView : UIView

@property(nonatomic,copy)NSString * ID;

@property(nonatomic,assign)NSInteger type;
/**
 *  创建弹出选择框
 *
 *  @param ID     商品id
 *  @param type   商品类型  0表示产品  1表示活动  2表示优惠券
 *  @param height 高度补偿  用于调整高度
 *
 *  @return UIView
 */
+(instancetype)initWithID:(NSString *)ID andType:(NSInteger)type andHeight:(CGFloat)height;

@property(nonatomic,assign)CGFloat height;

-(void)requestshelfData;

-(void)CounterCheck;

-(void)disappearClick;

@property(nonatomic,assign)BOOL isCounter;

@property(nonatomic,copy)pushBlock pushblock;

@end
