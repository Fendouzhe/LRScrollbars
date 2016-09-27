//
//  SMTaskTopView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskTopView.h"



@interface SMTaskTopView ()

@property (nonatomic ,strong)UIButton *allBtn;

@property (nonatomic ,strong)UIButton *alreadyDoneBtn;

@property (nonatomic ,strong)UIButton *notDoneBtn;

@property (nonatomic ,strong)UIView *underLine;

@property (nonatomic ,strong)UIView *leftLine;

@property (nonatomic ,strong)UIView *rightLine;

@property (nonatomic ,strong)UIView *allUnderLine;

@property (nonatomic ,strong)UIView *alreadyUnderLine;

@property (nonatomic ,strong)UIView *notDoneUnderLine;
@end

@implementation SMTaskTopView

+ (instancetype)taskTopView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KControllerBackGroundColor;
        //全部 按钮
        UIButton *allBtn = [[UIButton alloc] init];
        
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        dict3[NSFontAttributeName] = KDefaultFontBig;
        dict3[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:@"全部" attributes:dict3];
        [allBtn setAttributedTitle:attributeStr3 forState:UIControlStateNormal];
        
        NSMutableDictionary *dict33 = [NSMutableDictionary dictionary];
        dict33[NSFontAttributeName] = KDefaultFontBig;
        dict33[NSForegroundColorAttributeName] = KRedColor;
        NSAttributedString *attributeStr33 = [[NSAttributedString alloc] initWithString:@"全部" attributes:dict33];
        [allBtn setAttributedTitle:attributeStr33 forState:UIControlStateSelected];
        
        
        [allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:SMColor(180, 0, 27) forState:UIControlStateSelected];
        [allBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.allBtn = allBtn;
        [self addSubview:allBtn];
        allBtn.tag = TaskBtnTypeAll;
        
        //已完成 按钮
        UIButton *alreadyDoneBtn = [[UIButton alloc] init];
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        dict1[NSFontAttributeName] = KDefaultFontBig;
        dict1[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"已完成" attributes:dict1];
        [alreadyDoneBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
        
        NSMutableDictionary *dict11 = [NSMutableDictionary dictionary];
        dict11[NSFontAttributeName] = KDefaultFontBig;
        dict11[NSForegroundColorAttributeName] = KRedColor;
        NSAttributedString *attributeStr11 = [[NSAttributedString alloc] initWithString:@"已完成" attributes:dict11];
        [alreadyDoneBtn setAttributedTitle:attributeStr11 forState:UIControlStateSelected];
        
        
        [alreadyDoneBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.alreadyDoneBtn = alreadyDoneBtn;
        [self addSubview:alreadyDoneBtn];
        alreadyDoneBtn.tag = TaskBtnTypeAlready;
        
        //未完成
        UIButton *notDoneBtn = [[UIButton alloc] init];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        dict2[NSFontAttributeName] = KDefaultFontBig;
        dict2[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict2];
        [notDoneBtn setAttributedTitle:attributeStr2 forState:UIControlStateNormal];
        
        NSMutableDictionary *dict22 = [NSMutableDictionary dictionary];
        dict22[NSFontAttributeName] = KDefaultFontBig;
        dict22[NSForegroundColorAttributeName] = KRedColor;
        NSAttributedString *attributeStr22 = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict22];
        [notDoneBtn setAttributedTitle:attributeStr22 forState:UIControlStateSelected];
        
        [notDoneBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.notDoneBtn = notDoneBtn;
        [self addSubview:notDoneBtn];
        notDoneBtn.tag = TaskBtnTypeNotDone;
        
        //最下面的横线
        UIView *underLine = [[UIView alloc] init];
        self.underLine = underLine;
        [self addSubview:underLine];
        self.underLine.backgroundColor = KGrayColor;
        
        //左边小竖线
        UIView *leftLine = [[UIView alloc] init];
        self.leftLine = leftLine;
        [self addSubview:leftLine];
        self.leftLine.backgroundColor = KGrayColor;
        
        //右边的小竖线
        UIView *rightLine = [[UIView alloc] init];
        self.rightLine = rightLine;
        [self addSubview:rightLine];
        self.rightLine.backgroundColor = KGrayColor;
        
        //全部下面的红色横线
        UIView *allUnderLine = [[UIView alloc] init];
        self.allUnderLine = allUnderLine;
        [self addSubview:allUnderLine];
        self.allUnderLine.backgroundColor = KRedColor;
        
        //已完成下面的红色横线
        UIView *alreadyUnderLine = [[UIView alloc] init];
        self.alreadyUnderLine = alreadyUnderLine;
        [self addSubview:alreadyUnderLine];
        self.alreadyUnderLine.backgroundColor = KRedColor;
        
        //未完成下面的红色横线
        UIView *notDoneUnderLine = [[UIView alloc] init];
        self.notDoneUnderLine = notDoneUnderLine;
        [self addSubview:notDoneUnderLine];
        self.notDoneUnderLine.backgroundColor = KRedColor;
        
        self.allBtn.selected = YES;
        self.alreadyUnderLine.hidden = YES;
        self.notDoneUnderLine.hidden = YES;
    }
    return self;
}

#pragma mark -- 按钮点击事件

- (void)buttonDidClick:(UIButton *)btn{
    self.allBtn.selected = NO;
    self.alreadyDoneBtn.selected = NO;
    self.notDoneBtn.selected = NO;
    btn.selected = YES;
    self.allUnderLine.hidden = !self.allBtn.selected;
    self.alreadyUnderLine.hidden = !self.alreadyDoneBtn.selected;
    self.notDoneUnderLine.hidden = !self.notDoneBtn.selected;
    if ([self.delegate respondsToSelector:@selector(taskTopViewDidClick:)]) {
        [self.delegate taskTopViewDidClick:btn];
    }
}

- (void)allBtnClick:(UIButton *)btn{
    self.allBtn.selected = YES;
    self.alreadyDoneBtn.selected = NO;
    self.notDoneBtn.selected = NO;
    
    self.allUnderLine.hidden = !self.allBtn.selected;
    self.alreadyUnderLine.hidden = !self.alreadyDoneBtn.selected;
    self.notDoneUnderLine.hidden = !self.notDoneBtn.selected;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = KScreenWidth / 3.0;
    CGFloat y = 13;
    CGFloat height = 34 - 13 -13;
    NSNumber *heightNum = [NSNumber numberWithFloat:height];
    //左边竖线
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(width);
        make.top.equalTo(self.mas_top).with.offset(y);
        make.bottom.equalTo(self.mas_bottom).with.offset(-y);
        make.width.equalTo(@1);
    }];
    //右边竖线
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-width);
        make.top.equalTo(self.mas_top).with.offset(y);
        make.bottom.equalTo(self.mas_bottom).with.offset(-y);
        make.width.equalTo(@1);
    }];
    //下面灰色横线
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //全部按钮下面红色线
    [self.allUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.leftLine.mas_left).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //全部按钮
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.leftLine.mas_left).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-y);
        make.height.equalTo(heightNum);
    }];
    
    //已完成按钮下面红色线
    [self.alreadyUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLine.mas_right).with.offset(15);
        make.right.equalTo(self.rightLine.mas_left).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //已完成按钮
    [self.alreadyDoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLine.mas_left).with.offset(15);
        make.right.equalTo(self.rightLine.mas_left).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-y);
        make.height.equalTo(heightNum);
    }];
    
//    //未完成按钮下面红色线
    [self.notDoneUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alreadyUnderLine.mas_right).with.offset(30);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];

//    //未完成按钮
    [self.notDoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightLine.mas_right).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-y);
        make.height.equalTo(heightNum);
    }];
}
@end
