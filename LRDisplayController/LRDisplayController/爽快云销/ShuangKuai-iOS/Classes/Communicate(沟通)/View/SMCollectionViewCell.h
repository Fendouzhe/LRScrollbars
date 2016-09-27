//
//  SMCollectionViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SMCollectionViewType){
    SMCollectionViewTypeNone,
    SMCollectionViewTypeAdd,
    SMCollectionViewTypeDel
};

@class SMGroupChatDetailData;
@class ChatroomMemberListData;
@interface SMCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) SMCollectionViewType cellType;/**< cell类型 */
@property (nonatomic,strong) ChatroomMemberListData *cellData;/**< cell model */
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@end
