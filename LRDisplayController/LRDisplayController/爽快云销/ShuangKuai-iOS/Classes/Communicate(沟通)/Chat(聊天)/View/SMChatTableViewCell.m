//
//  SMChatTableViewCell.m
//  聊天界面测试
//
//  Created by iOS on 15/11/15.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "SMChatTableViewCell.h"
#import "UIImage+Extension.h"
#import "SMChatMessageFrame.h"
#import "SMChatMessage.h"

@interface SMChatTableViewCell ()

/**
 *  时间控件
 */
@property(nonatomic,weak)UILabel *timeLabel;
/**
 *  文字按钮控件
 */
@property(nonatomic,weak)UIButton *textBtn;
/**
 *  头像控件
 */
@property(nonatomic,weak)UIImageView *iconView;

@end

@implementation SMChatTableViewCell

//- (instancetype)cellWithTableView:(UITableView *)tableView{
//    
//    static NSString *ID = @"chatCell";
//    SMChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[SMChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    return cell;
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        //添加cell内部视图控件
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 添加时间控件
        UILabel *timeLabel = [[UILabel alloc] init];
        // 设置内容居中
        timeLabel.textAlignment = NSTextAlignmentCenter;
        // 设置字体
        timeLabel.font = [UIFont systemFontOfSize:14];
        // 设置字体颜色
        timeLabel.textColor = [UIColor colorWithRed:98/255.0f green:98/255.0f blue:98/255.0f alpha:1.0];
        [self.contentView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        // 添加聊天内容按钮控件
        UIButton *textBtn = [[UIButton alloc] init];
        // 设置按钮的字体大小
        textBtn.titleLabel.font = SMTextBtnFont;
        // 设置按钮的字体颜色
        [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置换行
        textBtn.titleLabel.numberOfLines = 0;
        // 设置按钮的内边距
        textBtn.contentEdgeInsets = UIEdgeInsetsMake(SMTextBtnContentInset, SMTextBtnContentInset, SMTextBtnContentInset, SMTextBtnContentInset);
        //        textBtn.backgroundColor = [UIColor orangeColor];
        //        textBtn.titleLabel.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview:textBtn];
        self.textBtn = textBtn;
        
        // 添加头像控件
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 设置cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        // 设置没有选中效果
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setMessageFrame:(SMChatMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    // 设置子控件内容
    [self setupData];
    // 设置子控件frame
    [self setupSubViewsFrame];
}
/**
 *  设置子控件内容
 */
- (void)setupData{
    // 获得数据模型
    SMChatMessage *message = _messageFrame.messgae;
    // 设置时间
    self.timeLabel.text = message.time;
    // 设置时间隐藏或显示
    self.timeLabel.hidden = message.hideTime;
    
    
    // 设置头像
    if (message.type == HMMessageTypeMe) { // 自己发的
//        self.iconView.image = [UIImage imageNamed:@"me"];
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        self.iconView.image = [UIImage imageWithData:data];
    } else { // 别人发的
//        self.iconView.image = [UIImage imageNamed:@"other"];
        
            NSString *imageStr = [self.user.portrait stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd",40,40]];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"touxiangKeFu"] options:SDWebImageRefreshCached];
        
        }
    // 设置按钮文字
    [self.textBtn setTitle:message.text forState:UIControlStateNormal];
    
    if (message.type == HMMessageTypeMe) { // 自己发的
        // 普通状态下的图片
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"chat_send_nor"] forState:UIControlStateNormal];
        // 高亮状态下的图片
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
    } else { // 别人发的
        
        // 普通状态下的图片
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"chat_recive_nor"] forState:UIControlStateNormal];
        // 高亮状态下的图片
        [self.textBtn setBackgroundImage:[UIImage resizableImageWithName:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
        
        //        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"chat_recive_nor"] forState:UIControlStateNormal];
        //        [self.textBtn setBackgroundImage:[UIImage imageNamed:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
    }
}
/**
 *  设置子控件frame
 */
- (void)setupSubViewsFrame{
    // 设置时间的frame
    self.timeLabel.frame = _messageFrame.timeF;
    
    // 设置头像的frame
    self.iconView.frame = _messageFrame.iconF;
    self.iconView.layer.cornerRadius = self.iconView.width/2.0;
    self.iconView.layer.masksToBounds = YES;
    
    // 设置按钮的frame
    self.textBtn.frame = _messageFrame.textBtnF;
}


@end
