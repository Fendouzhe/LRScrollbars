//
//  SMCustomerListViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerListViewController.h"
#import "SMFriendList.h"
#import "SMNewChatViewController.h"

@interface SMCustomerListViewController ()<RCIMUserInfoDataSource>
@property (nonatomic,assign) BOOL inGetFriendList;/**< 正在获取好友列表 */
@end

@implementation SMCustomerListViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //隐藏客服连线显示的红点
    [[NSNotificationCenter defaultCenter] postNotificationName:HiddenBageNotification object:nil userInfo:@{@"tag":KKeFuLianXianTag}];
}
- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    self.title = @"客服连线";
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    //SMLog(@"---%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserChatToken]);
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_DISCUSSION)]];
    {
    ////设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
//    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserChatToken];
//    [[RCIM sharedRCIM] connectWithToken:tokenStr success:^(NSString *userId) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//            NSString *userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//            NSString *userPortrait = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPortrait];
//            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userIDStr name:userNameStr portrait:userPortrait];
//            [RCIM sharedRCIM].currentUserInfo = userInfo;
//            //        [[RCIM sharedRCIM] setUserInfoDataSource:weakSelf];
//            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KUserChatID];
//        });
//
//        SMLog(@"融云连接成功");
//    } error:^(RCConnectErrorCode status) {
//        SMLog(@"融云连接错误");
//    } tokenIncorrect:^{
//        SMLog(@"token错误");
//    }];
    
//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = KDefaultFontBig;
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"帮助" attributes:dict];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    [rightBtn sizeToFit];
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    UIImage *image = [[UIImage imageNamed:@"问号"] scaleToSize:ScaleToSize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    //隐藏客服连线显示的红点
    [[NSNotificationCenter defaultCenter] postNotificationName:HiddenBageNotification object:nil userInfo:@{@"tag":KKeFuLianXianTag}];
}
//帮助
- (void)rightItemClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服连线" message:@"买家将通过客服连线与您交流，询问您任何购买事宜。而客服连线中的聊天记录可能不会被永久保留。记录过多的时候请及时删除，谢谢！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    //[action setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    alert.view.tintColor = [UIColor redColor];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion{
    if (self.inGetFriendList) {
        return;
    }
    NSString *userChatID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if ([userId isEqualToString:userChatID]) {  //如果是自己方
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        NSString *portrait = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPortrait];
        //        SMLog(@"name    %@   portrait   %@ userChatID  %@",name,portrait,userChatID);
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:portrait];
        return completion(user);
        
    }else {  //
        //        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:self.user.userid name:self.user.name portrait:self.user.portrait];
        //        SMLog(@"self.user.userid    %@   self.user.name   %@ self.user.portrait  %@",self.user.userid,self.user.name,self.user.portrait);
        //        return completion(user);
        if ([SMFriendList sharedManager].isGetValue) {
            //BOOL isInFriend = NO;
            for (User *user in [SMFriendList sharedManager].friendsArray) {
                if ([user.userid isEqualToString:userId]) {
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                    return completion(userInfo);
                }
            }
        }else{
            [self getFriendList];
        }
        
        //FIXME: 如果好友被删除，就不会显示头像
    }
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    //    SMNewChatViewController *conversationVC = [[SMNewChatViewController alloc] init];
    ////    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    //    conversationVC.conversationType = model.conversationType;
    //    conversationVC.targetId = model.targetId;
    //    conversationVC.title = model.conversationTitle;
    //    [self.navigationController pushViewController:conversationVC animated:YES];
    switch (conversationModelType) {
        case RC_CONVERSATION_MODEL_TYPE_NORMAL:
        {
            switch (model.conversationType) {
                
                case ConversationType_DISCUSSION:
                {
                    SMNewChatViewController *conversationVC = [[SMNewChatViewController alloc] init];
                    conversationVC.conversationType = model.conversationType;
                    conversationVC.targetId = model.targetId;
                    conversationVC.title = model.conversationTitle;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_COLLECTION:
        {
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION:
        {
        }
            break;
        case RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE:
        {
        }
            break;
        default:
            break;
    }
}



-(void)getFriendList{
    
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            [[SMFriendList sharedManager] startWithFriendsArray:array];
            for (User *user in array) {
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:user.userid];
            }
        }else{
        }
        self.inGetFriendList = NO;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
