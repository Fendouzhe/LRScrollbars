//
//  SMTaskTitleCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskTitleCell.h"
#import "SMFatherTask.h"

@interface SMTaskTitleCell ()

@property (nonatomic ,strong)UILabel *titleName;/**< 标题 */



@end

@implementation SMTaskTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"taskTitleCell";
    SMTaskTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMTaskTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.titleName = [[UILabel alloc] init];
        self.titleName.text = @"标题";
        self.titleName.font = KDefaultFontBig;
        self.titleName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleName];
        
        
        self.inputField = [[UITextField alloc] init];
        [self.contentView addSubview:self.inputField];
        self.inputField.placeholder = @"请输入标题";
        self.inputField.font = KDefaultFont;
        self.inputField.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setFatherTask:(SMFatherTask *)fatherTask{
    _fatherTask = fatherTask;
    self.inputField.text = fatherTask.title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.titleName.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
}

@end
