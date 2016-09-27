//
//  SMCommunicateTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCommunicateTableViewCell.h"
#import "SMConversation.h"
#import <UIImageView+WebCache.h>

@interface SMCommunicateTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *lastMessage;

@property (weak, nonatomic) IBOutlet UILabel *time;



@end

@implementation SMCommunicateTableViewCell

-(void)awakeFromNib{
    self.unreadBtn.layer.cornerRadius = 7.5;
    self.unreadBtn.layer.masksToBounds = YES;
}
+ (instancetype)communicateCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMCommunicateTableViewCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"communicateTableViewCell";
    SMCommunicateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMCommunicateTableViewCell communicateCell];
    }
    return cell;
}

- (void)setConversation:(SMConversation *)conversation{
    _conversation = conversation;
    self.name.text = conversation.user.name;
    self.lastMessage.text = conversation.lastMessage;
    self.time.text = conversation.time;
    self.user = conversation.user;
    if (conversation.unread.integerValue ==0) {
        self.unreadBtn.hidden = YES;
    }else{
        self.unreadBtn.hidden = NO;
        [self.unreadBtn setTitle:conversation.unread forState:UIControlStateNormal];
    }
    
    SMLog(@"conversation.user   %@",conversation.user);
    CGFloat wh = 50;
//    if (isIPhone5) {
//        wh = 50;
//    }else if (isIPhone6){
//        wh = 50 * KMatch6;
//    }else if (isIPhone6p){
//        wh = 50 * KMatch6p;
//    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:conversation.iconStr] placeholderImage:[UIImage imageNamed:@"touxiangKeFu"] options:0 completed:nil];
    
    if (conversation.user.name == nil ) {
        self.name.text = [conversation.clientId substringWithRange:NSMakeRange(20, conversation.clientId.length-20)];
    }
    
    SMLog(@"conversation.iconStr  %@",conversation.iconStr);
    self.icon.layer.cornerRadius = wh / 2.0;
    
    self.icon.clipsToBounds = YES;
}

-(void)setAvConversation:(AVIMConversation *)avConversation{
    _avConversation = avConversation;
    self.name.text = avConversation.name;
    
}
//- (void)awakeFromNib{
//    CGFloat wh = 25;
//    if (isIPhone5) {
//        wh = 25;
//    }else if (isIPhone6){
//        wh = 25 * KMatch6Height;
//    }else if (isIPhone6p){
//        wh = 25 * KMatch6pHeight;
//    }
//    self.icon.layer.cornerRadius = wh;
//    
//    self.icon.clipsToBounds = YES;
//}

@end
