//
//  SMNewPersonInfoController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/5.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewPersonInfoController.h"
#import "SMPersonInfoHeaderView.h"
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
#import "SMBasicInfoCell.h"
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
#import "SMPersonInfoHeaderView.h"
#import "SMPersonInfoSectionHeaderView.h"
#import "SMBasicDataViewController.h"
#import "SMPersonInfoNav.h"
#import "SMPersonInfoBjView.h"
#import "UINavigationBar+Awesome.h"


#import "SMPersonInfoCell.h"
#import "SMPersonInfoCell2.h"
#import "SMPersonInfoCell3.h"
#import "SMNameViewController.h"
#import "SMMyCodeViewController.h"
#import "SMEditPhoneNumController.h"
#import "SMEditNumController.h"
#import "SMEditCompanyNameController.h"
#import "SMEditInfo2Controller.h"
#import "SMSexViewController.h"
#import "SMAddressViewController.h"
#import "SMCreateErWeiMaViewController.h"
#import "SMIndustryController.h"
#import "AppDelegate.h"
#import "SMWorkPhoneController.h"

#define KChangeBjImageCount 4
#define KChangeBjImageMargin 5
#define KAnimateTime 0.5
#define SMValue 100 *SMMatchHeight

@interface SMNewPersonInfoController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SMIndustryControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,SMPersonInfoHeaderViewDelegate>

@property(nonatomic, copy)NSMutableArray * datasArray;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

@property (nonatomic ,strong)UIScrollView *scrollView;

@property(nonatomic, strong)SMPersonInfoHeaderView *headerView;

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

//蒙板
@property (nonatomic ,strong)UIView *cheatView;

@property (nonatomic ,assign)CGFloat changeImageWH;

@property (nonatomic ,strong)NSMutableArray *arrChangeBtns;

@property (nonatomic ,assign)NSInteger sourceType;

//更换图片类型 1 代表头像 2 代表背景
@property (nonatomic ,assign)NSInteger type;

/**
 *  大图
 */
@property (nonatomic ,strong)UIImageView *imageView;

@property (nonatomic ,strong)UIImage *theSaveImage;

@property (nonatomic ,strong)UIAlertView *photoBrowserAlert;

@property (nonatomic ,strong)SMPersonInfoBjView *bjView;/**< <#注释#> */

@property (nonatomic ,strong)SMPersonInfoNav *nav;/**< <#注释#> */

@property (nonatomic ,strong)UIView *header;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *cheatBtn;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *addFriendBtn;

//加好友验证消息
@property (nonatomic,copy)NSString * remark;

@property (nonatomic ,strong)UIImage *iconImage;


@end


@implementation SMNewPersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupNav];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self setUpBjView];
    
    [self setupNav];
    
    [self setupTableView];
    
    [self setupCheatBtn];
    
//    self.page = 1 ;
//    [self requestData];
    
    [self setupMJRefresh];

    //发起会话或者添加好友按钮
    [self setupButton];
}

- (void)setupButton{
    
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    //是别人
    if (self.user && ![self.user.userid isEqualToString:ID]) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = KBlackColorLight;
        CGFloat width = KScreenWidth * 0.88;
        button.frame = CGRectMake((KScreenWidth-width)*0.5, KScreenHeight-44-20, width, 44);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:16*KMatch];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [self.view addSubview:button];
        self.addFriendBtn = button;
        [self.addFriendBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    }
}


- (void)setupCheatBtn{
    
    self.cheatBtn = [[UIButton alloc] init];
    [self.view addSubview:self.cheatBtn];
    self.cheatBtn.backgroundColor = [UIColor clearColor];
    
    self.cheatBtn.frame = self.bjView.icon.frame;
    self.cheatBtn.x = self.cheatBtn.x *SMMatchWidth;
    self.cheatBtn.y = self.cheatBtn.y *SMMatchHeight + 20;
    self.cheatBtn.width = self.cheatBtn.width *SMMatchWidth;
    self.cheatBtn.height= self.cheatBtn.height *SMMatchWidth;
    //SMLog(@"NSStringFromCGRect(self.bjView.icon.frame)  %@",NSStringFromCGRect(self.bjView.icon.frame));
    
    [self.cheatBtn addTarget:self action:@selector(changgeIcon) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changgeIcon{
    //是本人
    if (!self.user || [self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        self.bjView.y = 0;
        self.nav.icon.alpha = 0;
        return;
    }
   
    SMLog(@"scrollView.contentOffset.y   %f",scrollView.contentOffset.y);
    self.bjView.y = - scrollView.contentOffset.y / 2.0 ;
    self.cheatBtn.y = self.bjView.y + 64 + 20;
    SMLog(@"self.cheatBtn.y   %f",self.cheatBtn.y);
    
    if (scrollView.contentOffset.y > 10 || scrollView.contentOffset.y < 0) {
        self.cheatBtn.userInteractionEnabled = NO;
    }else{
        self.cheatBtn.userInteractionEnabled = YES;
    }
    
    self.bjView.alpha = (SMValue - scrollView.contentOffset.y) / SMValue;
    
    self.nav.icon.alpha = scrollView.contentOffset.y / SMValue;
    
    if (scrollView.contentOffset.y >= SMValue) {
        self.nav.backgroundColor = [UIColor darkGrayColor];
        self.header.backgroundColor = [UIColor darkGrayColor];
    }else{
        self.nav.backgroundColor = [UIColor clearColor];
        self.header.backgroundColor = [UIColor clearColor];
    }
    
//    self.header.backgroundColor = [UIColor redColor];
}

- (void)setupNav{
    self.nav = [SMPersonInfoNav personInfoNav];
    [self.view addSubview:self.nav];
    self.nav.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    self.nav.backgroundColor = [UIColor clearColor];
//    self.nav.backgroundColor = [UIColor blueColor];
    
    
    __block SMNewPersonInfoController *blockSelf = self;
    self.nav.backBlock = ^(){
        [blockSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.nav.settingBlock = ^(){
        SMSettingViewController *vc = [[SMSettingViewController alloc] init];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.nav.editBlock = ^(){
        SMEditInfoController *vc = [[SMEditInfoController alloc] init];
        [blockSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.nav.iconClickBlock = ^(){
        [blockSelf changgeIcon];
    };
}

- (void)setUpBjView{
    self.bjView = [SMPersonInfoBjView personInfoBjView];
    [self.view addSubview:self.bjView];
    self.bjView.frame = CGRectMake(0, 0, KScreenWidth, 178 *SMMatchHeight);
    
}

- (void)setupTableView{
    if (self.user && ![self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {//别人
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-20-44-20) style:UITableViewStyleGrouped];
    }else{//自己不显示发起会话按钮
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-20) style:UITableViewStyleGrouped];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    
//    SMPersonInfoHeaderView *headerView = [SMPersonInfoHeaderView sharedPersonInfoHeaderView];
//    headerView.bounds = CGRectMake(0, 0, KScreenWidth, 178*KMatch);
//    self.headerView = headerView;
//    self.headerView.delegate = self;
    
    self.header = [[UIView alloc] init];
    self.header.frame = CGRectMake(0, 0, KScreenWidth, 178 *SMMatchHeight - 64);
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
//    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeBackgroundImage:)];
    self.header.userInteractionEnabled = YES;
//    [self.header addGestureRecognizer:press];
    
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //是本人
    if (!self.user || [self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
        //显示编辑设置按钮
        self.nav.editBtn.hidden = NO;
        self.nav.settingBtn.hidden = NO;
        //取出本地缓存的照片：
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image) {
            [self.nav.icon setBackgroundImage:image forState:UIControlStateNormal];
            [self.bjView.icon setBackgroundImage:image forState:UIControlStateNormal];
            self.bjView.bjIcon.image = image;
        }
        self.bjView.name.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        NSString *infoStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        self.bjView.info.text = [NSString stringWithFormat:@"简介：%@",infoStr];
        
        //取出用户自己选择的个性背景图片
//        NSData* bjImageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfoBjImage];
//        UIImage* bjImage = [UIImage imageWithData:bjImageData];
//        if (bjImage) {
//            self.bjView.bjIcon.image = bjImage;
//        }
    }else{//非本人
        
        //显示编辑设置按钮
        self.nav.editBtn.hidden = YES;
        self.nav.settingBtn.hidden = YES;
        //self.nav.icon.hidden = YES;
        //非本人
        [self queryUser];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView.mj_header beginRefreshing];
//    });
    
    self.page = 1 ;
    [self requestData];
    
}

- (void)changeBackgroundImage:(UILongPressGestureRecognizer *)press{
    SMLog(@"changeBackgroundImage ");
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    //是本人
    if (!self.user || [self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
        SMLog(@"长按 背景");
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
            self.scrollView.frame = CGRectMake(0,KScreenHeight - self.changeImageWH - 20, KScreenWidth, self.changeImageWH);
            
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

}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarBtnDidClick:) name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageBtnDidClick:) name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarRepostBtnClick:) name:KCircelToolRepostBtnClickNot object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolRepostBtnClickNot object:nil];
}


-(void)requestData{
    NSString *ID;
    //获取到ID  //暂时只有自己的ID 若有添加朋友可相应改变此ID
    if (self.user) {
        ID = self.user.userid;
    }else{
        ID = [[NSUserDefaults standardUserDefaults]objectForKey:KUserID];
    }
    
    [[SKAPI shared] queryTweet:ID andKeyword:@"" andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        //NSLog(@"array = %@ ---- error = %@",array,error);
        if (!error) {
            if (array.count>0) {
                if (!self.tableView.mj_footer.isRefreshing) {
                    [self.datasArray removeAllObjects];
                }
                for (Tweet * tweet in array) {
                    tweetFrame * tweetf = [[tweetFrame alloc]init];
                    tweetf.tweet = tweet;
                    [self.datasArray addObject:tweetf];
                }
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }else
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_header endRefreshing];
            }
        }else
        {
            SMLog(@"%@",error);
            [MBProgressHUD showError:@"网络不给力,请下拉重试!"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

-(void)setupMJRefresh{
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.page = 1 ;
//        [self requestData];
//    }];
//    self.tableView.mj_header = header;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestData];
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
//        
//        return self.datasArray.count;
//    }
//}
//static NSString *const section0ReuserIdentifier = @"UITableViewCell";
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section0ReuserIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:section0ReuserIdentifier];
//        }
//        cell.textLabel.text = @"基本资料";
//        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        return cell;
//    }else{
//        SMCircelCell *cell = [SMCircelCell cellWithTableView:tableView];
//        //给cell 传递模型数据
//        cell.tweetFrame = self.datasArray[indexPath.row];
//        
//        return cell;
//    }
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        if (indexPath.row ==0) {
//            SMBasicDataViewController *vc = [[SMBasicDataViewController alloc] init];
//            vc.user = self.user;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//        //爽快圈详情
//        tweetFrame *tweetFrame = self.datasArray[indexPath.row];
//        SMCircelDetailViewController *vc = [[SMCircelDetailViewController alloc] init];
//        vc.tweetFrame = tweetFrame;
//        vc.refreshBlock = ^{
//            self.page = 1;
//            [self requestData];
//            //可以先删除数组  然后刷新当然就没了
//        };
//        [self.navigationController pushViewController:vc animated:NO];
//    }
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 44 * KMatch;
//    }else{
//        tweetFrame *frame = self.datasArray[indexPath.row];
//        return frame.cellHeight;
//    }
//    
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return nil;
//    }else if(section == 1){
//        return [SMPersonInfoSectionHeaderView sharedSectionHeaderView];
//    }
//    return nil;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.01;
//    }else if (section == 1) {
//        return 44;
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    //返回0没有效果
//    return 1;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
  NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    
  if (self.user && ![self.user.userid isEqualToString:ID]){
      
      if (indexPath.section == 0 && indexPath.row == 0){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"名字";
          cell.nameInfoLabel.text = self.user.name;
          cell.iconView.hidden = YES;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else if (indexPath.section == 0 && indexPath.row == 1){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"性别";
          if (self.user.gender == 0) {
              cell.nameInfoLabel.text = @"未知性别";
          }else if (self.user.gender == 1)
          {
              cell.nameInfoLabel.text = @"男";
          }else if (self.user.gender == 2)
          {
              cell.nameInfoLabel.text = @"女";
          }
          cell.iconView.hidden = YES;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }
      //        else if (indexPath.section == 0 && indexPath.row == 3){
      //        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
      //        cell.nameInfoLabel.hidden = YES;
      //        cell.nameLabel.text = @"我的二维码";
      //        cell.iconView.image = [UIImage imageNamed:@"erweimaHei"];
      //        return cell;
      //    }
      else if (indexPath.section == 0 && indexPath.row == 2){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"手机号码";
          cell.nameInfoLabel.text = self.user.phone;
          cell.iconView.hidden = YES;
          cell.arrowheadImageView.hidden = YES;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else if (indexPath.section == 0 && indexPath.row == 3){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"工作电话";
          cell.nameInfoLabel.text = self.user.telephone;
          cell.iconView.hidden = NO;
          //        cell.arrowheadImageView.hidden = NO;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else if (indexPath.section == 0 && indexPath.row == 4){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"行业";
          cell.nameInfoLabel.text = self.user.induTag;
          cell.iconView.hidden = NO;
          cell.arrowheadImageView.hidden = NO;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else if (indexPath.section == 0 && indexPath.row == 5){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"公司";
          cell.nameInfoLabel.text = self.user.companyName;
          cell.iconView.hidden = YES;
          cell.arrowheadImageView.hidden = YES;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else if (indexPath.section == 0 && indexPath.row == 6){
          SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
          cell.nameLabel.text = @"简介";
          cell.nameInfoLabel.text = self.user.intro;
          cell.iconView.hidden = NO;
          cell.arrowheadImageView.hidden = NO;
          cell.nameLabel.font = KDefaultFontBig;
          cell.nameInfoLabel.font = KDefaultFontBig;
          return cell;
      }else{
          SMPersonInfoCell3 *cell = [SMPersonInfoCell3 cellWithTableView:tableView];
          cell.addressLabel.text = self.user.address;
          return cell;
      }
  }
    
  if (indexPath.section == 0 && indexPath.row == 0){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        cell.nameLabel.text = @"名字";
        cell.nameInfoLabel.text = nameStr;
        cell.iconView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSex];
        cell.nameLabel.text = @"性别";
        cell.nameInfoLabel.text = sexStr;
        cell.iconView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }
    //        else if (indexPath.section == 0 && indexPath.row == 3){
    //        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
    //        cell.nameInfoLabel.hidden = YES;
    //        cell.nameLabel.text = @"我的二维码";
    //        cell.iconView.image = [UIImage imageNamed:@"erweimaHei"];
    //        return cell;
    //    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
        cell.nameLabel.text = @"手机号码";
        cell.nameInfoLabel.text = phoneStr;
        cell.iconView.hidden = YES;
        cell.arrowheadImageView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *workPhone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserWorkPhone];
        cell.nameLabel.text = @"工作电话";
        cell.nameInfoLabel.text = workPhone;
        cell.iconView.hidden = NO;
        //        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *IndustryStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIndustry];
        cell.nameLabel.text = @"行业";
        cell.nameInfoLabel.text = IndustryStr;
        cell.iconView.hidden = NO;
        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 5){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *companyStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyName];
        cell.nameLabel.text = @"公司";
        cell.nameInfoLabel.text = companyStr;
        cell.iconView.hidden = YES;
        cell.arrowheadImageView.hidden = YES;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 6){
        SMPersonInfoCell2 *cell = [SMPersonInfoCell2 cellWithTableView:tableView];
        NSString *infoStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        cell.nameLabel.text = @"简介";
        cell.nameInfoLabel.text = infoStr;
        cell.iconView.hidden = NO;
        cell.arrowheadImageView.hidden = NO;
        cell.nameLabel.font = KDefaultFontBig;
        cell.nameInfoLabel.font = KDefaultFontBig;
        return cell;
    }else{
        NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyAddress];;
        SMPersonInfoCell3 *cell = [SMPersonInfoCell3 cellWithTableView:tableView];
        cell.addressLabel.text = addressStr;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 68;
    }else if (indexPath.section == 0){
        CGFloat height;
        if (isIPhone5) {
            height = 44;
        }else if (isIPhone6){
            height = 44 *KMatch6;
        }else if (isIPhone6p){
            height = 44 *KMatch6p;
        }
        return height;
    }else{
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//    
//    if (self.user && ![self.user.userid isEqualToString:ID])
//    {
//        return;
//    }
    
//   if (indexPath.section == 0 && indexPath.row == 0) {
//        SMNameViewController *nameVc = [[SMNameViewController alloc] init];
//        [self.navigationController pushViewController:nameVc animated:YES];
//    }else if (indexPath.section == 0 && indexPath.row == 1){
//        //        SMSexViewController *vc = [[SMSexViewController alloc] init];
//        //        [self.navigationController pushViewController:vc animated:YES];
//        //弹出提示选项
//        //        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
//        //        [sheet showInView:nil];
//        UIAlertController * alertSheet = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        //取消按钮
//        UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction * manBtn =[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //保存
//            [self saveserWith:0+1];
//        }];
//        UIAlertAction * grilBtn = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //保存
//            [self saveserWith:1+1];
//        }];
//        [alertSheet addAction:cancelBtn];
//        [alertSheet addAction:manBtn];
//        [alertSheet addAction:grilBtn];
//        [self presentViewController:alertSheet animated:YES
//                         completion:nil];
//        
//    }
//   
//    else if (indexPath.section == 0 && indexPath.row == 2){  //私人电话
//        //        SMEditPhoneNumController *editPhoneNumVc = [[SMEditPhoneNumController alloc] init];
//        //        [self.navigationController pushViewController:editPhoneNumVc animated:YES];
//        
//    }else if (indexPath.section == 0 && indexPath.row == 3){ //工作电话
//        SMWorkPhoneController *vc = [SMWorkPhoneController new];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }else if (indexPath.section == 0 && indexPath.row == 4){
//        SMIndustryController *vc = [[SMIndustryController alloc] init];
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.section == 0 && indexPath.row == 5){
//        //        SMEditCompanyNameController *vc = [[SMEditCompanyNameController alloc] init];
//        //        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.section == 0 && indexPath.row == 6){
//        SMEditInfo2Controller *vc = [[SMEditInfo2Controller alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        SMAddressViewController *vc = [[SMAddressViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}



//- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
//    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
//    
//    //    self.picking = YES;
//    
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = type;
//    ipc.delegate = self;
//    ipc.allowsEditing = YES;
//    [self presentViewController:ipc animated:YES completion:nil];
//}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.iconImage = image;
    [self.tableView reloadData];
    
    //    //取：
    //    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //    UIImage* image = [UIImage imageWithData:imageData];
    
    //新头像上传到服务器
    [[SKAPI shared] updatePortrait:image block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"新头像已上传至服务器%@",result);
            //新头像存到本地
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserIconImageChangeNotification object:nil userInfo:nil];
            
            //取出本地缓存的照片：
            NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
            UIImage* image = [UIImage imageWithData:imageData];
            if (image) {
                [self.nav.icon setBackgroundImage:image forState:UIControlStateNormal];
                [self.bjView.icon setBackgroundImage:image forState:UIControlStateNormal];
                self.bjView.bjIcon.image = image;
            }
            
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
            self.iconImage = [UIImage imageWithData:data];
            [self.tableView reloadData];
        }
    }];
}

- (void)sureBtnDidClick:(NSString *)title{
    
    NSString *Industry = title;
    NSDictionary *dict = @{@"induTag":Industry};
    
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:title forKey:KUserIndustry];
            [self.tableView reloadData];
        }else{
            SMLog(@"更改 失败");
        }
    }];
}



-(void)saveserWith:(NSInteger)sex{
    
    NSString *sexStr = [NSString stringWithFormat:@"%zd",sex];
    NSDictionary *dict = @{@"gender":sexStr};
    
    [[SKAPI shared] editProfile:dict block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"更改性别 成功");
            SMLog(@"%@",result);
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:sex-1?@"女":@"男" forKey:KUserSex];
            [self.tableView reloadData];
            //[self.navigationController popViewControllerAnimated:YES];
        }else{
            SMLog(@"更改性别 失败");
        }
    }];
};


#pragma mark -  SMPersonInfoHeaderViewDelegate
//返回按钮点击
- (void)personInfoHeaderViewBackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑按钮点击
- (void)personInfoHeaderViewEditBtnClick{
//    SMEditInfoController *vc = [[SMEditInfoController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
//设置按钮点击
- (void)personInfoHeaderViewSettingBtnClick{
    SMSettingViewController *vc = [[SMSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//头像按钮点击
- (void)personInfoHeaderViewIconBtnClick:(SMPersonInfoHeaderView *)HeaderView{
    //是本人
    if (!self.user || [self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
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
    
}
//背景长按手势
- (void)personInfoHeaderViewBjImageViewLongPress:(SMPersonInfoHeaderView *)HeaderView{
    
    //是本人
    if (!self.user || [self.user.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]]) {
        SMLog(@"长按 背景");
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
            self.scrollView.frame = CGRectMake(0,KScreenHeight - self.changeImageWH - 20, KScreenWidth, self.changeImageWH);
            
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
    
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
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
        self.bjView.bjIcon.image = btn.currentBackgroundImage;
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
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    //背景图
//    
//    if (self.type == 2) {
//        [picker dismissViewControllerAnimated:YES completion:^{
//            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//            SMLog(@"imagePickerController  image %@",image);
//            self.bjView.bjIcon.image = image;
//            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserInfoBjImage];
//            [self cheatViewTap];
//        }];
//    }else{//头像
//        
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        
//        // info中就包含了选择的图片
//        UIImage *image = info[UIImagePickerControllerEditedImage];
//        [self.bjView.icon setBackgroundImage:image forState:UIControlStateNormal];
//        [self.nav.icon setBackgroundImage:image forState:UIControlStateNormal];
//        //新头像上传到服务器
//        [[SKAPI shared] updatePortrait:image block:^(id result, NSError *error) {
//            if (!error) {
//                SMLog(@"新头像已上传至服务器%@---%@",result,[NSThread currentThread]);
//                //新头像存到本地
//                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:UserIconImageChangeNotification object:nil userInfo:nil];
//                
//            }else{
//                SMLog(@"新头像上传服务器失败error = %@",error);
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"网络不给力,图片上传失败,请重试！" preferredStyle:UIAlertControllerStyleAlert];
//                alert.view.tintColor = [UIColor redColor];
//                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                }];
//                [alert addAction:sure];
//                [self presentViewController:alert animated:YES completion:nil];
//                //恢复图片
//                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
//                [self.bjView.icon setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//            }
//        }];
//    }
//}
///工具条点击
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
        vc.refreshBlock = ^{
            [self requestData];
        };
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

}

#pragma mark - 查用户资料
-(void)queryUser{
    [[SKAPI shared] queryUserProfile:self.user.userid block:^(id result, NSError *error) {
        if (!error) {
            self.user = (User *)result;
            
            if (self.user.intro == nil) {
                self.bjView.info.text = [NSString stringWithFormat:@"简介：%@",@"这个人好懒~ 什么都没留下"];
            }else{
                self.bjView.info.text = [NSString stringWithFormat:@"简介：%@",self.user.intro];
            }
            [self.bjView.icon sd_setBackgroundImageWithURL:[NSURL URLWithString:self.user.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                SMLog(@"%@",error);
            }];
            //设置
            [self.bjView.bjIcon sd_setImageWithURL:[NSURL URLWithString:self.user.portrait] placeholderImage:[UIImage imageNamed:@"220"] options:SDWebImageRetryFailed];
            [self.nav.icon sd_setBackgroundImageWithURL:[NSURL URLWithString:self.user.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                SMLog(@"%@",error);
            }];
            self.bjView.name.text = self.user.name;
            [self.tableView reloadData];
        }else{
            
        }
    }];
}

#pragma mark - 添加好友或者发起会话
- (void)addBtnClick:(UIButton *)sender {
    
    if ([self.addFriendBtn.currentTitle isEqualToString:@"添加到联系人"]) {
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
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        SMLog(@"点击了发起会话");
        //新建一个聊天会话View Controller对象
        SMNewChatViewController *chat = [[SMNewChatViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.user.userid;
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
        SMLog(@"self.remark = %@",self.remark);
    }
}
#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    self.theSaveImage = image;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否保存图片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.photoBrowserAlert = alert;
    [alert show];
}

//保存到相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

///爽快圈图片点击
- (void)imageBtnDidClick:(NSNotification *)notification{
    
    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
    //    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
    
    NSArray *imageStrs = notification.userInfo[@"arr"];
    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageStrs delegate:self];
    photoBrowser.initialPageIndex = btn.tag;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    {
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
}



#pragma mark -- 懒加载

- (UIScrollView *)scrollViewPictures{
    if (_scrollViewPictures == nil) {
        _scrollViewPictures = [[UIScrollView alloc] initWithFrame:self.bgWindow.bounds];
        _scrollViewPictures.backgroundColor = [UIColor blackColor];
    }
    return _scrollViewPictures;
}

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        // 创建scrollView
        _scrollView = [[UIScrollView alloc] init];
        self.changeImageWH = (KScreenWidth - KChangeBjImageMargin *3) / 3.0;
        // 设置frame
        CGFloat scrollX = 0;
        //        CGFloat scrollY = KScreenHeight;
        CGFloat scrollY = KScreenHeight - self.changeImageWH - 20;
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

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}



@end
