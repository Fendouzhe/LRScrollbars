//
//  SMArticalListCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMArticalListCell.h"
#import "SMArticalList.h"

@interface SMArticalListCell()

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation SMArticalListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"SMArticalListCell";
    SMArticalListCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(SMArticalList *)model{
    _model = model;
    
    self.time.text = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",model.createAt]];
    self.title.text = model.title;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.imagePaths] placeholderImage:[UIImage imageNamed:@"220"]];
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
    // Initialization code
    
    self.time.font = KDefaultFont;
    self.title.font = KDefaultFontBig;
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
}

@end
