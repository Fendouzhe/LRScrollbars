//
//  SMEventInvitationsCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMEventInvitationsCell.h"

@interface SMEventInvitationsCell()

@property (nonatomic ,strong) UIView *backgroundVc; /** 背景的View */
@property (nonatomic ,strong) UILabel *titleLabel; /** 活动名称的Label */
@property (nonatomic ,strong) UIImageView *imageVc;/** 活动图片 */
@property (nonatomic ,strong) UILabel *timeLabel; /** 活动时间的Label */
@property (nonatomic ,strong) UILabel *addressLabel; /** 活动地址的Label */
@property (nonatomic ,strong) UIButton *purchaseBtn;/** 立即购买按钮 */
@end

@implementation SMEventInvitationsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SMEventInvitationsCell";
    
    SMEventInvitationsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[SMEventInvitationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
        self.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:233/255.0 alpha:1];

        
        // 背景的View
        _backgroundVc = [[UIView alloc]init];
        
        _backgroundVc.backgroundColor = [UIColor whiteColor];
        _backgroundVc.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _backgroundVc.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _backgroundVc.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        _backgroundVc.layer.shadowRadius = 2;//阴影半径，默认3
        
        [self.contentView addSubview:_backgroundVc];
        
        // 活动标题文字
        _titleLabel = [[UILabel alloc]init];
        
        [_backgroundVc addSubview:_titleLabel];
        
        // 活动图片
        _imageVc = [[UIImageView alloc]init];
        
        [_backgroundVc addSubview:_imageVc];
        
        // 活动时间
        _timeLabel = [[UILabel alloc]init];
        
        [_backgroundVc addSubview:_timeLabel];
        
        // 活动地址
        _addressLabel = [[UILabel alloc]init];
        
        [_backgroundVc addSubview:_addressLabel];
        
        // 立即购买按钮
        _purchaseBtn = [[UIButton alloc]init];
        _purchaseBtn.layer.cornerRadius = 5.f;
        _purchaseBtn.layer.masksToBounds = YES;
        _purchaseBtn.backgroundColor = KRedColorLight;
        [_purchaseBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        [_purchaseBtn.titleLabel setFont:KDefaultFontBig];
        _purchaseBtn.userInteractionEnabled = NO;
        [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backgroundVc addSubview:_purchaseBtn];
    }
    
    return self;
}

-(void)setCellData:(PromotionMaster *)cellData{
    
    _cellData = cellData;
    
    SMLog(@"cellData = %@",cellData.price);
    //[self.imageVc setShowActivityIndicatorView:YES];
    //[self.imageVc setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imageVc sd_setImageWithURL:[NSURL URLWithString:cellData.posterImage] placeholderImage:[UIImage imageNamed:@"220"]];
    self.imageVc.contentMode = UIViewContentModeScaleAspectFill;
    self.imageVc.clipsToBounds = YES;
    self.titleLabel.text = cellData.name;
    [self.titleLabel setFont:KDefaultFont16Match];
    
    NSString *foundTimeStr = [self dataStrFromInterger:cellData.createAt];
    
    self.timeLabel.text = [NSString stringWithFormat:@"时间: %@",foundTimeStr];
    [self.timeLabel setFont:KDefaultFont13Match];
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@",cellData.address];
    [self.addressLabel setFont:KDefaultFont13Match];
}


-(NSString *)dataStrFromInterger:(NSInteger)data{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:data];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    return [formatter stringFromDate:date1];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [_backgroundVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundVc.mas_top).offset(10*SMMatchWidth);
        make.centerX.equalTo(_backgroundVc.mas_centerX);
        make.height.equalTo(@(20*SMMatchWidth));
    }];
    
    [_imageVc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10*SMMatchWidth);
        make.left.equalTo(_backgroundVc.mas_left).offset(10);
        make.right.equalTo(_backgroundVc.mas_right).offset(-10);
        make.height.equalTo(@(170*SMMatchWidth));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imageVc.mas_left);
        make.top.equalTo(_imageVc.mas_bottom).offset(20*SMMatchWidth);
        make.height.equalTo(@(20*SMMatchWidth));
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imageVc.mas_left);
        make.top.equalTo(_timeLabel.mas_bottom).offset(10*SMMatchWidth);
        make.width.equalTo(_imageVc.mas_width);
        make.height.equalTo(@(20*SMMatchWidth));
    }];
    
    
    [_purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_addressLabel.mas_bottom).offset(15*SMMatchWidth);
        make.centerX.equalTo(_backgroundVc.mas_centerX);
        make.width.equalTo(@(120*SMMatchWidth));
        make.height.equalTo(@(30*SMMatchWidth));
    }];
    
}

@end
