//
//  SMConnectPersonSectionData.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMConnectPersonSectionData : NSObject
@property (nonatomic,copy) NSString *imageStr;/**< 本地头像 */
@property (nonatomic,copy) NSString *labelStr;/**< 显示的字符串 */
@property (nonatomic,copy) CellOption myoption;/**< block变量 */
@end
