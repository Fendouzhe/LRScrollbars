//
//  LocalTweet+CoreDataProperties.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocalTweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalTweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *comments;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *createAt;
@property (nullable, nonatomic, retain) id datas;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *isUpvote;
@property (nullable, nonatomic, retain) NSString *protrait;
@property (nullable, nonatomic, retain) NSString *repostFrom;
@property (nullable, nonatomic, retain) NSString *repostFromId;
@property (nullable, nonatomic, retain) NSNumber *reposts;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *upvotes;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) LocaltweetFrame *tweetship;

@end

NS_ASSUME_NONNULL_END
