//
//  SMVideoViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SMLoginViewController.h"
#import "SMTabBarViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <AVIMClient.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>
#import "AppDelegate.h"

@interface SMVideoViewController ()

@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;

@property(nonatomic ,strong)AVAudioSession *avaudioSession;

@property (nonatomic ,assign)NSInteger flag;

@property(nonatomic ,strong)UIActivityIndicatorView *indicatorView;

@end

@implementation SMVideoViewController

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //连接哥推通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectGetuiNoti:) name:ConnectGetuiNotification object:nil];
    
    //[RCIM sharedRCIM].receiveMessageDelegate = self;
    
    [self autoLogin];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViedeoUI];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginBgImage];
    UIImage *image = [UIImage imageWithData:data];
    imageView.image = image;
    
    [UIView animateWithDuration:3 animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.3, 1.3);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        //没有开机视频
        if (self.viedeoUrlStr.length == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginVideoUrl] length] == 0) {
            SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = vc;
        }
    }];
}

- (void)autoLogin{
    [[SKAPI shared] signInWithAccount:[[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount] andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret] andSocial:@"" block:^(id result, NSError *error) {
        ////[[SKAPI shared] relist];
        if (!error) {
            User *user = [User mj_objectWithKeyValues:[result valueForKey:@"user"]];
            
            [[RCIM sharedRCIM] connectWithToken:user.rcToken success:^(NSString *userId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:user.userid name:user.name portrait:user.portrait];
                    [RCIM sharedRCIM].currentUserInfo = userInfo;
                    //        [[RCIM sharedRCIM] setUserInfoDataSource:weakSelf];
                    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KUserChatID];
                });
                
                SMLog(@"融云连接成功 result = %@ error = %@",result,error);
            } error:^(RCConnectErrorCode status) {
                SMLog(@"融云连接错误 status = %lu  result = %@ error = %@",status,result,error);
            } tokenIncorrect:^{
                SMLog(@"token错误");
            }];
            //保存启动图片数据和视频路径
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.appLoginBg]];
            if (data) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:KAppLoginBgImage];
            }
            [[NSUserDefaults standardUserDefaults] setObject:user.appLoginVideo forKey:KAppLoginVideoUrl];
            
        }
        
        [[SKAPI shared] appendToken];
        //连接个推 不建议在改控制器连接，因为个推还未连接就进入下一个控制器，会导致连接失败
        //[self connectGetuiNoti:nil];
        
    }];
}

///连接哥推
- (void)connectGetuiNoti:(NSNotification *)notice{
    //哥推等
    //    AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *geTuiClientId = notice.userInfo[@"geTuiClientId"];
    //    NSString *geTuiClientId = nil;
    //    if (appdelegate.geTuiClientId) {
    //        geTuiClientId = appdelegate.geTuiClientId;
    //    }else{
    //        geTuiClientId = notice.userInfo[@"geTuiClientId"];
    //    }
    SMLog(@"geTuiClientId = %@",geTuiClientId);
    //注册聊天的Client
    if (geTuiClientId) {
        [[SKAPI shared] bindClientId:geTuiClientId block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"哥推连接成功：%@",result);
            }else{
                SMLog(@"哥推连接失败：%@",error);
            }
        }];
    }
}

- (void)setupViedeoUI{
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    //    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"LEVVVXHOTHEART唐禹哲开业视频.mp4" ofType:nil];
    //    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:nil];
    //    NSURL *url = [NSURL fileURLWithPath:urlStr];
    NSURL *url = nil;
    if (self.viedeoUrlStr.length) {
        url = [NSURL URLWithString:self.viedeoUrlStr];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginVideoUrl] length]){
        url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:KAppLoginVideoUrl]];
    }
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //_moviePlayer.view.backgroundColor = [UIColor whiteColor];
    [_moviePlayer.view setFrame:self.view.bounds];
    
    [self.view addSubview:_moviePlayer.view];
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setFullscreen:NO];
    
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadSate:) name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    //[MBProgressHUD showMessage:@" " toView:_moviePlayer.view];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView = indicatorView;
    CGFloat width = 88*KMatch;
    indicatorView.frame = CGRectMake((KScreenWidth-width)*0.5, (KScreenHeight-width)*0.5, width, width);
    [_moviePlayer.view addSubview:indicatorView];
    [indicatorView startAnimating];
    //[_moviePlayer play];
    
    //跳过按钮
    UIButton *passBtn = [[UIButton alloc] init];
    [passBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    [passBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]];
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:passBtn];
    passBtn.layer.cornerRadius = SMCornerRadios;
    passBtn.titleLabel.font = [UIFont systemFontOfSize:16*KMatch];
    passBtn.clipsToBounds = YES;
    //passBtn.alpha = 0.6;
    [passBtn addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        //        make.top.equalTo(self.view.mas_top).with.offset(10);
        //        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-58);
        make.width.equalTo(@(88*KMatch));
        make.height.equalTo(@(36*KMatch));
    }];
    
}
//点击了立即进入按钮;
- (void)passBtnClick{
    
    [self.moviePlayer stop];
    
    SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
    //[self presentViewController:vc animated:YES completion:nil];
}

//播放状态
-(void)playbackStateChanged{
    //取得目前状态
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    
    //状态类型
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            
            break;
        case MPMoviePlaybackStatePlaying:
        {
            SMLog(@"播放中");
            //            self.flag++;
            //            if (self.flag > 1) {
            //                UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //                SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
            //                window.rootViewController = vc;
            //                //[self presentViewController:vc animated:YES completion:nil];
            //            }
            break;
        }
        case MPMoviePlaybackStatePaused://播放完成，暂停
            
        {
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
            //            window.rootViewController = vc;
            //            //[self presentViewController:vc animated:YES completion:nil];
            
        }
            break;
            
        case MPMoviePlaybackStateInterrupted:
            SMLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            SMLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            SMLog(@"往后快转");
            break;
            
        default:
            SMLog(@"无法辨识的状态");
            break;
    }
}

//
- (void)movieLoadSate:(NSNotification *)notice{
    NSLog(@"LoadSate: notice = %@",notice.userInfo);
    switch (_moviePlayer.loadState) {
        case MPMovieLoadStateUnknown://未知状态
        {
            NSLog(@"LoadSate: MPMovieLoadStateUnknown");
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            SMTabBarViewController *vc = [[SMTabBarViewController alloc] init];
            window.rootViewController = vc;
        }
            break;
        case MPMovieLoadStatePlayable://可以播放
        {
            SMLog(@"LoadSate: MPMovieLoadStatePlayable");
            [_indicatorView stopAnimating];
            [_moviePlayer play];
            
        }
            break;
        case MPMovieLoadStatePlaythroughOK://加载完成
        {
            NSLog(@"LoadSate: MPMovieLoadStatePlaythroughOK");
        }
            break;
        case MPMovieLoadStateStalled:
        {
            NSLog(@"LoadSate: MPMovieLoadStateStalled");
        }
            break;
        default:
            break;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
