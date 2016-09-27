//
//  SMConnectPersonSection0.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConnectPersonSection0.h"

@interface SMConnectPersonSection0 ()

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation SMConnectPersonSection0

+ (instancetype)cellWithTableview:(UITableView *)tableView{
    
    static NSString *ID = @"connectPersonSection0";
    SMConnectPersonSection0 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMConnectPersonSection0" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (instancetype)connectPersonSection0{
    
    static NSString *ID = @"connectPersonSection0";
    return [[[NSBundle mainBundle] loadNibNamed:@"SMConnectPersonSection0" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftIcon.layer.cornerRadius = self.leftIcon.width / 2.0;
    self.leftIcon.clipsToBounds = YES;
}

-(void)setImage:(NSString *)imageStr WithStr:(NSString *)str{
    NSString *lastImageStr = imageStr.length>0?imageStr:@"hehuoren00";
    self.leftIcon.image = [UIImage imageNamed:lastImageStr];
    self.showLabel.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
