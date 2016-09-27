//
//  SMTitleView.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBlock)(void);
typedef void(^rightBlock)(void);

@interface SMTitleView : UIView

//左边点击事件的block
@property(nonatomic,strong)leftBlock leftBlcok;
//右边点击事件的block
@property(nonatomic,strong)rightBlock rightBlcok;
//左边的btn
@property(nonatomic,strong)UIButton * leftButton;
//右边的btn
@property(nonatomic,strong)UIButton * rightButton;
/*
 * 创建定制的titleView
 *  leftTitle 左边按钮的描述
 *  rightTitle 右边按钮的描述
 *  ViewController 添加的控制器
 */
+(instancetype)CreatNavSwipTitleViewWithLeftTitle:(NSString *)leftTitle andRight:(NSString *)rightTitle andViewController:(UIViewController *)ViewController;
//左边的按钮点击事件
-(void)leftBtnClickAction:(leftBlock)leftBlock;
//右边按钮点击事件
-(void)rightBtnClickAction:(rightBlock)rightBlock;
//显示左边的红点
-(void)showLeftSpot;
//显示右边的红点
-(void)showRightSpot;
//隐藏左边的红点
-(void)hiddenLeftSpot;
//隐藏右边的红点
-(void)hiddenRightSpot;

@end
