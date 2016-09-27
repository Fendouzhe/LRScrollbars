//
//  SMTaskContentCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTaskContentCell.h"
#import "SMFatherTask.h"

@interface SMTaskContentCell ()<UITextViewDelegate>

@property (nonatomic ,strong)UILabel *titleName;/**<  */


@end

@implementation SMTaskContentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"taskContentCell";
    SMTaskContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMTaskContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleName = [[UILabel alloc] init];
        self.titleName.text = @"任务内容";
        self.titleName.font = KDefaultFontBig;
        self.titleName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleName];
        
        
        self.inputView = [[UITextView alloc] init];
        [self.contentView addSubview:self.inputView];
        self.inputView.font = KDefaultFont;
//        self.inputView.delegate = self;

        //充当placeHolder
        self.holderLabel = [[UILabel alloc] init];
        self.holderLabel.text = @" 请输入任务内容";
        self.holderLabel.textColor = [UIColor lightGrayColor];
        self.holderLabel.font = KDefaultFont;
        self.holderLabel.textAlignment = NSTextAlignmentLeft;
        self.holderLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:self.holderLabel];
        
        self.backgroundColor = KControllerBackGroundColor;
    }
    return self;
}

- (void)setFatherTask:(SMFatherTask *)fatherTask{
    _fatherTask = fatherTask;
    self.inputView.text = fatherTask.remark;
    self.holderLabel.text = @"";
}

//- (void)setSonTask:(SMSonTask *)sonTask{
//    _sonTask = sonTask;
//    self.inputView.text = sonTask.remark;
//    self.holderLabel.text = @"";
//}

- (void)setList:(SMSonTaskList *)list{
    _list = list;
    
    self.inputView.text = list.childSchedule.remark;
    self.holderLabel.text = @"";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleName.mas_bottom).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    
    [self.holderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleName.mas_bottom).with.offset(20);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
}

//- (void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length == 0) {
//        self.holderLabel.text = @"   请输入任务内容";
//    }else{
//        self.holderLabel.text = @"";
//    }
//}

@end
