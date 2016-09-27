//
//  SMSeckillListCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSeckillListCell.h"

@interface SMSeckillListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *isOverLabel;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

#pragma mark -- match
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBtnHeight;

@property (weak, nonatomic) IBOutlet UIView *grayLine;

@end

@implementation SMSeckillListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"seckillListCell";
    
    SMSeckillListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMSeckillListCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (void)setModel:(SMSeckill *)model{
    _model = model;
    
    NSString *imagePath = model.imagePath;//[model.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,self.iconHeight.constant]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
    
    self.name.text = model.seckillName;
    
    if (model.status == -1) {  //已删除
        
    }else if (model.status == 0){  //未开始
        [self changeStatusBtn:[UIColor lightGrayColor] andTitile:@"尚未开始"];
    }else if (model.status == 1){  //正在进行
        [self changeStatusBtn:KRedColorLight andTitile:@"正在进行"];
    }else if (model.status == 2){   //已结束
        [self changeStatusBtn:[UIColor lightGrayColor] andTitile:@"已结束"];
    }
}

- (void)changeStatusBtn:(UIColor *)color andTitile:(NSString *)title{
    
    self.statusBtn.backgroundColor = color;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = KDefaultFontBig;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:title attributes:dict];
    [self.statusBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = KDefaultFontBig;
    self.isOverLabel.font = KDefaultFontBig;
    self.time.font = KDefaultFontBig;
    
    self.statusBtn.layer.cornerRadius = SMCornerRadios;
    self.statusBtn.clipsToBounds = YES;
    
    self.iconHeight.constant = 166 *SMMatchHeight;
    self.statusBtnWidth.constant = 80 *SMMatchWidth;
    self.statusBtnHeight.constant = 22 *SMMatchHeight;
    self.statusBtn.userInteractionEnabled = NO;
    
    self.isOverLabel.hidden = YES;
    self.time.hidden = YES;
    
    self.grayLine.backgroundColor = KGrayColorSeparatorLine;
    //超出内容减掉
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
