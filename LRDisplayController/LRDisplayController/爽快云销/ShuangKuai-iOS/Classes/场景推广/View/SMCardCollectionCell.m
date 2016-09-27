//
//  SMCardCollectionCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCardCollectionCell.h"
#define SMAlpha 0.7

@interface SMCardCollectionCell ()

@property (nonatomic ,strong)NSArray *arrColor;/**< 底部颜色 */

@property (nonatomic ,strong)NSArray *arrTopTitle;/**< 上面活动名 */

@property (nonatomic ,strong)NSArray *arrBottomTitle;/**< 下面活动名 */

@property (nonatomic ,strong)NSMutableArray *arrIcons;/**< 图片 */
@end

@implementation SMCardCollectionCell

+ (instancetype)cardCollectionCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCardCollectionCell" owner:nil options:nil] lastObject];
}

- (void)getChange:(NSInteger)index{
//    self.bottomView.backgroundColor = self.arrColor[index];
    
    SMLog(@"getChange  index  %zd",index);
    self.bottomView.backgroundColor = self.arrColor[index];
    
    self.topLabel.text = self.arrTopTitle[index];
    self.botttomLabel.text = self.arrBottomTitle[index];
    self.iconView.userInteractionEnabled = YES;
    self.iconView.image = [UIImage imageNamed:self.arrIcons[index]];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.bottomView.alpha = 0.6;
    
//    
//    self.arrColor = @[SMColor(210, 52, 158),SMColor(157, 106, 79),SMColor(230, 97, 3),SMColor(55, 110, 149),SMColor(224, 154, 4),SMColor(42, 68, 89)];
    
    self.arrColor = @[SMColorAlpha(210, 52, 158, SMAlpha),SMColorAlpha(230, 97, 3, SMAlpha),SMColorAlpha(55, 110, 149, SMAlpha),SMColorAlpha(224, 154, 4, SMAlpha),SMColorAlpha(157, 106, 79, SMAlpha)];
    
//    self.arrTopTitle = @[@"拼团促销",@"秒杀",@"活动邀请",@"微文传播",@"海报推广",@"优惠券赠送"];
//    self.arrBottomTitle = @[@"拉上朋友一起购",@"分秒抢购，不容错过",@"精彩活动，等你体验",@"深度好闻，等你赏阅",@"图文海报，优惠扫码",@"送券营销，贴心销售"];
    
    self.arrTopTitle = @[@"拼团促销",@"活动邀请",@"微文传播",@"海报推广",@"秒杀"];
    self.arrBottomTitle = @[@"超低价团购",@"精彩活动，邀你体验",@"深度好闻，等你赏阅",@"图文海报，优惠扫码",@"限时秒杀，疯狂抢购"];
    
    
    self.layer.cornerRadius = 2 * SMCornerRadios;
    self.clipsToBounds = YES;
    
    
    for (int i = 0 ;i < 6; i++){
        
//        NSString * str = [NSString stringWithFormat:@"scenePromotion%d.png",i];
        NSString * str = [NSString stringWithFormat:@"popularize%d",i];
        [self.arrIcons addObject:str];
    }
    
    self.bottomView.hidden = YES;
}

- (NSMutableArray *)arrIcons{
    if (_arrIcons == nil) {
        _arrIcons = [NSMutableArray array];
    }
    return _arrIcons;
}

@end
