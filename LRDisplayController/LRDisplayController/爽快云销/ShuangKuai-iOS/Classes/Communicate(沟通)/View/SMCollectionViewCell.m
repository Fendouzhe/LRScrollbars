//
//  SMCollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCollectionViewCell.h"
#import "ChatroomMemberListData.h"
#import "SMGroupChatDetailData.h"

@interface SMCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconView;/**< 头像 */
@property (nonatomic,strong) UILabel *titleLabel;/**< 名字 */
@end

@implementation SMCollectionViewCell

-(UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        CGFloat radio = 40*SMMatchHeight;
        _iconView.layer.cornerRadius = radio/2.0;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        CGFloat radio = 40*SMMatchHeight;
//        CGFloat w = self.frame.size.width;
//        self.iconView.frame = CGRectMake((w-radio)*0.5,10, radio, radio);
//        self.titleLabel.frame = CGRectMake(0,CGRectGetMaxY(self.iconView.frame) + 5 , w, 20);
    }
    return self;
}

-(void)setCellType:(SMCollectionViewType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case SMCollectionViewTypeAdd:
        {
            self.iconView.image = [UIImage imageNamed:@"100jia"];
            self.titleLabel.text = @"";
        }
            break;
        case SMCollectionViewTypeDel:
        {
            self.iconView.image = [UIImage imageNamed:@"100jian"];
            self.titleLabel.text = @"";
        }
            break;
        case SMCollectionViewTypeNone:
        {
            //[self.iconView sd_setImageWithURL:[NSURL URLWithString:_cellData.portrait] placeholderImage:[UIImage imageNamed:@"220"]];
        }
            break;
        default:
            break;
    }
}

-(void)setCellData:(ChatroomMemberListData *)cellData{
    _cellData = cellData;
//    switch (self.cellType) {
//        case SMCollectionViewTypeAdd:
//        {
//            self.titleLabel.text = @"";
//        }
//            break;
//        case SMCollectionViewTypeDel:
//        {
//            self.titleLabel.text = @"";
//        }
//            break;
//        case SMCollectionViewTypeNone:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellData.portrait] placeholderImage:[UIImage imageNamed:@"220"]];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    if ([cellData.name isEqualToString:userName]) {
        self.titleLabel.text = self.roomDetail.chatroom.remark;
    }else{
        self.titleLabel.text = cellData.name;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat radio = 40*SMMatchHeight;
    CGFloat w = self.frame.size.width;
    self.iconView.frame = CGRectMake((w-radio)*0.5,10, radio, radio);
    self.titleLabel.frame = CGRectMake(0,CGRectGetMaxY(self.iconView.frame) + 5 , w, 20);
}

@end
