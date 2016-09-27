//
//  SMSuperManShowView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSuperManShowView.h"
#import <UIButton+WebCache.h>

@interface SMSuperManShowView ()
/**
 *  图片的背景
 */
@property (nonatomic ,strong)UIImageView *bgView;
/**
 *  背景图片上面再盖一层view 透明的  用来真正展示内容
 */
@property (nonatomic ,strong)UIView *mainView;
/**
 *  头像
 */
@property (nonatomic ,strong)UIButton *iconBtn;
/**
 *  名字
 */
@property (nonatomic ,strong)UIButton *nameBtn;
/**
 *  业绩
 */
@property (nonatomic ,strong)UILabel *resultLabel;

@end

@implementation SMSuperManShowView

+ (instancetype)superManShowView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //图片的背景
        UIImageView *bgView = [[UIImageView alloc] init];
        [self addSubview:bgView];
        self.bgView = bgView;
        
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
        [bgView addGestureRecognizer:tap];
        
        
        
        //背景图片上面再盖一层view 透明的  用来真正展示内容
        UIView *mainView = [[UIView alloc] init];
        [self addSubview:mainView];
        mainView.backgroundColor = [UIColor clearColor];
        self.mainView = mainView;
        
        //头像
        UIButton *iconBtn = [[UIButton alloc] init];
        self.iconBtn = iconBtn;
        [mainView addSubview:iconBtn];
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"220"] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //名字
        UIButton *nameBtn = [[UIButton alloc] init];
        [mainView addSubview:nameBtn];
        self.nameBtn = nameBtn;
        [nameBtn setImage:[UIImage imageNamed:@"发现（新）guanjun"] forState:UIControlStateNormal];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFont;
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"名字" attributes:dict];
        [nameBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        
        
        //业绩
        UILabel *resultLabel = [[UILabel alloc] init];
        [mainView addSubview:resultLabel];
        self.resultLabel = resultLabel;
        resultLabel.text = @"业绩：888888元";
        resultLabel.textColor = KRedColor;
        resultLabel.font = KDefaultFontSmall;
       
    }
    return self;
}

- (void)bgViewClick{
    SMLog(@"bgViewClick");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KSuperManIconClickNoteKey] = self.user;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KSuperManIconClickNote object:self userInfo:dict];
}



- (void)setBgImage:(UIImage *)bgImage{
    _bgImage = bgImage;
    self.bgView.image = self.bgImage;
}

- (void)setFlag:(NSInteger)flag{
    _flag = flag;
    self.iconBtn.tag = flag;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat marginTop = 15*KMatch;
    CGFloat marginLeft = 20;
    
    self.bgView.frame = self.bounds;
    
    //头像
    CGFloat iconW = self.bounds.size.width - marginLeft *2;
    self.iconBtn.frame = CGRectMake(marginLeft, marginTop, iconW, iconW);
    self.iconBtn.layer.cornerRadius = iconW / 2.0;
    self.iconBtn.layer.masksToBounds = YES;
    
    //名字
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconBtn.mas_bottom).with.offset(9*KMatch);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    //业绩
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameBtn.mas_bottom).with.offset(8*KMatch);
        
    }];
    
}

#pragma mark -- 点击事件
- (void)iconBtnClick{
    SMLog(@"点击了销售达人的头像");
    
#pragma mark -- 可以去 首页页面  接收这个通知，并获取到  点击的是哪个头像（btn  活着btn.tag）然后做相应的跳转
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KSuperManIconClickNoteKey] = self.user;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KSuperManIconClickNote object:self userInfo:dict];
}

-(void)setUser:(User *)user{
    _user = user;
    
    CGFloat iconW;
    if (isIPhone5) {
        iconW = 50;
    }else if (isIPhone6){
        iconW = (50 + 10) * KMatch6;
    }else if (isIPhone6p){
        iconW = (50 + 12.3) * KMatch6p;
    }
    
    if (user.portrait) {
        NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",iconW *2,iconW *2];
        NSString *str = [self.user.portrait stringByAppendingString:strEnd];
        [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"]];
    }else{
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"220"] forState:UIControlStateNormal];
    }
    
    
    self.iconBtn.layer.cornerRadius = iconW / 2.0;
    self.iconBtn.layer.masksToBounds = YES;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:user.name attributes:dict];
    [self.nameBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
    if (!user.sumMoney) {
        self.resultLabel.text = @"业绩:0.00元";
    }else
    {
        self.resultLabel.text = [NSString stringWithFormat:@"业绩:%.2f元",user.sumMoney.doubleValue];
    }
}

@end
