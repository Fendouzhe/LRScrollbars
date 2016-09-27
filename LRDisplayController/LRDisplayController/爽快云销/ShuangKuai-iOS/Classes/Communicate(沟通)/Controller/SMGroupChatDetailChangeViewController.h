//
//  SMGroupChatDetailChangeViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/15.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SMGroupChatDetailChangeType) {
    SMGroupChatDetailChangeTypeGroupName = 1,/**< 群名称修改 */
    SMGroupChatDetailChangeTypeGroupNickName,/**< 群昵称修改 */
    SMGroupChatDetailChangeTypeGroupNotice,/**< 群公告修改 */
};


@protocol SMGroupChatDetailChangeViewControllerDelegate <NSObject>

@optional
-(void)valueChangeWithRoomDetailWithType:(SMGroupChatDetailChangeType)changeType newName:(NSString *)name;
@end

@class SMGroupChatDetailData;
@interface SMGroupChatDetailChangeViewController : UIViewController
@property (nonatomic,assign) SMGroupChatDetailChangeType changeType;/**< 修改类型 */
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@property (nonatomic,weak) id<SMGroupChatDetailChangeViewControllerDelegate> delegate;/**< 代理 */
-(instancetype)initWithSMGroupChatDetailChangeType:(SMGroupChatDetailChangeType)changeType withSMGroupChatDetailData:(SMGroupChatDetailData *)roomDetail;
@end
