//
//  SMNewPartnerConnectViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNewPartnerConnectViewController : UIViewController
/**
 *  搜索联系人的字段
 */
@property (nonatomic,copy)NSString * keyWord;

/**
 *  是否为搜索联系人
 */
@property (nonatomic,assign)BOOL isSearchContact;
/**
 *  是否为搜索伙伴
 */
@property (nonatomic,assign)BOOL isSearchPartner;
/**
 *  是否为搜索陌生朋友
 */
@property (nonatomic,assign)BOOL isSearchFriend;
@end
