//
//  skuSelected.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skuSelected : NSObject
/**
 *  "text":"颜色分类"
 */
@property (nonatomic ,copy)NSString *text;
/**
 *  "id":"0011"
 */
@property (nonatomic ,assign)NSInteger id;
/**
 *  "propList":["桔色","透明"]
 */
@property (nonatomic ,strong)NSArray *propList;

@end
