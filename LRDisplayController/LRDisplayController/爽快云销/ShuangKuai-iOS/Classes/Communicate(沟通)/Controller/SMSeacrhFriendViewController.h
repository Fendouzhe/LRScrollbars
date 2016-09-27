//
//  SMSeacrhFriendViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSeacrhFriendViewController : UITableViewController
@property (nonatomic,assign) int pageNumber;/**< 页面属性 */
@property (nonatomic,copy) NSString *keyWord;/**< 搜索关键字 */
@end
