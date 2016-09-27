//
//  LocaltweetFrame+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocaltweetFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocaltweetFrame (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addressLabelF;
@property (nullable, nonatomic, retain) NSNumber *cellHeight;
@property (nullable, nonatomic, retain) NSString *contentLabelF;
@property (nullable, nonatomic, retain) NSString *iconViewF;
@property (nullable, nonatomic, retain) NSString *leftIconF;
@property (nullable, nonatomic, retain) NSString *nameLabelF;
@property (nullable, nonatomic, retain) NSString *originalViewF;
@property (nullable, nonatomic, retain) NSString *photosViewF;
@property (nullable, nonatomic, retain) NSString *retweetPhotosViewF;
@property (nullable, nonatomic, retain) NSString *retweetViewF;
@property (nullable, nonatomic, retain) NSString *rightContentLabelF;
@property (nullable, nonatomic, retain) NSString *timeLabelF;
@property (nullable, nonatomic, retain) NSString *toolbarF;
@property (nullable, nonatomic, retain) NSSet<LocalTweet *> *tweet;
@property (nullable, nonatomic, retain) NSSet<LocalUser *> *user;

@end

@interface LocaltweetFrame (CoreDataGeneratedAccessors)

- (void)addTweetObject:(LocalTweet *)value;
- (void)removeTweetObject:(LocalTweet *)value;
- (void)addTweet:(NSSet<LocalTweet *> *)values;
- (void)removeTweet:(NSSet<LocalTweet *> *)values;

- (void)addUserObject:(LocalUser *)value;
- (void)removeUserObject:(LocalUser *)value;
- (void)addUser:(NSSet<LocalUser *> *)values;
- (void)removeUser:(NSSet<LocalUser *> *)values;

@end

NS_ASSUME_NONNULL_END
