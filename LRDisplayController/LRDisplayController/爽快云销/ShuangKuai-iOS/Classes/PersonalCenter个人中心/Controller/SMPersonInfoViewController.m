//
//  SMPersonInfoViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonInfoViewController.h"
#import "SMBasicInfoCell.h"
#import "SMCircleTableViewCell.h"
#import "SMEditInfoController.h"
#import "SMCompanyCell.h"
#import "SMEditInfo2Controller.h"
#import "SMMyCaredCompanyController.h"
#import "tweetFrame.h"
#import "SMCircelCell.h"
#import "SMCircelDetailViewController.h"
#import <UIButton+WebCache.h>
#import "SMChatViewController.h"
#import "SMRepostViewController.h"
#import "SMIndustryController.h"
#import "SMMyCodeViewController.h"
#import "SMCreateErWeiMaViewController.h"
#import "AppDelegate.h"
#import "MHPhotoBrowserController.h"
#import "MHPhotoModel.h"
#import "SYPhotoBrowser.h"
#import "SVProgressHUD.h"
#import "takePhoto.h"
#import "SMSettingViewController.h"
#import "SMNewChatViewController.h"


#define KChangeBjImageCount 4
#define KChangeBjImageMargin 5
#define KAnimateTime 0.5

@interface SMPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SMIndustryControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIView *leftLineView;

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (weak, nonatomic) IBOutlet UITableView *basicTableView;

@property (weak, nonatomic) IBOutlet UITableView *circleTableView;

@property(nonatomic, copy)NSMutableArray * datasArray;

@property(nonatomic,assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewbottomConstraint;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingButton;

@property (nonatomic ,assign)BOOL isLoading;
/**
 *  行业
 */
@property (nonatomic ,copy)NSString *industry;

/**
 *  点击图片显示大图的图片侧滑显示
 */
@property (nonatomic ,strong)UIScrollView *scrollViewPictures;
/**
 *  点击图片显示大图的图片侧滑显示   的最外层window
 */
@property (nonatomic ,strong)UIWindow *bgWindow;


@property(nonatomic,strong)UILabel * PicturesLabel;

/**
 *  大图
 */
@property (nonatomic ,strong)UIImageView *imageView;

@property (nonatomic ,strong)UIImage *theSaveImage;

@property (nonatomic ,strong)UIAlertView *photoBrowserAlert;

//背景图
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
//蒙板
@property (nonatomic ,strong)UIView *cheatView;

@property (nonatomic ,strong)UIScrollView *scrollView;

@property (nonatomic ,assign)CGFloat changeImageWH;

@property (nonatomic ,strong)NSMutableArray *arrChangeBtns;

@property (nonatomic ,assign)NSInteger sourceType;
//加好友验证消息
@property (nonatomic,copy)NSString * remark;

//更换图片类型 1 代表头像 2 代表背景
@property (nonatomic ,assign)NSInteger type;

@end

@implementation SMPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self setupBtnStatus];
    
    
    if (_select) {
        [self circleBtnClick:self.circleBtn];
    }else
    {
        [self basicBtnClick:self.basicInfoBtn];
    }
    
    [self requestData];
    
    [self setupMJRefresh];
    
    [self setup];
    
    
}
#pragma mark -- 添加背景点击事件
- (void)addTapGesture{
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bjViewTap)];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bjViewTap)];
    [self.bjImageView addGestureRecognizer:tap];
    self.bjImageView.userInteractionEnabled = YES;
}

- (void)bjViewTap{
    SMLog(@"点击了 背景");
    self.type = 2;
    //防止重复创建
    if (self.cheatView != nil) {
        return;
    }
    //展示萌版
    UIView *cheatView = [[UIView alloc] init];
    self.cheatView = cheatView;
    [self.view addSubview:cheatView];
    cheatView.backgroundColor = [UIColor lightGrayColor];
    cheatView.alpha = 0.4;
    cheatView.frame = self.view.bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewTap)];
    [cheatView addGestureRecognizer:tap];
    
    
    //展示scrollView
    [self.view addSubview:self.scrollView];
    
    self.scrollView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:KAnimateTime animations:^{
        self.scrollView.frame = CGRectMake(0,KScreenHeight - self.changeImageWH - 40, KScreenWidth, self.changeImageWH);
    }];
    
    self.scrollView.contentSize = CGSizeMake((KChangeBjImageMargin + self.changeImageWH) * (KChangeBjImageCount + 1), 0);
    for (int i = 0; i < KChangeBjImageCount + 1; i++) {
        UIButton *btn = [[UIButton alloc] init];
        
        CGFloat x = KChangeBjImageMargin + (KChangeBjImageMargin + self.changeImageWH) *i;
        btn.frame = CGRectMake(x, 0, self.changeImageWH, self.changeImageWH);
        [self.scrollView addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(changeImageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //把所有的默认图片按钮 添加到数组中去
        if (i < KChangeBjImageCount) {
            [self.arrChangeBtns addObject:btn];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"personInfoBj%zd",i]] forState:UIControlStateNormal];
        }
        
        if (i == KChangeBjImageCount) {//最后一个按钮
            [btn setImage:[UIImage imageNamed:@"证件上传02000"] forState:UIControlStateNormal];
            
        }
    }
    self.scrollView.contentOffset = CGPointMake((KChangeBjImageMargin + self.changeImageWH) * (KChangeBjImageCount + 1 - 3), 0);
    
}

- (void)changeImageClick:(UIButton *)btn{
    SMLog(@"点击了切换背景按钮");
    if (btn.tag == KChangeBjImageCount) {  //如果点击的是拍照按钮
        SMLog(@"点了拍照");
        
//        [takePhoto sharePicture:^(UIImage *image) {
//            self.bjImageView.image = image;
//        }];
        UIActionSheet *sheet;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
        }
        else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
        }
        [sheet showInView:self.view];
    }else{  //点击的是  切换背景图片按钮
        SMLog(@"点了 默认的图片，实时更新背景");
        self.bjImageView.image = btn.currentBackgroundImage;
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(btn.currentBackgroundImage) forKey:KUserInfoBjImage];
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                return;
            case 1: //相机
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2: //相册
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            return;
        } else {
            self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = self.sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   //原来背景图设置
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.type == 2) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            SMLog(@"imagePickerController  image %@",image);
            self.bjImageView.image = image;
            
            //        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserInfoBjImage];
            [self cheatViewTap];
        }];
    }else{

            [picker dismissViewControllerAnimated:YES completion:nil];
            
            // info中就包含了选择的图片
            UIImage *image = info[UIImagePickerControllerEditedImage];
            [self.iconBtn setImage:image forState:UIControlStateNormal];
            
            //新头像上传到服务器
            [[SKAPI shared] updatePortrait:image block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"新头像已上传至服务器%@---%@",result,[NSThread currentThread]);
                    //新头像存到本地
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserIconImageChangeNotification object:nil userInfo:nil];
                    
                }else{
                    SMLog(@"新头像上传服务器失败error = %@",error);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"网络不给力,图片上传失败,请重试！" preferredStyle:UIAlertControllerStyleAlert];
                    alert.view.tintColor = [UIColor redColor];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:sure];
                    [self presentViewController:alert animated:YES completion:nil];
                    //恢复图片
                    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
                    [self.iconBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                }
            }];
        }
}

- (void)cheatViewTap{
    
//    [UIView animateWithDuration:KAnimateTime animations:^{
//        self.scrollView.frame = CGRectMake(0,KScreenHeight, KScreenWidth, self.changeImageWH);
//    } completion:^(BOOL finished) {
        [self.cheatView removeFromSuperview];
        self.cheatView = nil;
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
//    }];
}

- (void)setup{
    self.addFriendBtn.hidden = YES;
    self.editBtn.hidden = YES;
    
    self.settingButton.hidden = YES;
    //    [self setupInfoOthers];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    //可以改这里的哦   可以和本地的id 对比
    if (!self.user || [self.user.userid isEqualToString:userId]) {
        self.addFriendBtn.hidden = YES;
        self.settingButton.hidden = NO;
        self.tableViewbottomConstraint.constant = -44;
        self.editBtn.hidden = NO;
        //查询自身
        [self loginGetDatas];
        //给背景添加点击事件
        [self addTapGesture];
    }else
    {
//        self.addFriendBtn.hidden = NO;
        self.tableViewbottomConstraint.constant = -44;
        self.editBtn.hidden = YES;
        self.addFriendBtn.hidden = NO;
        self.settingButton.hidden = YES;
    }
    
    //如果一经是自己的好友，就显示“发起会话”，如果不是，则显示“添加到联系人”
    [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.addFriendBtn setTitle:@"添加到联系人" forState:UIControlStateNormal];
            for (User *user in array) {
                SMLog(@"[user.userid isEqualToString:self.user.userid]   %zd",[user.userid isEqualToString:self.user.userid]);
                if ([user.userid isEqualToString:self.user.userid]) {
                    [self.addFriendBtn setTitle:@"发起会话" forState:UIControlStateNormal];
                    break;
                }else{
                    [self.addFriendBtn setTitle:@"添加到联系人" forState:UIControlStateNormal];
                }
            }
        }else{
            SMLog(@"error   %@",error);
        }
    }];
    
    self.circleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.circleTableView.mj_header beginRefreshing];
}

- (void)setupInfoOthers{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if (self.user.userid.length && ![userID isEqualToString:self.user.userid]) { //如果user有值，说明这个界面是从别的地方push过来的，就需要用传递进来的user模型赋值
        self.addFriendBtn.hidden = NO;
        
        //只来到了id 其他都没拿到  需要重新请求
        [self queryUser];
        
        //[self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.user.portrait] forState:UIControlStateNormal];
        
        
    }
    NSString * uuid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if ([self.user.userid isEqualToString:uuid]) {
        self.tableViewbottomConstraint.constant = -44;
        self.addFriendBtn.hidden = YES;
        self.editBtn.hidden = NO;
    }
}

- (void)setupBtnStatus{
    //基本资料按钮
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict1[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"基本资料" attributes:dict1];
    [self.basicInfoBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict2[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"基本资料" attributes:dict2];
    [self.basicInfoBtn setAttributedTitle:str2 forState:UIControlStateSelected];
    
    //爽快圈按钮
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict3[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"爽快圈" attributes:dict3];
    [self.circleBtn setAttributedTitle:str3 forState:UIControlStateNormal];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    dict4[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict4[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"爽快圈" attributes:dict4];
    [self.circleBtn setAttributedTitle:str4 forState:UIControlStateSelected];
    
    //红线
    self.leftLineView.backgroundColor = KRedColorLight;
    self.rightLineView.backgroundColor = KRedColorLight;
    
    //头像按钮

    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    self.iconBtn.layer.cornerRadius = self.iconBtn.width * 0.5;
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.borderWidth = 2.2;
    self.iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.basicTableView.separatorColor = KGrayColorSeparatorLine;
    
    self.addFriendBtn.backgroundColor = KRedColorLight;
    self.addFriendBtn.layer.cornerRadius = SMCornerRadios;
    self.addFriendBtn.clipsToBounds = YES;

}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self.basicTableView reloadData];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    //[self requestData];
#pragma mark -- 在这尝试改头像
    
    //取出本地缓存的照片：
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    NSString *infoStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    self.infoLabel.text = [NSString stringWithFormat:@"简介：%@",infoStr];
    
    //取出用户自己选择的个性背景图片
    NSData* bjImageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfoBjImage];
    UIImage* bjImage = [UIImage imageWithData:bjImageData];
    if (bjImage) {
        self.bjImageView.image = bjImage;
    }
    
    //刷新基本资料
    //[self.basicTableView reloadData];
    
    [self setupInfoOthers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarBtnDidClick:) name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageBtnDidClick:) name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarRepostBtnClick:) name:KCircelToolRepostBtnClickNot object:nil];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSex];
    
    self.user.gender = [str isEqualToString:@"男"]?0:1;
    //刷新
    [self.basicTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]   withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolRepostBtnClickNot object:nil];
}

#pragma mark -- 点击事件
- (IBAction)backBtnClick:(UIButton *)sender {
    SMLog(@"点击了 返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editBtnClick:(UIButton *)sender {
    SMLog(@"点击了 编辑资料按钮");
    SMEditInfoController *vc = [[SMEditInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setBtnClick {
    SMLog(@"点击了 设置按钮");
    SMSettingViewController *vc = [[SMSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)basicBtnClick:(UIButton *)sender {
    SMLog(@"点击了 基本资料按钮");
    self.basicInfoBtn.selected = YES;
    self.circleBtn.selected = NO;
    
    self.basicTableView.hidden = !self.basicInfoBtn.selected;
    self.circleTableView.hidden = !self.circleBtn.selected;
    
    self.leftLineView.hidden = !self.basicInfoBtn.selected;
    self.rightLineView.hidden = !self.circleBtn.selected;
    
    
    //self.addFriendBtn.hidden = !self.basicInfoBtn.selected;
}

- (IBAction)circleBtnClick:(UIButton *)sender {
    SMLog(@"点击了 爽快圈按钮");
    
    self.basicInfoBtn.selected = NO;
    self.circleBtn.selected = YES;
    
    self.basicTableView.hidden = !self.basicInfoBtn.selected;
    self.circleTableView.hidden = !self.circleBtn.selected;
    
    self.leftLineView.hidden = !self.basicInfoBtn.selected;
    self.rightLineView.hidden = !self.circleBtn.selected;
    
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if ([self.addFriendBtn.currentTitle isEqualToString:@"添加到联系人"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否添加对方为好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alert show];
       
        __block NSString * remark = @"";
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请求添加好友验证" message:self.user.name preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [[SKAPI shared] addFriend:self.user.userid andRemark:self.remark block:^(id result, NSError *error) {
                if (!error) {
                    
                    SMLog(@"%@",result);
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }];
        // 创建按钮
        // 注意取消按钮只能添加一个
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入验证信息";
            SMLog(@"text =  = %@",textField.text);
            textField.delegate = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        
       // UITextField *text = alertController.textFields.lastObject;
        
        
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        SMLog(@"点击了发起会话");
        
//        [[SKAPI shared] queryUserProfile:self.user.userid block:^(id result, NSError *error) {
//            if (!error) {
//                User *user = (User *)result;
//                NSString *rtcKey = user.rtcKey;
//                SMChatViewController *vc = [[SMChatViewController alloc] init];
//                vc.targetRtcKey = rtcKey;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                SMLog(@"error   %@",error);
//            }
//        }];
        
//        SMChatViewController *vc = [[SMChatViewController alloc] init];
//        vc.targetRtcKey = self.user.rtcKey;
//        vc.user = self.user;
//        vc.client = self.client;
//        [self.navigationController pushViewController:vc animated:YES];
        
        //新建一个聊天会话View Controller对象
        SMNewChatViewController *chat = [[SMNewChatViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.user.userid;
        SMLog(@"user.userid = %@",chat.targetId);
        //设置聊天会话界面要显示的标题
        chat.title = self.user.name;
        chat.user = self.user;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }
    
}

- (void)alertTextFieldTextDidChange:(NSNotification *)notification
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    
    if (alert) {
        UITextField *lisen = [alert.textFields lastObject];
        self.remark = lisen.text;
        SMLog(@"%@",self.remark);
    }
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    SMLog(@"buttonIndex   %zd",buttonIndex);
    
    //如果是提示是否保存到相册的提示。并且用户点击了“是”
    if (alertView == self.photoBrowserAlert && buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.theSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return;
    }else if (alertView == self.photoBrowserAlert && buttonIndex == 0){ //如果点了取消，就直接返回
        return;
    }
    
//    if (buttonIndex == 0)  return;
    //走到这里就代表点击了确认
//    [[SKAPI shared] acceptFriend:self.user.userid andMemo:@"" andStatus:1 block:^(id result, NSError *error) {
//        if (!error) {
//            //发通知给好友列表页面，让它刷新好友页面
//            [[NSNotificationCenter defaultCenter] postNotificationName:KReloadFriendsNote object:nil];
//            
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加失败，请重新添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            SMLog(@"error    %@",error);
//        }
//    }];
    SMLog(@"self.user.userid = = =%@",self.user.userid);
    [[SKAPI shared] addFriend:self.user.userid andRemark:@"你是谁" block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"%@",result);
        }else{
            SMLog(@"%@",error);
        }
    }];
}

#pragma mark -- SMIndustryControllerDelegate
- (void)sureBtnDidClick:(NSString *)title{
    self.industry = title;
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:KUserIndustry];
    [self.basicTableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.basicTableView) {
        return 1;
    }else{
        //随便写的一个数
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.basicTableView) {
        return 7;
    }else{
        //return 1;
        return self.datasArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.basicTableView) { //基本资料
        SMBasicInfoCell *cell = [SMBasicInfoCell cellWithTableView:tableView];
        
        cell.leftLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       if (indexPath.row == 0){
            cell.leftLabel.text = @"性别";
            cell.iconImageView.image = [UIImage imageNamed:@"sex"];
            if (self.user) {
                NSInteger sex = self.user.gender;
                if (sex == 0) {
                    cell.rightLabel.text = @"未知性别";
                }else if (sex == 1){
                    cell.rightLabel.text = @"男";
                }else if (sex == 2){
                    cell.rightLabel.text = @"女";
                }
            }else{
                NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSex];
//                if (sexStr.integerValue == 0) {
//                    cell.rightLabel.text = @"";
//                }else if (sexStr.integerValue == 1){
//                    cell.rightLabel.text = @"男";
//                }else if (sexStr.integerValue == 2){
//                    cell.rightLabel.text = @"女";
//                }
                cell.rightLabel.text = sexStr;
            }
            cell.icon.hidden = YES;
       }else if(indexPath.row == 1){
           cell.leftLabel.text = @"手机号码";
           cell.iconImageView.image = [UIImage imageNamed:@"mobile"];
           if (self.user) {
               cell.rightLabel.text = self.user.phone;
           }else{
               NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserTelephoneNum];
               cell.rightLabel.text = phone;
           }
           cell.icon.hidden = YES;
       }else if (indexPath.row == 2){
           cell.leftLabel.text = @"工作电话";
           cell.iconImageView.image = [UIImage imageNamed:@"telephone"];
           if (self.user) {
               cell.rightLabel.text = self.user.workPhone;
           }else{
               NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserWorkPhone];
               cell.rightLabel.text = phone;
           }
           cell.icon.hidden = YES;
       }else if (indexPath.row == 3){
           cell.leftLabel.text = @"所在地";
           cell.iconImageView.image = [UIImage imageNamed:@"address"];
           if (self.user) {
               
               cell.rightLabel.text = self.user.address;
               
           }else{
               //cell.rightLabel.text = @"广东 广州";
               NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyAddress];
               cell.rightLabel.text = address;
           }
           
           SMLog(@"Cell.rightLabel =     %@",cell.rightLabel.text);
           
           if (cell.rightLabel.text == nil ||[cell.rightLabel.text isEqualToString:@""]) {
               cell.rightLabel.text = @"暂未设置所在地";
           }
           
            cell.icon.hidden = YES;
        }else if (indexPath.row == 4){
            NSString *companyName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
            cell.leftLabel.text = @"公司";
            cell.iconImageView.image = [UIImage imageNamed:@"company"];
            if (self.user) {
                cell.rightLabel.text = self.user.companyName;
            }else{
                cell.rightLabel.text = companyName;
            }
            cell.icon.hidden = YES;
        }else if (indexPath.row == 5){
            NSString *industryStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIndustry];
            cell.leftLabel.text = @"行业";
            cell.iconImageView.image = [UIImage imageNamed:@"industry"];
            if (self.user) {
              cell.rightLabel.text = self.user.induTag;
                if (self.user.induTag == nil) {
                    cell.rightLabel.text = @"该用户暂时没有选择行业";
                }
              //cell.rightLabel.text = industryStr;
            }else{
                cell.rightLabel.text = industryStr;
            }
            cell.icon.hidden = YES;
        }else if (indexPath.row == 6){
            cell.leftLabel.text = @"二维码";
            cell.iconImageView.image = [UIImage imageNamed:@"QRCode"];
            cell.rightLabel.text = @"";
            cell.icon.image = [UIImage imageNamed:@"erweimaHei"];
            //cell.icon.hidden = YES;
#pragma mark 有问题
//            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//            [[SKAPI shared] queryMyFollowCompany:userID block:^(NSArray *array, NSError *error) {
//                if (!error) {//获取数据成功
//                    SMLog(@"queryMyFollowCompany  请求成功");
//                    if (array.count) {//如果返回的数组不为空
//                        NSString *count = [NSString stringWithFormat:@"%zd",array.count];
//                        cell.rightLabel.text = count;
//                        
//                    }else{//如果返回的是空数组
//                        cell.rightLabel.text = @"0";
//                    }
//                }else{//获取数据失败
//                    SMLog(@"queryMyFollowCompany  请求失败");
//                }
//            }];
        }
        return cell;
    }else{//爽快圈
        //SMCircleTableViewCell *cell = [SMCircleTableViewCell cellWithtableView:tableView];
        SMCircelCell *cell = [SMCircelCell cellWithTableView:tableView];
        
        //给cell 传递模型数据
        cell.tweetFrame = self.datasArray[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.basicTableView) {
        CGFloat height;
        if (isIPhone5) {
            height = 43;
        }else if (isIPhone6){
            height = 43 * KMatch6Height;
        }else if (isIPhone6p){
            height = 43 * KMatch6pHeight;
        }else if (KScreenHeight == 480){
            height = 40;
        }
        return height;
    }else{
        //return 238;
        tweetFrame *frame = self.datasArray[indexPath.row];
        return frame.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.user) {
        if (indexPath.row == 6) {
            SMCreateErWeiMaViewController * erWeiView = [SMCreateErWeiMaViewController new];
            erWeiView.user = self.user;
            
            [erWeiView setupQrcodeWithStr:[NSString stringWithFormat:@"SK-PROFILE:%@",self.user.userid]];
            //这就是二维码
            //SMLog(@"%@);
            
            
            [self.navigationController pushViewController:erWeiView animated:YES];
            
            return;
        }else{
            return;
        }
    }
    if (tableView == self.basicTableView) {//基本资料下面的tableView
        if (indexPath.row == 6) {//点击 二维码
            //SMEditInfo2Controller *vc = [[SMEditInfo2Controller alloc] init];
            //[self.navigationController pushViewController:vc animated:YES];
            NSString * ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
            
            SMCreateErWeiMaViewController * erWeiView = [SMCreateErWeiMaViewController new];
            [erWeiView setupQrcodeWithStr:[NSString stringWithFormat:@"SK-PROFILE:%@",ID]];
            
            [self.navigationController pushViewController:erWeiView animated:YES];
        }else if (indexPath.row == 4){//点击了 行业
//            SMLog(@"点击了 行业");
//          
        }else if (indexPath.row == 2){
            SMLog(@"点击了 工作电话");
            
        }

    }else{//爽快圈tableView
        tweetFrame *tweetFrame = self.datasArray[indexPath.row];
        SMCircelDetailViewController *vc = [[SMCircelDetailViewController alloc] init];
        vc.tweetFrame = tweetFrame;
        vc.refreshBlock = ^{
            self.page = 1;
            [self requestData];
            //可以先删除数组  然后刷新当然就没了
        };
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 爽快圈的数据
-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(void)requestData
{
    NSString *ID;
    //获取到ID  //暂时只有自己的ID 若有添加朋友可相应改变此ID
    if (self.user) {
        ID = self.user.userid;
    }else{
        ID = [[NSUserDefaults standardUserDefaults]objectForKey:KUserID];
    }
    
    [[SKAPI shared] queryTweet:ID andKeyword:@"" andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array.count>0) {
                if (!self.circleTableView.mj_footer.isRefreshing) {
                    [self.datasArray removeAllObjects];
                }
                for (Tweet * tweet in array) {
                    tweetFrame * tweetf = [[tweetFrame alloc]init];
                    tweetf.tweet = tweet;
                    [self.datasArray addObject:tweetf];
                }
                [self.circleTableView reloadData];
                [self.circleTableView.mj_header endRefreshing];
                [self.circleTableView.mj_footer endRefreshing];
            }else
            {
                [self.circleTableView.mj_footer endRefreshingWithNoMoreData];
                [self.circleTableView.mj_header endRefreshing];
            }
        }else
        {
            SMLog(@"%@",error);
            [self.circleTableView.mj_header endRefreshing];
            [self.circleTableView.mj_footer endRefreshing];
        }
    }];
}

-(void)setupMJRefresh
{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        [self requestData];
    }];
    self.circleTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestData];
    }];
    self.circleTableView.mj_footer = footer;
}


- (void)toolbarBtnDidClick:(NSNotification *)notification{
    if (self.isLoading) {
        return;
    }
    UIButton *btn = notification.userInfo[KCircelToolBtnKey];
    self.tweet = notification.userInfo[KCircelTweetKey];
    self.isLoading = YES;
    
    SMLog(@"self.tweet = notification.userInfo[KCircelToolCellKey]  %@",self.tweet);
    SMLog(@"btn = notification.userInfo[KCircelToolBtnKey]   %zd",btn.tag);
    //    cell.tweetFrame.tweet
    if (btn.tag == 0) {
        SMLog(@"点击了  转发");
        SMRepostViewController *vc = [[SMRepostViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        vc.tweet = self.tweet;
        self.isLoading = NO;
    }else if (btn.tag == 1){
        SMLog(@"点击了  评论");
        SMCircelDetailViewController *vc = [[SMCircelDetailViewController alloc] init];
        tweetFrame *tweetF = [[tweetFrame alloc] init];
        tweetF.tweet = self.tweet;
        vc.tweetFrame = tweetF;
        self.isLoading = NO;
        [self.navigationController pushViewController:vc animated:NO];
        //        SMRepostViewController *vc = [[SMRepostViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
        //        vc.tweet = self.tweet;
    }else if (btn.tag == 2){
        SMLog(@"点击了   赞");
#pragma  可以先判断自己有没有点过赞，再去判断数字应该加还是减
        //接口有问题，一直错误 ，有问题
        NSString *currentTitle = btn.currentTitle;
        
        if (btn.selected) {//处于选中状态  代表自己已经赞过,继续点就是取消赞了
            [[SKAPI shared] upvoteTweet:self.tweet.id upvote:0 block:^(id result, NSError *error) {
                if (!error) {
                    if ([currentTitle isEqualToString:@"1"]) {
                        btn.selected = NO;
                        [btn setTitle:@"赞" forState:UIControlStateNormal];
                        [btn setTitle:@"赞" forState:UIControlStateSelected];
                    }else{
                        btn.selected = NO;
                        NSInteger num = currentTitle.integerValue;
                        NSString *numStr = [NSString stringWithFormat:@"%zd",num - 1];
                        [btn setTitle:numStr forState:UIControlStateNormal];
                        [btn setTitle:numStr forState:UIControlStateSelected];
                    }
                    self.isLoading = NO;
                }else{
                    SMLog(@"error    %@",error);
                }
            }];
        }else if (!btn.selected){//处于非选中状态  代表自己没有赞过，  继续点击就代表赞
            
            [[SKAPI shared] upvoteTweet:self.tweet.id upvote:1 block:^(id result, NSError *error) {
                if (!error) {
                    if ([currentTitle isEqualToString:@"赞"]) {
                        btn.selected = YES;
                        [btn setTitle:@"1" forState:UIControlStateSelected];
                        [btn setTitle:@"1" forState:UIControlStateNormal];
                    }else{
                        btn.selected = YES;
                        NSInteger num = currentTitle.integerValue;
                        NSString *numStr = [NSString stringWithFormat:@"%zd",num + 1];
                        [btn setTitle:numStr forState:UIControlStateSelected];
                        [btn setTitle:numStr forState:UIControlStateNormal];
                        
                    }
                    self.isLoading = NO;
                }else{
                    SMLog(@"error   %@",error);
                }
            }];
        }
    }
    
    
    //重新获取数据 是否会浪费流量
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self requestData];
//    });
}

#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    self.theSaveImage = image;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否保存图片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.photoBrowserAlert = alert;
    [alert show];
}

//保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}


- (void)imageBtnDidClick:(NSNotification *)notification{
    
    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
    //    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
    
    NSArray *imageStrs = notification.userInfo[@"arr"];
    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageStrs delegate:self];
    photoBrowser.initialPageIndex = btn.tag;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
    
    
//    //点击大图，不带拖拽动画的代码
//    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
//    //    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
//    
//    NSArray *imageStrs = notification.userInfo[@"arr"];
//    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
//    //    SMLog(@"imageBtnDidClick    notification    %@",btn);
//    //    UIImage *currentImage = btn.currentImage;
//    
//    
//    MHPhotoBrowserController *vc = [MHPhotoBrowserController new];
//    NSMutableArray * bigImgArray = [NSMutableArray new];
//    
//    for (NSString *imageStr in imageStrs) {
//        [bigImgArray addObject:[MHPhotoModel photoWithURL:[NSURL URLWithString:imageStr]]];
//    }
//    
//    vc.currentImgIndex = (int)btn.tag;
//    vc.displayTopPage = YES;
//    vc.displayDeleteBtn = YES;
//    vc.imgArray = bigImgArray;
//    
//    [self presentViewController:vc animated:NO completion:nil];
    
    
    
//    //最外层window
//    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
//    self.bgWindow = window;
//    
//    [window addSubview:self.scrollViewPictures];
//    self.scrollViewPictures.contentSize = CGSizeMake(KScreenWidth *imageStrs.count, KScreenHeight);
//    self.scrollViewPictures.pagingEnabled = YES;
//    self.scrollViewPictures.alpha = 1;
//    self.scrollViewPictures.delegate = self;
//    
//    //创建图片
//    for (NSInteger i = 0; i < imageStrs.count; i++) {
//        
//        UIImageView *imageView = [[UIImageView alloc] init];
//        NSURL *url = [NSURL URLWithString:imageStrs[i]];
//        //[imageView sd_setImageWithURL:url];
//        [imageView setShowActivityIndicatorView:YES];
//        [imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//        [self.scrollViewPictures addSubview:imageView];
//        imageView.frame = CGRectMake(KScreenWidth *i, 0, KScreenWidth, KScreenHeight);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        //单击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
//        [imageView addGestureRecognizer:tap];
//        
//        //捏合手势
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
//        [imageView addGestureRecognizer:pinch];
//        
//        self.imageView = imageView;
//        imageView.tag = i+1;
//        imageView.userInteractionEnabled = YES;
//    }
//    SMLog(@"self.scrollViewPictures.subviews  %@",self.scrollViewPictures.subviews);
//    self.scrollViewPictures.contentOffset = CGPointMake(KScreenWidth *btn.tag, 0);
//    
//    self.PicturesLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-25, 44, 50, 30)];
//    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%zd",btn.tag+1,imageStrs.count];
//    self.PicturesLabel.textColor = [UIColor whiteColor];
//    self.PicturesLabel.textAlignment = NSTextAlignmentCenter;
//    [window addSubview:self.PicturesLabel];
    
}

- (void)pinchScale:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    
    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%.0f",page+1,scrollView.contentSize.width/KScreenWidth];
}

- (void)imageViewTap{
    if (self.imageView.isAnimating) {
        return;
    }
    SMLog(@"imageViewTap");
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollViewPictures.alpha = 0;
        self.PicturesLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        for (UIImageView *imageView in self.scrollViewPictures.subviews) {
            if (imageView.tag > 0) {
                [imageView removeFromSuperview];
            }
        }
        [self.scrollViewPictures removeFromSuperview];
        self.scrollViewPictures = nil;
        [self.PicturesLabel removeFromSuperview];
        self.PicturesLabel = nil;
        self.bgWindow = nil;
    }];
}

- (void)toolbarRepostBtnClick:(NSNotification *)noti{
    tweetFrame *tweetF = noti.userInfo[KCircelToolRepostBtnClickNotKey];
    SMLog(@"点击了  转发灰色view中的图片");
    SMCircelDetailViewController *vc = [[SMCircelDetailViewController alloc] init];
    NSString *ID = tweetF.tweet.repostFromId;
    //    tweetFrame *tweetF = [[tweetFrame alloc] init];
    //    tweetF.tweet = self.tweet;
    [[SKAPI shared] queryTweet:ID.integerValue block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"[result class]  %@",[result class]);
            tweetFrame *tweetFOriginal = [[tweetFrame alloc] init];
            tweetFOriginal.tweet = (Tweet *)result;
            vc.tweetFrame = tweetFOriginal;
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
    //    vc.tweetFrame = ID;
}

- (UIScrollView *)scrollViewPictures{
    if (_scrollViewPictures == nil) {
        _scrollViewPictures = [[UIScrollView alloc] initWithFrame:self.bgWindow.bounds];
        _scrollViewPictures.backgroundColor = [UIColor blackColor];
    }
    return _scrollViewPictures;
}

#pragma mark - 查用户资料
-(void)queryUser
{
    [[SKAPI shared] queryUserProfile:self.user.userid block:^(id result, NSError *error) {
        if (!error) {
            self.user = (User *)result;
            
            if (self.user.intro == nil) {
                self.infoLabel.text = [NSString stringWithFormat:@"简介：%@",@"这个人好懒~ 什么都没留下"];
            }else
            {
                self.infoLabel.text = [NSString stringWithFormat:@"简介：%@",self.user.intro];
            }
            [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.user.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                SMLog(@"%@",error);
                
            }];
            self.nameLabel.text = self.user.name;
            SMLog(@"nameLabel.text   %@",self.nameLabel.text);
            [self.basicTableView reloadData];
        }else
        {
            
        }
    }];
}


#pragma mark - 查询自身的user  并写入沙盒
-(void)loginGetDatas
{
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    
    
    [[SKAPI shared] queryUserProfile:ID block:^(id result, NSError *error) {
        if (error) {//请求失败
            SMLog(@"%@",error);
        }else{//请求成功
            User * user = (User *)result;
            
            SMLog(@"%@",user);
            [[NSUserDefaults standardUserDefaults] setObject:user.userid forKey:KUserID];
            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:KUserName];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
            //[[NSUserDefaults standardUserDefaults] setObject:user.password forKey:KUserSecret];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",user.tweets] forKey:@"tweets"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",user.follows] forKey:@"follows"];
            
            //存头像
            if (user.portrait) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
                UIImage *image = [UIImage imageWithData:data];
                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            }else{
                UIImage * image = [UIImage imageNamed:@"me"];
                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:user.intro forKey:KUserInfo];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserTelephoneNum];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.address forKey:KUserCompanyAddress];
            
            [[NSUserDefaults standardUserDefaults] setObject:user.induTag forKey:KUserIndustry];
            
            if (user.gender) {
                [[NSUserDefaults standardUserDefaults] setObject:user.gender-1?@"女":@"男" forKey:KUserSex];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"未知性别" forKey:KUserSex];
            }
            
            
            [self.basicTableView reloadData];
        }
    }];
}

//头像点击
- (IBAction)iconImageViewClick:(UIButton *)sender {
    self.type = 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = [UIColor redColor];
    UIAlertAction *camara = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:camara];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;

    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark -- 懒加载
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        // 创建scrollView
        _scrollView = [[UIScrollView alloc] init];
        self.changeImageWH = (KScreenWidth - KChangeBjImageMargin *3) / 3.0;
        // 设置frame
        CGFloat scrollX = 0;
//        CGFloat scrollY = KScreenHeight;
        CGFloat scrollY = KScreenHeight - self.changeImageWH - 40;
        CGFloat scrollW = KScreenWidth;
        CGFloat scrollH = self.changeImageWH;
        _scrollView.bounces = NO;
        
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
        //设置背景颜色
        _scrollView.backgroundColor = [UIColor whiteColor];
        // 设置代理
        //_scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray *)arrChangeBtns{
    if (_arrChangeBtns == nil) {
        _arrChangeBtns = [NSMutableArray array];
    }
    return _arrChangeBtns;
}

@end
