//
//  SMDropView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/7.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDropView.h"

@interface SMDropView ()

//灰色的view
@property (nonatomic ,strong)UIImageView *containerView;


/**
 *  删除商品
 */
@property (nonatomic ,strong)UIButton *deleteBtn;

@property (nonatomic ,strong) UIButton *groupBtn;/**< 发起群聊按钮 */

@property (nonatomic ,assign)CGRect newFrame;



@end

@implementation SMDropView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIImageView alloc] init];
        
        self.containerView.image = [UIImage imageNamed:@"xintishikuang"];//群聊版本
//        self.containerView.image = [UIImage imageNamed:@"tishikuang"];//非群聊版本
        self.containerView.userInteractionEnabled = YES;
        [self addSubview:self.containerView];
        
        //添加商品
        self.addBtn = [[UIButton alloc] init];
        [self addSubview:_addBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = SMColor(138, 139, 141);
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        NSAttributedString *attributrStr = [[NSAttributedString alloc] initWithString:@"添加朋友" attributes:dict];
        [self.addBtn setAttributedTitle:attributrStr forState:UIControlStateNormal];
        [self.addBtn setBackgroundColor:[UIColor clearColor]];
        [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        //删除模板
        self.deleteBtn = [[UIButton alloc] init];
        [self addSubview:self.deleteBtn];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"扫一扫" attributes:dict];
        [self.deleteBtn setAttributedTitle:str2 forState:UIControlStateNormal];
        [self.deleteBtn setBackgroundColor:[UIColor clearColor]];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //添加群聊
        self.groupBtn = [[UIButton alloc] init];
        [self addSubview:self.groupBtn];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"发起群聊" attributes:dict];
        [self.groupBtn setAttributedTitle:str3 forState:UIControlStateNormal];
        [self.groupBtn setBackgroundColor:[UIColor clearColor]];
        [self.groupBtn addTarget:self action:@selector(groupBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}


#pragma mark -- 点击事件
//添加朋友
- (void)addBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(addBtnDidClick)]) {
        [self.delegate addBtnDidClick];
    }
    
    [self dismiss];
}
//点击了 扫一扫
- (void)deleteBtnClick{
    //SMLog(@"点击了 扫一扫");
    
    if ([self.delegate respondsToSelector:@selector(deleteBtnDidClick)]) {
        [self.delegate deleteBtnDidClick];
    }
    
    [self dismiss];
}
//发起群聊
-(void)groupBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(groupBtnDidClick)]) {
        [self.delegate groupBtnDidClick];
    }
    
    [self dismiss];
    
}

+ (instancetype)menu{
    return [[self alloc] init];
}

- (void)showFrom:(UIView *)from{
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    [window addSubview:self];
    
    self.frame = window.bounds;
    
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.newFrame = newFrame;
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
    // 通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.containerView.width = 104;
    self.containerView.height = 80+35;//群聊版本
//    self.containerView.height = 80;//非群聊版本
    self.containerView.y = CGRectGetMaxY(self.newFrame);
    self.containerView.x = CGRectGetMaxX(self.newFrame) - self.containerView.width;
    
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).with.offset(0);
        make.top.equalTo(self.containerView.mas_top).with.offset(10+70);
        make.right.equalTo(self.containerView.mas_right).with.offset(0);
        make.height.equalTo(@35);
    }];
    
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.containerView.mas_left).with.offset(0);
        make.top.equalTo(self.containerView.mas_top).with.offset(10);
        make.right.equalTo(self.containerView.mas_right).with.offset(0);
        make.height.equalTo(@35);
    }];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.containerView.mas_left).with.offset(0);
        make.top.equalTo(self.containerView.mas_top).with.offset(10+35);
        make.right.equalTo(self.containerView.mas_right).with.offset(0);
        make.height.equalTo(@35);
    }];
    
    SMLog(@"%@",NSStringFromCGRect(self.deleteBtn.frame));
    
    
//    SMLog(@"%@",NSStringFromCGRect(self.groupBtn.frame));
}

@end
