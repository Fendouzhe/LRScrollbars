//
//  SMMyTemCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyTemCell.h"

@interface SMMyTemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;


@end

@implementation SMMyTemCell

+ (instancetype)cellWithTableview:(UITableView *)tableView{
    
    static NSString *Id = @"myTemCell";
    SMMyTemCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMyTemCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 20;
    self.icon.clipsToBounds = YES;
    self.rightBtn.backgroundColor = KRedColorLight;
    self.rightBtn.layer.cornerRadius = SMCornerRadios;
    self.rightBtn.clipsToBounds = YES;
}
-(void)setUser:(User *)user{
    _user = user;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:SDWebImageRefreshCached progress:nil completed:nil];
    self.name.text = user.name;
    
    if (user.isFriend) {
        self.rightBtn.hidden = YES;
    }else{
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    }
    self.rightBtn.selected = user.isSelect;
    
    
}
-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"删除" forState:UIControlStateSelected];
    }else if(type == 2){
        self.rightBtn.hidden = YES;
    }
}
- (IBAction)rightBtnClick {
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.type == 1) {
        self.editIdArrayBlock(self.rightBtn.selected);
    }
    if (self.type == 0) {
        self.alertblock();
    }
    
}

@end
