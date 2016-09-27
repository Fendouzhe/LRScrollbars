//
//  SMArticalList.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

///文章列表
#import <Foundation/Foundation.h>

@interface SMArticalList : NSObject
/*
    id = 54fd79ce5165483dbe9ac468061a5c03;
	lastUpdate = 1472262851;
	digest = ;
	author = ;
	url = ;
	createAt = 1472262851;
	pubTime = 0;
	isWxpub = 0;
	mediaId = ;
	title = rtt;
	imagePaths = http://test.image.shuangkuai.co/resources/af75dd378d0844c8ba06a23cdfae16b2;
	companyName = ;
	contentSourceUrl = ;
	userId = 761b155b-32d4-40c0-8d88-aca762a4a2d9;
	companyId = unizone;
	content = <p>ttt</p>;
 */

@property (nonatomic ,copy)NSString *title;/**< <#注释#> */

@property (nonatomic ,copy)NSString *companyId;

@property (nonatomic ,copy)NSString *content;

@property (nonatomic ,copy)NSString *companyName;

@property (nonatomic ,copy)NSString *userId;/**< <#注释#> */

@property (nonatomic ,copy)NSString *id;/**< <#注释#> */

@property (nonatomic ,copy)NSString *imagePaths;/**< <#注释#> */

@property (nonatomic ,assign)NSInteger createAt; /**< <#注释#> */

@property (nonatomic ,assign)NSInteger lastUpdate; /**< <#注释#> */



@end
