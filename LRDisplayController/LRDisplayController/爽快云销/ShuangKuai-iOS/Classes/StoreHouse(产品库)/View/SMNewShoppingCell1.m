//
//  SMNewShoppingCell1.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewShoppingCell1.h"
#import "SMSynthesizeBtnView.h"

@interface SMNewShoppingCell1 ()<SMSynthesizeBtnViewClickDelegate>

@property (nonatomic ,strong)UIView *bottomGrayLine;
//销量排序
@property (nonatomic ,strong)UIButton *salesVolumeBtn;
//佣金排序
@property (nonatomic ,strong)SMSynthesizeBtnView *trustView;
//价格排序
@property (nonatomic ,strong)SMSynthesizeBtnView *synthesizeView;

@property (nonatomic ,strong)UIView *classLeftGrayView;
//分类
@property (nonatomic ,strong)UIButton *classesBtn;

@property (nonatomic ,strong)UIView *leftView;

@property (nonatomic ,strong)UIView *rightView;


@end

@implementation SMNewShoppingCell1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //下面给一条灰色横线
        UIView *bottomGrayLine = [[UIView alloc] init];
        [self.contentView addSubview:bottomGrayLine];
        bottomGrayLine.backgroundColor = KGrayColor;
        self.bottomGrayLine = bottomGrayLine;
        [self.bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.height.equalTo(@1);
        }];
        
        // 左边view
        UIView *leftView = [[UIView alloc] init];
        [self.contentView addSubview:leftView];
        self.leftView = leftView;
        
        
        //销量排序
        UIButton *salesVolumeBtn = [[UIButton alloc] init];
        self.salesVolumeBtn = salesVolumeBtn;
        [self.leftView addSubview:salesVolumeBtn];
        salesVolumeBtn.selected = YES;
        
        NSMutableDictionary *salesVolumeDictNor = [NSMutableDictionary dictionary];
        salesVolumeDictNor[NSFontAttributeName] = KDefaultFont;
        salesVolumeDictNor[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *salesVolumeStrNor = [[NSAttributedString alloc] initWithString:@"销量优先" attributes:salesVolumeDictNor];
        [salesVolumeBtn setAttributedTitle:salesVolumeStrNor forState:UIControlStateNormal];
        
        NSMutableDictionary *salesVolumeDictSel = [NSMutableDictionary dictionary];
        salesVolumeDictSel[NSFontAttributeName] = KDefaultFont;
        salesVolumeDictSel[NSForegroundColorAttributeName] = KRedColor;
        NSAttributedString *salesVolumeStrSel = [[NSAttributedString alloc] initWithString:@"销量优先" attributes:salesVolumeDictSel];
        [salesVolumeBtn setAttributedTitle:salesVolumeStrSel forState:UIControlStateSelected];
        [salesVolumeBtn addTarget:self action:@selector(salesVolumeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.salesVolumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.leftView.mas_centerX);
            make.centerY.equalTo(self.leftView.mas_centerY);
            make.height.equalTo(self.leftView.mas_height);
            make.width.equalTo(@60);
        }];
        
        //佣金排序
        SMSynthesizeBtnView * trustView = [[[NSBundle mainBundle] loadNibNamed:@"SMSynthesizeBtnView" owner:self options:nil] lastObject];
        trustView.delegate = self;
        self.trustView = trustView;
        [trustView.priceBtn setTitle:@"佣金排序" forState:UIControlStateNormal];
        [self.leftView addSubview:trustView];
        [self.trustView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.leftView.mas_top).with.offset(0);
            make.right.equalTo(self.leftView.mas_right).with.offset(0);
            make.bottom.equalTo(self.leftView.mas_bottom).with.offset(0);
            make.left.equalTo(self.salesVolumeBtn.mas_right).with.offset(0);
        }];
        
        //价格排序 按钮
        SMSynthesizeBtnView *synthesizeView = [[[NSBundle mainBundle] loadNibNamed:@"SMSynthesizeBtnView" owner:self options:nil] lastObject];
        //self.synthesizeBtn = synthesizeBtn;
        self.synthesizeView = synthesizeView;
        synthesizeView.isPrice = YES;
        synthesizeView.delegate = self;
        [self.leftView addSubview:synthesizeView];
        [self.synthesizeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.leftView.mas_top).with.offset(0);
            make.left.equalTo(self.leftView.mas_left).with.offset(0);
            make.bottom.equalTo(self.leftView.mas_bottom).with.offset(0);
            make.right.equalTo(self.salesVolumeBtn.mas_left).with.offset(0);
        }];
        
        
        //右边整体view （包括分类）
        UIView *rightView = [[UIView alloc] init];
        [self.contentView addSubview:rightView];
        self.rightView = rightView;
        rightView.backgroundColor = [UIColor greenColor];
        
        //商品分类
        UIButton *classesBtn = [[UIButton alloc] init];
        self.classesBtn = classesBtn;
        [self.rightView addSubview:classesBtn];
        NSMutableDictionary *dictClasses = [NSMutableDictionary dictionary];
        dictClasses[NSFontAttributeName] = KDefaultFont;
        dictClasses[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *classesStr = [[NSAttributedString alloc] initWithString:@"" attributes:dictClasses];
        [classesBtn setAttributedTitle:classesStr forState:UIControlStateNormal];
        [classesBtn setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
        [classesBtn addTarget:self action:@selector(classesBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.classesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.rightView.mas_centerX);
            make.centerY.equalTo(self.rightView.mas_centerY);
            make.height.equalTo(self.contentView.mas_height);
            make.width.equalTo(self.contentView.mas_height);
        }];
        
        //分类左边的回溯竖线
        UIView *classLeftGrayView = [[UIView alloc] init];
        classLeftGrayView.backgroundColor = [UIColor lightGrayColor];
        [self.rightView addSubview:classLeftGrayView];
        self.classLeftGrayView = classLeftGrayView;
        [self.classLeftGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.rightView.mas_top).with.offset(0);
            make.left.equalTo(self.rightView.mas_left).with.offset(0);
            make.bottom.equalTo(self.rightView.mas_bottom).with.offset(0);
            make.width.equalTo(@0.5);
        }];
    }
    return self;
}


#pragma mark -- 点击事件
- (void)salesVolumeBtnClick{
    SMLog(@"点击了 销量优先");
}

- (void)classesBtnClick{
    SMLog(@"点击了 分类按钮");
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat rightViewWidth = KScreenWidth / 8.0;
    NSNumber *widthRight = [NSNumber numberWithFloat:rightViewWidth];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.width.equalTo(widthRight);
    }];
    
    NSNumber *widthLeft = [NSNumber numberWithFloat:KScreenWidth - rightViewWidth];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.width.equalTo(widthLeft);
    }];
    
}

@end
