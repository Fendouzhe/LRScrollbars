//
//  TaskUserCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskUserCell.h"
#import "SMParticipant.h"

@interface TaskUserCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
@end

@implementation TaskUserCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setUser:(SMParticipant *)user{
    _user = user;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"220"]];
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = KTaskInfoIconWidth * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        MJWeakSelf
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }
    return _iconImageView;
}
@end
