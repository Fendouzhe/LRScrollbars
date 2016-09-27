//
//  LocalConversation+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalConversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalConversation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *clientId;
@property (nullable, nonatomic, retain) NSString *conversationId;
@property (nullable, nonatomic, retain) NSString *iconStr;
@property (nullable, nonatomic, retain) NSNumber *isCustomer;
@property (nullable, nonatomic, retain) NSString *lastMessage;
@property (nullable, nonatomic, retain) id messages;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSNumber *unix;
@property (nullable, nonatomic, retain) NSString *unread;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *pid;
@property (nullable, nonatomic, retain) NSSet<LocalUser1 *> *user;

@end

@interface LocalConversation (CoreDataGeneratedAccessors)

- (void)addUserObject:(LocalUser1 *)value;
- (void)removeUserObject:(LocalUser1 *)value;
- (void)addUser:(NSSet<LocalUser1 *> *)values;
- (void)removeUser:(NSSet<LocalUser1 *> *)values;

@end

NS_ASSUME_NONNULL_END
