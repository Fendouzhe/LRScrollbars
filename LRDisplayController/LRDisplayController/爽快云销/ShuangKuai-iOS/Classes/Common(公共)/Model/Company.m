//
//  Company.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import "Company.h"

@interface Company()

@end


@implementation Company

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeInteger:self.createAt forKey:@"createAt"];
    [aCoder encodeObject:self.descr forKey:@"descr"];
    [aCoder encodeObject:self.engName forKey:@"engName"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.followers forKey:@"followers"];
    [aCoder encodeInteger:self.lastUpdate forKey:@"lastUpdate"];
    [aCoder encodeObject:self.scale forKey:@"scale"];
    [aCoder encodeObject:self.logoPath forKey:@"logoPath"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.createAt = [aDecoder decodeIntegerForKey:@"createAt"];
        self.descr = [aDecoder decodeObjectForKey:@"descr"];
        self.engName = [aDecoder decodeObjectForKey:@"engName"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.followers = [aDecoder decodeIntegerForKey:@"followers"];
        self.lastUpdate = [aDecoder decodeIntegerForKey:@"lastUpdate"];
        self.scale = [aDecoder decodeObjectForKey:@"scale"];
        self.logoPath = [aDecoder decodeObjectForKey:@"logoPath"];
    }
    return self;
}

@end
