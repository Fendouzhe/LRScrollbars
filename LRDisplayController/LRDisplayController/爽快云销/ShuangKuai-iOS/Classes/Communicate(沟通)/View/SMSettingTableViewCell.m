//
//  SMSettingTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSettingTableViewCell.h"
#import "SMBaseCellData.h"
#import "SMArrowCellData.h"
#import "SMSwithCellData.h"

@interface SMSettingTableViewCell ()
@property (nonatomic,strong) UILabel *mainLabel;/**< 主要的文本显示 */
@property (nonatomic,strong) UILabel *detailLabel;/**< 尾部文本 */
@property (nonatomic,strong) UIImageView *detailImage;/**< 尾部图片 */
@property (nonatomic,strong) UISwitch *detailSwitch;/**< 切换按钮 */
@end

@implementation SMSettingTableViewCell

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)detailLabel{
    if (_detailLabel==nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

-(UIImageView *)detailImage{
    if (_detailImage==nil) {
        _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.detailImage.layer.cornerRadius = self.detailImage.height*0.5;
        self.detailImage.layer.masksToBounds = YES;
        self.detailImage.layer.shouldRasterize = YES;
        [self.contentView addSubview:_detailImage];
    }
    return _detailImage;
}

-(UISwitch *)detailSwitch{
    if (_detailSwitch==nil) {
        _detailSwitch = [[UISwitch alloc] init];
        [_detailSwitch addTarget:self action:@selector(detailSwitchButtonClick:) forControlEvents:UIControlEventValueChanged];
//        _detailSwitch.frame = CGRectMake(0, 0, 40, 20);
//        [self.contentView addSubview:_detailSwitch];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = _detailSwitch;
        
    }
    return _detailSwitch;
}

-(void)detailSwitchButtonClick:(UISwitch *)switchBtn{
    SMLog(@"hhhhhhhhhh%d",switchBtn.on);
    if ([self.delegate respondsToSelector:@selector(switchButtonClick:)]) {
        [self.delegate switchButtonClick:switchBtn.on];
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setCellData:(SMBaseCellData *)cellData{
    _cellData = cellData;
    self.mainLabel.text = cellData.title;
    if ([cellData isKindOfClass:[SMArrowCellData class]]) {
        if(cellData.detailImage.length){
            //self.detailImage.image = [UIImage imageNamed:cellData.detailImage];
            [self.detailImage sd_setImageWithURL:[NSURL URLWithString:cellData.detailImage] placeholderImage:[UIImage imageNamed:@"default_group_portrait"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        }else{
            self.detailLabel.text = cellData.detailText;
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if([cellData isKindOfClass:[SMSwithCellData class]]){
        SMSwithCellData *data = (SMSwithCellData *)cellData;
//        if (data.isBtnOn) {
//            self.detailSwitch.on = YES;
//        }else{
//            self.detailSwitch.on = NO;
//        }
        NSLog(@"self.detailSwitch.on = %d",data.btnOn);
        self.detailSwitch.on = data.btnOn;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = 30;
    self.mainLabel.frame = CGRectMake(10, (self.height-height)*0.5, 200, height);
    if ([self.cellData isKindOfClass:[SMArrowCellData class]]) {
        if(self.cellData.detailImage.length){
            self.detailImage.frame = CGRectMake(KScreenWidth - 70, (self.height-height-10)*0.5, height+10, height+10);
        }else{
            self.detailLabel.frame = CGRectMake(KScreenWidth*0.5 -5 , 10, KScreenWidth*0.5 - height , height);
        }
    }else if([self.cellData isKindOfClass:[SMSwithCellData class]]){
        
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"SMSettingTableViewCell";
    SMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SMSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
