//
//  SMCounterCellSection0.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCounterCellSection0.h"

@interface SMCounterCellSection0 ()

@property (weak, nonatomic) IBOutlet UIView *partnerView;

@property (weak, nonatomic) IBOutlet UIView *cutShelfView;

@property (weak, nonatomic) IBOutlet UIView *orderView;

@property (weak, nonatomic) IBOutlet UIView *cartView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partnerIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *partnerIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *counterIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CounterIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartIconHeight;

@end

@implementation SMCounterCellSection0

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"counterCellSection0";
    SMCounterCellSection0 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMCounterCellSection0" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self judgeIsLevel2];
    
    [self addGestureTaps];
    
    [self match];
}

- (void)match{
    self.partnerIconWidth.constant = 25 *SMMatchHeight;
    self.partnerIconHeight.constant = self.partnerIconWidth.constant;
    self.counterIconWidth.constant = self.partnerIconWidth.constant;
    self.CounterIconHeight.constant = self.partnerIconWidth.constant;
    self.orderIconWidth.constant = self.partnerIconWidth.constant;
    self.orderIconHeight.constant = self.partnerIconWidth.constant;
    self.cartIconWidth.constant = self.partnerIconWidth.constant;
    self.cartIconHeight.constant = self.partnerIconWidth.constant;    
}

- (void)addGestureTaps{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(partnerViewClick)];
    [self.partnerView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutShelfViewClick)];
    [self.cutShelfView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewClick)];
    [self.orderView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartViewClick)];
    [self.cartView addGestureRecognizer:tap4];
}

#pragma mark -- 点击事件
- (void)partnerViewClick{
    if ([self.delegate respondsToSelector:@selector(partnerViewDidClick)]) {
        [self.delegate partnerViewDidClick];
    }
}

- (void)cutShelfViewClick{
    if ([self.delegate respondsToSelector:@selector(cutShelfViewDidClick)]) {
        [self.delegate cutShelfViewDidClick];
    }
}

- (void)orderViewClick{
    if ([self.delegate respondsToSelector:@selector(orderViewDidClick)]) {
        [self.delegate orderViewDidClick];
    }
}

- (void)cartViewClick{
    if ([self.delegate respondsToSelector:@selector(cartViewDidClick)]) {
        [self.delegate cartViewDidClick];
    }
}

- (void)judgeIsLevel2{
    NSInteger isLevel2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    SMLog(@"isLevel2   %zd",isLevel2);
    if (isLevel2) {
        CGFloat width = KScreenWidth/4;
        CGFloat magrin = (KScreenWidth-3*width)/4;
        CGFloat height = self.contentView.height;
        //2级
        self.partnerView.hidden = YES;
        //先约中间的
        [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).with.offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
        [self.cutShelfView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
            make.right.equalTo(self.orderView.mas_left).with.offset(-magrin);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
        [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
            make.left.equalTo(self.orderView.mas_right).with.offset(magrin);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
    }

}


@end
