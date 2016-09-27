//
//  SMSubSelectTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSubSelectTableViewCell.h"

@interface SMSubSelectTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *showLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gouHeight;


@end
@implementation SMSubSelectTableViewCell

- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = ! sender.selected;
    
    if (sender.selected) {
        self.addFavIDBlcok();
    }else
    {
        self.subFavIDBlcok();
    }
}

-(void)setshowLabel:(NSString *)favName :(Favorites *)fav :(NSInteger)isCanAdd
{
    //self.selectBtn.selected = NO;
    self.selectBtn.enabled = YES;
    
    if (fav.gouIsSelected) {
        self.selectBtn.selected = YES;
    }else
    {
        self.selectBtn.selected = NO;
    }
    
    NSString * str = @"可添加";
    if (!isCanAdd) {
        self.selectBtn.enabled = NO;
        str = @"不可添加";
    }
    NSString * category;
    if (self.type==0) {
        category = @"商品";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.products.integerValue,category,str];
    }else if (self.type == 1)
    {
        category = @"活动";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.activitys,category,str];
    }else
    {
        category = @"优惠券";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.coupons,category,str];
    }
}

-(void)setsubshowLabel:(NSString *)favName :(Favorites * )fav :(NSInteger)isCansub
{
    self.selectBtn.selected = NO;
    self.selectBtn.enabled = YES;
    
    if (fav.gouIsSelected) {
        self.selectBtn.selected = YES;
    }else
    {
        self.selectBtn.selected = NO;
    }
    NSString * str = @"可下架";
    if (!isCansub) {
        self.selectBtn.enabled = NO;
        str = @"不可下架";
    }
    NSString * category;
    if (self.type==0) {
        category = @"商品";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.products.integerValue,category,str];
    }else if (self.type == 1)
    {
        category = @"活动";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.activitys,category,str];
    }else
    {
        category = @"优惠券";
        self.showLabel.text  = [NSString stringWithFormat:@"%@(%ld件%@,%@)",favName,fav.coupons,category,str];
    }
}


-(void)setFavorites:(Favorites *)favorites
{
    if (!favorites.isCanClick) {
        self.selectBtn.enabled = YES;
        self.selectBtn.hidden = NO;
    }else
    {
        self.selectBtn.hidden = YES;
        self.selectBtn.enabled = NO;
    }
}


- (void)awakeFromNib{
    self.gouWidth.constant = 15 *SMMatchWidth;
    self.gouHeight.constant = 15 *SMMatchWidth;
}

//颜色转换 背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
