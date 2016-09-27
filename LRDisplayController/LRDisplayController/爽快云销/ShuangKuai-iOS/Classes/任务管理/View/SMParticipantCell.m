//
//  SMParticipantCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMParticipantCell.h"
#import "SMFriend.h"
#import <UIButton+WebCache.h>
#import "SMParticipant.h"

@interface SMParticipantCell ()

@property (nonatomic ,strong)UILabel *leftLabel;/**< 参与人 */

@property (nonatomic ,strong)UIImageView *rightIcon;/**< 指向箭头 */

@property (nonatomic ,strong)UIView *grayLine;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *btn0;/**<  6个按钮 从右往左 依次是btn0,12345*/
@property (nonatomic ,strong)UIButton *btn1;/**<  */
@property (nonatomic ,strong)UIButton *btn2;/**<  */
@property (nonatomic ,strong)UIButton *btn3;/**<  */
@property (nonatomic ,strong)UIButton *btn4;/**<  */
@property (nonatomic ,strong)UIButton *btn5;/**<  */

@property (nonatomic ,strong)NSArray *arrBtns;/**< 装着6个头像按钮的数组 */

@end

@implementation SMParticipantCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"participantCell";
    SMParticipantCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMParticipantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 参与人
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.text = @"参与人";
        self.leftLabel.textColor = [UIColor blackColor];
        self.leftLabel.font = KDefaultFont;
        [self.contentView addSubview:self.leftLabel];
        
        //指向箭头
        self.rightIcon = [[UIImageView alloc] init];
        self.rightIcon.image = [UIImage imageNamed:@"zhixiang"];
        [self.contentView addSubview:self.rightIcon];
        
        //请选择任务参与人label
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.text = @"请选择任务参与人";
        self.rightLabel.textColor = [UIColor darkGrayColor];
        self.rightLabel.font = KDefaultFont;
        [self.contentView addSubview:self.rightLabel];
        
        //循环创建6个头像按钮
        for (int i = 0; i < 6; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [self.contentView addSubview:btn];
            btn.userInteractionEnabled = NO;
            btn.hidden = YES;
            btn.tag = i;
            [btn setBackgroundImage:[UIImage imageNamed:@"220"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.btn0 = btn;
            }else if (i == 1){
                self.btn1 = btn;
            }else if (i == 2){
                self.btn2 = btn;
            }else if (i == 3){
                self.btn3 = btn;
            }else if (i == 4){
                self.btn4 = btn;
            }else if (i == 5){
                self.btn5 = btn;
            }
        }
        
        self.arrBtns = @[self.btn0,self.btn1,self.btn2,self.btn3,self.btn4,self.btn5];
        
        //最下面加一个灰色线
        self.grayLine = [[UIView alloc] init];
        self.grayLine.backgroundColor = KGrayColorSeparatorLine;
        [self.contentView addSubview:self.grayLine];
    }
    return self;
}

- (void)setList:(SMSonTaskList *)list{
    _list = list;
    
    if (list.childUser.count > 0) {  //有参与者就隐藏label显示头像
        self.rightLabel.hidden = YES;
        
        for (int i = 0; i < list.childUser.count; i++) {
            
            for (UIButton *btn in self.arrBtns) {
                if (btn.tag < list.childUser.count) {
                    btn.hidden = NO;
                    SMParticipant *p = list.childUser[btn.tag];
                    
                    //显示缩略图
                    CGFloat width = 25 *SMMatchHeight *2;
                    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
                    NSString *iconStr = [p.portrait stringByAppendingString:strEnd];
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:iconStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"]];
                    
                }else{
                    btn.hidden = YES;
                }
            }
        }
        
        
    }else{
        self.rightLabel.hidden = NO;
        for (UIButton *btn in self.arrBtns) {
            btn.hidden = YES;
        }
    }
    
    
    
    
}

//- (void)setSonTask:(SMSonTask *)sonTask{
//    _sonTask = sonTask;
//    
//    
//    for (NSString *userid in sonTask.users) {
//        SMLog(@"userid  %@ ",userid);
//    }
//    if (sonTask.users.count > 0) {
//        self.rightLabel.hidden = YES;
//        
//        for (int i = 0; i < sonTask.users.count; i++) {
//            
//            for (UIButton *btn in self.arrBtns) {
//                if (btn.tag < sonTask.users.count) {
//                    btn.hidden = NO;
//                    NSString *userId = sonTask.users[btn.tag];
//                    [[SKAPI shared] queryUserProfile:userId block:^(id result, NSError *error) {
//                        if (!error) {
//                            SMLog(@"result  queryUserProfile  %@",result);
//                        }else{
//                            SMLog(@"error   %@",error );
//                        }
//                    }];
//                }else{
//                    btn.hidden = YES;
//                }
//            }
//        }
//    }else{
//        self.rightLabel.hidden = NO;
//        for (UIButton *btn in self.arrBtns) {
//            btn.hidden = YES;
//        }
//    }
//    
//    
//}

- (void)setArrIconStrs:(NSArray *)arrIconStrs{
    _arrIconStrs = arrIconStrs;
    if (arrIconStrs.count == 0) { //如果是空数组 隐藏所有的头像控件，显示label
        [self haveNoParticipant];
    }else{
        [self haveParticipant:arrIconStrs];
    }
}

- (void)haveNoParticipant{
    self.rightLabel.hidden = NO;
    for (UIButton *btn in self.arrBtns) {
        btn.hidden = YES;
    }
}

- (void)haveParticipant:(NSArray *)array{
    self.rightLabel.hidden = YES;
    
    for (UIButton *btn in self.arrBtns) {
        
        if (btn.tag < array.count) {
            SMFriend *friend = array[btn.tag];
            //显示缩略图
            CGFloat width = 80;
            NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
            NSString *iconStr = [friend.portrait stringByAppendingString:strEnd];
            
            btn.hidden = NO;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:iconStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"]];
        }else{
            btn.hidden = YES;
        }
    }
}

- (void)setArrParticipant:(NSMutableArray *)arrParticipant{
    _arrParticipant = arrParticipant;
    
    self.rightLabel.hidden = YES;
    for (UIButton *btn in self.arrBtns) {
        
        if (btn.tag < arrParticipant.count) {
            SMParticipant *p = arrParticipant[btn.tag];
            //显示缩略图
            CGFloat width = 80;
            NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
            NSString *iconStr = [p.portrait stringByAppendingString:strEnd];
            
            btn.hidden = NO;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:iconStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"]];
        }else{
            btn.hidden = YES;
        }
    }
}


- (void)iconBtnClick:(UIButton *)btn{
    SMLog(@"点击了 参与人里的图标   tag %zd",btn.tag);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    NSNumber *rightIconWH = [NSNumber numberWithFloat:15 *SMMatchHeight];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.width.equalTo(rightIconWH);
        make.height.equalTo(rightIconWH);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightIcon.mas_left).with.offset(-5);
    }];
    
    [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //6个icon头像按钮、
    int iconCount = 6;
    CGFloat margin = 5;
    CGFloat iconTotalW = KScreenWidth - (10 + 35 + 10 + 5 + 15*SMMatchHeight + 10);
    CGFloat iconW = (iconTotalW - margin * (iconCount - 1)) / iconCount;
    NSNumber *iconWH = [NSNumber numberWithFloat:iconW];
    [self.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightIcon.mas_left).with.offset(-10);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn0.layer.cornerRadius = iconW / 2.0;
    self.btn0.clipsToBounds = YES;
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.btn0.mas_left).with.offset(-margin);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn1.layer.cornerRadius = iconW / 2.0;
    self.btn1.clipsToBounds = YES;
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.btn1.mas_left).with.offset(-margin);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn2.layer.cornerRadius = iconW / 2.0;
    self.btn2.clipsToBounds = YES;
    
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.btn2.mas_left).with.offset(-margin);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn3.layer.cornerRadius = iconW / 2.0;
    self.btn3.clipsToBounds = YES;
    
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.btn3.mas_left).with.offset(-margin);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn4.layer.cornerRadius = iconW / 2.0;
    self.btn4.clipsToBounds = YES;
    
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.btn4.mas_left).with.offset(-margin);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    self.btn5.layer.cornerRadius = iconW / 2.0;
    self.btn5.clipsToBounds = YES;
}

//- (NSMutableArray *)arrParticipant{
//    if (_arrParticipant == nil) {
//        _arrParticipant = [NSMutableArray array];
//    }
//    return _arrParticipant;
//}

@end
