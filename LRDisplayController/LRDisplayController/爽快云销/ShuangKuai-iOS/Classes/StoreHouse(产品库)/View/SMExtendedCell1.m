//
//  SMExtendedCell1.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMExtendedCell1.h"


#define KOneRowCount 3
#define KMarginEdge 10
#define kButtonWidth 75
#define kButtonHeight 22
@interface SMExtendedCell1 ()
/**
 *  左上角的颜色label
 */
@property (nonatomic ,strong)UILabel *colorLabel;
/**
 *  有多少种颜色的
 */
@property (nonatomic ,assign)NSInteger colorCount;
/**
 *  用一个数组，来装所有的颜色数据种类
 */
@property (nonatomic ,strong)NSArray *colorArr;
/**
 *  另外一个数组，用来装按钮
 */
@property (nonatomic ,strong)NSMutableArray *btnArr;
/**
 *  中间部分横向的间距
 */
@property (nonatomic ,assign)CGFloat margin;


@end

@implementation SMExtendedCell1

- (NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"extendedCell1";
    SMExtendedCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMExtendedCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor greenColor];
        //这个数据需要网络加载过来的
        self.colorArr = @[@"白色",@"红色",@"黄色",@"橘色",@"灰色",@"蓝色"];
        self.colorCount = self.colorArr.count;
        self.margin = (KScreenWidth - KMarginEdge * 2 - kButtonWidth * KOneRowCount) / 2.0;
        
        //左上角颜色label
        UILabel *colorLabel = [[UILabel alloc] init];
        colorLabel.text = @"颜色";
        colorLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:colorLabel];
        self.colorLabel = colorLabel;
        
        //几个按钮,这里面还要添加选中状态下的显示y
        for (int i = 0; i < self.colorCount; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
//            [btn setTitle:self.colorArr[i] forState:UIControlStateNormal];
            [self.btnArr addObject:btn];
            [self.contentView addSubview:btn];
//            [btn setBackgroundColor:[UIColor yellowColor]];
            
            NSMutableDictionary *dictNor = [NSMutableDictionary dictionary];
            dictNor[NSFontAttributeName] = [UIFont systemFontOfSize:10];
            dictNor[NSForegroundColorAttributeName] = [UIColor blackColor];
            NSAttributedString *attributeStrNor = [[NSAttributedString alloc] initWithString:self.colorArr[i] attributes:dictNor];
            [btn setAttributedTitle:attributeStrNor forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"heikuang-1"] forState:UIControlStateNormal];
            
            NSMutableDictionary *dictSel = [NSMutableDictionary dictionary];
            dictSel[NSFontAttributeName] = [UIFont systemFontOfSize:10];
            dictSel[NSForegroundColorAttributeName] = KRedColor;
            NSAttributedString *attributeStrSel = [[NSAttributedString alloc] initWithString:self.colorArr[i] attributes:dictSel];
            [btn setAttributedTitle:attributeStrSel forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"kuanghong"] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        //计算cell总高度
        int row = ( (int)self.colorCount + KOneRowCount - 1)  /  KOneRowCount;
        
        self.totalHeight = KMarginEdge + 15 + (KMarginEdge + kButtonHeight) * row + KMarginEdge;
        SMLog(@"%zd",self.totalHeight);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat colorLabelH = 15;
    self.colorLabel.frame = CGRectMake(KMarginEdge, KMarginEdge, KScreenWidth - 2 * KMarginEdge, colorLabelH);
    
    for (UIButton *btn in self.btnArr) {
        
        NSInteger atRow = btn.tag / KOneRowCount;
        NSInteger atCol = btn.tag % KOneRowCount;
        
        CGFloat x = KMarginEdge + (kButtonWidth + self.margin) * atCol;
        CGFloat y = KMarginEdge + colorLabelH + KMarginEdge + (kButtonHeight + KMarginEdge) * atRow;
        btn.frame = CGRectMake(x, y, kButtonWidth, kButtonHeight);
        SMLog(@"test  %zd",y);
        
    }
}

// 这里参数可以利用btn.tag 取出数组中对应的值  ，直接把这个值传过去
- (void)btnClick:(UIButton *)btn{
    SMLog(@"选择了颜色 %zd",btn.tag);
    for (UIButton *btn in self.btnArr) {
        btn.selected = NO;
    }
    btn.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(colorBtnDidClick:)]) {
        [self.delegate colorBtnDidClick:btn];
    }
}


@end
