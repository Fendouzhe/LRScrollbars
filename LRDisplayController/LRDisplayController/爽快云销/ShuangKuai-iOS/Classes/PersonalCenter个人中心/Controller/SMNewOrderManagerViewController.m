//
//  SMNewOrderManagerViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewOrderManagerViewController.h"
#import "SMOrderSubViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SMSearchViewController.h"
#import "LocalSalesOrder.h"
#import "AppDelegate.h"
#import "SingtonManager.h"
#import "SMOrderManagerTopView.h"
#import "SMSearchViewController.h"
#import "SMSearchView.h"

@interface SMNewOrderManagerViewController ()<UIScrollViewDelegate,SMOrderManagerTopViewDelegate, SMSearchViewDelegate>
/**
 *  装载控制器的滑动视图
 */
@property(nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic ,strong)SMOrderManagerTopView *topView;

@property (nonatomic ,assign)NSInteger currentPage; /**< 当先显示哪个状态的 */

@property (nonatomic ,strong)UIView *searchView;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *searchBtn;/**< <#注释#> */

@property (nonatomic ,strong)UIView *bottomView;/**< <#注释#> */


@property (nonatomic, strong) UIView *backgroundView;  // 弹窗背景的View

@property (nonatomic, strong) SMSearchView *searchVc;

@property (nonatomic, strong) SMOrderSubViewController * Vc;//存放点击的图标对应的控制器

@end

@implementation SMNewOrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self createNav];
    
    [self setupSearchView];
    
    [self createTopView];
    
    //下面承载控制器的scrollView
    [self createScrollView];
    //添加控制器
    [self addViewController];
    
    ///清除订单管理消息红点
    SingtonManager * sington = [SingtonManager sharedManager];
    NSMutableArray * array = [NSMutableArray array];
    for (Msg * msg in sington.orderArray) {
        [array addObject:msg.messageId];
    }
    SMLog(@"array = %@",array);
    [[SKAPI shared] receiptMessage:[array copy] block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [sington.orderArray removeAllObjects];
            sington.orderNum = sington.orderArray.count;
        }else{
            SMLog(@"%@",error);
        }
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    self.navigationController.navigationBar.hidden = NO;
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}
-(void)createNav
{
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightClick) image:@"产品库(fangdajing)" highImage:@"产品库(fangdajing)"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"liebiao02"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
}
-(void)rightClick
{
    SMLog(@"点击了rightitem");
    
    [self addSearchVc];
   
//    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
//    vc.categoryType = 5;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupSearchView{
    self.searchView = [[UIView alloc] init];
    self.searchView.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:self.searchView];
    
    NSNumber *searchViewHeight = [NSNumber numberWithFloat:44];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(searchViewHeight);
    }];
    
    //分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self.searchView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
    
            //        make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.searchView.mas_bottom).with.offset(0);
            make.left.equalTo(self.searchView.mas_left).with.offset(0);
            make.right.equalTo(self.searchView.mas_right).with.offset(0);
            make.height.equalTo(@1);
        }];
    
    
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setImage:[UIImage imageNamed:@"fangdajing2"] forState:UIControlStateNormal];
    [self.searchView addSubview:self.searchBtn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" 搜索订单" attributes:dict];
    [self.searchBtn setAttributedTitle:str forState:UIControlStateNormal];
    self.searchBtn.backgroundColor = [UIColor whiteColor];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.layer.cornerRadius = SMCornerRadios;
    self.searchBtn.clipsToBounds = YES;
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.searchView.mas_top).with.offset(8);
        make.left.equalTo(self.searchView.mas_left).with.offset(15);
        make.right.equalTo(self.searchView.mas_right).with.offset(-15);
        make.bottom.equalTo(self.searchView.mas_bottom).with.offset(-8);
    }];
    
    
}


- (void)addSearchVc{
    if (self.backgroundView) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    UIView *backgroundView = [[UIView alloc] init];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = [UIColor blackColor];
    
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackgroundView)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.frame = window.bounds;
    
    SMSearchView *searchVc = [SMSearchView searchView];
    searchVc.delegate = self;
    searchVc.layer.cornerRadius = 10;
    
    searchVc.layer.masksToBounds = YES;
    
    [window addSubview:searchVc];
    self.searchVc = searchVc;
    [self.searchVc mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@(200*KMatch));
        make.height.equalTo(@(335*KMatch));
    }];
    
    // 动画
    backgroundView.alpha = 0;
    searchVc.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        searchVc.transform = CGAffineTransformMakeScale(1, 1);
        backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeBackgroundView
{
    [UIView animateWithDuration:0.35 animations:^{
        self.searchVc.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
        [self.searchVc removeFromSuperview];
        self.searchVc = nil;
    }];
}

- (void)searchBtnClick{
    SMLog(@"点击了 搜索");
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 5;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮视图
-(void)createTopView{
    
    SMOrderManagerTopView *topView = [SMOrderManagerTopView orderManagerTopView];
    [self.view addSubview:topView];
    topView.delegate = self;
    topView.frame = CGRectMake(0, 44, KScreenWidth, 80 *SMMatchHeight);
    self.topView = topView;
}

#pragma mark -- SMOrderManagerTopViewDelegate
- (void)refundDidClick{
    SMLog(@"点击了 退款");
    self.currentPage = 6;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)alreadyClosedDidClick{
    SMLog(@"点击了  已关闭");
    self.currentPage = 5;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)alreadyDoneDidClick{
    SMLog(@"点击了  已完成");
    self.currentPage = 4;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)alreadyDispatchGoodsDidClick{
    SMLog(@"点击了  已发货");
    self.currentPage = 3;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)alreadyPayDidClick{
    SMLog(@"点击了  已付款");
    self.currentPage = 2;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)waitForPayDidClick{
    SMLog(@"点击了  待付款");
    self.currentPage = 1;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}

- (void)allOrderDidClick{
    SMLog(@"点击了  全部订单");
    self.currentPage = 0;
    self.Vc = self.childViewControllers[self.currentPage];
    self.scrollView.contentOffset = CGPointMake(KScreenWidth *self.currentPage, 0);
}


#pragma 点击事件
-(void)btnClick:(UIButton *)btn
{
    SMLog(@"%zd",btn.tag);
    //确定选中的按钮  同时确定scrollView的偏移
    UIView * view = [self.view viewWithTag:20];
    for (NSInteger i=0; i<5; i++) {
        UIButton * b = [view viewWithTag:10+i];
        if (btn.tag == b.tag) {
            btn.selected = YES;
            UILabel * line = [view viewWithTag:btn.tag+20];
            line.hidden = NO;
            //确定偏移
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentOffset = CGPointMake(i*KScreenWidth, 0);
            }];
        }else
        {
            b.selected = NO;
            UILabel * line = [view viewWithTag:b.tag+20];
            line.hidden = YES;
        }
    }

}


#pragma mark - scrollView
-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*5, KScreenHeight-108-10);
    //self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    //加约束
    //获取TopView
//    UIView * topView = [self.view viewWithTag:20];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    SMLog(@"减速回调");
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    //确定选中的按钮
    UIView * view = [self.view viewWithTag:20];
    [UIView animateWithDuration:0.5 animations:^{
        for (NSInteger i=0; i<5; i++) {
            UIButton * b = [view viewWithTag:10+i];
            if (i==page) {
                b.selected = YES;
                UILabel * line = [view viewWithTag:b.tag+20];
                line.hidden = NO;
            }else
            {
                b.selected = NO;
                UILabel * line = [view viewWithTag:b.tag+20];
                line.hidden = YES;
            }
        }
    }];
   
}

#pragma maek -- <SMSearchViewDelegate>
- (void)cancelBtnClick
{
    [self removeBackgroundView];
}


- (void)didSelectedType:(NSInteger)type
{
    [self removeBackgroundView];
    
    [self.Vc requestType:type];
    
    
}

#pragma mark - 添加控制器
-(void)addViewController{
    //循环创建控制器
    for (NSInteger i = -1; i < 6; i++) {
        SMOrderSubViewController * Vc = [SMOrderSubViewController new];
        
        //确定状态
        Vc.type = i;
        [self addChildViewController:Vc];
        [self.scrollView addSubview:Vc.view];
        
        //加约束
        [Vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).with.offset(0);
            make.left.equalTo(self.scrollView.mas_left).with.offset(KScreenWidth*(i + 1));
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.scrollView.mas_height);
        }];
        
    }
    self.Vc = self.childViewControllers[0];
}

@end
