//
//  SMGroupChatDetailViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.

/*
 *  群聊详情控制器
 */
#import "SMGroupChatDetailViewController.h"
#import "SMGroupChatDetailData.h"
#import "SMBaseCellData.h"
#import "SMArrowCellData.h"
#import "SMSwithCellData.h"
#import "SMSettingCell.h"
#import "SMGroupChatListData.h"
#import "CollectionTableViewCell.h"
#import "SMSettingTableViewCell.h"
#import "SMGroupChatMemberListViewController.h"
#import "BottomBtnDelView.h"
#import "SMCreateErWeiMaViewController.h"
#import "SMGroupChatDetailChangeViewController.h"
#import "SMGroupChatHistoryViewController.h"
#import "SMPersonInfoViewController.h"
#import "SMNewMemberController.h"
#import "SMDeleteMemberController.h"
#import "ChatroomMemberListData.h"
#import "SMAlertView.h"

@interface SMGroupChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CollectionTableViewCellDelegate,SMSettingTableViewCellDelegate,BottomBtnDelViewDelegate,SMGroupChatDetailChangeViewControllerDelegate,SMAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@property (nonatomic,weak) UITableView *tableView;/**< tableview */
@property (nonatomic,weak) BottomBtnDelView *bottomBtn;/**< 底部按钮 */
@property (nonatomic,assign,getter=isRecevieMessage) BOOL recevieMessage;/**< 是否接收消息 */

@property (nonatomic ,strong)UIView *cheatView3;

@property(nonatomic,strong)SMAlertView *alertView;

@property(nonatomic,copy)NSString *imageToken;

@end
#define BottomBtnHeight 50*SMMatchWidth
@implementation SMGroupChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群资料";
    [self setupUI];
    //加载组资料
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self groupNumberChangeNotification:nil];
    });

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNumberChangeNotification:) name:AddGroupMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNumberChangeNotification:) name:DeleteGroupMemberNotification object:nil];
}

///添加，删除组成员回调方法,重新加载数据更新界面
- (void)groupNumberChangeNotification:(NSNotification *)notice{
    
    [[SKAPI shared] queryGroupDetail4IM:_roomDetail.chatroom.id more:YES block:^(id result, NSError *error) {
        if (!error) {
            
            [SMGroupChatDetailData mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"chatroomMemberList" : [ChatroomMemberListData class]
                         // @"statuses" : [Status class],
                         };
            }];
            SMGroupChatDetailData *listData = [SMGroupChatDetailData mj_objectWithKeyValues:[result valueForKey:@"result"]];

            [self setRoomDetail:listData];
            self.roomDetail = listData;
        }
        
    }];
}

- (void)setupUI{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    MJWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-BottomBtnHeight);
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = whiteView;
    
    //删除并退出按钮
    BottomBtnDelView *bottomBtn = [[BottomBtnDelView alloc] init];
//    [bottomBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    bottomBtn.delegate = self;
    bottomBtn.roomDetail = self.roomDetail;
    self.bottomBtn = bottomBtn;
    [self.view addSubview:bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(@(BottomBtnHeight));
        make.bottom.equalTo(weakSelf.view);
    }];
}
#pragma mark -- BottomBtnDelViewDelegate
//删除并退出
-(void)delBtnClick:(UIButton *)btn{
    
    NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    MJWeakSelf
//    [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    if ([userIDStr isEqualToString:self.roomDetail.chatroom.createrId]) {//房主
        
        if (self.roomDetail.chatroomMemberList.count>1) {
            [MBProgressHUD showError:@"请先清空群中的人，再删除群组"];
        }else{
            //退出群
            [[SKAPI shared] quitGroup4IM:self.roomDetail.chatroom.id block:^(id result, NSError *error) {
                if (!error) {
                    
                    [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:QuitGroupNotification object:nil userInfo:nil];
                }else{
                    
                }
            }];
        }
        
    }else{
        //退出群
        [[SKAPI shared] quitGroup4IM:self.roomDetail.chatroom.id block:^(id result, NSError *error) {
            if (!error) {
                [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:QuitGroupNotification object:nil userInfo:nil];
            }else{
                
            }
        }];
    }
}

-(void)setRoomDetail:(SMGroupChatDetailData *)roomDetail{
    _roomDetail = roomDetail;
    
    MJWeakSelf
    //组1
    SMBaseCellData *base1 = [[SMBaseCellData alloc] init];
    SMArrowCellData *arrow1 = [[SMArrowCellData alloc] init];
    arrow1.title = [NSString stringWithFormat:@"全部群成员(%ld)",(unsigned long)roomDetail.chatroomMemberList.count];
    NSArray *group1 = @[base1,arrow1];
    arrow1.cellOption = ^(){
        SMGroupChatMemberListViewController *vc = [[SMGroupChatMemberListViewController alloc] init];
        vc.roomDetail = roomDetail;
        //SMLog(@"roomDetail = %@",roomDetail);
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //组2
    SMArrowCellData *arrow2 = [[SMArrowCellData alloc] init];
    arrow2.title = @"群头像";
    arrow2.detailImage = roomDetail.chatroom.imageUrl;
    arrow2.cellOption = ^(){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        UIView *cheatView3 = [[UIView alloc] init];
        self.cheatView3 = cheatView3;
        
        cheatView3.backgroundColor = [UIColor blackColor];
        [window addSubview:cheatView3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
        [cheatView3 addGestureRecognizer:tap];
        cheatView3.frame = window.bounds;
        
        SMAlertView *alertView = [SMAlertView alertView];
        alertView.imageUrl = roomDetail.chatroom.imageUrl;
        [alertView.creatButton setTitle:@"确定" forState:UIControlStateNormal];
        alertView.delegate = self;
        alertView.tipLabel.text = @"群头像修改";
        alertView.inputTextField.hidden = YES;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alertView.tipLabel.frame), alertView.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [alertView addSubview:lineView];
        CGFloat offY = 24;
        alertView.groupImageTopConstrait.constant += offY;
        alertView.addImageBtnTopConstrait.constant += offY;
        alertView.textFiledBottomConstrait.constant -= offY;
        [alertView layoutIfNeeded];
        alertView.center = window.center;
        [window addSubview:alertView];
        self.alertView = alertView;
        
        // 动画
        cheatView3.alpha = 0;
        alertView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        [UIView animateWithDuration:0.35 animations:^{
            alertView.transform = CGAffineTransformMakeScale(1, 1);
            cheatView3.alpha = 0.5;
        } completion:^(BOOL finished) {
            
        }];
    };

    SMArrowCellData *arrow3 = [[SMArrowCellData alloc] init];
    arrow3.title = @"群名称";
    arrow3.detailText = roomDetail.chatroom.roomName;
    arrow3.cellOption = ^(){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"请输入新名称" preferredStyle:UIAlertControllerStyleAlert];
        [alert.view setTintColor:KRedColorLight];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = roomDetail.chatroom.roomName;
            //textField.placeholder = @"请输入新名称";
        }];
        UIAlertAction *comfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //修改群名称
            NSString *intro = self.roomDetail.chatroom.intro.length ? self.roomDetail.chatroom.intro : @"";
            [[SKAPI shared] updateGroup:self.roomDetail.chatroom.id andRoomName:alert.textFields[0].text andIntro:intro andImageToken:@"" block:^(id result, NSError *error) {
                if (!error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [weakSelf groupNumberChangeNotification:nil];
                    });
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力,请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:comfirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    };

    
    SMArrowCellData *arrow6 = [[SMArrowCellData alloc] init];
    arrow6.title = @"我在本群的昵称";
    arrow6.detailText = roomDetail.chatroom.remark;
    arrow6.cellOption = ^(){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"请输入新名称" preferredStyle:UIAlertControllerStyleAlert];
        [alert.view setTintColor:KRedColorLight];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = roomDetail.chatroom.remark;
        }];
        UIAlertAction *comfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SKAPI shared] settingGroup:self.roomDetail.chatroom.id andMessageStatus:self.recevieMessage andRemark:alert.textFields[0].text block:^(id result, NSError *error) {

                if (!error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [weakSelf groupNumberChangeNotification:nil];
                    });
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力,请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:comfirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
//    SMArrowCellData *arrow3 = [[SMArrowCellData alloc] init];
//    arrow3.title = @"群二维码";
//    arrow3.detailImage = @"erweimaHei";
//    arrow3.cellOption = ^(){
//        SMCreateErWeiMaViewController *vc = [[SMCreateErWeiMaViewController alloc] init];
//        vc.roomDetail = weakSelf.roomDetail;
//        [vc setupQrcodeWithStr:[NSString stringWithFormat:@"%@",self.roomDetail.chatroom.id]];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    };
    
    SMSwithCellData *switch1 = [[SMSwithCellData alloc] init];
    switch1.title = @"消息免打扰";
    if([roomDetail.chatroom.messageStatus isEqualToString:@"0"]){
        switch1.btnOn = YES;
        weakSelf.recevieMessage = NO;
    }else{
        switch1.btnOn = NO;
        weakSelf.recevieMessage = YES;
    }
    
    
//    SMArrowCellData *arrow4 = [[SMArrowCellData alloc] init];
//    arrow4.title = @"群公告";
//    arrow4.detailText = roomDetail.chatroom.intro;
//    arrow4.cellOption = ^(){
//        SMGroupChatDetailChangeViewController *vc = [[SMGroupChatDetailChangeViewController alloc] initWithSMGroupChatDetailChangeType:SMGroupChatDetailChangeTypeGroupNotice withSMGroupChatDetailData:weakSelf.roomDetail];
//        vc.delegate = weakSelf;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    };
    
    SMArrowCellData *arrow5 = [[SMArrowCellData alloc] init];
    arrow5.title = @"群聊天记录";
    arrow5.cellOption = ^(){
        SMGroupChatHistoryViewController *vc = [[SMGroupChatHistoryViewController alloc] init];
        vc.roomDetail = weakSelf.roomDetail;
        vc.targetId = weakSelf.roomDetail.chatroom.id;
        vc.conversationType = ConversationType_GROUP;
        vc.title = weakSelf.roomDetail.chatroom.roomName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
//        SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
//        vc.targetId = tagertID;
//        vc.conversationType = ConversationType_GROUP;
//        SMGroupChatListData *roomData = [[SMGroupChatListData alloc] init];
//        roomData.id = tagertID;
//        roomData.roomName = groupName;
//        vc.roomData = roomData;
//        vc.title = groupName;
//        [self.navigationController pushViewController:vc animated:YES];
    };
    
    NSArray *group2 = @[arrow2,arrow3,arrow6,switch1,arrow5];
    self.dataArray = @[group1,group2];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray[section] count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        CollectionTableViewCell *cell = [CollectionTableViewCell cellWithTableView:tableView];
        cell.roomDetail = self.roomDetail;
        cell.delegate = self;
        return cell;
    }else{
        SMSettingTableViewCell *cell = [SMSettingTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.cellData = self.dataArray[indexPath.section][indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80*SMMatchWidth;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        return 60*SMMatchWidth;
    } else {
        return 40*SMMatchWidth;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0 && indexPath.section == 0) {
        
    }else{
        SMBaseCellData *cellData = self.dataArray[indexPath.section][indexPath.row];
        
        if ([cellData isKindOfClass:[SMArrowCellData class]]) {
            
            if (cellData.cellOption) {
                
                NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
                BOOL isAdmin = NO;
                //SMLog(@"%@--%@--%@",userID,self.roomDetail.chatroom.createrId,self.roomDetail.chatroom.id);
                if ([userID isEqualToString:self.roomDetail.chatroom.createrId]) {
                    isAdmin = YES;
                }
                if (indexPath.section == 1) {
                    
                    
                    if (indexPath.row == 0) {
                        if (!isAdmin) {
                            [MBProgressHUD showError:@"只有群主才可以修改群头像"];
                        }else{
                            cellData.cellOption();
                        }
                    } else if (indexPath.row == 1){
                        if (!isAdmin) {
                            [MBProgressHUD showError:@"只有群主才可以修改群名称"];
                        }else{
                            cellData.cellOption();
                        }
                    }else{
                        cellData.cellOption();
                    }
                    
                    
                }else{
                    
                    cellData.cellOption();
                }
                
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SMSettingTableViewCellDelegate
//免消息打扰开关
-(void)switchButtonClick:(BOOL)on{
    //SMLog(@"switchButtonClick = %d",on);
    MJWeakSelf
    [[SKAPI shared] settingGroup:self.roomDetail.chatroom.id andMessageStatus:!on block:^(id result, NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeGroupMessageStateNotification object:nil userInfo:@{@"targetId":self.roomDetail.chatroom.id,@"status":@(on)}];
            //等待0.25秒再刷新，让开关看得见动画效果
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf groupNumberChangeNotification:nil];
            });
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力,请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - valueChange
-(void)valueChangeWithRoomDetailWithType:(SMGroupChatDetailChangeType)changeType newName:(NSString *)name{
//    SMLog(@"值改变事件----%@--%@--%d",name,self.roomDetail.chatroom.id,self.recevieMessage);
//    __weak typeof(self) weakSelf = self;
//    switch (changeType) {
//            //修改所在群昵称
//        case SMGroupChatDetailChangeTypeGroupNickName:
//        {
//            //[MBProgressHUD showMessage:@"正在加载" toView:self.view];
//            [[SKAPI shared] settingGroup:self.roomDetail.chatroom.id andMessageStatus:self.recevieMessage andRemark:name block:^(id result, NSError *error) {
//                //[MBProgressHUD hideHUDForView:self.view];
//                SMLog(@"result = %@------error = %@",result,error);
//                if (!error) {
//                    [weakSelf groupNumberChangeNotification:nil];
//                }
//            }];
//        }
//            break;
//        case SMGroupChatDetailChangeTypeGroupName:
//        {
//            //修改群名称
//            NSString *intro = self.roomDetail.chatroom.intro.length ? self.roomDetail.chatroom.intro : @"";
//            [[SKAPI shared] updateGroup:self.roomDetail.chatroom.id andRoomName:name andIntro:intro andImageToken:@"" block:^(id result, NSError *error) {
//                if (!error) {
//                    [weakSelf groupNumberChangeNotification:nil];
//                }
//            }];
//        }
////            break;
//        case SMGroupChatDetailChangeTypeGroupNotice:
//        {
//        }
////            break;
//        default:
//        {   //修改群名称
////            NSString *intro = self.roomDetail.chatroom.intro.length ? self.roomDetail.chatroom.intro : @"";
////            [[SKAPI shared] updateGroup:self.roomDetail.chatroom.id andRoomName:name andIntro:intro andImageToken:@"" block:^(id result, NSError *error) {
////                if (!error) {
////                    [weakSelf groupNumberChangeNotification:nil];
////                }
////            }];
//        }
//            break;
//    }
    
}

-(void)dataArrayChange{
    SMBaseCellData *cellData1 = self.dataArray[1][0];
    cellData1.detailText = self.roomDetail.chatroom.roomName;
    
    SMBaseCellData *cellData2 = self.dataArray[1][1];
    cellData2.detailText = self.roomDetail.chatroom.remark;
    
    SMBaseCellData *cellData3 = self.dataArray[1][3];
    cellData3.detailText = self.roomDetail.chatroom.intro;
}

#pragma mark - CollectionTableViewCellDelegate
//点击用户头像
-(void)clickUserWithUserID:(NSString *)userID{
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    User *user = [[User alloc] init];
    user.userid = userID;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

//添加组成员方法
-(void)addGroupMemberClick{
    SMNewMemberController *vc = [[SMNewMemberController alloc] init];
    vc.roomDetail = self.roomDetail;
    vc.chatroomMemberList = self.roomDetail.chatroomMemberList;
    [self.navigationController pushViewController:vc animated:YES];
}
//删除组成员方法
-(void)delGroupMemberClick{
    SMDeleteMemberController *vc = [[SMDeleteMemberController alloc] init];
    vc.roomDetail = self.roomDetail;
    vc.chatroomMemberList = self.roomDetail.chatroomMemberList;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SMAlertViewDelegate
///选择组图片
- (void)alertViewChooseImageButtonClick:(SMAlertView *)alertView{
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置群头像" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    alert.view.tintColor = KRedColorLight;
//    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        [self presentViewController:imagePickerController animated:YES completion:nil];
//        
//    }];
//    UIAlertAction *photoes = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self presentViewController:imagePickerController animated:YES completion:nil];
//        
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alert addAction:camera];
//    [alert addAction:photoes];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
    alert.tintColor = [UIColor redColor];
    [alert show];
}


/**
 *  确定修改群头像
 */
- (void)alertViewCreateButtonClick:(SMAlertView *)alertView{
    if (!_imageToken) {
        [self cheatViewTap];
        return;
    }
    [[SKAPI shared] updateGroup:_roomDetail.chatroom.id imageToken:_imageToken block:^(id result, NSError *error) {
        if (!error) {
            //[self groupNumberChangeNotification:nil];
            [self cheatViewTap];
#warning 延时加载数据刷新界面，才能刷新组头像
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self groupNumberChangeNotification:nil];
            });
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力,请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}


///取消
- (void)alertViewCancelButtonClick:(SMAlertView *)alertView{
    [self cheatViewTap];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"buttonIndex = %lu",buttonIndex);
    if (buttonIndex == 0) {//取消
        
    } else if(buttonIndex == 1){//拍照
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        self.alertView.hidden = YES;
        self.cheatView3.hidden = YES;
    } else if(buttonIndex == 2){//相册
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        self.alertView.hidden = YES;
        self.cheatView3.hidden = YES;
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.alertView.hidden = NO;
    self.cheatView3.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        image = [self scaleToSize:image size:CGSizeMake(118, 118)];
        [MBProgressHUD showMessage:@"正在上传图片..." toView:[UIApplication sharedApplication].keyWindow];
        [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) { //先拿到 要上传图片的imageToken
            //SMLog(@"image = %@ result = %@  error = %@---%@",image,result,error,[NSThread currentThread]);
            if (!error) {
                self.alertView.groupImageView.image = image;
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [MBProgressHUD showSuccess:@"图片上传成功!"];
                
                self.imageToken = [[result valueForKey:@"result"] valueForKey:@"token"];
                
            }else{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                SMLog(@"error updateStorage  %@",error);
            }
        }];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.alertView.hidden = NO;
        self.cheatView3.hidden = NO;
    }];
}

//蒙板点击
- (void)cheatViewTap{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView3.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView3 removeFromSuperview];
        self.cheatView3 = nil;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
}

@end
