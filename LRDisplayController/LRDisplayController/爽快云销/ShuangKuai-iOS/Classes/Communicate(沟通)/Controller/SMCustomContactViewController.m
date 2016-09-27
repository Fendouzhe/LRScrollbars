//
//  SMCustomContactViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomContactViewController.h"
#import "SMCommunicateTableViewCell.h"
#import "SMChatViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SMSearchViewController.h"
#import "AppDelegate.h"
#import "SMConversation.h"
#import "SMChatMessage.h"
#import "SMChatMessageFrame.h"
#import "LocalConversation.h"
#import "LocalUser1.h"
#import "LocalChatMessageFrame.h"
#import "LocalChatMessage.h"

@interface SMCustomContactViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy)NSMutableArray * arrConversations;

@end

@implementation SMCustomContactViewController

//懒加载
-(NSMutableArray *)arrConversations{
    if (!_arrConversations) {
        _arrConversations = [NSMutableArray array];
    }
    return _arrConversations;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    [self loadSqlite];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    //接收到通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveConversation:) name:KChatVcDisappearNotCustom object:nil];
    
    
}

- (void)setup{
    self.title = @"客服连线";
    self.topView.backgroundColor = KControllerBackGroundColor;
    
    // 放大镜
//    UIImageView *searchIcon = [[UIImageView alloc] init];
//    searchIcon.image = [UIImage imageNamed:@"放大镜"];
//    searchIcon.width = 28;
//    searchIcon.height = 28;
//    searchIcon.contentMode = UIViewContentModeCenter;
//    self.searchField.leftView = searchIcon;
//    self.searchField.leftViewMode = UITextFieldViewModeAlways;
////    self.searchField.keyboardType = UIKeyboardTypeWebSearch;
//    self.searchField.delegate = self;
//    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
   
    if (!self.isSearchCustomer) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightClick) image:@"产品库(fangdajing)" highImage:@"产品库(fangdajing)"];
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)rightClick{
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 7;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)recieveConversation:(NSNotification *)not{
    SMLog(@"recieveConversation     KChatVcDisappearNot");
    User * user = [User new];
    AVIMConversation *imConversation = not.userInfo[KChatVcDisappearNotUserKey];
    self.conversation = imConversation;
    SMChatMessageFrame *messageF = not.userInfo[KChatVcDisappearNotLastMessageKey];
    SMConversation *conversation = [[SMConversation alloc] init];
    conversation.iconStr = user.portrait;
    //自己作为名字
    conversation.name = conversation.clientId;
    conversation.userID = user.userid;
    conversation.user = user;
    conversation.lastMessage = messageF.messgae.text;
    conversation.time = messageF.messgae.time;
    conversation.unix = messageF.messgae.unix;
    conversation.clientId = messageF.messgae.OtherClientId;
    conversation.conversationId = imConversation.conversationId;
    conversation.isOther = messageF.messgae.type;
    conversation.pid = messageF.messgae.pid;
    
    SMLog(@"ClientId =      %@",messageF.messgae.OtherClientId);
    
    SMLog(@"user.name  recieveConversation  %@",user.name);
    
    for (SMConversation *c in self.arrConversations) {//
        if ([conversation.clientId isEqualToString:c.clientId]) {
            if (c.unix < conversation.unix) {
                c.lastMessage = conversation.lastMessage;
                c.unix = conversation.unix;
                c.time = conversation.time;
                if (conversation.isOther) {
                   c.unread = [NSString stringWithFormat:@"%ld",c.unread.integerValue+1]; 
                }
                
            }
            
            //排序刷新
            [self sequence];
            
            [self updateSqliteWith:conversation];
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
    
    [self.arrConversations addObject:conversation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
    //SMLog(@"self.arrConversations.count  %zd",self.arrConversations.count);
    
    //排序刷新
    [self sequence];
    
    //[self.communicateTableView reloadData];
}

-(void)receiveConversationWithUser:(User *)user andChatMessgaeFrame:(SMChatMessageFrame *)messageF
{
    SMLog(@"ClientId =      %@",messageF.messgae.OtherClientId);
    SMConversation *conversation = [[SMConversation alloc] init];
    conversation.iconStr = user.portrait;
    conversation.name = user.name;
    conversation.userID = user.userid;
    conversation.user = user;
    conversation.lastMessage = messageF.messgae.text;
    conversation.time = messageF.messgae.time;
    conversation.unix = messageF.messgae.unix;
    conversation.clientId = messageF.messgae.OtherClientId;
    conversation.conversationId = self.conversation.conversationId;
    conversation.pid = messageF.messgae.pid;
    
    conversation.isOther = messageF.messgae.type;
    
    SMLog(@"user.name  recieveConversation  %@",user.name);

 
    NSArray * localArray = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1"];
        
    for (LocalConversation *c in localArray) {//
        if ([c.clientId isEqualToString:conversation.clientId]) {
            //c.lastMessage = conversation.lastMessage;
            [self updateSqliteWith:conversation];
            
            //排序刷新
            [self sequence];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
            //[self.communicateTableView reloadData];
            return;
        }
    }
 
    
    //判断是否已经存在  更新  也可以重新存
    [self saveSqliteWith:conversation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PartnerBadgeRefresh" object:nil];
    SMLog(@"self.arrConversations.count  %zd",self.arrConversations.count);
    
    //排序刷新
    //[self sequence];
    
}

//排序
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
    
    [self.tableView reloadData];
    
}

//保存
-(void)saveSqliteWith:(SMConversation *)conversation{
    
    //判断是否更新
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        LocalConversation * localconversation = [LocalConversation MR_createEntityInContext:localContext];
        localconversation.iconStr = conversation.iconStr;
        localconversation.name = conversation.name;
        localconversation.userID = conversation.userID;
        localconversation.lastMessage = conversation.lastMessage;
        localconversation.time = conversation.time;
        localconversation.unix = [NSNumber numberWithDouble:conversation.unix];
        localconversation.isCustomer = [NSNumber numberWithBool:YES];
        localconversation.clientId = conversation.clientId;
        localconversation.conversationId = conversation.conversationId;
        localconversation.messages = [NSMutableArray array];
        localconversation.pid = conversation.pid;
        if (conversation.isOther) {
            localconversation.unread = [NSString stringWithFormat:@"%d",1];
        }
        
        //存消息的数组
        //创建消息体  保存到数组中
        SMChatMessage * message = [SMChatMessage new];
        message.time = conversation.time;
        message.text = conversation.lastMessage;
        message.OtherClientId = conversation.clientId;
        message.conversationId = conversation.conversationId;
        
        //转成字典存储
        NSDictionary * dic = [message mj_JSONObject];
        
        [localconversation.messages addObject:dic];
        
        SMLog(@"save = ==     %@",localconversation.unix);
        
        LocalUser1 * localUser = [LocalUser1 MR_createEntityInContext:localContext];
        
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
        
    }];
    
}

//更新
-(void)updateSqliteWith:(SMConversation *)conversation
{

    
    NSArray * array = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalConversation * localConversation in array) {
        if ([localConversation.clientId isEqualToString:conversation.clientId]) {
            //更新
            localConversation.lastMessage = conversation.lastMessage;
            
            //保存新的消息
            
            //创建消息体  保存到数组中
            SMChatMessage * message = [SMChatMessage new];
            message.time = conversation.time;
            message.text = conversation.lastMessage;
            message.OtherClientId = conversation.clientId;
            message.conversationId = conversation.conversationId;
            message.pid = conversation.pid;
            
            if (conversation.isOther) {
                localConversation.unread = [NSString stringWithFormat:@"%ld",localConversation.unread.integerValue+1];
            }
            
            
            //转成字典存储
            NSDictionary * dic = [message mj_JSONObject];
            
            [localConversation.messages addObject:dic];
            
            
            localConversation.iconStr = conversation.iconStr;
            localConversation.name = conversation.name;
            localConversation.conversationId  = self.conversation.conversationId;
            if (localConversation.unix.doubleValue < conversation.unix) {
                localConversation.time = conversation.time;
                localConversation.unix = [NSNumber numberWithDouble:conversation.unix];
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            return;
        }
    }
}

//读取
-(void)loadSqlite
{
    [self.arrConversations removeAllObjects];
    
   
    
    NSArray * array = [NSArray array];
    if (!self.customerKeyWord) {
        array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    }else{
        NSMutableArray * mutarray = [NSMutableArray array];
        
        NSArray * bigArray  =  [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]];
        
        for (LocalConversation * localConversation in bigArray) {
            for (NSDictionary * dic in localConversation.messages) {
                SMChatMessage * message = [SMChatMessage mj_objectWithKeyValues:dic];
                if ([message.text rangeOfString:self.customerKeyWord].location != NSNotFound) {
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
    if (array.count>0) {
        for (LocalConversation * localconversation in array) {
            SMConversation * conversation = [SMConversation new];
            conversation.iconStr = localconversation.iconStr;
            conversation.name = localconversation.name;
            conversation.time = localconversation.time;
            conversation.userID = localconversation.userID;
            conversation.lastMessage = localconversation.lastMessage;
            conversation.unix = localconversation.unix.doubleValue;
            conversation.clientId = localconversation.clientId;
            conversation.conversationId = localconversation.conversationId;
            conversation.unread = localconversation.unread;
            conversation.pid = localconversation.pid;
            LocalUser1 * localUser = [localconversation.user anyObject];
            
            if (self.customerKeyWord) {
                for (NSDictionary  * dic in localconversation.messages) {
                    SMChatMessage * message = [SMChatMessage mj_objectWithKeyValues:dic];
                    if ([message.text rangeOfString:self.customerKeyWord].location != NSNotFound) {
                        //如果相等  找到时间  //
                        conversation.time = message.time;
                        conversation.lastMessage = message.text;
                    }
                }
            }
            
             
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
        
        [self.tableView reloadData];
        
        for (SMConversation * c in self.arrConversations) {
            SMLog(@"loadSqlite =   %lf ",c.unix);
        }
        
    }else
    {
        //[self requestData];
    }
}

//  保存接到的消息记录

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //暂时没有数据
    return self.arrConversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCommunicateTableViewCell *cell = [SMCommunicateTableViewCell cellWithTableView:tableView];
    cell.conversation = self.arrConversations[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 64;
    }else if (isIPhone6){
        height = 64 *KMatch6;
    }else if (isIPhone6p){
        height = 64 *KMatch6p;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMChatViewController *chatVc = [[SMChatViewController alloc] init];
    chatVc.isCustomer = YES;
    User * user = [User new];
    //获取点击clientId
    user.rtcKey = [self.arrConversations[indexPath.row] clientId];
    user.name =[[self.arrConversations[indexPath.row] clientId] substringWithRange:NSMakeRange(20, [self.arrConversations[indexPath.row] clientId].length-20)];
    SMLog(@"ClientId =      %@",[self.arrConversations[indexPath.row] clientId]);
    chatVc.user  = user;
    chatVc.targetRtcKey = user.rtcKey;
    SMConversation * smcon = self.arrConversations[indexPath.row];
    chatVc.conversationId = smcon.conversationId;
    chatVc.pid = smcon.pid;
    smcon.unread = [NSString stringWithFormat:@"%d",0];
    [self.tableView reloadData];
    
    //点击进去  清空未读
    NSArray * array = [[LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]] copy];
    
    
    for (LocalConversation * localConversation in array) {
        if ([localConversation.clientId isEqualToString:[smcon clientId]]) {
            //找到这个  然后更新为0
            localConversation.unread = [NSString stringWithFormat:@"%d",0];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }
    [self.navigationController pushViewController:chatVc animated:YES];
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
    if (tableView == self.tableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
            NSArray * array = [LocalConversation MR_findByAttribute:@"isCustomer" withValue:@"1" inContext:[NSManagedObjectContext MR_defaultContext]];
            
            for (LocalConversation * conversation in array) {
                if ([conversation.clientId isEqualToString:[self.arrConversations[indexPath.row] clientId]]) {
                    
                    [conversation MR_deleteEntity];
                    
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
            // 删除数组中对应的模型
            [self.arrConversations removeObjectAtIndex:indexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        }
    }
}

/**
 *  告诉tableView第indexPath行要执行怎么操作
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(tableView.editing) { // 插入操作
        return UITableViewCellEditingStyleInsert;
    }
        // 删除操作
    return UITableViewCellEditingStyleDelete;

   
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchField resignFirstResponder];
}
#pragma mark -- 在这里接着写点击cell 跳进去的界面

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.searchField resignFirstResponder];
        
    }
    return YES;
}


-(void)dealloc{
    SMLog(@"customer     dealloc");
}
@end
