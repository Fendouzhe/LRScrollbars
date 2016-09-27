//
//  SMCircleHomeViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/28.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircleHomeViewController.h"
#import "tweetFrame.h"
#import "SMCircelCell.h"
#import "Tweet.h"
#import "SMComposeViewController.h"
#import "SMRepostViewController.h"
#import "SMCircelDetailViewController.h"
#import "SMLeftItemBtn.h"
#import "SMPersonCenterViewController.h"
#import "LocaltweetFrame+CoreDataProperties.h"
#import "LocalTweet.h"
#import "LocalUser.h"
#import "User.h"
#import "SMNewRigthItemVIew.h"
#import <UIImageView+WebCache.h>
#import "SMSearchViewController.h"
#import <MBProgressHUD.h>
#import "SMPersonInfoViewController.h"
#import "AppDelegate.h"
#import "MHPhotoBrowserController.h"
#import "MHPhotoModel.h"
#import "SYPhotoBrowser.h"
#import "SVProgressHUD.h"
#import "SMPersonInfoViewController.h"
#import "SMNewPersonInfoController.h"

#define KAnimateTime 0.3
@interface SMCircleHomeViewController ()<SMNewRigthItemVIewDelegate,SMRepostViewControllerDelegate,MBProgressHUDDelegate>


@property (nonatomic ,strong) NSMutableArray *tweetFrames;
/**
 *  点击爽快圈时  小图的原始frame
 */
@property (nonatomic ,assign)CGRect originalFrame;

@property (nonatomic ,assign)NSInteger page;

/**
 * 当前选中  cell 对应的模型
 */
@property (nonatomic ,strong)Tweet *tweet;

@property(nonatomic , assign)NSInteger refreshPage;

@property(nonatomic,copy)NSMutableArray * tweetArray;
/**
 *  大图
 */
@property (nonatomic ,strong)UIImageView *imageView;
/**
 *  大图背景
 */
@property (nonatomic ,strong)UIView *bgView;
/**
 *  点击图片显示大图的图片侧滑显示
 */
@property (nonatomic ,strong)UIScrollView *scrollViewPictures;
/**
 *  点击图片显示大图的图片侧滑显示   的最外层window
 */
@property (nonatomic ,strong)UIWindow *bgWindow;
/**
 *  /如果正处于点赞获取接口请求状态下
 */
@property (nonatomic ,assign)BOOL isLoading;
/**
 *  第几张
 */
@property(nonatomic,strong)UILabel * PicturesLabel;

@property (nonatomic ,strong)UIImage *theSaveImage;

@property(nonatomic,strong)SMLeftItemBtn * leftItemBtn;

@end

@implementation SMCircleHomeViewController

-(NSString *)keyWord
{
    if (!_keyWord) {
        _keyWord = [NSString string];
    }
    return _keyWord;
}
-(NSMutableArray *)tweetArray
{
    if (!_tweetArray) {
        _tweetArray = [NSMutableArray array];
    }
    return _tweetArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarBtnDidClick:) name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageBtnDidClick:) name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolbarRepostBtnClick:) name:KCircelToolRepostBtnClickNot object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allPhotosAlreadyLoad) name:KAllPhotosAlreadyLoad object:nil];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    //[self loadDatas];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.backgroundColor = KControllerBackGroundColor;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //检查当前版本，发送通知
//    [self checkCurrentVersionForNotification];
    
    [self setupNav];
    
   // [self loadDatas];
    
    // 创建上下拉刷新
    [self setupMJRefresh];
    //    //主动出发刷新
    //    [self.tableView.mj_header beginRefreshing];
    
    //进来获取本地数据
    [self loadSandBox];

    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBar) name:@"hideTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"showTabBar" object:nil];
    
}

- (void)hideTabBar{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)showTabBar{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)allPhotosAlreadyLoad{
//    [self.tableView reloadData];
}

#pragma mark -- SMRepostViewControllerDelegate
- (void)recomposeBtnDidClick{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.color = [UIColor lightGrayColor];
    //显示的文字
    HUD.labelText = @"转发成功";
    //        HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelColor = [UIColor whiteColor];
    //是否有庶罩
    [HUD hide:YES afterDelay:2];
}


#pragma mark -- 通知
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

- (void)toolbarBtnDidClick:(NSNotification *)notification{
    SMLog(@"toolbarBtnDidClick:(NSNotification *)notification ");
    if (self.isLoading) { //如果正处于点赞获取接口请求状态下，直接返回
        SMLog(@"正处于点赞获取接口请求状态下，直接返回");
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
        vc.delegate = self;
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
                        NSInteger count = num - 1;
                        if (count < 0) {
                            count = 0;
                        }
                        NSString *numStr = [NSString stringWithFormat:@"%zd",count];
                        [btn setTitle:numStr forState:UIControlStateNormal];
                        [btn setTitle:numStr forState:UIControlStateSelected];
                    }
                    self.isLoading = NO;
                    //刷新一下 model ，拿到最新的数据 model。（为了解决点赞bug）
                    [self justLoadDatas];
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
                    //刷新一下 model ，拿到最新的数据 model。（为了解决点赞bug）
                    [self justLoadDatas];
                }else{
                    SMLog(@"error   %@",error);
                }
            }];
        }
    }
    
//重新获取数据 是否会浪费流量
//    [self loadDatas];
}

#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    self.theSaveImage = image;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否保存图片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//保存到相册
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.theSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
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
    
    //    SMLog(@"imageBtnDidClick    notification    %@",btn);
    //    UIImage *currentImage = btn.currentImage;
    
//    MHPhotoBrowserController *vc = [MHPhotoBrowserController new];
//    NSMutableArray * bigImgArray = [NSMutableArray new];
    
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
   
    
//    //点击大图，不带拖拽动画的代码
//    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
////    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
//    
//    NSArray *imageStrs = notification.userInfo[@"arr"];
//    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
//    //    SMLog(@"imageBtnDidClick    notification    %@",btn);
////    UIImage *currentImage = btn.currentImage;
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
//        CGFloat w = KScreenWidth *2;
//        CGFloat h = KScreenHeight *2;
//        UIImageView *imageView = [[UIImageView alloc] init];
//        NSString *imageStr = [imageStrs[i] stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",w,h]];
//        SMLog(@"imageStr   %@",imageStr);
//        NSURL *url = [NSURL URLWithString:imageStr];
//        //[imageView sd_setImageWithURL:url];
//        [imageView setShowActivityIndicatorView:YES];
//        [imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"220"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
//        
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

//捏合手势处理事件
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

//- (void)imageVIewTap{
//    SMLog(@"又点击了 大图");
//    if ([self.imageView isAnimating]) {
//        return;
//    }
//    [UIView animateWithDuration:KAnimateTime animations:^{
//        self.imageView.frame = self.originalFrame;
//        self.imageView.alpha = 0;
//        self.bgView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.bgView removeFromSuperview];
//    }];
//}

//- (void)bigBtnClick:(UIButton *)btn{
//    SMLog(@"又点击了大图");
//
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bigBtn.frame = self.originalFrame;
//    } completion:^(BOOL finished) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.bigBtn removeFromSuperview];
//        });
//    }];
//}

- (void)loadDatas{
    
    [[SKAPI shared] queryTweet:@"" andKeyword:self.keyWord andPage:self.refreshPage andSize:8 block:^(NSArray *array, NSError *error) {
        
        if (!error) {
            SMLog(@"SMCircleHomeViewController     array   %@",array);
            NSArray *newFrames = [self tweetFramesWithTweets:array];
            
            for (Tweet *t in array) {
                SMLog(@"t.repostFrom   %@",t.repostFrom);
            }
            
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.tweetFrames removeAllObjects];
            }
            
            //[self.tweetFrames addObjectsFromArray:newFrames];
            
            for (tweetFrame *tweetF in newFrames) {
                [self.tweetFrames addObject:tweetF];
            }
            
            
//            NSInteger count = self.tweetFrames.count;
//            if (count>=8) {
//                NSRange range = NSMakeRange(0, count - 8);
//                self.tweetFrames = [NSMutableArray arrayWithArray:[self.tweetFrames subarrayWithRange:range]];
//            }
//
//            
//            for (tweetFrame *tweetF in newFrames) {
//                [self.tweetFrames addObject:tweetF];
//            }
            

            //不是搜索的时候才保存
            if (!self.isSearch) {
                //保存下来
                [self writeSandBox:self.tweetFrames];
            }

            //[self.tableView reloadData];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络异常，请检查网络!"];
            SMLog(@"%@",error);
        }
    }];
}

/**
 *  只加载数据，不刷新爽快圈列表
 */
- (void)justLoadDatas{
    
    [[SKAPI shared] queryTweet:@"" andKeyword:self.keyWord andPage:self.refreshPage andSize:8 block:^(NSArray *array, NSError *error) {
        
        if (!error) {
            SMLog(@"SMCircleHomeViewController     array   %@",array);
            NSArray *newFrames = [self tweetFramesWithTweets:array];
            
//            for (Tweet *t in array) {
//                SMLog(@"t.repostFrom   %@",t.repostFrom);
//            }
//            
//            if (!self.tableView.mj_footer.isRefreshing) {
//                [self.tweetFrames removeAllObjects];
//            }
//            
//            //[self.tweetFrames addObjectsFromArray:newFrames];
//            
//            
//            for (tweetFrame *tweetF in newFrames) {
//                [self.tweetFrames addObject:tweetF];
//            }
//            
//            //不是搜索的时候才保存
//            if (!self.isSearch) {
//                //保存下来
//                [self writeSandBox:self.tweetFrames];
//            }
            
            
            NSInteger count = self.tweetFrames.count;
            
            if (count - 8 > 0) {
                NSRange range = NSMakeRange(0, count - 8);
                self.tweetFrames = [NSMutableArray arrayWithArray:[self.tweetFrames subarrayWithRange:range]];
                
                for (tweetFrame *tweetF in newFrames) {
                    [self.tweetFrames addObject:tweetF];
                }
            }
            
            
//                        //不是搜索的时候才保存
//                        if (!self.isSearch) {
//                            //保存下来
//                            [self writeSandBox:self.tweetFrames];
//                        }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}


//讲 tweet 模型转换成 tweetFrame 模型
- (NSArray *)tweetFramesWithTweets:(NSArray *)tweets{
    
    NSMutableArray *frams = [NSMutableArray array];
    for (Tweet *tweet in tweets) {
        tweetFrame *f = [[tweetFrame alloc] init];
        f.tweet = tweet;
        SMLog(@"frame =  %lf",f.cellHeight);
        [frams addObject:f];
    }
    
    return frams;
}



- (void)setupNav{
    self.navigationItem.title = @"能量圈";
    if (!self.isSearch) {
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(composeBtnDidClick)];
        UIImage *image = [UIImage imageNamed:@"nav_search"];
        UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnDidClick)];
        self.navigationItem.rightBarButtonItems = @[button1,button3];
        //头像按钮
        SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
        self.leftItemBtn = leftItemBtn;
        leftItemBtn.width = 22;
        leftItemBtn.height = 22;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
        [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 搜索按钮
///点击了 搜索 按钮
- (void)searchBtnDidClick{
    //SMLog(@"点击了 搜索 按钮");
    SMSearchViewController * search = [SMSearchViewController new];
    search.categoryType = 2;
    [self.navigationController pushViewController:search animated:YES];
}
///点击了发布按钮
- (void)composeBtnDidClick{
    //SMLog(@"点击了发布按钮");
    SMComposeViewController *vc = [[SMComposeViewController alloc] init];
    vc.refreshBlock = ^{
        
//        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.color = [UIColor lightGrayColor];
//        //显示的文字
//        HUD.labelText = @"发布成功";
//        //        HUD.mode = MBProgressHUDModeAnnularDeterminate;
//        HUD.labelColor = [UIColor whiteColor];
//        //是否有庶罩
//        [HUD hide:YES afterDelay:2];
        [MBProgressHUD showSuccess:@"发布成功!"];
        
        self.refreshPage = 1;
        [self loadDatas];
        //延时刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)leftItemDidClick:(UIButton *)btn{
    SMLog(@"点击了左上角的头像按钮  %@",[btn class]);
    //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    SMNewPersonInfoController *vc =[[SMNewPersonInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//- (void)rightItemClick{
//    SMLog(@"点击了 爽快圈 home页面的发布按钮");
//    SMComposeViewController *vc = [[SMComposeViewController alloc] init];
//    vc.refreshBlock = ^{
//        self.refreshPage = 1;
//        [self loadDatas];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    //    SMWriteCircelViewController *vc = [[SMWriteCircelViewController alloc] init];
//    //    [self.navigationController pushViewController:vc animated:YES];
//}


//检查当前版本，发送通知
- (void)checkCurrentVersionForNotification{
    //拿到当前版本信息
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    //判断版本，在版本8.0之后，需要写下面的代码，才能在app 右上角图标上显示消息数量
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCircelCell *cell = [SMCircelCell cellWithTableView:tableView];

    //给cell 传递模型数据
    cell.tweetFrame = self.tweetFrames[indexPath.row];
    
    cell.iconblock = ^{
        //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
        SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
        User  * user = [User new];
        user.userid = [[self.tweetFrames[indexPath.row] tweet] userId];
        user.portrait = [[self.tweetFrames[indexPath.row] tweet] portrait];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    };
//    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tweetFrame *tweetFrame = self.tweetFrames[indexPath.row];
    SMCircelDetailViewController *vc = [[SMCircelDetailViewController alloc] init];
    vc.tweetFrame = tweetFrame;
    vc.refreshBlock = ^{
        //self.refreshPage = 1;
        //[self loadDatas];
        //可以先删除数组  然后刷新当然就没了
        [self.tweetFrames removeObject:tweetFrame];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tweetFrame *frame = self.tweetFrames[indexPath.row];
    
    SMLog(@"Height = %lf",frame.cellHeight);
    return frame.cellHeight;
    
}

#pragma mark -- 懒加载
- (NSMutableArray *)tweetFrames{
    if (!_tweetFrames) {
        _tweetFrames = [NSMutableArray array];
    }
    return _tweetFrames;
}

- (UIScrollView *)scrollViewPictures{
    if (_scrollViewPictures == nil) {
        _scrollViewPictures = [[UIScrollView alloc] initWithFrame:self.bgWindow.bounds];
        _scrollViewPictures.backgroundColor = [UIColor blackColor];
    }
    return _scrollViewPictures;
}

#pragma mark - 创建上下拉刷新
-(void)setupMJRefresh
{
   
    MJRefreshNormalHeader *TableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshPage = 1;
        [self loadDatas];
    }];
    self.tableView.mj_header = TableViewheader;

    MJRefreshBackNormalFooter *TableViewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.refreshPage++;
        [self loadDatas];
    }];

    self.tableView.mj_footer = TableViewfooter;
//    self.tableView.mj_footer.hidden = YES;
//    self.tableView.mj_footer.automaticallyHidden = YES;
}



//保存本地
-(void)writeSandBox:(NSArray *)array
{
        //存之前需要删除  //如果是上拉刷新 不要求删除

        for (LocalUser * user in [LocalUser MR_findAll]) {
            [user MR_deleteEntity];
        }
        for (LocaltweetFrame * tweetf in [LocaltweetFrame MR_findAll]) {
            [tweetf MR_deleteEntity];
        }
        for (LocalTweet * tweet in [LocalTweet MR_findAll]) {
            [tweet MR_deleteEntity];
        }

    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (tweetFrame * tweetf in array) {
            
            LocaltweetFrame * localtweetF = [LocaltweetFrame MR_createEntityInContext:localContext];
            //localtweetF.tweet = (NSSet *)(LocalTweet*)tweetf.tweet;
            //localtweetF.user = (NSSet *)tweetf.user;
            
            //localtweetF.tweet = [[NSSet alloc]initWithObjects:tweetf.tweet, nil];
            //localtweetF.user = [[NSSet alloc]initWithObjects:tweetf.user, nil];
            //分开存储
            LocalTweet * localtweet = [LocalTweet MR_createEntityInContext:localContext];
            localtweet.id = [NSNumber numberWithInteger:tweetf.tweet.id];
            localtweet.userId = tweetf.tweet.userId;
            localtweet.upvotes = [NSNumber numberWithInteger:tweetf.tweet.upvotes];
            localtweet.comments = [NSNumber numberWithInteger:tweetf.tweet.comments];
            localtweet.reposts = [NSNumber numberWithInteger:tweetf.tweet.reposts];
            localtweet.type = [NSNumber numberWithInteger:tweetf.tweet.type];
            localtweet.address = tweetf.tweet.address;
            localtweet.protrait = tweetf.tweet.portrait;
            localtweet.createAt = [NSNumber numberWithInteger:tweetf.tweet.createAt];
            localtweet.repostFrom = tweetf.tweet.repostFrom;
            localtweet.content = tweetf.tweet.content;
            localtweet.datas = tweetf.tweet.datas;
            localtweet.repostFromId = tweetf.tweet.repostFromId;
            localtweet.isUpvote = [NSNumber numberWithInteger:tweetf.tweet.isUpvote];
            localtweet.tweetship = localtweetF;
            //
            //            LocalUser * localuser = [LocalUser MR_createEntity];
            //            localuser.userid = tweetf.user.userid;
            //            localuser.intro = tweetf.user.intro;
            //            localuser.email = tweetf.user.email;
            //            localuser.follows = [NSNumber numberWithInteger:tweetf.user.follows];
            //            localuser.name = tweetf.user.name;
            //            localuser.password = tweetf.user.password;
            //            localuser.phone = tweetf.user.phone;
            //            localuser.portrait = tweetf.user.portrait;
            //            localuser.tweets = [NSNumber numberWithInteger:tweetf.user.tweets];
            //            localuser.rtckey = tweetf.user.rtcKey;
            //            localuser.address = tweetf.user.address;
            //            localuser.telephone = tweetf.user.telephone;
            //            localuser.companyName = tweetf.user.companyName;
            //            localuser.usership = localtweetF;
            
            //SMLog(@"Userid = %@",tweetf.user.userid);
            //localtweetF.user.anyObject.userid = tweetf.user.userid;
            
            //
#pragma haha
            localtweetF.originalViewF = NSStringFromCGRect(tweetf.originalViewF);
            localtweetF.iconViewF = NSStringFromCGRect(tweetf.iconViewF);
            localtweetF.photosViewF = NSStringFromCGRect(tweetf.photosViewF);
            localtweetF.nameLabelF = NSStringFromCGRect(tweetf.nameLabelF);
            localtweetF.timeLabelF = NSStringFromCGRect(tweetf.timeLabelF);
            localtweetF.addressLabelF = NSStringFromCGRect(tweetf.addressLabelF);
            localtweetF.contentLabelF = NSStringFromCGRect(tweetf.contentLabelF);
            localtweetF.cellHeight =  [NSNumber numberWithFloat:tweetf.cellHeight];
            localtweetF.retweetPhotosViewF = NSStringFromCGRect(tweetf.retweetPhotosViewF);
            localtweetF.retweetViewF = NSStringFromCGRect(tweetf.retweetViewF);
            localtweetF.leftIconF = NSStringFromCGRect(tweetf.leftIconF);
            localtweetF.rightContentLabelF = NSStringFromCGRect(tweetf.rightContentLabelF);
            localtweetF.toolbarF = NSStringFromCGRect(tweetf.toolbarF);
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
}

//读取本地数据
-(void)loadSandBox
{
    self.refreshPage = 1;
    NSArray * array = [LocaltweetFrame MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    if (array.count > 0) {
        for (LocaltweetFrame * localtweetf in array) {
            tweetFrame * tweetf = [tweetFrame new];
            Tweet * tweet = [[Tweet alloc]init];
            //        User * user = [[User alloc]init];
            //取出localuser
            //        LocalUser * localuser = [localtweetf.user anyObject];
            //        //给user赋值
            //        user.userid = localuser.userid;
            //        user.intro = localuser.intro;
            //        user.email = localuser.email;
            //        user.follows = localuser.follows.integerValue;
            //        user.name = localuser.name;
            //        user.password = localuser.password;
            //        user.phone = localuser.phone;
            //        user.portrait = localuser.portrait;
            //        user.tweets = localuser.tweets.integerValue;
            //        user.rtcKey = localuser.rtckey;
            //        user.address = localuser.address;
            //        user.telephone = localuser.telephone;
            //        user.companyName = localuser.companyName;
            //给模型赋值
            //tweetf.user = user;
            //获取localtweet
            LocalTweet * localtweet = [localtweetf.tweet anyObject];
            //给tweet赋值
            tweet.id = localtweet.id.integerValue;
            tweet.userId = localtweet.userId;
            tweet.upvotes = localtweet.upvotes.integerValue;
            tweet.comments = localtweet.comments.integerValue;
            tweet.reposts = localtweet.reposts.integerValue;
            tweet.type = localtweet.type.integerValue;
            tweet.address = localtweet.address;
            tweet.portrait = localtweet.protrait;
            tweet.createAt = localtweet.createAt.integerValue;
            tweet.repostFrom = localtweet.repostFrom;
            tweet.content = localtweet.content;
            tweet.datas = (NSArray *)localtweet.datas;
            tweet.repostFromId = localtweet.repostFromId;
            tweet.isUpvote = localtweet.isUpvote.integerValue;
            //给模型赋值
            tweetf.tweet = tweet;
            
            //给其他的赋值
            tweetf.originalViewF = CGRectFromString(localtweetf.originalViewF);
            tweetf.iconViewF = CGRectFromString(localtweetf.iconViewF);
            tweetf.photosViewF = CGRectFromString(localtweetf.photosViewF);
            tweetf.nameLabelF = CGRectFromString(localtweetf.nameLabelF);
            tweetf.timeLabelF = CGRectFromString(localtweetf.timeLabelF);
            tweetf.addressLabelF = CGRectFromString(localtweetf.addressLabelF);
            tweetf.contentLabelF = CGRectFromString(localtweetf.contentLabelF);
            tweetf.cellHeight = localtweetf.cellHeight.floatValue;
            tweetf.retweetPhotosViewF = CGRectFromString(localtweetf.retweetPhotosViewF);
            tweetf.retweetViewF = CGRectFromString(localtweetf.retweetViewF);
            tweetf.leftIconF = CGRectFromString(localtweetf.leftIconF);
            tweetf.rightContentLabelF = CGRectFromString(localtweetf.rightContentLabelF);
            tweetf.toolbarF = CGRectFromString(localtweetf.toolbarF);
            [self.tweetFrames addObject:tweetf];
  
        }
        
        //[self loadDatas];
       
    }else
    {
        
        [self loadDatas];
        //[self.tableView.mj_header beginRefreshing];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolBtnClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelImageClickNot object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelToolRepostBtnClickNot object:nil];
}





@end
