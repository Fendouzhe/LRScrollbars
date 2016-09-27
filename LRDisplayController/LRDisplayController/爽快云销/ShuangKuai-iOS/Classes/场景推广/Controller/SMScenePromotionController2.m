//
//  SMScenePromotionController2.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScenePromotionController2.h"
#import "SMCardLayout.h"
#import "SMLeftItemBtn.h"
#import "SMScanerBtn.h"
#import "SMPersonInfoViewController.h"
#import "SMScannerViewController.h"
#import "SMCardCollectionCell.h"
#import "SMTogetherBuyWebVc.h"
#import "SMTogetherBuyController.h"
#import "SMNavigationViewController.h"
#import <MBProgressHUD.h>
#import "SMPosterController.h"
#import "SMArticleController.h"
#import "EventInvitationsViewController.h"
#import "SMArticleController.h"
#import "SMScenePageControl.h"
#import "SMSeckillListController.h"
#import "SMSeckillListController.h"

#import "SMTogetherBuyWebVc.h"
#import "SMActiveWebVc.h"
#import "SMSeckillWebController.h"
#import "AppDelegate.h"
#import "PushModel.h"
#import "SMNewPersonInfoController.h"
#import "SMPosterListVc.h"

#define KTotalCount 10000
#define KIconCount 5

@interface SMScenePromotionController2 ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 * collectionView;
 */
@property(nonatomic,strong)UICollectionView * cardView;

/**
 * 存放img名字的数组;
 */
@property(nonatomic,strong)NSMutableArray * imgArr;

@property (nonatomic ,strong)SMLeftItemBtn *leftItemBtn;/**< <#注释#> */

//@property (nonatomic ,strong)UIPageControl *pageC;/**< <#注释#> */

@property (nonatomic ,strong)SMScenePageControl *pageC;/**< <#注释#> */

@property (nonatomic, assign)CGFloat startOffSet;

@end

@implementation SMScenePromotionController2

//场景推送本地消息点击
- (void)scenePromotionNewMessageNoti:(NSNotification *)notice{
    
    NSDictionary *dict = notice.userInfo;
    if ([dict[@"type"] integerValue] == KPingTuan_71) {
        //拼团
        SMTogetherBuyWebVc *vc = [[SMTogetherBuyWebVc alloc] init];
        vc.pId = dict[@"id"];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if ([dict[@"type"] integerValue] == KMiaoSha_72) {
        //秒杀
        SMSeckillWebController *vc = [[SMSeckillWebController alloc] init];
        vc.pId = dict[@"id"];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([dict[@"type"] integerValue] == KHuoDongYaoQing_73) {
        //活动邀请
        SMActiveWebVc *vc = [[SMActiveWebVc alloc] init];
        vc.pId = dict[@"id"];
        vc.titleName = @"活动邀请";
        [self.navigationController pushViewController:vc animated:NO];
    }
}

///获取场景推广未读推送消息
- (void)unreadPushMessage{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDataArr.count>0) {
        //显示场景推广tabbar红点
        //[[NSNotificationCenter defaultCenter] postNotificationName:ShowSceneTabbarBageNotification object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }
    [appDelegate.pushDataArr enumerateObjectsUsingBlock:^(PushModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        switch (model.type) {
                
            case KPingTuan_71:{//拼团有新产品上架
                [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KPingTuanPage}];
                
            }
                break;
            case KMiaoSha_72:{//秒杀有新产品上架
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KMiaoShaPage}];
                
            }
                break;
            case KHuoDongYaoQing_73:{//有新的活动邀请
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PageControlStartAnimationNotification object:nil userInfo:@{@"index":KHuoDongYaoQingPage}];
                
            }
            default:
                break;
        }
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self createCardView];
    
    [self setupPageC];
    
    //监听本地通知点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scenePromotionNewMessageNoti:) name:ScenePromotionNewMessageNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self unreadPushMessage];
    });
    
}

- (void)setupPageC{
    
    //50 *SMMatchHeight  是UIPageControl *pageC  距离tabbar的距离
    self.pageC = [[SMScenePageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64  - 49 - 50 *SMMatchHeight, KScreenWidth, 30)];
    [self.view addSubview:self.pageC];
    self.pageC.numberOfPages = KIconCount;
    self.pageC.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageC.currentPageIndicatorTintColor = KRedColorLight;
    self.pageC.currentPage = 0;
    self.pageC.userInteractionEnabled = NO;
}

static NSString *const reuseIdentifier = @"cardCollectionCell";
//创建collectionview
- (void)createCardView{
    SMCardLayout * flowLayout = [[SMCardLayout alloc]init];
    _cardView = ({
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) collectionViewLayout:flowLayout];
        
        collectionView.delegate   = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        //提前注册
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMCardCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        
        
        CGFloat offsetX;
        if (isIPhone5) {
            offsetX = 210 *SMMatchWidth *(KTotalCount / 2 + KIconCount) - 5;
        }else if (isIPhone6){
            offsetX = 210 *SMMatchWidth *(KTotalCount / 2 + KIconCount) - 15;
        }else if (isIPhone6p){
            offsetX = 210 *SMMatchWidth *(KTotalCount / 2 + KIconCount) - 20;
        }else if (KScreenHeight == 480){
            offsetX = 210 *SMMatchWidth *(KTotalCount / 2 + KIconCount) - 30;
        }
        self.startOffSet = offsetX;
        //6p   -20  6  -10
        //[collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        collectionView.backgroundColor = KControllerBackGroundColor;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView;
    });
    [self.view addSubview:_cardView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //if (![self isViewLoaded]) {
        [_cardView setContentOffset:CGPointMake(_startOffSet, 0) animated:NO];
    //}
    //self.startOffSet = 0;
}


#pragma mark -- collectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return KTotalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //SMLog(@"%s----%lu",__func__,indexPath.item);
    SMCardCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    [cell getChange:indexPath.row % KIconCount];
    
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc = nil;
    if (indexPath.row % KIconCount == 0) {
        SMLog(@"拼团促销");
        vc = [[SMTogetherBuyController alloc] init];
        
    }else if (indexPath.row % KIconCount == 1){
        SMLog(@"活动邀请");
        vc = [[EventInvitationsViewController alloc] init];
    }else if (indexPath.row % KIconCount == 2){
        SMLog(@"微文化传播");
        vc = [[SMArticleController alloc] init];
        
    }else if (indexPath.row % KIconCount == 3){
        SMLog(@"海报推广");
        //vc = [[SMPosterController alloc] init];
        vc = [SMPosterListVc new];
        
    }else if (indexPath.row % KIconCount == 4){
        SMLog(@"秒杀");
        vc = [SMSeckillListController new];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 * 当滚动动画停止的时候调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    SMLog(@"%s",__func__);
    [self scrollViewDidEndDecelerating:scrollView];
}

//实时更新page显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self scrollViewDidEndDecelerating:scrollView];
    CGFloat width = 210 *SMMatchWidth;
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width ;
    self.pageC.currentPage = page % KIconCount;
}

/**
 * 减速完毕时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    SMLog(@"%s",__func__);
    // 获得scrollView宽度
    //    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat width = 210 *SMMatchWidth;
    SMLog(@"width  scrollViewDidEndDecelerating   %f   (self.imgArr.count - 2) * width   %f",width,(self.imgArr.count - 2) * width);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width ;
    SMLog(@"offset.x   %f   page   %zd",offset.x,page % KIconCount);
    self.pageC.currentPage = page % KIconCount;

    //    if (page == self.imgArr.count - 1) { // 最后一张
    //        //        [scrollView setContentOffset:CGPointMake(width, 0)];
    //        [scrollView setContentOffset:CGPointMake(width , 0) animated:NO]; // 不能使用动画
    //    } else if (page == 0) {
    //        [scrollView setContentOffset:CGPointMake((self.imgArr.count - 2) * width, 0)];
    //    }
    self.startOffSet = scrollView.contentOffset.x;
}

- (void)setupNav{
    
    self.title = @"推广";
    self.view.backgroundColor = KControllerBackGroundColor;
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftItemBtn = leftItemBtn;
    CGFloat wh;
    if (isIPhone5) {
        wh = KIconWH;
    }else if (isIPhone6){
        wh = KIconWH *KMatch6;
    }else if (isIPhone6p){
        wh = KIconWH * KMatch6p;
    }else if (KScreenHeight == 480){
        wh = KIconWH;
    }
    
    leftItemBtn.width = wh;
    leftItemBtn.height = wh;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //二维码
//    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
//    scanerBtn.width = 22;
//    scanerBtn.height = 22;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[[UIImage imageNamed:@"saomiaoGray"] scaleToSize:ScaleToSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanerBtnDidClick)];
}

#pragma mark -- 生命周期

- (void)leftItemDidClick:(UIButton *)leftBtn{
    SMLog(@"点击了左上角的头像按钮  %@",[leftBtn class]);
    //SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    SMNewPersonInfoController *vc = [[SMNewPersonInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanerBtnDidClick{
    SMLog(@"点击了扫描二维码的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

@end
