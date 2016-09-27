//
//  SMChooseParticipantCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChooseParticipantCell.h"
#import "SMFriend.h"
#import <UIImageView+WebCache.h>

@interface SMChooseParticipantCell ()



@property (nonatomic ,strong)UIImageView *iconView;/**< 头像 */

@property (nonatomic ,strong)UILabel *nameLabel;/**< 名字 */
@end

@implementation SMChooseParticipantCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"chooseParticipantCell";
    SMChooseParticipantCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SMChooseParticipantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //对勾
        self.gouBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.gouBtn];
        [self.gouBtn setImage:[UIImage imageNamed:@"勾gray"] forState:UIControlStateNormal];
        [self.gouBtn setImage:[UIImage imageNamed:@"勾red"] forState:UIControlStateSelected];
        self.gouBtn.userInteractionEnabled = NO;
//        [self.gouBtn addTarget:self action:@selector(gouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //头像
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        self.iconView .image = [UIImage imageNamed:@"220"];
        
        //名字
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = @"姓名";
        self.nameLabel.font = KDefaultFont;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setFriendModel:(SMFriend *)friendModel{
    _friendModel = friendModel;
    //显示缩略图
    CGFloat width = 80;
    
    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width *2,width *2];
    NSString *iconStr = [friendModel.portrait stringByAppendingString:strEnd];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"220"]];
    
    self.nameLabel.text = friendModel.name;
    
    self.gouBtn.selected = friendModel.isSelected;
}

//- (void)gouBtnClick:(UIButton *)btn{
//    SMLog(@"gouBtnClick");
//}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSNumber *gouBtnWidth = [NSNumber numberWithFloat:30 *SMMatchWidth];
    [self.gouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.width.equalTo(gouBtnWidth);
    }];
    
    
    NSNumber *iconWidth = [NSNumber numberWithFloat:self.contentView.height - 10];
    self.iconView.layer.cornerRadius = (self.contentView.height - 10) / 2.0;
    self.iconView.clipsToBounds = YES;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.gouBtn.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.width.equalTo(iconWidth);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.iconView.mas_right).with.offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
    }];
}


@end
