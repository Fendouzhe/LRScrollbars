//
//  SMTitleView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTitleView.h"

@interface SMTitleView ()
//左边的线条
@property(nonatomic,strong)UILabel * leftLabel;
//右边的线条
@property(nonatomic,strong)UILabel * rightLabel;
//btn上的红点（有新消息可以显示出来的）
@property(nonatomic,strong)UILabel * leftSpotLabel;
@property(nonatomic,strong)UILabel *RightSpotLabel;

@end
@implementation SMTitleView

+(instancetype)CreatNavSwipTitleViewWithLeftTitle:(NSString *)leftTitle andRight:(NSString *)rightTitle andViewController:(UIViewController *)ViewController{
    
    SMTitleView * view = [[SMTitleView alloc]init];
    
    if (isIPhone5) {
        view.width = KScreenWidth-90-20;
    }else if(isIPhone6){
        view.width = KScreenWidth-90-55-20;
    }else if(isIPhone6p){
        view.width = KScreenWidth-90-94-20;
    }
    
    view.height = 44;
    view.center = CGPointMake(ViewController.view.centerX, 22);
    ViewController.navigationItem.titleView = view;
    
    
    //计算title的size
    CGSize size1 =  [leftTitle boundingRectWithSize:CGSizeMake(KScreenWidth, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFontBig} context:nil].size;
    
    CGSize size =  [rightTitle boundingRectWithSize:CGSizeMake(KScreenWidth, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFontBig} context:nil].size;
    
    
    //创建按钮
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    view.leftButton = btn1;
    //普通状态
    [btn1 setTitle:leftTitle forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.size = size1;
    btn1.origin = CGPointMake(view.frame.size.width/2-size1.width-10, 11);
    btn1.titleLabel.font = KDefaultFontBig;
    
    [btn1 addTarget:view action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //选中字体变红
    [btn1 setTitleColor:KRedColorLight forState:UIControlStateSelected];
    
    [view addSubview:btn1];
    
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    view.rightButton = btn2;
    [btn2 setTitle:rightTitle forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.size = size;
    btn2.origin = CGPointMake(view.frame.size.width/2+10, 11);
    btn2.titleLabel.font = KDefaultFontBig;
    [btn2 addTarget:view action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //选中字体变红
    [btn2 setTitleColor:KRedColorLight forState:UIControlStateSelected];
    
    [view addSubview:btn2];
    
    //创建下面的线条
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size1.width, 2)];
    leftLabel.backgroundColor = KRedColorLight;
    leftLabel.center = CGPointMake(btn1.centerX, CGRectGetMaxY(btn1.frame)+2);
    view.leftLabel = leftLabel;
    [view addSubview:leftLabel];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 2)];
    rightLabel.backgroundColor = KRedColorLight;
    rightLabel.center = CGPointMake(btn2.centerX, CGRectGetMaxY(btn2.frame)+2);
    view.rightLabel = rightLabel;
    [view addSubview:rightLabel];
    
    //初始选中左边的按钮
    view.rightLabel.hidden = YES;
    view.leftButton.selected = YES;
    
    
    UILabel * leftSpot = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    view.leftSpotLabel = leftSpot;
    leftSpot.origin = CGPointMake(btn1.width-2.5, -2.5);
    leftSpot.backgroundColor = KRedColorLight;
    leftSpot.layer.cornerRadius = 2.5;
    leftSpot.layer.masksToBounds = YES;
    [btn1 addSubview:leftSpot];
    
    UILabel * rightSpot = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    view.RightSpotLabel = rightSpot;
    rightSpot.origin = CGPointMake(btn2.width-2.5, -2.5);
    rightSpot.backgroundColor = KRedColorLight;
    rightSpot.layer.cornerRadius = 2.5;
    rightSpot.layer.masksToBounds = YES;
    [btn2 addSubview:rightSpot];
    
    return view;
    
}

-(void)showLeftSpot{
    self.leftSpotLabel.hidden = NO;
}
-(void)showRightSpot{
    self.RightSpotLabel.hidden = NO;
}

-(void)hiddenLeftSpot{
    self.leftSpotLabel.hidden = YES;
}

-(void)hiddenRightSpot{
    self.RightSpotLabel.hidden = YES;
}
-(void)leftBtnClickAction:(leftBlock)leftBlock{
    self.leftBlcok = leftBlock;
}

-(void)rightBtnClickAction:(rightBlock)rightBlock{
    self.rightBlcok = rightBlock;
}

-(void)leftBtnClick:(UIButton *)btn{
    SMLog(@"左边的按钮");
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = YES;
    self.leftBlcok();
}

-(void)rightBtnClick:(UIButton*)btn{
    SMLog(@"右边的按钮");
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    self.rightLabel.hidden = NO;
    self.leftLabel.hidden = YES;
    self.rightBlcok();
}
@end
