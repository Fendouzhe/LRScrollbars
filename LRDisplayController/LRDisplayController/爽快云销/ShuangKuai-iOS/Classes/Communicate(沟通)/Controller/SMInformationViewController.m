//
//  SMInformationViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMInformationViewController.h"
#import "SingtonManager.h"
#import "informationTableViewCell.h"
#import "SMPersonInfoViewController.h"

@interface SMInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation SMInformationViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)startTimer{
    self.timer = [NSTimer timerWithTimeInterval:6 target:self selector:@selector(getSystermMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爽快消息";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([informationTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    [self requestData];
    
    //SingtonManager * sington = [SingtonManager sharedManager];
    
    //[sington addObserver:self forKeyPath:@"friendNum" options:NSKeyValueObservingOptionNew context:nil];
    
    //清除消息红点
    [self receiptMessage];
    
    [self requestNewData];
    
}

- (void)getSystermMessage{
    [self.dataArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKAPI shared] queryFriendMessages:^(id result, NSError *error) {
            if (!error) {
                //SMLog(@"queryFriendMessages = %@",result);
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * dic in result) {
                    Information * info = [Information mj_objectWithKeyValues:dic];
                    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
                    if ([info.sender isEqualToString:userId]) {
                        //是自己主动发送
                        [array addObject:info];
                        //
                    }else{
                        //不是自己主动发送的
                        [self.dataArray addObject:info];
                        
                    }
                }
                NSMutableArray * deleteArray = [NSMutableArray array];
                for (Information * myInfo in array) {
                    for (Information* otherInfo in self.dataArray) {
                        //判断自己发送时的接受者和别人请求添加你的发送者
                        if ([myInfo.receiver isEqualToString:otherInfo.sender]) {
                            if (myInfo.type == otherInfo.type) {
                                //如果是相同状态的只存在一个
                                //要删除
                                [deleteArray addObject:otherInfo];
                            }
                            if (otherInfo.type == 30) {
                                //是请求消息
                                otherInfo.type = myInfo.type;
                            }
                            
                        }
                    }
                }
                for (Information * info in deleteArray) {
                    [self.dataArray removeObject:info];
                }
                
                NSMutableArray * receiveStatusArray = [NSMutableArray array];
                //如果是30状态 和已处理的消息 隐藏 也就是删除
                for (Information * info in self.dataArray) {
                    if (info.type == 30 && info.receiveStatus == 1) {
                        [receiveStatusArray addObject:info];
                    }
                }
                for (Information * info in receiveStatusArray) {
                    [self.dataArray removeObject:info];
                }
                
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else{
                SMLog(@"%@",error);
            }
            
        }];
    });
 
}


//清除消息红点
-(void)receiptMessage{
    SingtonManager * sington = [SingtonManager sharedManager];
    NSMutableArray * array = [NSMutableArray array];
    for (Msg * msg in sington.friendArray) {
        [array addObject:msg.messageId];
    }
    //SMLog(@"array = %@",array);
    [[SKAPI shared] receiptMessage:[array copy] block:^(id result, NSError *error) {
        if (!error) {
            //SMLog(@"result = %@",result);
            if (sington.friendArray.count>0) {
                [sington.friendArray removeAllObjects];
                sington.friendNum = sington.friendArray.count;
            }
        }else{
            SMLog(@"error = %@",error);
        }
    }];
}

-(void)requestNewData{
    
    [[SKAPI shared] queryFriendMessages:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"queryFriendMessages = %@",result);
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in result) {
                Information * info = [Information mj_objectWithKeyValues:dic];
                NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
                if ([info.sender isEqualToString:userId]) {
                    //是自己主动发送
                    [array addObject:info];
                    //
                }else{
                    //不是自己主动发送的
                    [self.dataArray addObject:info];

                }
            }
            NSMutableArray * deleteArray = [NSMutableArray array];
            for (Information * myInfo in array) {
                for (Information * otherInfo in self.dataArray) {
                    //判断自己发送时的接受者和别人请求添加你的发送者
                    if ([myInfo.receiver isEqualToString:otherInfo.sender]) {
                        if (myInfo.type == otherInfo.type) {
                            //如果是相同状态的只存在一个
                            //要删除
                            [deleteArray addObject:otherInfo];
                        }
                        if (otherInfo.type == 30) {
                            //是请求消息
                            otherInfo.type = myInfo.type;
                        }

                    }
                }
            }
            for (Information * info in deleteArray) {
                [self.dataArray removeObject:info];
            }
            
            NSMutableArray * receiveStatusArray = [NSMutableArray array];
            //如果是30状态 和已处理的消息 隐藏 也就是删除
            for (Information * info in self.dataArray) {
                if (info.type == 30 && info.receiveStatus == 1) {
                    [receiveStatusArray addObject:info];
                }
            }
            for (Information * info in receiveStatusArray) {
                [self.dataArray removeObject:info];
            }
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
        
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    informationTableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    
//    User * user =self.dataArray[indexPath.row][@"User"];
//    NSString * remark = self.dataArray[indexPath.row][@"remark"];
//    
//    [cell refreshUIWithUser:user andRemark:remark];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.dataArray[indexPath.row];

//    User * user =self.dataArray[indexPath.row][@"User"];
//    NSString * remark = self.dataArray[indexPath.row][@"remark"];
//    [cell refreshUIWithUser:user andRemark:remark];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMPersonInfoViewController * personInfo = [SMPersonInfoViewController new];
    User * user = [User new];
    Information * info = self.dataArray[indexPath.row];
    
    if (info.body[@"userA"]) {
        user.userid = info.body[@"userA"];
    }else if(info.body[@"userId"]){
        user.userid = info.body[@"userId"];
    }
    
    if (info.body[@"name"]) {
        user.name = info.body[@"name"];
    }else if(info.body[@"uName"]){
        user.name = info.body[@"uName"];
    }
    
    user.portrait = info.body[@"portrait"];
    personInfo.user = user;
    [self.navigationController pushViewController:personInfo animated:YES];
}


//-(void)requestData{
//    //获取个人信息
//    SingtonManager * sington = [SingtonManager sharedManager];
//    NSMutableArray * mutArray = [NSMutableArray array];
//
//    for (Msg * msg in sington.friendArray) {
//        SMLog(@"%@",msg.body);
//        NSMutableString * str = (NSMutableString *)msg.body;
//        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        NSInteger i=0;
//        for ( i= 0; i<mutArray.count; i++) {
//            Msg * message = mutArray[i];
//            NSMutableString * str1 = (NSMutableString *)message.body;
//            NSData * data = [str1 dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            if ([dic[@"userA"] isEqualToString:dic1[@"userA"]]) {
//                break;
//            }
//        }
//        if (i == mutArray.count) {
//            [mutArray addObject:msg];
//        }
//    }
//
//    for (Msg * msg in mutArray) {
//        SMLog(@"%@",msg.body);
//        NSMutableString * str = (NSMutableString *)msg.body;
//
//        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        SMLog(@"dic = == = =%@",dic1);
//
//        User * user = [User new];
//        user.portrait = dic1[@"portrait"];
//        user.name = dic1[@"name"];
//        user.userid  = dic1[@"userA"];
//
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setObject:user forKey:@"User"];
//        [dic setObject: dic1[@"remark"] forKey:@"remark"];
//
//        [self.dataArray addObject:dic];
//    }
//
//    [self.tableView reloadData];
//
//}


@end
