//
//  SMSonTaskCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSonTaskCell.h"
#import "SMSonTaskList.h"
#import <UIButton+WebCache.h>
#import "SMParticipant.h"

@interface SMSonTaskCell ()

@property (nonatomic ,strong)UILabel *titleName;/**< 子任务123 */

@property (nonatomic ,strong)UILabel *content;/**< 任务内容 */

@property (nonatomic ,strong)UIView *participantView;/**< 参与人那一行view */

@property (nonatomic ,strong)UILabel *participantLabel;/**< 参与人label */

@property (nonatomic ,strong)UIButton *btn0;/**< 头像  从左到右 依次是btn0，12345*/
@property (nonatomic ,strong)UIButton *btn1;/**< 头像 */
@property (nonatomic ,strong)UIButton *btn2;/**< 头像 */
@property (nonatomic ,strong)UIButton *btn3;/**< 头像 */
@property (nonatomic ,strong)UIButton *btn4;/**< 头像 */
@property (nonatomic ,strong)UIButton *btn5;/**< 头像 */

@property (nonatomic ,strong)NSArray *arrBtns;/**< 装着6个头像按钮 */

@property (nonatomic ,strong)UIButton *statusBtn;/**< 右上角 显示子任务状态的控件 */

@property (nonatomic ,strong)UIView *grayLine;/**< 最先面灰色横线 */


@end

@implementation SMSonTaskCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"sonTaskCell";
    SMSonTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SMSonTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleName = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleName];
        self.titleName.text = @"子任务";
        self.titleName.font = KDefaultFontSmall;
        self.titleName.textColor = [UIColor darkGrayColor];
        
        
        self.content = [[UILabel alloc] init];
        self.content.text = @"完成levvv公司对接工作";
        self.content.font = KDefaultFont;
        self.content.numberOfLines = 0;
        self.content.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.content];
        
        
        self.participantView = [[UIView alloc] init];
        [self.contentView addSubview:self.participantView];
        
        
        self.participantLabel = [[UILabel alloc] init];
        self.participantLabel.text = @"参与人:";
        self.participantLabel.textColor = [UIColor darkGrayColor];
        self.participantLabel.font = KDefaultFontSmall;
        [self.participantView addSubview:self.participantLabel];
        
        
        for (int i = 0; i < 6; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"220"] forState:UIControlStateNormal];
            [self.participantView addSubview:btn];
            btn.tag = i;
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
            btn.layer.cornerRadius = 25 *SMMatchHeight / 2.0;
            btn.clipsToBounds = YES;
        }
        
        self.arrBtns = @[self.btn0,self.btn1,self.btn2,self.btn3,self.btn4,self.btn5];
        
        //右上角 显示子任务状态的控件
        self.statusBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.statusBtn];
        self.statusBtn.userInteractionEnabled = NO;
        self.statusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        //最下面给个灰色横线
        self.grayLine = [[UIView alloc] init];
        self.grayLine.backgroundColor = KGrayColorSeparatorLine;
        [self.contentView addSubview:self.grayLine];
        
    }
    return self;
}

- (void)setListF:(SMSonTaskListFrame *)listF{
    _listF = listF;
    
    self.titleName.frame = listF.titleF;
    self.titleName.text = [NSString stringWithFormat:@"子任务%@",listF.list.childSchedule.rownum];
    self.titleName.textColor = KRedColorLight;
    
    
    self.content.frame = listF.contentF;
//    self.content.text = listF.list.childSchedule.remark;
    self.content.text = [@"任务内容：" stringByAppendingString:listF.list.childSchedule.remark];

    
    self.participantView.frame = listF.participantViewF;
    self.participantLabel.frame = listF.participantF;
    self.participantLabel.text = @"参与人:";
    
    
    self.btn0.frame = listF.btn0F;
    self.btn1.frame = listF.btn1F;
    self.btn2.frame = listF.btn2F;
    self.btn3.frame = listF.btn3F;
    self.btn4.frame = listF.btn4F; 
    self.btn5.frame = listF.btn5F;
    
    
    NSArray *arrUsers = listF.list.childUser;
    for (int i = 0; i < arrUsers.count; i++) {
        
        for (UIButton *btn in self.arrBtns) {
            if (btn.tag < arrUsers.count) {
                btn.hidden = NO;
                SMParticipant *p = arrUsers[btn.tag];
                
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
    
    self.statusBtn.frame = listF.statusBtnF;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontSmall;
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSString *statusStr;
    if (listF.list.childSchedule.status == 0) {
        statusStr = @"未发布";
    }else if (listF.list.childSchedule.status == 1){
        statusStr = @"未完成";
    }else if (listF.list.childSchedule.status == 2){
        statusStr = @"已完成";
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:statusStr attributes:dict];
    [self.statusBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    
    self.grayLine.frame = listF.grayLineF;
}

- (void)iconBtnClick:(UIButton *)btn{
    
    SMLog(@"点击了 头像 tag %zd",btn.tag);
    SMParticipant *p = self.listF.list.childUser[btn.tag];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KSonTaskParticipantIconClickKey] = p;
    [[NSNotificationCenter defaultCenter] postNotificationName:KSonTaskParticipantIconClick object:self userInfo:dict];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
//    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.contentView.mas_top).with.offset(5);
//        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
//        make.left.equalTo(self.titleName.mas_right).with.offset(10);
//        make.height.equalTo(@119);
//    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleName.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    NSNumber *participantViewHeight = [NSNumber numberWithFloat:30 *SMMatchHeight];
    [self.participantView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.content.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(participantViewHeight);
    }];
    
    [self.participantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.participantView.mas_left).with.offset(10);
    }];
    
    NSNumber *iconWH = [NSNumber numberWithFloat:25 *SMMatchHeight];
    
    [self.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.participantLabel.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.btn0.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.btn1.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.btn2.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.btn3.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.participantView.mas_centerY);
        make.left.equalTo(self.btn4.mas_right).with.offset(5);
        make.width.equalTo(iconWH);
        make.height.equalTo(iconWH);
    }];
    
    [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
}

@end
