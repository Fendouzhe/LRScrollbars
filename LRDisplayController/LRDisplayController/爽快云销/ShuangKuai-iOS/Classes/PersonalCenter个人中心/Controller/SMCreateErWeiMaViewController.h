//
//  SMCreateErWeiMaViewController.h
//  生成二维码
//
//  Created by yuzhongkeji on 15/11/5.
//  Copyright © 2015年 yuzhongkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMGroupChatDetailData;
@interface SMCreateErWeiMaViewController : UIViewController

- (void)setupQrcodeWithStr:(NSString *)Str;

@property (nonatomic ,strong)UIImageView *qrcodeView;

@property (nonatomic ,strong)User * user;

@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */

@end
