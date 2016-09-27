//
//  LocalChatMessageFrame+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalChatMessageFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalChatMessageFrame (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *timeF;
@property (nullable, nonatomic, retain) NSString *textBtnF;
@property (nullable, nonatomic, retain) NSString *iconF;
@property (nullable, nonatomic, retain) NSNumber *cellHeight;
@property (nullable, nonatomic, retain) NSString *targetRtcKey;
@property (nullable, nonatomic, retain) NSSet<LocalChatMessage *> *chatMessage;

@end

@interface LocalChatMessageFrame (CoreDataGeneratedAccessors)

- (void)addChatMessageObject:(LocalChatMessage *)value;
- (void)removeChatMessageObject:(LocalChatMessage *)value;
- (void)addChatMessage:(NSSet<LocalChatMessage *> *)values;
- (void)removeChatMessage:(NSSet<LocalChatMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
