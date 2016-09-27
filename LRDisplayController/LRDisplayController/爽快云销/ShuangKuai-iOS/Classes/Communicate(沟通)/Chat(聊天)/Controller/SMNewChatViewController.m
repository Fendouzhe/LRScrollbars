//
//  SMNewChatViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/5/31.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

/**
 *  单聊界面
 */
#import "SMNewChatViewController.h"
#import "SMPersonInfoViewController.h"
#import "ChatMessageSave.h"
#import "SMNavigationViewController.h"
#import "SMImageNaviController.h"
#import "SMNewPersonInfoController.h"

//#import "User.h"
@interface SMNewChatViewController ()


@end

@implementation SMNewChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //删除工具条位置功能按钮
    [self.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
    //群ziliao
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"qunziliao"] forState:UIControlStateNormal];
    rightBtn.width = 22;
    rightBtn.height = 22;
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //重新定义方法
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"fanhuihong" highImage:@"fanhuihong"];
    
}

- (void)back{
    
    if (self.navigationController.viewControllers.count > 3 && _isSearchVc == NO) {
        //返回伙伴连线控制器
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightItemClick{
    [self didTapCellPortrait:self.targetId];
}


//点击头像
- (void)didTapCellPortrait:(NSString *)userId{
    //SMLog(@">>>>>>>%@",userId);
    //SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:NSStringFromClass([SMPersonInfoViewController class]) bundle:nil];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    User *tapUser = [[User alloc] init];
    tapUser.userid = userId;
    vc.user = tapUser;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//将要发送消息
- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message{
    if([message.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *txtMsg = (RCTextMessage*)message.content;
        //使用txtMsg做一些事情 ...
        SMLog(@"消息内容 = %@",txtMsg.content);
        if(message.messageDirection == 1){
            [[ChatMessageSave shareInstance] saveMessage:message];
        }
    }
    return message;
}
/*!
 发送消息完成的回调
 
 @param stauts          发送状态，0表示成功，非0表示失败
 @param messageCotent   消息内容
 */
- (void)didSendMessage:(NSInteger)stauts
               content:(RCMessageContent *)messageCotent{
    SMLog(@"%lu-----%@",stauts,messageCotent);
    
}

/*!
 查看图片消息中的图片
 
 @param model   消息Cell的数据模型
 
 @discussion SDK在此方法中会默认调用RCImagePreviewController下载并展示图片。
 */
- (void)presentImagePreviewController:(RCMessageModel *)model{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    //_imagePreviewVC.title = @"图片预览";
    
//    UINavigationController *nav = [[UINavigationController alloc]
//                                   initWithRootViewController:_imagePreviewVC];
//    nav.navigationBar.backgroundColor = [UIColor blackColor];
//    [self presentViewController:nav animated:YES completion:nil];
    
    SMImageNaviController *nav = [[SMImageNaviController alloc] initWithRootViewController:_imagePreviewVC];
    [self presentViewController:nav animated:YES completion:nil];

}

@end
