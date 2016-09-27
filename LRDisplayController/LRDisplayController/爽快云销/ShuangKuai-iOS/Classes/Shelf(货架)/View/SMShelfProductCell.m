//
//  SMShelfProductCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfProductCell.h"
#import <UIButton+WebCache.h>

@interface SMShelfProductCell ()
/**
 *  图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/**
 *  商品名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  当前价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
/**
 *  原始价格
 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@property (nonatomic ,assign)BOOL isAllSelected;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconheight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *midImageWidthConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *midImageHeightConstraint;
@end

@implementation SMShelfProductCell

+ (instancetype)shelfProductCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMShelfProductCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    //self.currentPriceLabel.textColor = KRedColor;
    self.gouBtn.layer.cornerRadius = 10;
    self.gouBtn.clipsToBounds = YES;
    self.gouBtn.hidden = YES;
    
    if (isIPhone5) {
        self.iconheight.constant = 154;
        self.midImageWidthConstraint.constant = 209;
        self.midImageHeightConstraint.constant = 85;
    }else if (isIPhone6){
        self.iconheight.constant = 154 *KMatch6Height;
        self.midImageWidthConstraint.constant = 209*KMatch6;
        self.midImageHeightConstraint.constant = 85*KMatch6Height;
    }else if (isIPhone6p){
        self.iconheight.constant = 154 *KMatch6pHeight;
        self.midImageWidthConstraint.constant = 209*KMatch6p;
        self.midImageHeightConstraint.constant = 85*KMatch6pHeight;
    }
}

- (void)setFavDetail:(FavoritesDetail *)favDetail{
    _favDetail = favDetail;
    self.nameLabel.text = favDetail.itemName;
    self.originalPriceLabel.text = [NSString stringWithFormat:@"原价：￥%.0lf",[favDetail.value1 doubleValue]];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.0lf",[favDetail.value2 doubleValue]];
//    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:favDetail.imagePath] forState:UIControlStateNormal];
    //[self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:favDetail.imagePath] forState:UIControlStateNormal];
    
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:favDetail.imagePath] forState:UIControlStateNormal placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    if (favDetail.isMoveRight) {
        self.gouBtn.hidden = NO;
    }else{
        self.gouBtn.hidden = YES;
    }
    
    if (favDetail.isAllSelected) {//如果属于全选状态，就把勾勾  勾上
        SMLog(@"favDetail.isAllSelected");
        self.gouBtn.selected = YES;
        self.isAllSelected = YES;
    }else{
        self.gouBtn.selected = NO;
        self.isAllSelected = NO;
        SMLog(@"!favDetail.isAllSelected");
    }
    

    
//    if (favDetail.isAllSelected || !favDetail.isMoveRight) {//如果属于全选状态，就把勾勾  勾上
//        SMLog(@"favDetail.isAllSelected");
//        self.gouBtn.selected = YES;
//        self.isAllSelected = YES;
//    }else{
//        self.gouBtn.selected = NO;
//        self.isAllSelected = NO;
//        SMLog(@"!favDetail.isAllSelected");
//    }
    
    
    if (self.gouBtn.selected) {
        [self gouBtnClick:self.gouBtn];
    }
    
    if (favDetail.isSelected) {
        self.gouBtn.selected = YES;
    }else{
        self.gouBtn.selected = NO;
    }
}

- (IBAction)iconBtnClick {
    SMLog(@"点击了 商品图标按钮");
    
}

- (void)buyNowBtnClick{
    SMLog(@"点击了 马上抢购");
}

- (IBAction)gouBtnClick:(UIButton *)sender {
    SMLog(@"点击了 cell左上角的勾勾");
    if (!self.isAllSelected) {//如果不是点击全选
        SMLog(@"不是点击全选");
        sender.selected = !sender.selected;
        self.favDetail.isSelected = !self.favDetail.isSelected;
    }
        //点击了全选
        NSString *selectedStr = [NSString stringWithFormat:@"%zd",sender.selected];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"KSelectedStrProduct"] = selectedStr;
        dict[@"KModleIDProduct"] = self.favDetail.id;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteProduct" object:self userInfo:dict];
    
    
   
}

- (void)manageBtnClick{
    
}

- (void)manageBtnClickAgain{
    
}

- (NSMutableArray *)arrDelete{
    if (_arrDelete == nil) {
        _arrDelete = [NSMutableArray array];
    }
    return _arrDelete;
}

@end
