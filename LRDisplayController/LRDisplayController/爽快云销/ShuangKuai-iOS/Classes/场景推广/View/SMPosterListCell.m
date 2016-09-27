//
//  SMPosterListCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPosterListCell.h"
#import <UIImageView+WebCache.h>

@interface SMPosterListCell ()

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation SMPosterListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"posterListCell";
    SMPosterListCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(SMPosterList *)model{
    _model = model;
    
    self.time.text = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",model.createAt]];
    self.title.text = model.adName;
    [self.icon setShowActivityIndicatorView:YES];
    [self.icon setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"220"]];
}

- (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@" YYYY年MM月dd日 "];
    return [objDateformat stringFromDate: date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.time.font = KDefaultFont;
    self.title.font = KDefaultFontBig;
    
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
}


@end
