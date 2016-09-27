//
//  SMPartnerConnectViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPartnerConnectViewController.h"
#import "SMCommunicateTableViewCell.h"
#import "SMContactPersonTableViewCell.h"
#import "SMDetailContactViewController.h"
#import "SMAddContactPersonViewController.h"
#import "SMChatViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SMNewRigthItemVIew.h"
#import "SMDropView.h"
#import "SMScannerViewController.h"
#import "SMFriend.h"
#import "SMFriendGroup.h"
#import "SMPersonInfoViewController.h"
#import <AVIMClient.h>
#import <AVIMConversationQuery.h>
#import <AVIMConversation.h>
#import <AVIMTextMessage.h>
#import "SMChatMessageFrame.h"
#import "SMConversation.h"
#import "SMChatMessage.h"
#import "LocalConversation.h"
#import "LocalUser1.h"
#import "SMScannerViewController.h"
#import "SMSearchViewController.h"
#import "AppDelegate.h"
#import "SMPlaySound.h"
#import "SMTitleView.h"
#import "SMScanerBtn.h"
#import "SMDropView.h"
#import "SMConnectPersonSection0.h"
#import "SMMyTeamController.h"
#import "NEWSTableViewCell.h"
#import "SMInformationViewController.h"
#import "SingtonManager.h"
#import "SMMessageListViewController.h"
#import "SMFriendList.h"
#import "SMConnectPersonController.h"
#import "SMAddGroupChatViewController.h"
#import "SMNewAddGroupChatViewController.h"

#define KTextcolor SMColor(186, 0, 21)

@interface SMPartnerConnectViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SMNewRigthItemVIewDelegate,SMDropViewDelegate,AVIMClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *communicateTableView;

@property (weak, nonatomic) IBOutlet UITableView *contactPersonTableView;

@property (nonatomic , strong) SMMessageListViewController *messageListViewController;/**< 消息列表 */

@property (nonatomic,strong) SMConnectPersonController *connectPersonController;/**< 联系人列表 */

/**
 *  数据数组
 */
@property (nonatomic ,strong)NSArray *arrDatas;

@property (nonatomic ,strong)NSArray *arrLetters;

@property (nonatomic ,strong)NSMutableArray *arrayDatas;

/**
 *  发消息
 */
//@property (nonatomic, strong) AVIMClient *client;
/**
 *  leancloud需要的key
 */
@property (nonatomic ,copy)NSString *myRtcKey;

@property (nonatomic ,strong)NSMutableArray *arrConversations;

@property (nonatomic,strong)SMDropView * men;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TableViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic ,strong)UIButton *rightBtn;

@property(nonatomic,strong)SMTitleView * titleView;
@end

@implementation SMPartnerConnectViewController

-(NSString *)keyWord{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}

-(void)dealloc{
    SMLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFriends) name:KReloadFriendsNote object:nil];

    //[self requestData];
    

}
//搜索所有人 不局限于联系人
-(void)requestStrange{
    [[SKAPI shared] queryUser:self.keyWord andPage:1 andSize:65535 block:^(NSArray *array, NSError *error) {
        if (!error) {
            for (NSInteger i = 0 ; i < self.arrLetters.count; i++) {
                NSString *letter = self.arrLetters[i];//ABCD..
                
                NSMutableArray *arrFriend = [NSMutableArray array];
                //遍历返回过来的user数组
                for (NSInteger j = 0; j < array.count; j++) {
                    User *user = array[j];
                    NSString *sort = user.sort;
                    //如果有user的sort（名字首字母缩写）与给定数组中的字母相同
                    if ([sort isEqualToString:letter]) {
                        SMFriend *friend = [[SMFriend alloc] init];
                        friend.user = user;
                        [arrFriend addObject:friend];
                    }
//                    else if ([sort isEqualToString:@"?"]){
//                        SMFriend *friend = [[SMFriend alloc] init];
//                        friend.user = user;
//                        [arrFriend addObject:friend];
//                    }
                }
                
                if (arrFriend.count > 0) {
                    SMFriendGroup *friendG = [[SMFriendGroup alloc] init];
                    
                    friendG.arrFriend = arrFriend;
                    friendG.sort = letter;
                    
                    [self.arrayDatas addObject:friendG];
                }
            }
            [self.contactPersonTableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)requestFriend{
    SMLog(@"%@",self.keyWord);
    [[SKAPI shared] queryFriend:self.keyWord block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array.count   好友数 %zd",array.count);
            SMLog(@"array   %@",array);
            [[SMFriendList sharedManager] startWithFriendsArray:array];
            for (NSInteger i = 0 ; i < self.arrLetters.count; i++) {
                NSString *letter = self.arrLetters[i];//ABCD..
                
                NSMutableArray *arrFriend = [NSMutableArray array];
                //遍历返回过来的user数组
                for (NSInteger j = 0; j < array.count; j++) {
                    User *user = array[j];
                    NSString *sort = user.sort;
                    //如果有user的sort（名字首字母缩写）与给定数组中的字母相同
                    if ([sort isEqualToString:letter]) {
                        SMFriend *friend = [[SMFriend alloc] init];
                        friend.user = user;
                        [arrFriend addObject:friend];
                    }
                    //                    else if ([sort isEqualToString:@"?"]){
                    //                        SMFriend *friend = [[SMFriend alloc] init];
                    //                        friend.user = user;
                    //                        [arrFriend addObject:friend];
                    //                    }
                }
                
                if (arrFriend.count > 0) {
                    SMFriendGroup *friendG = [[SMFriendGroup alloc] init];
                    
                    friendG.arrFriend = arrFriend;
                    friendG.sort = letter;
                    
                    [self.arrayDatas addObject:friendG];
                }
            }
            SMLog(@"self.arrayDatas   %@",self.arrayDatas);
            [self.contactPersonTableView reloadData];
            //            for (User *u in array) {
            //                SMLog(@"u   %@",[u class]);
            //            }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
    
    self.communicateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.arrConversations removeAllObjects];
    
    self.navigationController.navigationBar.hidden = NO;
    
    //注册聊天的Client
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    self.client = application.client;
    application.notesViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveConversation:) name:KChatVcDisappearNot object:nil];
    
    [self loadSqlite];
    
}

-(void)requestData{

//    [self.arrConversations removeAllObjects];
//    
//    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    self.client = application.client;
    
//    NSString *useID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    
//    [[SKAPI shared] queryUserProfile:useID block:^(id result, NSError *error) {
//        if (!error) {
//            User *user = (User *)result;
//            self.myRtcKey = user.rtcKey; //拿到 rtcKey；
    
            
//            SMLog(@"friend = %p",self.client);
            //self.client.delegate = self;
            
            // Tom 构建一个查询
//            AVIMConversationQuery *query = [self.client conversationQuery];
            // Tom 设置查询最近 20 个活跃对话
//            query.limit = 1000;
            // 执行查询
//            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    SMLog(@"找到 %zd 个对话！ ", [objects count]);
//                    SMLog(@"objects =     %@",objects);
//                    for (AVIMConversation *c in objects) {
//                        SMLog(@"AVIMConversation   %@",c.conversationId);
//                        
//                        SMConversation * comversation = [SMConversation new];
//                        NSString * otherID  = @"";
//                        SMLog(@"members =    %@",c.members);
//                        SMLog(@"otherID   %@",otherID);
//                        
//                        BOOL isMy = NO;
//                        if (c.members.count>=2) {
//                            for (NSString * string in c.members) {
//                                if ([string isEqualToString:[@"shuangkuai-sales-" stringByAppendingString:useID]]) {
//                                    //必须要一个是自己的id
//                                    isMy = YES;
//                                    break;
//                                }
//                            }
//                            
//                            if (isMy) {
//                                for (NSString * string in c.members) {
//                                    if (![string isEqualToString:[@"shuangkuai-sales-" stringByAppendingString:useID]]) {
//                                        otherID = string;
//                                    }
//                                }
//                            }
//                            
//                        }
//                        
//                        //截取出userID
//                        NSString * subOtherId = @"";
//                        SMLog(@"userID  %@",subOtherId);
//                        //通过userId 获取用户信息
//                        //头像，名字
//                        
//                        //进行判断  ，出现客服
//                        
//                        if ([otherID rangeOfString:@"shuangkuai-sales-"].location != NSNotFound) {
//                            //销售人员
//                            subOtherId = [otherID substringWithRange:NSMakeRange(17, otherID.length-17)];
//                        }else{
//                            //subOtherId = [otherID substringWithRange:NSMakeRange(17, otherID.length-17)];
//                            subOtherId = otherID;
//                        }
//                        
//                        comversation.userID = subOtherId;
//                        [[SKAPI shared] queryUserProfile:subOtherId block:^(id result, NSError *error) {
//                            if (!error) {
//                                comversation.user = (User *)result;
//                                
//                                comversation.iconStr = [(User *)result portrait];
//                                comversation.name = [(User *)result name];
//                                
//                                SMLog(@"name   %@",user.name);
//                                [c queryMessagesWithLimit:10 callback:^(NSArray *objects, NSError *error) {
//                                    if (!error) {
//                                        
//                                        SMLog(@"objects.count  %zd",objects.count);
//                                        for (AVIMTextMessage *m in objects) {
//                                            SMLog(@"m.text  %@",m.text);
//                                            //每个对话 的历史对话
//                                            //这里获取到最后一条消息
//                                        }
//                                        
//                                        comversation.lastMessage = [[objects lastObject] text];
//                                        SMLog(@"lastMessage =    %@",comversation.lastMessage);
//                                        
//                                        comversation.time = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%lf",[c.lastMessageAt timeIntervalSince1970]]];
//                                        
//                                        [self.arrConversations addObject:comversation];
//                                        
//                                        NSMutableArray * array = [NSMutableArray array];
//                                        
//                                        for (SMConversation * c in self.arrConversations) {
//                                            [array addObject:c];
//                                        }
//                                        //                                                对数组进行处理
//                                        for (NSInteger i = 0; i<self.arrConversations.count; i++) {
//                                            SMConversation * onec = self.arrConversations[i];
//                                            for (NSInteger j=0 ;j<self.arrConversations.count;j++) {
//                                                SMConversation * c = self.arrConversations[j];
//                                                if (j==i) {
//                                                    break;
//                                                }
//                                                
//                                                if ([c.userID isEqualToString:onec.userID]) {
//                                                    [array removeObject:c];
//                                                    
//                                                }
//                                            }
//                                        }
//                                        
//                                        [self.arrConversations removeAllObjects];
//                                        
//                                        for (SMConversation * c in array) {
//                                            if (c.lastMessage == nil) {
//                                                
//                                            }else{
//                                                [self.arrConversations addObject:c];
//                                            }
//                                        }
//                                        
//                                        //[self saveSqliteWithArray:[self.arrConversations copy]];
//                                        
//                                        //[self loadSqlite];
//                                        
//                                        [self.communicateTableView reloadData];
//                                        
//                                    }else{
//                                        SMLog(@"error  %@",error);
//                                    }
//                                }];
//                                
//                            }
//                        }];
//                    }
//                    
//                    
//                    
//                }else{
//                    SMLog(@"error  %@",error);
//                }
//                
//                
//            }];
//        }else{
//            SMLog(@"error   %@",error);
//        }
//    }];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //消失时  保存
    
    //    NSArray * array = [LocalConversation MR_findAll];
    //    for (SMConversation * c in self.arrConversations) {
    //        BOOL isSave = YES;
    //        for (LocalConversation * localC in array) {
    //            if ([localC.userID isEqualToString:c.user.userid]) {
    //                //更新
    //                [self updateSqliteWith:c];
    //                isSave = NO;
    //                break;
    //            }
    //        }
    //        if (isSave) {
    //            [self saveSqliteWith:c];
    //        }
    //    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KChatVcDisappearNot object:nil];
    
}

- (void)recieveConversation:(NSNotification *)not{
    SMLog(@"recieveConversation     KChatVcDisappearNot");
    User *user = not.userInfo[KChatVcDisappearNotUserKey];
    SMChatMessageFrame *messageF = not.userInfo[KChatVcDisappearNotLastMessageKey];
    SMConversation *conversation = [[SMConversation alloc] init];
    conversation.iconStr = user.portrait;
    conversation.name = user.name;
    conversation.userID = user.userid;
    conversation.user = user;
    conversation.lastMessage = messageF.messgae.text;
    conversation.time = messageF.messgae.time;
    conversation.unix = messageF.messgae.unix;
    conversation.isOther = messageF.messgae.type;
    SMLog(@"user.name  recieveConversation  %@",user.name);
    [self.titleView showLeftSpot];
    for (SMConversation *c in self.arrConversations) {//
        if ([user.userid isEqualToString:c.userID]) {
            if (c.unix < conversation.unix) {
                c.lastMessage = conversation.lastMessage;
                c.unix = conversation.unix;
                c.time = conversation.time;
                if (conversation.isOther) {
                    c.unread = [NSString stringWithFormat:@"%zd",c.unread.integerValue+1];
                }
                
            }
            
            //排序刷新
            [self sequence];
            
            [self updateSqliteWith:conversation];
            //刷新沟通首页的伙伴连线的角标
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
            
            //[self.communicateTableView reloadData];
            
            return;
        }
    }
    if (conversation.isOther) {
        conversation.unread = @"1";
    }
    
    //判断是否已经存在  更新  也可以重新存
    [self saveSqliteWith:conversation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
    
    [self.arrConversations addObject:conversation];
    
    SMLog(@"self.arrConversations.count  %zd",self.arrConversations.count);
    
    //排序刷新
    [self sequence];
    
    //[self.communicateTableView reloadData];
}

-(void)receiveConversationWithUser:(User *)user andChatMessgaeFrame:(SMChatMessageFrame *)messageF
{
    
    SMConversation *conversation = [[SMConversation alloc] init];
    conversation.iconStr = user.portrait;
    conversation.name = user.name;
    conversation.userID = user.userid;
    conversation.user = user;
    conversation.lastMessage = messageF.messgae.text;
    conversation.time = messageF.messgae.time;
    conversation.unix = messageF.messgae.unix;
    conversation.isOther = messageF.messgae.type;
    SMLog(@"user.name  recieveConversation  %@",user.name);
    [self.titleView showLeftSpot];
    
    NSArray * localArray = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0"];
    
    for (LocalConversation  *c in localArray) {//
        if ([user.userid isEqualToString:c.userID]) {
            //c.lastMessage = conversation.lastMessage;
            [self updateSqliteWith:conversation];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
            //排序刷新
            [self sequence];
            
            //[self.communicateTableView reloadData];
            return;
        }
    }
    
    //判断是否已经存在  更新  也可以重新存
    [self saveSqliteWith:conversation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
    
    SMLog(@"self.arrConversations.count  %zd",self.arrConversations.count);
    
    //排序刷新
    [self sequence];
    
    //[self.communicateTableView reloadData];
    
}

//对数组进行排序后刷新
-(void)sequence{
    
    for (int i = 0; i<[self.arrConversations count]; i++)
    {
        for (int j=i+1; j<[self.arrConversations count]; j++)
        {
            SMConversation * a = [self.arrConversations objectAtIndex:i] ;
            
            SMConversation * b = [self.arrConversations objectAtIndex:j] ;
            
            if (a.unix < b.unix)
            {
                [self.arrConversations replaceObjectAtIndex:i withObject:b];
                [self.arrConversations replaceObjectAtIndex:j withObject:a];
            }
            
        }
        
    }
    
    [self.communicateTableView reloadData];
    
}

- (void)reloadFriends{
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array  queryFriend  %@",array);
            self.arrDatas = array;
            [self.communicateTableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)setupNav{
    //    self.title = @"伙伴连线";
    
    //自定义titleView
    SMTitleView * titleView = [SMTitleView CreatNavSwipTitleViewWithLeftTitle:@"消息" andRight:@"联系人" andViewController:self];
    self.titleView = titleView;
    [titleView leftBtnClickAction:^{
        SMLog(@"伙伴联系点击左边按钮");
        self.communicateTableView.hidden = NO;
        self.messageListViewController.view.hidden = NO;
        self.contactPersonTableView.hidden = YES;
        self.connectPersonController.view.hidden = YES;
    }];
    [titleView rightBtnClickAction:^{
        SMLog(@"伙伴联系点击右边按钮");
        self.communicateTableView.hidden = YES;
        self.messageListViewController.view.hidden = YES;
        self.contactPersonTableView.hidden = NO;
        self.connectPersonController.view.hidden = NO;
    }];
    
    [titleView hiddenRightSpot];
    
//    [titleView showRightSpot];
//    
//    [titleView showLeftSpot];
    //添加联系人
    //    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    //    scanerBtn.width = 22;
    //    scanerBtn.height = 22;
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    //    self.navigationItem.rightBarButtonItem = rightItem;
    //    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.isSearchPartner && !self.isSearchContact && !self.isSearchFriend) {
        //添加联系人
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjialianxirrenRed"] forState:UIControlStateNormal];
        rightBtn.width = 22;
        rightBtn.height = 22;
        self.rightBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    //针对搜索做的处理
    if (self.isSearchContact) {
        self.titleView.rightButton.selected = YES;
        self.titleView.leftButton.selected = NO;
        self.titleView.rightBlcok();
        self.titleView.hidden = YES;
        self.title = @"伙伴连线";
        self.topView.hidden = YES;
        self.topConstraint.constant = -45;
    }
    
    if (self.isSearchPartner) {
        self.titleView.rightButton.selected = NO;
        self.titleView.leftButton.selected = YES;
        self.titleView.leftBlcok();
        self.titleView.hidden = YES;
        self.title = @"联系人";
        self.topViewHeight.constant = 0;
        self.topView.hidden = YES;
        self.topConstraint.constant = -45;
    }else if(!self.isSearchFriend){
        [self requestFriend];
    }else{
        self.titleView.rightButton.selected = NO;
        self.titleView.leftButton.selected = YES;
        self.titleView.rightBlcok();
        self.titleView.hidden = YES;
        self.title = @"添加朋友";
        self.topViewHeight.constant = 0;
        self.topView.hidden = YES;
        self.topConstraint.constant = -45;
        [self requestStrange];
    }
    
}

- (void)rightItemClick{
    SMLog(@"点击了 添加联系人");
    SMDropView *menu = [SMDropView menu];
    menu.delegate = self;
    
    //    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    //    vc.view.height = 44 *3;
    //    menu.contentController = vc;
    
    [menu showFrom:self.rightBtn];
}

- (void)setupUI{
    
    self.topView.backgroundColor = KControllerBackGroundColor;
    if (isIPhone5) {
        self.topViewHeight.constant = 45;
    }else if (isIPhone6){
        self.topViewHeight.constant = 45 *KMatch6Height;
    }else if (isIPhone6p){
        self.topViewHeight.constant = 45 *KMatch6pHeight;
    }
    self.searchBtn.layer.cornerRadius = SMCornerRadios;
    self.searchBtn.clipsToBounds = YES;
    
    self.messageListViewController = [[SMMessageListViewController alloc] init];
    [self addChildViewController:self.messageListViewController];
    [self.view addSubview:self.messageListViewController.view];
    
    [self.messageListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.communicateTableView);
    }];
    
    self.connectPersonController = [[SMConnectPersonController alloc] init];
    [self addChildViewController:self.connectPersonController];
    [self.view addSubview:self.connectPersonController.tableView];
    
    [self.connectPersonController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.communicateTableView);
    }];
    
    self.connectPersonController.view.hidden = YES;
}


- (void)searchBtnDidClick{
    SMLog(@"点击了 搜索 按钮");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    if (!self.communicateTableView.hidden) {//当前显示会话
        vc.categoryType = 4;
    }else if (!self.contactPersonTableView.hidden){//当前显示联系人
        vc.categoryType = 6;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchBtnClick {
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    if (!self.communicateTableView.hidden) {//当前显示会话
        vc.categoryType = 4;
    }else if (!self.contactPersonTableView.hidden){//当前显示联系人
        vc.categoryType = 6;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)BtnDidClick:(UIButton *)btn{
    SMLog(@"点击了 二维码 按钮");
    
    //    self.men = [SMDropView menu];
    //    self.men.delegate = self;
    //    [self.men showFrom:btn];
    //    SMLog(@"%p",btn);
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 红色添加联系人点击事件
- (void)addBtnDidClick{
    SMLog(@"点击了 添加朋友按钮");
    SMAddContactPersonViewController *addVc = [[SMAddContactPersonViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)deleteBtnDidClick{
    SMLog(@"点击了 扫一扫");
    SMScannerViewController *vc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)groupBtnDidClick{
    SMLog(@"点击了 添加群聊");
//    SMAddGroupChatViewController *vc = [[SMAddGroupChatViewController alloc] init];
    SMNewAddGroupChatViewController *vc = [[SMNewAddGroupChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//- (void)addContactPersonClick{
//
////    SMAddContactPersonViewController *addVc = [[SMAddContactPersonViewController alloc] init];
////    [self.navigationController pushViewController:addVc animated:YES];
//    //要弹出视图
//    UIView * View = [[UIView alloc]init];
//    [self.view addSubview:View];
//
//    [View mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
//}
//-(void)searchClickBtn
//{
//    SMLog(@"点击搜索按钮");
//}


#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.communicateTableView) {
        return 1;
    }else{
        SMLog(@"self.arrayDatas.count   %zd",self.arrayDatas.count);
        return self.arrayDatas.count+1 ;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.communicateTableView) {//对话
        
        return self.arrConversations.count+1;
    }else{ //联系人
        if (section == 0) {
            return 1;
        }else{
            SMFriendGroup *friendGroup = self.arrayDatas[section - 1];
            SMLog(@"friendGroup.arrFriend.count   %zd",friendGroup.arrFriend.count);
            return friendGroup.arrFriend.count;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.communicateTableView) {//对话
        if (indexPath.row == 0) {
            NEWSTableViewCell * cell = [NEWSTableViewCell cellWithTableView:tableView];
            
            return cell;
        }else{
            SMCommunicateTableViewCell *cell = [SMCommunicateTableViewCell cellWithTableView:tableView];
            //可以在这里给cell赋值
            if (self.arrConversations.count>0) {
                cell.conversation = self.arrConversations[indexPath.row-1];
            }
            
            
            
            //        SMConversation *con = self.arrConversations[indexPath.row];
            //        SMLog(@"con.user.name  %@",con.user.name);
            return cell;
        }
        
    }else{//联系人
        
        if (indexPath.section == 0) {//第一组显示“我的团队”
            SMConnectPersonSection0 *cell = [SMConnectPersonSection0 cellWithTableview:tableView];
            return cell;
        }else{
            SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
            //可以在这里给cell赋值
            
            SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section - 1];
            SMFriend *friend = friendGroup.arrFriend[indexPath.row];
            cell.myFriend = friend;
            return cell;
        }
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.communicateTableView) { //对话
        CGFloat height;
        if (isIPhone5) {
            height = 64;
        }else if (isIPhone6){
            height = 64 *KMatch6;
        }else if (isIPhone6p){
            height = 64 *KMatch6p;
        }
        return height;
    }else{  //联系人
        if (indexPath.section == 0) {   //第一组“我的团队”
            CGFloat height;
            if (isIPhone5) {
                height = 65;
            }else if (isIPhone6){
                height = 65 *KMatch6Height;
            }else if (isIPhone6p){
                height = 65;
            }
            return height;
        }else{
//            CGFloat height;
//            if (isIPhone5) {
//                height = 51;
//            }else if (isIPhone6){
//                height = 51 *KMatch6Height;
//            }else if (isIPhone6p){
//                height = 51;
//            }
            return 41 *SMMatchHeight+10;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.contactPersonTableView) {
        
        if (section == 0) { //"我的团队"这一组
            return nil;
        }else{
            SMFriendGroup *friendG = self.arrayDatas[section - 1];
            if ([friendG.sort isEqualToString:@"?"]) {
                return @"#";
            }else{
                
                return friendG.sort;
            }
        }
        //        SMFriendGroup *friendG = self.arrayDatas[section];
        //        return friendG.sort;
        
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.contactPersonTableView) {//联系人
        if (indexPath.section == 0) {
            SMLog(@"点击了 我的团队cell");
            SMMyTeamController *vc = [[SMMyTeamController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
            SMPersonInfoViewController * vc = [[SMPersonInfoViewController alloc]initWithNibName:@"SMPersonInfoViewController" bundle:nil];
            SMFriendGroup *friendG = self.arrayDatas[indexPath.section - 1];
            SMFriend *friend = friendG.arrFriend[indexPath.row];
            vc.user = friend.user;
//            vc.client = self.client;
            [self.navigationController pushViewController:vc animated:YES];
            SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            SMLog(@"%@",NSStringFromCGRect(cell.icon.frame));
        }
    }else{//对话
        //进入会话界面
        if (indexPath.row == 0) {
            //进入消息列表
            SMInformationViewController * info = [SMInformationViewController new];
            [self.navigationController pushViewController:info animated:YES];
        }else{
            SMCommunicateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            SMChatViewController *chatVc = [[SMChatViewController alloc] init];
            //        SMChatViewController * chatVc = [[SMChatViewController alloc]initWithNibName:@"SMChatViewController" bundle:nil];
            //        SMFriendGroup *friendGroup = self.arrayDatas[indexPath.section];
            //        SMFriend *friend = friendGroup.arrFriend[indexPath.row];
            //        chatVc.targetRtcKey = friend.user.rtcKey;
            //        chatVc.client = self.client;
            chatVc.user = cell.conversation.user;
            chatVc.targetRtcKey = cell.conversation.user.rtcKey;
//            chatVc.client = self.client;
            cell.conversation.unread = [NSString stringWithFormat:@"%d",0];
            [self.communicateTableView reloadData];
            SMLog(@"cell.conversation.user.rtcKey    %@",cell.conversation.user.rtcKey);
            //点击进去  清空未读
            NSArray * array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
            
            for (LocalConversation * localConversation in array) {
                if ([localConversation.userID isEqualToString:cell.conversation.userID]) {
                    //找到这个  然后更新为0
                    localConversation.unread = [NSString stringWithFormat:@"%d",0];
                    
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
            [self.navigationController pushViewController:chatVc animated:YES];
            
            
        }

        }
}

/**
 *  返回分组索引数组
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    //这里需要用KVC 来取值
    if (tableView == self.contactPersonTableView) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < self.arrayDatas.count; i++) {
            SMFriendGroup *friendG = self.arrayDatas[i];
            NSString *title = friendG.sort;
            if ([title isEqualToString:@"?"]) {
                title = @"#";
                [arrM addObject:title];
                continue;
            }
            [arrM addObject:title];
        }
        return arrM;
    }else{
        return nil;
    }
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
////    [self.searchField resignFirstResponder];
//}
//
//#pragma mark -- UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"]) {
//        [self.searchField resignFirstResponder];
//    }
//    return YES;
//}

#pragma mark -- 懒加载
- (NSMutableArray *)arrayDatas{
    if (_arrayDatas == nil) {
        _arrayDatas = [NSMutableArray array];
    }
    return _arrayDatas;
}

- (NSArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSArray array];
    }
    return _arrDatas;
}

- (NSArray *)arrLetters{
    if (_arrLetters == nil) {
        _arrLetters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"?"];
    }
    return _arrLetters;
}

- (NSMutableArray *)arrConversations{
    if (_arrConversations == nil) {
        _arrConversations = [NSMutableArray array];
    }
    return _arrConversations;
}

-(void)updateSqliteWith:(SMConversation *)conversation
{
    NSArray * array = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalConversation * localConversation in array) {
        if ([localConversation.userID isEqualToString:conversation.userID]) {
            //更新
            localConversation.lastMessage = conversation.lastMessage;
            localConversation.iconStr = conversation.iconStr;
            localConversation.name = conversation.name;
            //保存消息
            //创建消息体  保存到数组中
            SMChatMessage * message = [SMChatMessage new];
            message.time = conversation.time;
            message.text = conversation.lastMessage;
            message.OtherClientId = conversation.clientId;
            message.conversationId = conversation.conversationId;
            LocalUser1 * localUser = [localConversation.user anyObject];
            localUser.portrait = conversation.iconStr;
            if (conversation.isOther) {
                localConversation.unread = [NSString stringWithFormat:@"%zd",localConversation.unread.integerValue+1];
            }
            
            
            
            
            NSDictionary * dic = [message mj_JSONObject];
            
            [localConversation.messages addObject:dic];
            
            if (localConversation.unix.doubleValue < conversation.unix) {
                localConversation.time = conversation.time;
                localConversation.unix = [NSNumber numberWithDouble:conversation.unix];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return;
        }
    }
}

-(void)saveSqliteWith:(SMConversation *)conversation{
    
    
        LocalConversation * localconversation = [LocalConversation MR_createEntity];
        localconversation.iconStr = conversation.iconStr;
        localconversation.name = conversation.name;
        localconversation.userID = conversation.userID;
        localconversation.lastMessage = conversation.lastMessage;
        localconversation.time = conversation.time;
        localconversation.unix = [NSNumber numberWithDouble:conversation.unix];
        localconversation.isCustomer = [NSNumber numberWithBool:NO];
        
        if (conversation.isOther) {
            localconversation.unread = [NSString stringWithFormat:@"%d",1];
        }
        
        
        
        SMLog(@"save = ==     %@",localconversation.unix);
        localconversation.messages = [NSMutableArray array];
        //保存消息
        //创建消息体  保存到数组中
        SMChatMessage * message = [SMChatMessage new];
        message.time = conversation.time;
        message.text = conversation.lastMessage;
        message.OtherClientId = conversation.clientId;
        message.conversationId = conversation.conversationId;
        
        //转成字典存储
        NSDictionary * dic = [message mj_JSONObject];
        
        [localconversation.messages addObject:dic];
        
        
        LocalUser1 * localUser = [LocalUser1 MR_createEntity];
        
        localUser.userid = conversation.user.userid;
        localUser.name = conversation.user.name;
        localUser.gender = [NSNumber numberWithInteger:conversation.user.gender];
        localUser.password = conversation.user.password;
        localUser.email = conversation.user.email;
        localUser.phone = conversation.user.phone;
        localUser.portrait = conversation.user.portrait;
        //localUser.id = user.id;
        localUser.intro = conversation.user.intro;
        localUser.follows = [NSNumber numberWithInteger:conversation.user.follows];
        localUser.tweets = [NSNumber numberWithInteger:conversation.user.tweets];
        localUser.rtckey = conversation.user.rtcKey;
        localUser.address = conversation.user.address;
        localUser.telephone = conversation.user.telephone;
        localUser.companyName = conversation.user.companyName;
        localUser.sumMoney = conversation.user.sumMoney;
        
        localUser.conversatiponShip = localconversation;
        
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

-(void)loadSqlite
{
    [self.arrConversations removeAllObjects];
    
    NSArray * array = [NSArray array];
    if (!self.partnerKeyWord) {
        array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    }else{
        NSMutableArray * mutarray = [NSMutableArray array];
        
        NSArray * bigArray  =  [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]];
        
        for (LocalConversation * localConversation in bigArray) {
            for (NSDictionary * dic in localConversation.messages) {
                SMChatMessage * message = [SMChatMessage mj_objectWithKeyValues:dic];
                if ([message.text rangeOfString:self.partnerKeyWord].location != NSNotFound) {
                    //如果有这一条记录 则加载到数组中   //排除有两次出现同样的聊天记录
                    NSInteger i=0;
                    for (i=0 ;i<mutarray.count;i++) {
                        LocalConversation * conversation1 = mutarray[i];
                        if (conversation1 == localConversation) {
                            //有了 返回
                            break;
                        }
                    }
                    //如果没找到 就直接加入进去
                    if (i==mutarray.count) {
                        [mutarray addObject:localConversation];
                    }
                    
                }
            }
        }
        array = [mutarray copy];
    }
    
    NSInteger badge = 0;
    for (LocalConversation * localconVersation in array) {
        badge = badge+localconVersation.unread.integerValue;
    }
    
    if (badge>0) {
        [self.titleView showLeftSpot];
    }else{
        [self.titleView hiddenLeftSpot];
    }
    
    if (array.count>0) {
        for (LocalConversation * localconversation in array) {
            SMConversation * conversation = [SMConversation new];
            conversation.iconStr = localconversation.iconStr;
            conversation.name = localconversation.name;
            conversation.time = localconversation.time;
            conversation.userID = localconversation.userID;
            conversation.lastMessage = localconversation.lastMessage;
            conversation.unix = localconversation.unix.doubleValue;
            conversation.unread = localconversation.unread;
            if (self.partnerKeyWord) {
                for (NSDictionary  * dic in localconversation.messages) {
                    SMChatMessage * message = [SMChatMessage mj_objectWithKeyValues:dic];
                    if ([message.text rangeOfString:self.partnerKeyWord].location != NSNotFound) {
                        //如果相等  找到时间  //
                        conversation.time = message.time;
                        conversation.lastMessage = message.text;
                    }
                }
            }
            
            LocalUser1 * localUser = [localconversation.user anyObject];
            
            User * user = [User new];
            user.userid = localUser.userid;
            user.name = localUser.name;
            user.gender = localUser.gender.integerValue;
            user.password = localUser.password;
            user.email = localUser.email;
            user.phone = localUser.phone;
            user.portrait = localUser.portrait;
            //localUser.id = user.id;
            user.intro = localUser.intro;
            user.follows = localUser.follows.integerValue;
            user.tweets = localUser.tweets.integerValue;
            user.rtcKey = localUser.rtckey;
            user.address = localUser.address;
            user.telephone = localUser.telephone;
            user.companyName = localUser.companyName;
            user.sumMoney = localUser.sumMoney;
            
            conversation.user = user;
            
            [self.arrConversations addObject:conversation];
            
            //[self.communicateTableView reloadData];
        }
        
        for (int i = 0; i<[self.arrConversations count]; i++)
        {
            for (int j=i+1; j<[self.arrConversations count]; j++)
            {
                SMConversation * a = [self.arrConversations objectAtIndex:i] ;
                
                SMConversation * b = [self.arrConversations objectAtIndex:j] ;
                
                if (a.unix < b.unix)
                {
                    [self.arrConversations replaceObjectAtIndex:i withObject:b];
                    [self.arrConversations replaceObjectAtIndex:j withObject:a];
                }
                
            }
            
        }
        
        [self.communicateTableView reloadData];
        
        for (SMConversation * c in self.arrConversations) {
            SMLog(@"loadSqlite =   %lf ",c.unix);
        }
        
    }else
    {
        //[self requestData];
    }
}

#pragma mark - 执行搜索联系人  以及  历史记录
-(void)searchPartner{
    
}

/**
 *  当提交一个编辑操作的时候调用
 *  只要实现了这个方法，那么向左滑动就会出现删除按钮，
 *  只有点击了删除按钮才会调用该方法
 *  @param editingStyle 编辑操作
 UITableViewCellEditingStyleDelete, 删除
 UITableViewCellEditingStyleInsert  插入
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.communicateTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
            if (indexPath.row == 0) {
                
            }else{
                NSArray * array = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"0" inContext:[NSManagedObjectContext MR_defaultContext]];
                
                for (LocalConversation * conversation in array) {
                    if ([conversation.userID isEqualToString:[self.arrConversations[indexPath.row-1] userID]]) {
                        
                        
                        [conversation MR_deleteEntity];
                        
                        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    }
                }
                // 删除数组中对应的模型
                [self.arrConversations removeObjectAtIndex:indexPath.row];
                
                [self.communicateTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
           
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.communicateTableView) {
        if (indexPath.row == 0 ) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}
/**
 *  告诉tableView第indexPath行要执行怎么操作
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.communicateTableView) {
        if(tableView.editing) { // 插入操作
            return UITableViewCellEditingStyleInsert;
        }
        // 删除操作
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.communicateTableView) {
        return @"删除";
    }
    return nil;
    
}

//截取首字母
-(NSString *)transformCharacter:(NSString*)sourceStr
{
    //先将原字符串转换为可变字符串
    NSMutableString *ms = [NSMutableString stringWithString:sourceStr];
    
    if (ms.length) {
        //将汉字转换为拼音
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformToLatin, NO);
        //将拼音的声调去掉
        CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics,NO);
        //将字符串所有字母大写
        NSString *upStr = [ms uppercaseString];
        //截取首字母
        NSString *firstStr = [upStr substringToIndex:1];
        return firstStr;
    }
    return @"?";
}
@end
