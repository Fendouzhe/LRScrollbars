//
//  SMContactPersonTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMContactPersonTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SMFriend.h"
@interface SMContactPersonTableViewCell ()



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;


@end

@implementation SMContactPersonTableViewCell

+ (instancetype)contactPersonCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMContactPersonTableViewCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"contactPersonTableViewCell";
    SMContactPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMContactPersonTableViewCell contactPersonCell];
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = backgroundView;
//        MJWeakSelf
//        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf);
//        }];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
    }
//    SMLog(@"cell.subviews = %@",cell.subviews);
    for (UIView *view in cell.subviews) {
        id class = NSClassFromString(@"_UITableViewCellSeparatorView");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setMyFriend:(SMFriend *)myFriend{
    _myFriend = myFriend;
    //显示缩略图
    CGFloat width = 80;

    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
    NSString *iconStr = [myFriend.portrait stringByAppendingString:strEnd];
    
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    
    [self.icon setShowActivityIndicatorView:YES];
    [self.icon setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nameLabel.text = myFriend.name;
    
    self.selected = myFriend.select;
}

- (void)setUser:(User *)user{
    _user = user;
    
    //显示缩略图
    CGFloat width = 80;
    
    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
    NSString *iconStr = [user.portrait stringByAppendingString:strEnd];
    
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    
    [self.icon setShowActivityIndicatorView:YES];
    [self.icon setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nameLabel.text = user.name;
    
    self.selected = _myFriend.select;
}

- (void)awakeFromNib{
    
    self.iconWidth.constant = 41 *SMMatchHeight;
    self.icon.layer.cornerRadius = 41 *SMMatchHeight / 2.0;
    self.icon.clipsToBounds = YES;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];

}


@end
