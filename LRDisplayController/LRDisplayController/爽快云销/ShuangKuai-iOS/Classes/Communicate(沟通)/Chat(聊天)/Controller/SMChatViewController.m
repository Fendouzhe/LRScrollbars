//
//  SMChatViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMChatViewController.h"
#import "SMChatMessage.h"
#import "SMChatMessageFrame.h"
#import "SMChatTableViewCell.h"
#import <AVIMClient.h>
#import <AVIMTextMessage.h>
#import <AVIMConversation.h>
#import <AVIMConversationQuery.h>
#import "LocalChatMessageFrame.h"
#import "LocalChatMessage.h"
#import "AppDelegate.h"
#import "LocalConversation.h"
#import "SMPartnerConnectViewController.h"
#import "SMProductDetailController.h"

@interface SMChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVIMClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatTableViewTopConstraint;

/**
 *  frames模型数组
 */
@property(nonatomic,strong) NSMutableArray *messageFrames;
/**
 *  leancloud需要的key
 */
@property (nonatomic ,copy)NSString *myRtcKey;



/**
 *  发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

/**
 *  拉取历史记录的page
 */
@property (nonatomic,assign)NSInteger page;

@property (nonatomic,copy)NSMutableArray * historyArray;


//产品的控件
@property (nonatomic,strong)UIImageView * productImage;

@property (nonatomic,strong)UILabel * productNameLabel;

@property(nonatomic,strong)UILabel * productMoneyLabel;

@property(nonatomic,strong)Product * product;

@property (nonatomic ,strong)SMChatTableViewCell *lastCell;

@end

@implementation SMChatViewController

// 声明一个重用标示
static NSString *ID = @"message";



#pragma mark -- 懒加载

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
- (NSMutableArray *)messageFrames {
    if (_messageFrames == nil) {
        //_messageFrames = [SMChatMessageFrame messageFrames];
        _messageFrames = [NSMutableArray array];

    }
    return _messageFrames;
}
-(NSString *)pid{
    if (!_pid) {
        _pid = [NSString string];
    }
    return _pid;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //SMLog(@"viewWill  = %@",self.messageFrames);
    
    SMLog(@"viewWill = %p", self.chatTableView);
    
    
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.targetRtcKey = @"shuangkuai-customer-21a250c95e2fbf44e5fe8f53369ad6332b5459cd";
    
    //self.messageFrames = [NSMutableArray array];
    
    SMLog(@"targetRtckey  viewDidLoad  %@",self.targetRtcKey);
    
    [self setup];
    
    [self scrollToLastRow];
    
    [self ViewGoUp];
    
    [self setupConversation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTypedMessage:) name:@"didReceiveTypedMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"KReceiveMessage" object:nil];
    
    AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    self.client = appdelegate.client;
    
    [self setupDownMore];
    
    SMLog(@"ClientId =      %@",self.targetRtcKey);
    
}

- (void)receiveTypedMessage:(NSNotification *)not{
    
    AVIMTypedMessage *message = not.userInfo[@"message"];
    
    SMLog(@"message.clientId    %@   self.targetRtcKey  %@",message.clientId,self.targetRtcKey);
    if ([message.clientId isEqualToString:self.targetRtcKey]) {
        [self refreshChatTableViewWithMessage:message];
    }
    
    SMLog(@"hahah      %@,       %@",message.clientId,self.targetRtcKey);
}

- (void)setupConversation{
    /*** 通过自己的useID 拿到自己的 rtcKey  (uuid前面加前缀 )***/
    NSString *useID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    SMLog(@"useID  %@",useID);
    [[SKAPI shared] queryUserProfile:useID block:^(id result, NSError *error) {
        if (!error) {
            User *user = (User *)result;
            self.myRtcKey = user.rtcKey; //拿到 rtcKey；
            SMLog(@"self.myRtcKey   %@",self.myRtcKey);
            
            // Jerry 用自己的名字作为 ClientId 打开了 client
            
            //接收
            //self.client = [[AVIMClient alloc] initWithClientId:self.myRtcKey];
            // 设置 client 的 delegate，并实现 delegate 方法
            //self.client.delegate = self;
                        
            SMLog(@"chat2 = %p",self.client);
            
            //[self.client openWithClientId:self.myRtcKey callback:^(BOOL succeeded, NSError *error) {
                //if (succeeded) {
                    NSString *myName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
                    NSString * reckey = self.targetRtcKey;
                    
                    if (self.isCustomer) {
                        NSString * string = [self.targetRtcKey substringWithRange:NSMakeRange(20, self.targetRtcKey.length-20)];
                        reckey = [NSString stringWithFormat:@"Sales-%@",string];
                    }
                    
                    //创建原子对话
                    SMLog(@"self.targetRtcKey 创建原子对话  %@",self.targetRtcKey);
                    [self.client createConversationWithName:myName clientIds:@[reckey] attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                        
                        
                        if (!error) {
                            /**
                             *  判断会话Id
                             */
                            NSString * conId ;
                            if (self.isCustomer) {
                                conId = self.conversationId;
                            }else{
                                conId = conversation.conversationId;
                            }
                            
                            SMLog(@"self.conversation.conversationId   ,%@",self.conversation.conversationId);
                            
                            //查询这个会话id 里面的最近10条记录（发送和接受的）
                                // Tom 创建查询会话的 query
                                AVIMConversationQuery *query = [self.client conversationQuery];
                                // Tom 获取 id 为 2f08e882f2a11ef07902eeb510d4223b 的会话
                                [query getConversationById:conId callback:^(AVIMConversation *conversation, NSError *error) {
                                    // 查询对话中最后 10 条消息
                                    self.conversation = conversation;
                                    [conversation queryMessagesWithLimit:10 callback:^(NSArray *objects, NSError *error) {
                                        SMLog(@"查询成功！");
                                        
                                        SMLog(@"%zd",objects.count);
                                        for (AVIMTextMessage *m in objects) {
                                            
                                            //记录到mesaage  用于历史记录查询
                                            [self.historyArray addObject:m];
                                            
                                            SMLog(@"m.text  send  %@  m.conversationId  %@  m.clientId  %@",m.text,m.conversationId,m.clientId);
                                            //在这里判断是谁发出的消息，消息内容是什么。
                                            //先拿到发消息人的userId
                                            NSString *userID = [[m.clientId componentsSeparatedByString:@"shuangkuai-sales-"] lastObject];
                                            //如果userID和自己的userID是一样，则是自己发的
                                            
                                            SMChatMessage *message = [[SMChatMessage alloc] init];
                                            message.text = m.text;
                                            message.OtherClientId = self.targetRtcKey;
                                            message.unix = m.sendTimestamp;
                                            SMLog(@"m.sendTimestamp  %lld",m.sendTimestamp);
                                            if ([userID isEqualToString:useID]) {//是自己发的
                                                SMLog(@"自己发的");
                                                message.type = HMMessageTypeMe;
                                                //拿到时间
                                                NSString *time = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",m.sendTimestamp / 1000]];
                                                message.time = time;
                                            }else{//别人发的
                                                SMLog(@"别人发的");
                                                message.type = HMMessageTypeOther;
                                                //拿到时间
                                                NSString *time = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",m.sendTimestamp / 1000]];
                                                message.time = time;
                                            }
                                            SMChatMessageFrame *messageF = [[SMChatMessageFrame alloc] init];
                                            messageF.messgae = message;
                                            [self.messageFrames addObject:messageF];
                                        }
                                        [self.chatTableView reloadData];
                                        [self scrollToLastRow];
                                        
//                                        [self loadMoreMessage:objects forConversation:conversation];
//                                        [self loadMoreMessage:objects forConversation:conversation];
                                    }];
                                }];
                            
                        }else{
                            SMLog(@"error   %@",error);
                        }
                        
                    }];
//                }else{
//                    SMLog(@"error  %@",error);
//                }
            //}];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

-(void)setupDownMore{
    //拉取更多消息
    
    MJRefreshStateHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMoreMessage:self.historyArray forConversation:self.conversation];
    }];
    //header.stateLabel.text = @"下拉加载更多历史消息";
    header.lastUpdatedTimeLabel.hidden = YES;
    self.chatTableView.mj_header = header;
    [header setTitle:@"下拉加载历史消息" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新历史消息" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载历史消息" forState:MJRefreshStateRefreshing];
}



//查看更多历史消息
- (void)loadMoreMessage:(NSArray *)messages forConversation:(AVIMConversation *)conversation {
    
    NSString *useID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    SMLog(@"useID  %@",useID);
    //[self.historyArray removeAllObjects];
    //用来存储查询出来的
    NSMutableArray * historyArr = [NSMutableArray array];
    
    AVIMMessage *oldestMessage = [messages firstObject];
    SMLog(@"firstTime = %lld",oldestMessage.sendTimestamp);
    
    [conversation queryMessagesBeforeId:oldestMessage.messageId timestamp:oldestMessage.sendTimestamp limit:10 callback:^(NSArray *objects, NSError *error) {
        SMLog(@"查询成功！");
        [self.historyArray removeAllObjects];
        for (AVIMTextMessage *m in objects) {
            SMLog(@"m.text  send  %@  m.conversationId  %@  m.clientId  %@",m.text,m.conversationId,m.clientId);
            //在这里判断是谁发出的消息，消息内容是什么。
            //先拿到发消息人的userId
            NSString *userID = [[m.clientId componentsSeparatedByString:@"sales-"] lastObject];
            //如果userID和自己的userID是一样，则是自己发的
           
            SMChatMessage *message = [[SMChatMessage alloc] init];
            message.text = m.text;
            message.unix = m.sendTimestamp;
            SMLog(@"m.sendTimestamp  %lld",m.sendTimestamp);
            if ([userID isEqualToString:useID]) {//是自己发的
                SMLog(@"自己发的");
                message.type = HMMessageTypeMe;
                //拿到时间
                NSString *time = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",m.sendTimestamp / 1000]];
                message.time = time;
            }else{//别人发的
                SMLog(@"别人发的");
                message.type = HMMessageTypeOther;
                //拿到时间
                NSString *time = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",m.sendTimestamp / 1000]];
                message.time = time;
            }
            SMChatMessageFrame *messageF = [[SMChatMessageFrame alloc] init];
            messageF.messgae = message;
            //加到数组前面  然后刷新tableview
            //判断是否添加
            [historyArr addObject:messageF];
            
            [self.historyArray addObject:m];
        }
        
        CGFloat height = 0;
        for (NSInteger i=historyArr.count-1; i>=0;i-- ) {
            SMChatMessageFrame * messageF = historyArr[i];
            SMLog(@"%lf,%lf",messageF.messgae.unix,[[[self.messageFrames firstObject] messgae] unix]);
            if ([[[self.messageFrames firstObject] messgae] unix] > messageF.messgae.unix) {
                [self.messageFrames insertObject:messageF atIndex:0];
                
                height = messageF.cellHeight+height;
                //计算tableview 的高度
                self.chatTableView.contentOffset = CGPointMake(0,height-44);
                
            }else{
                
                //没有了  执行代码
                SMLog(@"没有聊天记录了");
                
            }
        }
        [self.chatTableView reloadData];
        
        [self.chatTableView.mj_header endRefreshing];
    }];
    
}

//通过时间戳拿到时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"MM-dd HH:mm"];
    return [objDateformat stringFromDate: date];
}

- (void)ViewGoUp{
    CGPoint point = self.chatTableView.contentOffset;
    point.y += 44;
    self.chatTableView.contentOffset = point;
}

/**
 *  显示到tableView的最后一行
 */
- (void)scrollToLastRow{
    NSUInteger sectionCount = [self.chatTableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [self.chatTableView numberOfRowsInSection:0];
        
        if (rowCount) {
            
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            
            [self.chatTableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

- (void)setup{
    
    self.title = self.user.name;
    self.inputField.delegate = self;
    self.inputField.returnKeyType = UIReturnKeySend;
    self.inputField.enablesReturnKeyAutomatically = YES;
    // 监听键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    // 设置文本输入框左边显示view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    //    leftView.backgroundColor = [UIColor redColor];
    self.inputField.leftView = leftView;
    // 设置左边view的模式：一直出现
    self.inputField.leftViewMode = UITextFieldViewModeAlways;
    
    // 设置tableView的背景颜色
    
    self.chatTableView.backgroundColor = [UIColor colorWithRed:239 / 255.0f green:239 / 255.0f blue:239 / 255.0f alpha:1.0];
    // 隐藏分割线
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 隐藏垂直滚动条
    self.chatTableView.showsVerticalScrollIndicator = NO;
    // 设置tableView不允许选中
    self.chatTableView.allowsSelection = NO;
    
    // 注册cell
    [self.chatTableView registerClass:[SMChatTableViewCell class] forCellReuseIdentifier:ID];
    
    self.sendBtn.layer.cornerRadius = SMCornerRadios;
    self.sendBtn.clipsToBounds = YES;
    [self.sendBtn setBackgroundColor:KRedColor];
    
    SMLog(@"pid     =   %@",self.pid);
    if (self.isCustomer  && ![self.pid isEqualToString:@""]) {
        
        self.chatTableViewTopConstraint.constant = 80;
        UIView * salesProduct = [[UIView alloc]init];
        salesProduct.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:salesProduct];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [salesProduct addGestureRecognizer:tap];
        [salesProduct mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.height.with.offset(80);
        }];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        self.productImage = imageView;
        imageView.image = [UIImage imageNamed:@"dog"];
        [salesProduct addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(salesProduct.mas_left).with.offset(10);
            make.centerY.equalTo(salesProduct.mas_centerY).with.offset(0);
            make.height.with.offset(60);
            make.width.with.offset(60);
        }];
        
        UILabel * nameLabel = [[UILabel alloc]init];
        self.productNameLabel = nameLabel;
        nameLabel.text = @"中国电信100M光纤宽带";
        nameLabel.font = KDefaultFontBig;
        [salesProduct addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.offset(10);
            make.top.equalTo(imageView.mas_top).with.offset(8);
        }];
        
        UILabel * moneyLabel = [[UILabel alloc]init];
        self.productMoneyLabel = moneyLabel;
        moneyLabel.text = @"￥1980";
        moneyLabel.font = KDefaultFontBig;
        moneyLabel.textColor = KRedColorLight;
        [salesProduct addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.offset(10);
            make.top.equalTo(nameLabel.mas_bottom).with.offset(8);
        }];
        
        
        SMLog(@"pid = =  %@",self.pid);
        [self requestProductData];
    }
}
-(void)tapClick{
    SMLog(@"hahah");
    
    SMProductDetailController * detail = [SMProductDetailController new];
    detail.product = self.product;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)requestProductData{
    //获取到pid
    if (![self.pid isEqualToString:@""]) {
        [[SKAPI shared] queryProductById:self.pid block:^(Product *product, NSError *error) {
            if (!error) {
                SMLog(@"%@",product);
                NSString *imageStr =  [NSString mj_objectArrayWithKeyValuesArray:product.imagePath].firstObject;
//                NSString *imageStrAppen = [imageStr stringByAppendingString:[NSString stringWithFormat:@"?w=%f&h=%f&q=60",60.0 *2,60.0 *2]];
                
                [self.productImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached progress:nil completed:nil];
                self.productNameLabel.text = product.name;
                self.productMoneyLabel.text = [NSString stringWithFormat:@"￥%@",product.finalPrice];
                self.product = product;
            }else{
                SMLog(@"%@",error);
            }
        }];
    }
}
/**
 *  用来监听键盘的弹出/隐藏
 */
-(void)keyboardWillChange:(NSNotification *)note{
    
//    for (SMChatMessageFrame *msg in self.messageFrames) {
//        
//        SMLog(@"msg.messgae.text  %@   ,msg.textBtnF.origin.y   %f",msg.messgae.text,msg.textBtnF.origin.y);
//        CGRect rect = [self.lastCell convertRect:msg.textBtnF toView:self.view];
//        SMLog(@"rect.origin.y   %f",rect.origin.y);
//    }
//    
    
    
    SMChatMessageFrame *msg = self.messageFrames.lastObject;
    SMLog(@"self.messageFrames.lastObject    %@",msg.messgae.text);
    
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘弹出后或隐藏后的frame
    CGRect keyboardFrame =[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获得键盘的y值
    CGFloat keyboardY = keyboardFrame.origin.y;
    SMLog(@"keyboardY   %f",keyboardY);
    // 获得屏幕的高度
    CGFloat screenH =[UIScreen mainScreen].bounds.size.height;
    //
    //    SMLog(@"note = %@",note);
    // 获得键盘执行动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    /*
     [UIView animateWithDuration:duration animations:^{
     self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
     }];
     */
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
    } completion:nil];
    
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    SMLog(@"self.messageFrames.count  %zd",self.messageFrames.count);
    
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 从缓存池获得cell
    SMChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.user = self.user;
    // 获得frame模型
    if (self.messageFrames.count>0) {
       SMChatMessageFrame *messageFrame = self.messageFrames[indexPath.row];
        cell.messageFrame = messageFrame;
    }
    if (indexPath.row == self.messageFrames.count - 1) {
        self.lastCell = cell;
    }
    // 传递数据
    return cell;
}

/**
 *  返回每一行的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获得frame模型
    SMChatMessageFrame *messageFrame = self.messageFrames[indexPath.row];
    CGFloat height = messageFrame.cellHeight;
    return height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 隐藏键盘
    //    [self.inputField resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark- 文本输入框的代理
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    // 获得数组中最后一个frame模型
//    SMChatMessageFrame *lastMessageFrame = [self.messageFrames lastObject];
//    SMChatMessage *lastMessage = lastMessageFrame.messgae;
//    // 获得最后一个消息模型对应时间
//    NSString *lastTime = lastMessage.time;
//    
//    // 获得用输入的内容
//    NSString *text = textField.text;
//    // 创建数据模型
//    SMChatMessage *message = [[SMChatMessage alloc] init];
//    message.text = text;
//    // 设置时间
//    // 获得当前时间
//    NSDate *nowDate = [NSDate date];
//    // 创建一个格式化时间对象
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置时间格式
//    // HH:mm 大写表示24小时  hh:mm 表示12小时
//    formatter.dateFormat = @"HH:mm";
//    // 将当前时间转换成字符串
//    NSString *time = [formatter stringFromDate:nowDate];
//    message.time = time;
//    message.type = HMMessageTypeMe;
//    // 设置是否显示或隐藏时间
//    message.hideTime = [lastTime isEqualToString:time];
//
//    // 创建frame模型
//    SMChatMessageFrame *messageFrame = [SMChatMessageFrame messageFrameWithMeassge:message];
//    // 将frame模型添加到数组中
//    [self.messageFrames addObject:messageFrame];
//    
//    // 刷新表格
//    [self.chatTableView reloadData];
//    
//    /**
//     > 在tableView插入一行数据
//     > 添加一个messageFrame模型到数组中
//     */
//    
//    //显示最后一行
//    [self scrollToLastRow];
//    self.inputField.text = nil;
//    return YES;
//}


- (IBAction)sendBtnClick {
    SMLog(@"点击了 输入框右边的 发送");
    [self sendMessageWithContent:self.inputField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        SMLog(@"点了发送");
        [self sendMessageWithContent:textField.text];
        
    }
    return YES;
}

- (void)sendMessageWithContent:(NSString *)content{
    
    SMLog(@"self.targetRtcKey   sendMessageWithContent  %@",self.targetRtcKey);
  
    if (![content isEqualToString:@""]) {
        
        // 获得数组中最后一个frame模型
        SMChatMessageFrame *lastMessageFrame = [self.messageFrames lastObject];
        SMLog(@"[self.messageFrames lastObject]   %@",self.messageFrames);
        SMChatMessage *lastMessage = lastMessageFrame.messgae;
        // 获得最后一个消息模型对应时间
        NSString *lastTime = lastMessage.time;
        
        // 获得用输入的内容
        NSString *text = self.inputField.text;
        
        // 创建数据模型
        SMChatMessage *message = [[SMChatMessage alloc] init];
        message.text = text;
        // 设置时间
        // 获得当前时间
        NSDate *nowDate = [NSDate date];
        
        NSTimeInterval timeDouble = [nowDate timeIntervalSince1970];
        SMLog(@"double =             %f",timeDouble);
        
        message.unix = timeDouble;
        // 创建一个格式化时间对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        // HH:mm 大写表示24小时  hh:mm 表示12小时
        formatter.dateFormat = @"HH:mm";
        // 将当前时间转换成字符串
        NSString *time = [formatter stringFromDate:nowDate];
        message.time = time;
        message.type = HMMessageTypeMe;
        // 设置是否显示或隐藏时间
        message.hideTime = [lastTime isEqualToString:time];
        
        message.OtherClientId = self.targetRtcKey;
        
        message.conversationId = self.conversation.conversationId;
        
        SMLog(@"ClientId =      %@",self.targetRtcKey);
        
        [self send];
        
        SMLog(@"......%lf",message.unix);
        // 创建frame模型
        SMChatMessageFrame *messageFrame = [SMChatMessageFrame messageFrameWithMeassge:message];
        //存起来
        //    [self saveSqliteWith:messageFrame];
        // 将frame模型添加到数组中
        [self.messageFrames addObject:messageFrame];
        
        // 刷新表格
        //
        
        SMLog(@"发送%p",self.chatTableView);
        /**
         > 在tableView插入一行数据
         > 添加一个messageFrame模型到数组中
         */
        [self.chatTableView reloadData];
        //显示最后一行
        [self scrollToLastRow];
    }
}

- (void)send{
    
    AVIMTextMessage * message = [AVIMTextMessage messageWithText:self.inputField.text attributes:nil];
    
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    if (self.user.name) {
//        // 避免为空造成崩溃
//        [attributes setObject:self.user.name forKey:@"username"];
//    }
//    
//        [attributes setObject:@YES forKey:@"dev"];
//    
//    if (message.attributes == nil) {
//        message.attributes = attributes;
//    } else {
//        [attributes addEntriesFromDictionary:message.attributes];
//        message.attributes = attributes;
//    }

    // 用自己的名字作为 ClientId 打开 client   self.myRtcKey
    if (![message.text isEqualToString:@""]) {
        if (self.myRtcKey) {
            [self.client openWithClientId:self.myRtcKey callback:^(BOOL succeeded, NSError *error) {
                
                [self.conversation sendMessage:message options:AVIMMessageSendOptionRequestReceipt callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        SMLog(@"发送成功！");
                        //创建消息模型
                        SMLog(@"ClientId =      %@",message.clientId);
                        self.inputField.text = nil;
                        //                SMLog(@"self.messageFrames  send  %@",self.messageFrames);
                        
                        for (SMChatMessageFrame *messageF in self.messageFrames) {
                            //SMLog(@"%p",self.messageFrames);
                            SMLog(@"messageF.messgae.text   send %@",messageF.messgae.text);
                        }
                        if (!self.isCustomer) {
                            //伙伴的消息
                            //                    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                            //                    dict1[KChatVcDisappearNotUserKey] = self.user;
                            //                    dict1[KChatVcDisappearNotLastMessageKey] = [self.messageFrames lastObject]; //最后一条消息
                            //                    [[NSNotificationCenter defaultCenter] postNotificationName:KChatVcDisappearNot object:self userInfo:dict1];
                            SMPartnerConnectViewController * Vc = [SMPartnerConnectViewController new];
                            
                            [Vc receiveConversationWithUser:self.user andChatMessgaeFrame:[self.messageFrames lastObject]];
                        }else{
                            //客服的消息
                            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                            dict1[KChatVcDisappearNotUserKey] = self.conversation;
                            dict1[KChatVcDisappearNotLastMessageKey] = [self.messageFrames lastObject]; //最后一条消息
                            [[NSNotificationCenter defaultCenter] postNotificationName:KChatVcDisappearNotCustom object:self userInfo:dict1];
                        }
                        
                        //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"KReceiveMessage" object:nil];
                        
                    }else{
                        SMLog(@"发送失败");
                    }
                }];
            }];

        }
    }
}

#pragma mark -- AVIMClientDelegate
// 接收消息的回调函数
//- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message  {
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"message"] = message;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveTypedMessage" object:self userInfo:dict];
//    
//    SMLog(@"爽快  didReceiveTypedMessage  %@ ", message.text);
//    
//    
////    //搞一个本地通知
//    //[self reateNotificateWithMessage:message];
//}

//监听消息送达
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    SMLog(@"%@", @"消息已送达。"); // 打印消息
}

- (void)reateNotificateWithMessage:(AVIMTypedMessage *)message{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置重复间隔
    //notification.repeatInterval = kCFCalendarUnitDay;
    notification.repeatInterval = 0;
    // 设置提醒的文字内容
    notification.alertBody  = message.text;
    //notification.alertAction = NSLocalizedString(self.inputTextField.text, nil);
    
    // 通知提示音 使用默认的
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 设置应用程序右上角的提醒个数
    //notification.applicationIconBadgeNumber = 0;
    
    //这里添加识别
    // 设定通知的userInfo，用来标识该通知
    NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
    aUserInfo[@"newMessage"] = message.text;
    notification.userInfo = aUserInfo;
    
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)refreshChatTableViewWithMessage:(AVIMTypedMessage *)message{
    // 创建数据模型
    SMChatMessage *messageRec = [[SMChatMessage alloc] init];
    
    messageRec.text = message.text;
    // 设置时间
    // 获得当前时间
    NSDate *nowDate = [NSDate date];
    // 创建一个格式化时间对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    // HH:mm 大写表示24小时  hh:mm 表示12小时
    formatter.dateFormat = @"HH:mm";
    // 将当前时间转换成字符串
    NSString *time = [formatter stringFromDate:nowDate];
    messageRec.time = time;
    messageRec.type = HMMessageTypeOther;
    messageRec.unix = [nowDate timeIntervalSince1970];
    messageRec.OtherClientId  = message.clientId;
    
    SMChatMessageFrame *lastMessageFrame = [self.messageFrames lastObject];
    SMChatMessage *lastMessage = lastMessageFrame.messgae;
    // 获得最后一个消息模型对应时间   0000
    NSString *lastTime = lastMessage.time;
    // 设置是否显示或隐藏时间
    messageRec.hideTime = [lastTime isEqualToString:time];
    
    // 创建frame模型
    
    SMChatMessageFrame *messageFrame = [SMChatMessageFrame messageFrameWithMeassge:messageRec];
    // 将frame模型添加到数组中
    //[self.messageFrames addObject:messageFrame];
    
    //    SMLog(@"self.messageFrames  回调函数  %@",self.messageFrames);
    //    for (SMChatMessageFrame *m in self.messageFrames) {
    //        SMLog(@"m.messgae.text  回调  %@",m.messgae.text);
    //        //SMLog(@"%p",self.messageFrames);
    //    }
    
    //存起来
    //    [self saveSqliteWith:messageFrame];
    
    // 刷新表格
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KReceiveMessage" object:nil userInfo:@{@"connect":messageFrame}];
    
    /**
     > 在tableView插入一行数据
     > 添加一个messageFrame模型到数组中
     */
    //显示最后一行
    //[self scrollToLastRow];
}

-(void)reloadTableView:(NSNotification *)not
{
    SMChatMessageFrame * messageFrame = not.userInfo[@"connect"];
    
    [self.messageFrames addObject:messageFrame];
    
    [self.chatTableView reloadData];
    
    //显示最后一行
    [self scrollToLastRow];
    
   //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"KReceiveMessage" object:nil];

}

- (void)dealloc{
    SMLog(@"SMChatViewController   dealloc");
//    [self.messageFrames removeAllObjects];
    self.messageFrames = nil ;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //self.client = nil;didReceiveTypedMessage
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KReceiveMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceiveTypedMessage" object:nil];
    
    //点击进去  清空未读
    NSArray * array = [LocalConversation MR_findAll];
    
    for (LocalConversation * localConversation in array) {
        if ([localConversation.userID isEqualToString:self.user.userid]||[localConversation.clientId isEqualToString:self.targetRtcKey]) {
            //找到这个  然后更新为0
            localConversation.unread = @"0";
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }

}

-(void)saveSqliteWith:(SMChatMessageFrame *)chatMessageFrame{
    //插入数据
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        LocalChatMessageFrame * localChatMessageFrame = [LocalChatMessageFrame MR_createEntityInContext:localContext];
        localChatMessageFrame.iconF = NSStringFromCGRect(chatMessageFrame.iconF);
        localChatMessageFrame.textBtnF = NSStringFromCGRect(chatMessageFrame.textBtnF);
        localChatMessageFrame.timeF = NSStringFromCGRect(chatMessageFrame.timeF);
        localChatMessageFrame.cellHeight = [NSNumber numberWithFloat:chatMessageFrame.cellHeight];
        localChatMessageFrame.targetRtcKey = self.targetRtcKey;
        
        LocalChatMessage * chatMessage = [LocalChatMessage MR_createEntityInContext:localContext];
        chatMessage.time = chatMessageFrame.messgae.time;
        chatMessage.text = chatMessageFrame.messgae.text;
        chatMessage.type = [NSNumber numberWithInteger:chatMessageFrame.messgae.type];
        chatMessage.hideTime = [NSNumber numberWithBool:chatMessageFrame.messgae.hideTime];
        chatMessage.chatMessage = localChatMessageFrame;
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
}

//-(void)loadSqlite
//{
//    [self.messageFrames removeAllObjects];
//    
//    NSArray * array = [LocalChatMessageFrame MR_findByAttribute:@"targetRtcKey" withValue:self.targetRtcKey inContext:[NSManagedObjectContext MR_defaultContext]];
//    
//    for (LocalChatMessageFrame * localchatMessageFrame  in array) {
//        SMChatMessageFrame *  chatMessageFrame = [SMChatMessageFrame new];
//        
//        chatMessageFrame.iconF = CGRectFromString(localchatMessageFrame.iconF);
//        chatMessageFrame.textBtnF =CGRectFromString(localchatMessageFrame.iconF);
//        chatMessageFrame.timeF = CGRectFromString(localchatMessageFrame.iconF);
//        chatMessageFrame.cellHeight = localchatMessageFrame.cellHeight.floatValue;
//        chatMessageFrame.targetRtcKey = localchatMessageFrame.targetRtcKey;
//        
//        
//        SMChatMessage * chatMessage = [SMChatMessage new];
//        
//        LocalChatMessage * localChatMessage = [localchatMessageFrame.chatMessage anyObject];
//        
//        chatMessage.time = localChatMessage.time;
//        chatMessage.text = localChatMessage.text;
//        chatMessage.type = localChatMessage.type.integerValue?HMMessageTypeOther:HMMessageTypeMe;
//        chatMessage.hideTime = localChatMessage.hideTime.boolValue;
//        
//        chatMessageFrame.messgae = chatMessage;
//        
//        
//        [self.messageFrames addObject:chatMessageFrame];
//    }
//    
//    [self.chatTableView reloadData];
//    
//    //显示最后一行
//    [self scrollToLastRow];
//}

@end
