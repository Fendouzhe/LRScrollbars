//
//  CreatNewCustomerCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CreatNewCustomerCell.h"
#import "CreatNewCustomerBaseModel.h"
#import "CreatNewCustomerNormalModel.h"
#import "CreatNewCustomerArrowModel.h"
#import "CreatNewCustomerTextField.h"

@interface CreatNewCustomerCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *mainLabel;/**< 标题 */
//@property (nonatomic,strong) UILabel *detailLabel;/**< 尾部 */
//@property (nonatomic,strong) CreatNewCustomerTextField *textField;/**< 文本输入框 */
@end

@implementation CreatNewCustomerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    
    static NSString *ID = @"CreatNewCustomerCell";
    CreatNewCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CreatNewCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.cellData.detailText = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.cellData.detailText = textField.text;
    return YES;
}

-(CreatNewCustomerTextField *)textField{
    if (_textField == nil) {
        _textField = [[CreatNewCustomerTextField alloc] init];
        [self addSubview:_textField];
        _textField.delegate = self;
    }
    return _textField;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)setCellData:(CreatNewCustomerBaseModel *)cellData{
    _cellData = cellData;
    if ([cellData isKindOfClass:[CreatNewCustomerNormalModel class]]) {
        self.mainLabel.text = cellData.title;
        self.textField.text = cellData.detailText;
        self.textField.placeholder = cellData.placeText;
        self.accessoryType = UITableViewCellAccessoryNone;
        _detailLabel.hidden = YES;
        return;
    }
    if ([cellData isKindOfClass:[CreatNewCustomerArrowModel class]]){
        self.mainLabel.text = cellData.title;
        self.detailLabel.text = cellData.detailText;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _textField.hidden= YES;
        return;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.mainLabel sizeToFit];
    CGFloat mainLabelW = self.mainLabel.frame.size.width;
    CGFloat mainLabelH = self.mainLabel.frame.size.height;
    CGFloat mainLabelX = 10;
    CGFloat mainLabelY = (self.frame.size.height - mainLabelH)*0.5;
    self.mainLabel.frame = CGRectMake(mainLabelX, mainLabelY, mainLabelW, mainLabelH);
    CGFloat detailLabelX;
    CGFloat detailLabelY;
    CGFloat detailLabelW;
    CGFloat detailLabelH;
//    [self.detailLabel sizeToFit];
    if ([self.cellData isKindOfClass:[CreatNewCustomerNormalModel class]]) {
//        if (!self.textField.text.length) {
//            self.textField.text = @" ";
//        }
        [self.textField sizeToFit];
        detailLabelX = CGRectGetMaxX(self.mainLabel.frame) + 5;
        detailLabelW = self.frame.size.width - detailLabelX - 10;
        detailLabelH = self.textField.frame.size.height;
        detailLabelY = (self.frame.size.height - detailLabelH)*0.5;
        self.textField.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
        return;
    }
    if ([self.cellData isKindOfClass:[CreatNewCustomerArrowModel class]]){
        [self.detailLabel sizeToFit];
        detailLabelX = CGRectGetMaxX(self.mainLabel.frame) + 5;
        detailLabelW = self.frame.size.width - detailLabelX - 30;
        detailLabelH = self.detailLabel.frame.size.height;
        detailLabelY = (self.frame.size.height - detailLabelH)*0.5;
        self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
        return;
    }
}
@end
