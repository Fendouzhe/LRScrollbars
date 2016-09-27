//
//  SMPosterList.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/9/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

///海报列表
#import <Foundation/Foundation.h>

@interface SMPosterList : NSObject

/*
adName = iPhone7;
status = 0;
userId = ;
id = 1144884977319952;
imagePath = http://test.image.shuangkuai.co/resources/c66c0a1ac2c349c49d3aafbba29c4b31;
createAt = 1473732728;
lastUpdate = 0;
link = ;
type = 1;
*/

@property (nonatomic ,copy)NSString *adName;/**< <#注释#> */

@property (nonatomic ,assign)NSInteger status; /**< <#注释#> */

@property (nonatomic ,copy)NSString *userId;/**< <#注释#> */

@property (nonatomic ,copy)NSString *id;/**< <#注释#> */

@property (nonatomic ,copy)NSString *imagePath;/**< <#注释#> */

@property (nonatomic ,assign)NSInteger createAt; /**< <#注释#> */

@property (nonatomic ,assign)NSInteger lastUpdate; /**< <#注释#> */

@property (nonatomic ,assign)NSInteger type; /**< <#注释#> */

//@property (nonatomic ,copy)NSString *link;/**< <#注释#> */



@end
