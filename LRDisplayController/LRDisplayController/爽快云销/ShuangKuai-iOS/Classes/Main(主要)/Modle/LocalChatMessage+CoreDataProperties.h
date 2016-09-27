//
//  LocalChatMessage+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalChatMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *hideTime;
@property (nullable, nonatomic, retain) LocalChatMessageFrame *chatMessage;

@end

NS_ASSUME_NONNULL_END
