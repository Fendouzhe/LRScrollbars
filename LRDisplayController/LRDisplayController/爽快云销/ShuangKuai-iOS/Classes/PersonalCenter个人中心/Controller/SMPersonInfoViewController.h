//
//  SMPersonInfoViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMClient.h>
@interface SMPersonInfoViewController : UIViewController

@property (nonatomic ,strong)User *user;
//基本资料按钮
@property (weak, nonatomic) IBOutlet UIButton *basicInfoBtn;
//爽快圈按钮
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;

@property(nonatomic,assign)BOOL select;

@property(nonatomic,strong)Tweet * tweet;

@property(nonatomic,strong)AVIMClient * client;

//搜索的关键字
//@property (nonatomic ,copy)NSString *keyWord;

@end
