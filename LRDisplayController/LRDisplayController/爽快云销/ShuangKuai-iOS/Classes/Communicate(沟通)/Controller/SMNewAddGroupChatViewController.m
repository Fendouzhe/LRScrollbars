//
//  SMNewAddGroupChatViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewAddGroupChatViewController.h"
#import "ChineseToPinyin.h"
#import "SMFriend.h"
#import "SMContactPersonTableViewCell.h"
#import "ChatTopOfTableView.h"
#import "SMGroupChatListViewController.h"
#import "SMAddGroupTeamViewController.h"
#import "SMGroupChatViewController.h"
#import "SMGroupChatListData.h"
#import "SMGroupChatDetailData.h"
#import "ChatroomMemberListData.h"
#import "MBProgressHUD.h"
#import "SMAlertView.h"

#define AlerViewOffY 100

@interface SMNewAddGroupChatViewController ()<SMContactPersonTableViewCellDelegate,ChatTopOfTableViewDelegate,SMAddGroupTeamViewControllerDelegate,SMAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSMutableArray *sectionTitles;//头部数组
@property (nonatomic,strong) NSMutableArray *dataSource;/**< 数据源数据 */
@property (nonatomic,strong) NSMutableArray *selectArray;/**< 选中的数据 */
@property (nonatomic,strong) NSArray *originalArray;/**< 原始好友数据 */

@property (nonatomic ,strong)UIView *cheatView3;

@property(nonatomic,strong)SMAlertView *alertView;

@property(nonatomic,copy)NSString *imageToken;

@end

@implementation SMNewAddGroupChatViewController

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)sectionTitles
{
    if (_sectionTitles==nil) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发起群聊";
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestFriend];
    
    ChatTopOfTableView *topView = [[ChatTopOfTableView alloc] init];
    topView.delegate = self;
    [topView setWithImageArray:@[@"group",@"hehuoren00"] withStrArray:@[@"我的群组",@"我的团队"]];
    self.tableView.tableHeaderView = topView;
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.width = 40;
//    rightBtn.height = 30;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = KDefaultFontBig;
    dic[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:@"确定" attributes:dic];
    [rightBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(addGroupChat) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldClickNoti:(NSNotification *)notice{

    [NSThread sleepForTimeInterval:0.25];
    [UIView animateWithDuration:0.35 animations:^{
        self.alertView.y -= AlerViewOffY;
    }];
    //}
}
//确定
-(void)addGroupChat{
    
    if (self.selectArray.count == 0) {
        [MBProgressHUD showError:@"请选择组成员！"];
        return;
    }
    //包含自己少于
    if (self.selectArray.count + 1 < 3) {
        [MBProgressHUD showError:@"群组人数不能少于3人！"];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cheatView3 = [[UIView alloc] init];
    self.cheatView3 = cheatView3;
    
    cheatView3.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
    [cheatView3 addGestureRecognizer:tap];
    cheatView3.frame = window.bounds;
    
    SMAlertView *alertView = [SMAlertView alertView];
    alertView.delegate = self;
    alertView.center = window.center;
    [window addSubview:alertView];
    self.alertView = alertView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldClickNoti:) name:TextFieldClickNotification object:nil];
    
    // 动画
    cheatView3.alpha = 0;
    alertView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        alertView.transform = CGAffineTransformMakeScale(1, 1);
        cheatView3.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];

    {
//    if (self.selectArray.count < 3) {
//        [MBProgressHUD showError:@"群组人数不能少于3人"];
//        return;
//    }
//    if (self.selectArray.count>2) {
//        //弹框
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建群组" message:@"请输入群组名称" preferredStyle:UIAlertControllerStyleAlert];
//        //添加空文本输入框
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            
//        }];
//        UIAlertAction *comfirm = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIImage *image = [UIImage imageNamed:@"qunziliao"];
//            NSString *groupName = alert.textFields.firstObject.text;
//            NSMutableArray *tempIDArray = [NSMutableArray array];
//            for (User *user in self.selectArray) {
//                [tempIDArray addObject:user.userid];
//            }
//            
//            [MBProgressHUD showMessage:@"正在创建..." toView:[UIApplication sharedApplication].keyWindow];
//            MJWeakSelf
//            [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) {
//                if (!error) {
//                    NSString *token = [[result valueForKey:@"result"] valueForKey:@"token"];
//                    SMLog(@"result = %@",result);
//                    [[SKAPI shared] createGroup4IM:@"" andImageToken:token andGroupName:groupName andUserIds:tempIDArray block:^(id result, NSError *error) {
//                        if (!error) {
//                            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                            [MBProgressHUD showSuccess:@"创建成功!"];
//                            SMLog(@"群聊返回值 = %@",result);
//                            NSString *tagertID = [result valueForKey:@"result"];
//                            SMLog(@"tagertID = %@",tagertID);
//                            SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
//                            vc.targetId = tagertID;
//                            vc.conversationType = ConversationType_GROUP;
//                            SMGroupChatListData *roomData = [[SMGroupChatListData alloc] init];
//                            roomData.id = tagertID;
//                            roomData.roomName = groupName;
//                            //roomData.remark = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//                            vc.roomData = roomData;
//                            SMGroupChatDetailData *detailData = [[SMGroupChatDetailData alloc] init];
//                            detailData.chatroom = roomData;
//                            NSMutableArray *tempArray = [NSMutableArray array];
//                            for (User *user in weakSelf.selectArray) {
//                                ChatroomMemberListData *listData = [[ChatroomMemberListData alloc] init];
//                                listData.user = user;
//                                [tempArray addObject:listData];
//                            }
//                            detailData.chatroomMemberList = [tempArray copy];
//                            vc.title = groupName;
//                            vc.roomDetail = detailData;
//
//                            [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
//                            //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            //                            [weakSelf.navigationController pushViewController:vc animated:YES];
//                            //                        });
//                            [weakSelf.navigationController pushViewController:vc animated:YES];
//                            
//                        }else{
//                            SMLog(@"%@",error);
//                        }
//                    }];
//                }
//            }];
//        }];
//        
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            //
//        }];
//        //[comfirm setValue:[UIColor redColor] forKey:@"_titleTextColor"];
//        //[cancel setValue:[UIColor redColor] forKey:@"_titleTextColor"];
//        alert.view.tintColor = [UIColor redColor];
//        alert.view.tintColor = [UIColor redColor];
//        [alert addAction:comfirm];
//        [alert addAction:cancel];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    }
}

- (void)cheatViewTap{

    //if ([UIScreen mainScreen].bounds.size.height <= 667) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (self.alertView.center.y == window.center.y + AlerViewOffY || self.alertView.center.y == window.center.y) {
        return;
    }
    [self.alertView.inputTextField endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.y += AlerViewOffY;
    }];
    //}
//    [UIView animateWithDuration:0.35 animations:^{
//        self.alertView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
//        self.cheatView3.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.cheatView3 removeFromSuperview];
//        self.cheatView3 = nil;
//        [self.alertView removeFromSuperview];
//        self.alertView = nil;
//    }];
}

#pragma mark - SMAlertViewDelegate
///选择组图片
- (void)alertViewChooseImageButtonClick:(SMAlertView *)alertView{
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置群头像" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    alert.view.tintColor = [UIColor redColor];
//
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
//    [self presentViewController:alert animated:YES completion:^{
//        //[[UIApplication sharedApplication].keyWindow bringSubviewToFront:alert.view];
////        [[UIApplication sharedApplication].keyWindow insertSubview:alert.view aboveSubview:self.alertView];
////        alert.view.center = [[UIApplication sharedApplication].keyWindow center];
//    }];
    [self cheatViewTap];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
    alert.tintColor = [UIColor redColor];
    [alert show];

    
}


///创建--组
- (void)alertViewCreateButtonClick:(SMAlertView *)alertView{
    
    if (alertView.inputTextField.text.length <= 0) {
        [MBProgressHUD showError:@"请输入群名称！"];
        return;
    }
    [self cheatViewTap];
    //SMLog(@"_imageToken = %@",_imageToken);
    //UIImage *image = alertView.groupImageView.image;
    NSString *groupName = alertView.inputTextField.text;
    NSMutableArray *userIdArray = [NSMutableArray array];
    for (User *user in self.selectArray) {
        [userIdArray addObject:user.userid];
    }
    //设置默认图
    if (!_imageToken.length) {
        UIImage *image = alertView.groupImageView.image;
        [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) { //先拿到 要上传图片的imageToken
            if (!error) {
                NSString *imageToken = [[result valueForKey:@"result"] valueForKey:@"token"];
                
                [self creatGroupWithImagToken:imageToken name:groupName userIds:userIdArray];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                SMLog(@"error updateStorage  %@",error);
            }
        }];
    }else{

        [self creatGroupWithImagToken:_imageToken name:groupName userIds:userIdArray];
    }
}

- (void)creatGroupWithImagToken:(NSString *)token name:(NSString *)groupName userIds:(NSArray *)arr{
    MJWeakSelf
    [MBProgressHUD showMessage:@"正在创建..." toView:[UIApplication sharedApplication].keyWindow];
    [[SKAPI shared] createGroup4IM:@"" andImageToken:token andGroupName:groupName andUserIds:arr block:^(id result, NSError *error) {
        if (!error) {
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            [MBProgressHUD showSuccess:@"创建成功!"];
            //去掉弹框
            [self alertViewCancelButtonClick:nil];
            
            SMLog(@"群聊返回值 = %@",result);
            NSString *tagertID = [result valueForKey:@"result"];
            SMLog(@"tagertID = %@",tagertID);
//            SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
//            vc.targetId = tagertID;
//            vc.groupId = tagertID;
//            vc.conversationType = ConversationType_GROUP;
//            SMGroupChatListData *roomData = [[SMGroupChatListData alloc] init];
//            roomData.id = tagertID;
//            roomData.roomName = groupName;
//            //roomData.remark = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//            vc.roomData = roomData;
//            SMGroupChatDetailData *detailData = [[SMGroupChatDetailData alloc] init];
//            detailData.chatroom = roomData;
//            NSMutableArray *tempArray = [NSMutableArray array];
//            for (User *user in weakSelf.selectArray) {
//                ChatroomMemberListData *listData = [[ChatroomMemberListData alloc] init];
//                listData.user = user;
//                [tempArray addObject:listData];
//            }
//            detailData.chatroomMemberList = [tempArray copy];
//            vc.title = groupName;
//            vc.roomDetail = detailData;
            
            SMGroupChatListData *roomData = [[SMGroupChatListData alloc] init];
            roomData.id = tagertID;
            roomData.roomName = groupName;
            SMGroupChatViewController *vc = [[SMGroupChatViewController alloc] init];
            vc.groupId = tagertID;
            //目标会话一定要设置
            vc.targetId = tagertID;
            vc.conversationType = ConversationType_GROUP;
            vc.roomData = roomData;
            vc.title = groupName;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            SMLog(@"群组创建失败 error = %@",error);
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"群组创建失败，请检查网络!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
///取消
- (void)alertViewCancelButtonClick:(SMAlertView *)alertView{
    //[self removeCheatView3];
    [alertView.inputTextField endEditing:YES];
    //SMLog(@"Y = %lf",self.alertView.center.y);
    [UIView animateWithDuration:0.35 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView3.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView3 removeFromSuperview];
        self.cheatView3 = nil;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
    //一定要这这里移除监听，否则监听回调方法会执行多次
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TextFieldClickNotification object:nil];
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
        self.alertView.groupImageView.image = image;
        //[MBProgressHUD showMessage:@"正在上传图片..." toView:[UIApplication sharedApplication].keyWindow];
        [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) { //先拿到 要上传图片的imageToken
            SMLog(@"image = %@ result = %@  error = %@---%@",image,result,error,[NSThread currentThread]);
            if (!error) {
//                self.alertView.groupImageView.image = image;
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                [MBProgressHUD showSuccess:@"图片上传成功!"];
                
                self.imageToken = [[result valueForKey:@"result"] valueForKey:@"token"];
                
            }else{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                //设置为默认
                self.alertView.groupImageView.image = [UIImage imageNamed:@"default_group_portrait"];
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

- (void)requestFriend{
    MJWeakSelf
    //[MBProgressHUD showMessage:@"" toView:[UIApplication sharedApplication].keyWindow];
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            //[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            weakSelf.originalArray = array;
            NSMutableArray *friendArray = [NSMutableArray array];
            for (User *user in array) {
                SMFriend *friend = [[SMFriend alloc] init];
                friend.user = user;
                [friendArray addObject:friend];
            }
            weakSelf.dataSource = [weakSelf sortDataArray:friendArray];
            [weakSelf.tableView reloadData];
        }else{
//            [MBProgressHUD showError:@"好友列表加载失败,请检查网络!"];
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }
    }];
}

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (SMFriend *friendsListData in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        //        NSString *realNameStr = friendsListData.strRealName;
        //        if (!realNameStr.length) {
        //            realNameStr = @"#";
        //        }
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:friendsListData.name];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:friendsListData];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(SMFriend *obj1, SMFriend *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.name];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.name];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:(section)] count] == 0)
    {
        return 0;
    }else{
        return 22;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41 *SMMatchHeight+10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    SMLog(@"section = %ld,%ld",section,[[self.dataSource objectAtIndex:(section)] count]);
    return [[self.dataSource objectAtIndex:(section)] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMContactPersonTableViewCell *cell = [SMContactPersonTableViewCell cellWithTableView:tableView];
    //可以在这里给cell赋值
    cell.delegate = self;
    
    SMFriend *friend = self.dataSource[indexPath.section][indexPath.row];
    
    cell.myFriend = friend;
    
    if(friend.select)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    SMLog(@"选中");
    
    
    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
    
    [self.selectArray addObject:theFriend.user];
    SMLog(@"最新状态");
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMContactPersonTableViewCell *cell = (SMContactPersonTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.myFriend.select = !cell.myFriend.select;
    
    
    SMFriend *theFriend = self.dataSource[indexPath.section][indexPath.row];
    
    [self.selectArray removeObject:theFriend.user];
    SMLog(@"最新状态");
    for (User *user1 in self.selectArray) {
        SMLog(@"%@,%@",user1.name,user1.userid);
    }
}

- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}

#pragma mark - SMAddGroupTeamViewControllerDelegate
-(void)addFriend:(User *)user{
    [self.selectArray addObject:user];
    SMLog(@"%@,%@",user.name,user.userid);
    SMLog(@"最新状态");
//    for (User *user1 in self.selectArray) {
//        SMLog(@"%@,%@",user1.name,user1.userid);
//    }
    for (int i = 0; i < self.dataSource.count; i++) {
        for (int j = 0; j < [self.dataSource[i] count]; j++) {
            SMFriend *friend = self.dataSource[i][j];
            if ([friend.user.userid isEqualToString:user.userid]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

-(void)delFriend:(User *)user{
    SMLog(@"%@,%@",user.name,user.userid);
    for (User *user1 in self.selectArray) {
        if ([user.userid isEqualToString:user1.userid]) {
            [self.selectArray removeObject:user1];
        }
    }
    SMLog(@"最新状态");
//    for (User *user1 in self.selectArray) {
//        SMLog(@"%@,%@",user1.name,user1.userid);
//    }
    for (int i = 0; i < self.dataSource.count; i++) {
        for (int j = 0; j < [self.dataSource[i] count]; j++) {
            SMFriend *friend = self.dataSource[i][j];
            if ([friend.user.userid isEqualToString:user.userid]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }
}
#pragma mark - ChatTopOfTableViewDelegate
-(void)chatTopOfTableViewWithNumber:(NSUInteger)tag{
    switch (tag) {
        case 0:
        {
            SMGroupChatListViewController *vc = [[SMGroupChatListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            SMAddGroupTeamViewController *vc = [[SMAddGroupTeamViewController alloc] init];
            vc.delegate = self;
            vc.oldSelectArray = self.selectArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}




@end
