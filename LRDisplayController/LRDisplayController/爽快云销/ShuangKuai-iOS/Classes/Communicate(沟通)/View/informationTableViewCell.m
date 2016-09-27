//
//  informationTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "informationTableViewCell.h"
#import "NSString+Extension.h"
@interface informationTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbel;

@end
@implementation informationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.agreeBtn.layer.cornerRadius = 4;
    self.agreeBtn.layer.masksToBounds = YES;
    
    self.refuseBtn.layer.cornerRadius = 4;
    self.refuseBtn.layer.borderWidth = 1;
    self.refuseBtn.layer.borderColor = KRedColorLight.CGColor;
    self.refuseBtn.layer.masksToBounds = YES;
    
    self.iconView.layer.cornerRadius = 22;
    self.iconView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUIWithUser:(User * )user andRemark:(NSString *)remark{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached completed:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",user.name];
    if (remark) {
        self.remarkLabel.text = [NSString stringWithFormat:@"%@",remark];
    }else{
        self.remarkLabel.text = [NSString stringWithFormat:@"%@",@"无验证消息"];
    }
    
    
    
}

-(void)setInfo:(Information *)info{
    _info = info;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.body[@"portrait"]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached completed:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[info.body[@"name"] length] ? info.body[@"name"]:info.body[@"uName"]];
    self.remarkLabel.text = [NSString stringWithFormat:@"%@",info.body[@"remark"]];
    if (info.body[@"remark"]) {
        self.remarkLabel.text = [NSString stringWithFormat:@"%@",info.body[@"remark"]];
    }else{
        self.remarkLabel.text = [NSString stringWithFormat:@"%@",@"无验证消息"];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%lu",info.sendTime];
    SMLog(@"timeStr = %@",timeStr);
    self.timeLbel.text = [Utils getTimeFromTimestamp2:timeStr];
    
    if (info.type == 31) {
        //添加好友失败
        self.agreeBtn.hidden = YES;
        [self.refuseBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [self.refuseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.refuseBtn.layer.borderWidth = 0;
        [self.refuseBtn setBackgroundColor:[UIColor whiteColor]];
        self.refuseBtn.enabled = NO;
    }else if(info.type == 32){
        //添加好友成功了
        self.agreeBtn.hidden = YES;
        [self.refuseBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [self.refuseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.refuseBtn.layer.borderWidth = 0;
        [self.refuseBtn setBackgroundColor:[UIColor whiteColor]];
        self.refuseBtn.enabled = NO;
    }
}
//同意
- (IBAction)addAction:(id)sender {
    SMLog(@"同意按钮");
    [[SKAPI shared] acceptFriend:self.info.body[@"userA"] andMemo:@"" andStatus:1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"同意按钮result = %@",result);
            self.agreeBtn.hidden = YES;
            [self.refuseBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [self.refuseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.refuseBtn.layer.borderWidth = 0;
            [self.refuseBtn setBackgroundColor:[UIColor whiteColor]];
            self.refuseBtn.enabled = NO;
            [self receiptMessage];
        }else{
            SMLog(@"%@",error);
        }
    }];
}
//拒绝
- (IBAction)subAction:(id)sender {
    [[SKAPI shared] acceptFriend:self.info.body[@"userA"] andMemo:@"" andStatus:0 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            self.agreeBtn.hidden = YES;
            [self.refuseBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.refuseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.refuseBtn.layer.borderWidth = 0;
            [self.refuseBtn setBackgroundColor:[UIColor whiteColor]];
            self.refuseBtn.enabled = NO;
            [self receiptMessage];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

//回执消息
-(void)receiptMessage{
    SMLog(@"%@",self.info.messageId);
    
    [[SKAPI shared] receiptMessage:@[self.info.messageId] block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"receiptMessage = %@",result);
        }else{
            SMLog(@"error = %@",error);
        }
    }];
}
@end
