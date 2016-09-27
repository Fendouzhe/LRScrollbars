//
//  CustomerDetailNoteCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailNoteCell.h"
#import "CustomerDetailBaseModel.h"
#import "CustomerDetailNoteFrameModel.h"

@interface CustomerDetailNoteCell ()
@property (nonatomic,strong) UILabel *mainLabel;/**< 时间 */
@property (nonatomic,strong) UILabel *detailLabel;/**< 详情 */
@end

@implementation CustomerDetailNoteCell

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.textColor = [UIColor lightGrayColor];
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.font = KDefaultFontBig;
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)detailLabel{
    if (_detailLabel ==nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = KDefaultFontBig;
        _detailLabel.numberOfLines = 0;
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

-(void)setCellData:(CustomerDetailNoteFrameModel *)cellData{
    _cellData = cellData;
    self.mainLabel.text = [self setTime:cellData.cellData.createAt];
    self.detailLabel.text = cellData.cellData.content;
    self.mainLabel.frame = cellData.mainLabelFrame;
    self.detailLabel.frame = cellData.detailLabelFrame;
}

-(NSString *)setTime:(NSString *)time{
    NSTimeInterval time1=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time1];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    NSString *currentDateStr = [formatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"CustomerDetailNoteCell";
    CustomerDetailNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CustomerDetailNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
@end
