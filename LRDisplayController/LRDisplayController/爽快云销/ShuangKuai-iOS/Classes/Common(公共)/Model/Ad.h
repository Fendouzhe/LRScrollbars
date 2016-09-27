//
//  Ad.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/4/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ad : NSObject

@property (nonatomic, retain) NSString *id;

//广告链接 网址
@property (nonatomic, retain) NSString *link;

//广告图片
@property (nonatomic, retain) NSString *imagePath;

//广告名，还是空，以后可能有用，留着
@property (nonatomic, retain) NSString *adName;

@property (nonatomic, assign) NSInteger createAt;

@end
