//
//  SMShoppingBottomView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShoppingBottomView.h"

@interface SMShoppingBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

//适配
@property (weak, nonatomic) IBOutlet UILabel *allChooseLabel; //全选
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;//合计


@end


@implementation SMShoppingBottomView

+ (instancetype)shoppingBottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMShoppingBottomView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.settlementBtn setBackgroundColor:KRedColorLight];
    self.priceLabel.textColor = KRedColorLight;
    self.allChooseLabel.font = KDefaultFont;
    self.sumLabel.font = KDefaultFont;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoney:) name:@"Money" object:nil];
}

-(void)refreshMoney:(NSNotification *)not{
    NSString * str =  not.userInfo[@"sumMoney"];
    NSString *sumMoney = [NSString stringWithFormat:@"¥%.2f",str.floatValue];
    self.priceLabel.text = sumMoney;
}
- (IBAction)gouBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(shoppingBottomViewAllSelectedClick:)]) {
        [self.delegate shoppingBottomViewAllSelectedClick:sender];
    }
    
}

- (IBAction)settlementBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(shoppingBottomViewAccountClick:)]) {
        [self.delegate shoppingBottomViewAccountClick:sender];
    }
}



@end
