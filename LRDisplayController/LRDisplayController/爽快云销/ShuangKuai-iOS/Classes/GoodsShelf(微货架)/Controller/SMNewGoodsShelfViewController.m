//
//  SMNewGoodsShelfViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewGoodsShelfViewController.h"
#import "SMShelfProductViewController.h"
#import "SMShelfDiscountController.h"
#import "LocalFavorites.h"
#import "SMProductDetailController.h"
#import "SMDiscountDetailController.h"
#import "SMPersonInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SMShoppingCartController.h"
#import "AppDelegate.h"
#import "UIButton+Badge.h"
#import "SMNewOrderManagerViewController.h"
#import "SMShelfHotProductController.h"
#import "SMShareMenu.h"
#import "SMNewShelfManagerController.h"
#import "SMStroreHouseForShelfController.h"


#define KPikerVIewHeight 200
#define KInvitePartner [NSString stringWithFormat:@"%@sk_invite.html",SKAPI_PREFIX_SHARE]
#define KInviteShelf [NSString stringWithFormat:@"%@sk_sales.html",SKAPI_PREFIX_SHARE]

//#define KWebString @"http://www.shuangkuai.co:1224/shuangkuai_app/sk_sales.html"

@interface SMNewGoodsShelfViewController ()<SMShelfDiscountControllerDelegate,SMShelfProductViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,SMShareMenuDelegate,SMShelfHotProductControllerDelegate>
/**
 *  头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  名字
 */
@property (strong, nonatomic) IBOutlet UILabel *customerName;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  分享的按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
///**
// *  切换货架的按钮
// */
//@property (strong, nonatomic)UIButton *cutShelfBtn;
///**
// *  购物车按钮
// */
//@property (strong, nonatomic)UIButton *shopBtn;
///**
// *  查看订单按钮
// */
//@property (strong, nonatomic)UIButton *orderBtn;
///**
// *  合伙人按钮
// */
//@property (strong, nonatomic)UIButton *partnerBtn;

/**
 *  热销商品按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *goodsBtn;
/**
 *  优惠券按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *discountBtn;
/**
 *  左边的红线
 */
@property (strong, nonatomic) IBOutlet UIView *leftLine;
/**
 *  右边的红线
 */
@property (strong, nonatomic) IBOutlet UIView *rightLine;
/**
 *  承载控制器的scrollView
 */
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  货架的ID
 */
@property (nonatomic,strong)Favorites * favorites;
/**
 *  第一页 产品
 */
@property (nonatomic ,strong)SMShelfProductViewController *vc;

/**
 *  第二页 优惠券
 */
@property (nonatomic ,strong)SMShelfDiscountController *vc2;

/**
 *  新的产品界面
 */
@property (nonatomic ,strong)SMShelfHotProductController *vc3;

/**
 *  便于切换货架
 */
@property (nonatomic,copy)NSMutableArray * favIdArray;

/**
 *  选择几号微货架
 */
@property (nonatomic ,strong)UIPickerView *pickerView;
/**
 *  出现选择微货架时的蒙板
 */
@property (nonatomic ,strong)UIView *bgGrayView;

@property (nonatomic ,strong)NSMutableArray *arrPickerSouce;

/**
 *  确定
 */
@property (nonatomic ,strong)UIButton *sureBtn;

@property (nonatomic ,assign)NSInteger count;

@property (nonatomic ,copy)NSString *webStr;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midViewheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH4;

//调色
@property (weak, nonatomic) IBOutlet UIView *midGrayView;

@property (weak, nonatomic) IBOutlet UIView *topGrayLine;

@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;

//创建四个按钮的父控件view
@property (weak, nonatomic) IBOutlet UIView *midView;

//新创建的四个按钮view
//邀请合伙人
@property (weak, nonatomic) IBOutlet UIView *partnerView;
//切换柜台
@property (weak, nonatomic) IBOutlet UIView *cutShelfView;
//查看订单
@property (weak, nonatomic) IBOutlet UIView *orderView;
//购物车
@property (weak, nonatomic) IBOutlet UIView *cartView;

@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;

@property(nonatomic,strong)UIButton * cutShelfBtn;

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;

@property (strong, nonatomic) IBOutlet UIImageView *bjImageView;
//选择“热销产品”“优惠券”的view
@property (weak, nonatomic) IBOutlet UIView *menuView;

@end

@implementation SMNewGoodsShelfViewController

#pragma mark - 懒加载
-(Favorites *)favorites{
    if (!_favorites) {
        _favorites = [Favorites new];
    }
    return _favorites;
}
-(NSMutableArray *)favIdArray{
    if (!_favIdArray) {
        _favIdArray = [NSMutableArray array];
    }
    return _favIdArray;
}
- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight - KTabBarHeight - KPikerVIewHeight + 20, KScreenWidth, KPikerVIewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (NSMutableArray *)arrPickerSouce{
    if (_arrPickerSouce == nil) {
        _arrPickerSouce = [NSMutableArray array];
    }
    return _arrPickerSouce;
}

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProducts:) name:KRefreshCounterProductNoti object:nil];
    
    self.navigationController.navigationBar.hidden = YES;
    

    [self requestShelfData];
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    //刷新角标
    NSNumber *  num = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfCount];
    
    [self.cutShelfBtn showBadgeWith:num.stringValue];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.iconImageView.image = image;
    }
    
    NSData* bjImageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfoBjImage];
    UIImage* bjImage = [UIImage imageWithData:bjImageData];
    if (bjImage) {
        self.bjImageView.image = bjImage;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *currentStr = SKAPI_PREFIX;
//    NSString *headStr = [[currentStr componentsSeparatedByString:@"api"] firstObject];
//    NSString *footStr = @"shuangkuai_app/sk_sales.html";
    self.webStr = KInviteShelf;
    self.view.backgroundColor = KControllerBackGroundColor;
    
    
    //[self requestShelfData];
    
    [self refreshUI];
    
    [self addGesture];

//    [self.shopBtn showBadgeWith:@"999"];
//    [self.partnerBtn showBadgeWith:@"99"];
//    [self.cutShelfBtn showBadgeWith:@"9"];
//    [self.orderBtn showBadgeWith:@"99+"];
    
    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    if (!level2) {
        //1级
    }else{
        CGFloat width = KScreenWidth/4;
        CGFloat magrin = (KScreenWidth-3*width)/4;
        CGFloat height = self.midView.height;
        //2级
        self.partnerView.hidden = YES;
        //先约中间的
        [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
            make.centerY.equalTo(self.view.mas_centerY).with.offset(0);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
        [self.cutShelfView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.midView.mas_centerY).with.offset(0);
            make.right.equalTo(self.orderView.mas_left).with.offset(-magrin);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
        [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.midView.mas_centerY).with.offset(0);
            make.left.equalTo(self.orderView.mas_right).with.offset(magrin);
            make.width.with.offset(width);
            make.height.with.offset(height);
        }];
    }
    
    //1.5.1  隐藏优惠券代码
    self.menuView.hidden = YES;
    if (self.menuView.hidden) {
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.midGrayView.mas_bottom).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
    }
    
}

- (void)refreshProducts:(NSNotification *)noti{
    
    NSInteger selectesNum = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        if (!error) {
            self.favorites = array[selectesNum];
            [self setupScrollViewWith:self.favorites];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}


- (void)addGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(partnerViewTap)];
    [self.partnerView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cutShelfViewTap)];
    [self.cutShelfView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewTap)];
    [self.orderView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartViewTap)];
    [self.cartView addGestureRecognizer:tap4];
}

#pragma mark -- 点击手势事件
- (void)partnerViewTap{
    SMLog(@"点击了 邀请合伙人");
    [self addShareMemu];
}

- (void)addShareMemu{
    if (self.cheatView2) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    UIView *cheatView2 = [[UIView alloc] init];
    self.cheatView2 = cheatView2;
    cheatView2.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCheatView2)];
    [cheatView2 addGestureRecognizer:tap];
    cheatView2.frame = window.bounds;
    
    SMShareMenu *menu = [SMShareMenu shareMenu];
    menu.delegate = self;
    [window addSubview:menu];
    self.menu = menu;
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@300);
        make.height.equalTo(@270);
    }];
    
    // 动画
    cheatView2.alpha = 0;
    menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        menu.transform = CGAffineTransformMakeScale(1, 1);
        cheatView2.alpha = 0.4;
    } completion:^(BOOL finished) {
        
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

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
    if (self.cheatView2) {  // 邀请合伙人
        SMLog(@"邀请合伙人");
        NSDate *localeDate = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
        image = [self scaleToSize:image size:CGSizeMake(100, 100)];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
        NSString *eid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
        
        NSString *para = [NSString stringWithFormat:@"?uid=%@&eid=%@&t=%@",uid,eid,timeSp];
        NSString *path = KInvitePartner;
        NSURL *url = [NSURL URLWithString:[path stringByAppendingString:para]];
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:@"点击查看更多详情"
                                         images:image
                                            url:url
                                          title:@"邀请朋友"
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
        
    }else if (self.cheatView3){  //分享微柜台
        SMLog(@"分享微柜台");
        NSDate *localeDate = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
        SMLog(@"timeSp :%@",timeSp); //时间戳的值
        
        //取出照片：
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
        image = [self scaleToSize:image size:CGSizeMake(100, 100)];
        NSArray* imageArray = @[image];
        
        
        NSString *para = [NSString stringWithFormat:@"?favId=%@&mode=1",self.favorites.id];
        
        NSString *urlStr = [self.webStr stringByAppendingString:para];
        
        
        
        NSString *headStr = [[urlStr componentsSeparatedByString:@"&"] firstObject];
        SMLog(@"headStr   %@",headStr);
        NSString *urlStrEnd = [headStr stringByAppendingString:[NSString stringWithFormat:@"&mode=0&t=%@",timeSp]];
        
        NSString *urlChang1 = [urlStrEnd stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString *urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        SMLog(@"urlChang5   %@",urlChang5);
        /*
        if (type == 22) { //分享到微信
            urlChang5 = [Utils createOauthUrlForCode:@"wx0cc9d5092f1a711c" andRedirectUrl:urlChang5 andMoreinfo:NO];
        }
        */
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"这些宝贝很不错喔！"
                                         images:imageArray
                                            url:[NSURL URLWithString:urlChang5]
                                          title:[NSString stringWithFormat:@"%@的柜台",userName]
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
    
}

- (void)removeCheatView2{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView2.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView2 removeFromSuperview];
        self.cheatView2 = nil;
        [self.menu removeFromSuperview];
        self.menu = nil;
    }];
}


- (void)cutShelfViewTap{
    SMLog(@"点击了 切换柜台");
//    //弹出pickView
//    if (self.favIdArray.count>0) {
//        [self showPickerView];
//    }else{
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有柜台，请添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
    
    SMNewShelfManagerController *vc = [[SMNewShelfManagerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)orderViewTap{
    SMLog(@"点击了 查看订单");
    SMNewOrderManagerViewController * manager = [SMNewOrderManagerViewController new];
    
    [self.navigationController pushViewController:manager animated:YES];
}

- (void)cartViewTap{
    SMLog(@"点击了 购物车");
    //添加购物车
    SMShoppingCartController * shopping = [SMShoppingCartController new];
    
    [self.navigationController pushViewController:shopping animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI相关
-(void)refreshUI{
    
    self.iconImageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personClick)];
    [self.iconImageView addGestureRecognizer:tap];
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    
    self.iconImageView.image = [UIImage imageWithData:data];
    
    self.nameLabel.text = [NSString stringWithFormat:@"掌柜：%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserName]];
    
    
    
    //进来时  默认选择  热销商品
    [self goodsAction:self.goodsBtn];
    
    [self.favIdArray removeAllObjects];
    
    //请求到数据
    //[self requestShelfData];
    
    if (isIPhone5) {
        self.topViewHeight.constant = 135;
        self.iconW.constant = 50;
        self.midViewheight.constant = 55;
        self.iconW1.constant = 25;
        self.iconW2.constant = 25;
        self.iconW3.constant = 25;
        self.iconW4.constant = 25;
    }else if (isIPhone6){
        self.topViewHeight.constant = 135 *KMatch6Height;
        self.iconW.constant = 50 *KMatch6;
        self.midViewheight.constant = 55 *KMatch6Height;
        self.iconW1.constant = 25 *KMatch6Height;
        self.iconW2.constant = 25 *KMatch6Height;
        self.iconW3.constant = 25 *KMatch6Height;
        self.iconW4.constant = 25 *KMatch6Height;
    }else if (isIPhone6p){
        self.topViewHeight.constant = 135 *KMatch6pHeight;
        self.iconW.constant = 50 *KMatch6p;
        self.midViewheight.constant = 55 *KMatch6pHeight;
        self.iconW1.constant = 25 *KMatch6pHeight;
        self.iconW2.constant = 25 *KMatch6pHeight;
        self.iconW3.constant = 25 *KMatch6pHeight;
        self.iconW4.constant = 25 *KMatch6pHeight;
    }
    self.iconH.constant = self.iconW.constant;
    self.iconImageView.layer.cornerRadius = self.iconH.constant / 2.0;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconH1.constant = self.iconW1.constant;
    self.iconH2.constant = self.iconW2.constant;
    self.iconH3.constant = self.iconW3.constant;
    self.iconH4.constant = self.iconW4.constant;
    
    self.midGrayView.backgroundColor = KControllerBackGroundColor;
    self.topGrayLine.backgroundColor = [UIColor whiteColor];
    self.bottomGrayView.backgroundColor = [UIColor whiteColor];
    
}

-(void)setupScrollViewWith:(Favorites * )fav{
    
    self.scrollView.contentSize = CGSizeMake(2*KScreenWidth,0);
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    
//    SMShelfProductViewController * vc = [[SMShelfProductViewController alloc]init];
//    self.vc = vc;
//    vc.fav = fav;
//    vc.isRootShelf = YES;
//    vc.delegate = self;
//    vc.isBelongCounter = YES;
//    [self addChildViewController:vc];
//    vc.view.frame = CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height);
//    [self.scrollView addSubview:vc.view];
    
    SMShelfHotProductController *vc3 = [[SMShelfHotProductController alloc] init];
    self.vc3 = vc3;
    vc3.delegate = self;
    self.vc3.fav = fav;
//    [self addChildViewController:vc3];
    [self.scrollView addSubview:vc3.view];
    vc3.view.frame = CGRectMake(0, 0, KScreenWidth, self.scrollView.frame.size.height);
    
    
//    self.vc2 = [[SMShelfDiscountController alloc]init];
//    
//    self.vc2.fav = fav;
//    self.vc2.delegate = self;
//    self.vc2.isBelongCounter = YES;
////    [self addChildViewController:self.vc2];
//    self.vc2.view.frame = CGRectMake(KScreenWidth,0, KScreenWidth, self.scrollView.frame.size.height);
//    
//    [self.scrollView addSubview:self.vc2.view];
}

- (void)moreProductDidClick{
    SMStroreHouseForShelfController *vc = [SMStroreHouseForShelfController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击事件
//分享
- (IBAction)shareAction:(UIButton *)sender {
    [self sharePage];
}
////切换
//- (IBAction)cutShelfAction:(UIButton *)sender {
//    //弹出pickView
//    if (self.favIdArray.count>0) {
//       [self showPickerView];
//    }else{
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有柜台，请添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    
//}
//购物车
//- (IBAction)shopActiom:(UIButton *)sender {
//    //添加购物车
//    SMShoppingCartController * shopping = [SMShoppingCartController new];
//    
//    [self.navigationController pushViewController:shopping animated:YES];
//}
////邀请合伙人
//- (IBAction)partnerAction:(UIButton *)sender {
//    SMLog(@"邀请合伙人");
//}
//- (IBAction)orderAction:(UIButton *)sender {
//    SMLog(@"查看订单");
//    SMNewOrderManagerViewController * manager = [SMNewOrderManagerViewController new];
//    
//    [self.navigationController pushViewController:manager animated:YES];
//}
//热销商品
- (IBAction)goodsAction:(UIButton *)sender {
    self.goodsBtn.selected = YES;
    self.leftLine.hidden = NO;
    self.discountBtn.selected = NO;
    self.rightLine.hidden = YES;
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
}
//优惠券
- (IBAction)discountAction:(UIButton *)sender {
    self.goodsBtn.selected = NO;
    self.leftLine.hidden = YES;
    self.discountBtn.selected = YES;
    self.rightLine.hidden = NO;
    
    self.scrollView.contentOffset = CGPointMake(KScreenWidth, 0);
}
//点击头像
-(void)personClick{
    SMPersonInfoViewController * info = [SMPersonInfoViewController new];
    
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - 点击代理
- (void)productCellDidClick:(NSInteger)index isBelongToCounter:(BOOL)isBelongCounter{
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    
#pragma mark   可以在这模型赋值
    FavoritesDetail *f = self.vc.arrProducts[index];
    Product * product =  [Product new];
    product.id = f.itemId;
    product.imagePath = f.imagePath;
    vc.product = product;
    vc.isGoodsShelf = YES;
    vc.favorites = self.favorites;
    vc.isPushCounter = YES;
    vc.isBelongCounter = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)productCellDidClick:(NSInteger)index{
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//    
//#pragma mark   可以在这模型赋值
//    FavoritesDetail *f = self.vc.arrProducts[index];
//    Product * product =  [Product new];
//    product.id = f.itemId;
//    product.imagePath = f.imagePath;
//    vc.product = product;
//    vc.isGoodsShelf = YES;
//    vc.favorites = self.favorites;
//    vc.isPushCounter = YES;
//    
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)discountCellDidClick:(NSInteger)index{
    
#pragma mark   可以在这模型赋值
    FavoritesDetail *f = self.vc2.arrDatas[index];
    NSString *discountID = f.itemId;
    SMLog(@"index   %zd",index);
    [[SKAPI shared] queryObject:@[discountID] andType:Type_Coupon block:^(NSArray * result, NSError *error) {
        if (!error) {
            SMLog(@"discountCellDidClick    result    %@",result);
            Coupon *coupon = [Coupon mj_objectWithKeyValues:result.firstObject];
            SMDiscountDetailController *vc = [[SMDiscountDetailController alloc] init];
            vc.coupon = coupon;
            vc.pushedByShelf = YES;
            vc.favorites = self.favorites;
            vc.isPushCounter = YES;
            vc.isGoodsShelf = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
    
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMShelfHotProductControllerDelegate
- (void)goToProductDetailVC:(NSString *)productID and:(Favorites *)fav{
    [[SKAPI shared] queryProductById:productID block:^(Product *product, NSError *error) {
        if (!error) {
            SMProductDetailController *vc = [[SMProductDetailController alloc] init];
            vc.product = product;
            vc.isBelongCounter = YES;
            vc.isGoodsShelf = YES;
            vc.favorites = fav;
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}



#pragma mark - 数据相关
-(void)requestShelfData{
    [self.favIdArray removeAllObjects];
    
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        
        if (!error) {
            SMLog(@"array  %@",array);
            
            if (array.count>0) {
                
                [[NSUserDefaults standardUserDefaults] setInteger:array.count forKey:KCurrentShelfCount];
                
                NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
                
                SMLog(@"row  requestShelfData   %ld",row);
                
                Favorites * fav = array[row];
                
                self.favorites.id = fav.id;
                
                self.customerName.text = fav.name;
                
                SMLog(@"fav = %@",fav.id);
                //保存下来
                [self saveSqliteWith:array];
                
                //保存到数组 便于切换
                for (Favorites * fa in array) {
                   [self.favIdArray addObject:fa];
                }
                
                //创建出scrollView上的视图
                
                [self setupScrollViewWith:fav];
                
                [self.arrPickerSouce addObject:fav.name];
                
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有微柜台,请到工作台->柜台管理添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alertView show];
            }
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}

-(void)saveSqliteWith:(NSArray *)array
{
    //保存前需要删除
    NSArray * localArray = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (LocalFavorites * fav in localArray) {
            [fav MR_deleteEntityInContext:localContext];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    //    存起来
    //这里数组  存储时候  乱序了
    for (Favorites * favorites in array) {
        SMLog(@"name = %@",favorites.name);
        LocalFavorites * localFavorites = [LocalFavorites MR_createEntity];
        localFavorites.id = favorites.id;
        localFavorites.createAt = [NSNumber numberWithInteger:favorites.createAt];
        localFavorites.name = favorites.name;
        localFavorites.type = [NSNumber numberWithInteger:favorites.type];
        localFavorites.products = favorites.products;
        localFavorites.activitys = [NSNumber numberWithInteger:favorites.activitys];
        localFavorites.coupons = [NSNumber numberWithInteger:favorites.coupons];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


- (void)showPickerView{
    self.count = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentShelfCount];
    [self.arrPickerSouce removeAllObjects];
    SMLog(@"self.count    %zd",self.count);
    
    NSArray * array = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (NSInteger i = 0; i < array.count; i++) {
        LocalFavorites * fav = array[i];
        NSString *title = fav.name;
        [self.arrPickerSouce addObject:title];
    }
    
    [self.pickerView reloadAllComponents];
    //蒙板
    UIView *bgView = [[UIView alloc] init];
    self.bgGrayView = bgView;
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTabBarHeight);
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap)];
    [bgView addGestureRecognizer:tap];
    
    //加入pickerview
    [self.view addSubview:self.pickerView];
    
    //确定按钮
    UIButton *sureBtn = [[UIButton alloc] init];
    self.sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    CGFloat sureBtnH = 20;
    sureBtn.frame = CGRectMake(0, KScreenHeight - KTabBarHeight - KPikerVIewHeight - sureBtnH + 20, KScreenWidth, sureBtnH);
    [sureBtn setBackgroundColor:[UIColor whiteColor]];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)sureBtnClick{
    SMLog(@"点击了 确定");
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    SMLog(@"%ld,%ld",row,self.favIdArray.count);
   
    if (self.favIdArray.count>0) {
        //拿到当前货架的id
        self.favorites = self.favIdArray[row];
        //发通知给展示产品的vc 刷新界面
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"KRefreshShelfProductKey"] = self.favorites.id; //当前货架的id

        
        [self setupScrollViewWith:self.favorites];
        
        [[NSUserDefaults standardUserDefaults] setInteger:row forKey:KCurrentSelectedShelf];
        
        [self bgViewTap];
        
        self.customerName.text = self.favorites.name;
    }
    
}

- (void)bgViewTap{
    [self.bgGrayView removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource
//显示几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//显示几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrPickerSouce.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.arrPickerSouce[row];
}

#pragma mark - scroll 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    
    if (page) {
        [self discountAction:self.discountBtn];
    }else{
        [self goodsAction:self.goodsBtn];
    }
}

/**
 *  分享微柜台
 */
- (void)sharePage{
    
    [self addShareMemu2];
    
}

- (void)addShareMemu2{
    if (self.cheatView3) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    UIView *cheatView3 = [[UIView alloc] init];
    self.cheatView3 = cheatView3;
    
    cheatView3.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCheatView3)];
    [cheatView3 addGestureRecognizer:tap];
    cheatView3.frame = window.bounds;
    
    SMShareMenu *menu3 = [SMShareMenu shareMenu];
    menu3.delegate = self;
    [window addSubview:menu3];
    self.menu3 = menu3;
    [self.menu3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@300);
        make.height.equalTo(@270);
    }];
    
    // 动画
    cheatView3.alpha = 0;
    menu3.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        menu3.transform = CGAffineTransformMakeScale(1, 1);
        cheatView3.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)removeCheatView3{
    [UIView animateWithDuration:0.35 animations:^{
        self.menu3.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView3.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView3 removeFromSuperview];
        self.cheatView3 = nil;
        [self.menu3 removeFromSuperview];
        self.menu3 = nil;
    }];
}

#pragma mark -- SMShareMenuDelegate  分享
- (void)cancelBtnDidClick{
    [self removeCheatView2];
    [self removeCheatView3];
}

@end
