//
//  SearchChatMessageCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/18.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SearchChatMessageCell.h"
#import <RongIMKit/RongIMKit.h>
#import "SMGroupChatDetailData.h"
#import "SMGroupChatListData.h"

@interface SearchChatMessageCell ()
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
//@property (nonatomic,strong) UILabel *mainLabel;/**< <#属性#> */
@property (nonatomic,strong) UILabel *messageLabel;/**< 消息内容 */
@end

@implementation SearchChatMessageCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString *ID = @"SearchChatMessageCell";
    SearchChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SearchChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.equalTo(self.iconImageView.mas_height);
        }];
        
        self.mainLabel = [[UILabel alloc] init];
        _mainLabel.text = @" ";
        [self.contentView addSubview:self.mainLabel];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.iconImageView.mas_right).with.offset(8);
        }];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.textColor = KGrayColor;
        [self.contentView addSubview:self.messageLabel];
        self.messageLabel.font = KDefaultFont;
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainLabel);
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
    }
    return self;
}

-(void)setCellData:(RCMessage *)cellData{
    _cellData = cellData;
    if([cellData.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *txtMsg = (RCTextMessage*)cellData.content;
        //使用txtMsg做一些事情 ...
//        SMLog(@"消息内容 = %@",txtMsg.content);
        self.messageLabel.text = txtMsg.content;
    }
    MJWeakSelf
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    switch (cellData.conversationType) {
        case ConversationType_PRIVATE:
        {
            if ([cellData.targetId isEqualToString:userID]) {
                [[SKAPI shared] queryUserProfile:cellData.senderUserId block:^(id result, NSError *error) {
                    if (!error) {
                        User *user = (User *)result;
                        [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait]];
                        weakSelf.mainLabel.text = user.name;
                    }
                }];
            }else{
                [[SKAPI shared] queryUserProfile:cellData.targetId block:^(id result, NSError *error) {
                    if (!error) {
                        User *user = (User *)result;
                        [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait]];
                        weakSelf.mainLabel.text = user.name;
                    }
                }];
            }
        }
            break;
        case ConversationType_GROUP:
        {
            
            [[SKAPI shared] queryGroupDetail4IM:cellData.targetId more:YES block:^(id result, NSError *error) {
                SMGroupChatDetailData *listData = [SMGroupChatDetailData mj_objectWithKeyValues:[result valueForKey:@"result"]];
//                SMLog(@"listData = %@",listData);
                [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:listData.chatroom.imageUrl]];
                weakSelf.mainLabel.text = listData.chatroom.roomName;
            }];
        }
            break;
        default:
            break;
    }
    
}

@end
