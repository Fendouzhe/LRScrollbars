//
//  SMDiscountDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/21.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscountDetailController.h"
#import "SMExtractionRecordViewController.h"
#import "SMCheatView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"
#import "LocalFavoritesDetail.h"
#import "SMShareMenu.h"

//#define KWebString @"http://www.shuangkuai.co:1234/shuangkuai_app/sk_coupon_detail.html"

@interface SMDiscountDetailController ()<UIAlertViewDelegate,SMShareMenuDelegate>
/**
 *  加入优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) IBOutlet UIButton *subBtn;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UILabel *actiomtitle;

@property (strong, nonatomic) IBOutlet UILabel *timerLable;

@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
//折扣率
@property (weak, nonatomic) IBOutlet UILabel *depositRateLable;
//有效时间
@property (weak, nonatomic) IBOutlet UILabel *effectiveLable;


//使用规则
@property (weak, nonatomic) IBOutlet UILabel *ruleLable1;
@property (weak, nonatomic) IBOutlet UILabel *ruleLable2;
@property (weak, nonatomic) IBOutlet UILabel *ruleLable3;
@property (weak, nonatomic) IBOutlet UILabel *ruleLable4;
@property (weak, nonatomic) IBOutlet UILabel *ruleLable5;

@property(nonatomic,copy)NSAttributedString * attribute;

@property(nonatomic,strong)SMCheatView * cheatView;

@property(nonatomic,strong)UIAlertView * popAlertView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIImageView *bgColorView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

/**
 *  优惠券码
 */
@property (nonatomic ,copy)NSString *couponCode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (nonatomic ,copy)NSString *webStr;

@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *footerHeightConstraint;

@end

@implementation SMDiscountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *currentStr = SKAPI_PREFIX_SHARE;
//    NSString *headStr = [[currentStr componentsSeparatedByString:@"api"] firstObject];
//    NSString *footStr = @"sk_coupon_detail.html";
    
    self.webStr = [currentStr stringByAppendingString:@"sk_coupon_detail.html"];
    SMLog(@"self.webStr   ,%@",self.webStr);
    
    [self setupNav];
    [self refreshUI];
    
    //[self.addBtn setBackgroundColor:KRedColor];
//    if (self.pushedByShelf) {
//        self.addBtn.hidden = NO;
//    }else{
//        self.addBtn.hidden = YES;
//    }
    
    
    if (self.isGoodsShelf) {
        self.footerView.hidden = YES;
    }else{
        self.footerView.hidden = NO;
    }
    
    if (isIPhone5) {
        self.iconHeight.constant = 92;
        self.footerHeightConstraint.constant = 49;
    }else if (isIPhone6){
        self.iconHeight.constant = 92 *KMatch6Height;
        self.footerHeightConstraint.constant = 49*KMatch6Height;
    }else if (isIPhone6p){
        self.iconHeight.constant = 92 *KMatch6pHeight;
        self.footerHeightConstraint.constant = 49*KMatch6pHeight;
    }
    
    [self.addBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];;
    self.subBtn.backgroundColor = KRedColorLight;
    self.subBtn.layer.cornerRadius = SMCornerRadios;
    self.subBtn.clipsToBounds = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)setupNav{
    self.title = @"优惠券详情";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = KRightItemWidth;
    rightBtn.height = KRightItemHeight;
    [rightBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
//    self.addBtn.layer.cornerRadius = SMCornerRadios;
//    self.addBtn.clipsToBounds = YES;
}
-(SMCheatView *)cheatView
{
    
    if (!_cheatView) {
        _cheatView = [SMCheatView initWithID:self.coupon.id andType:2 andHeight:64];
        _cheatView.pushblock = ^(UIViewController * Vc){
            [self.navigationController pushViewController:Vc animated:YES];
        };
        [self.view addSubview:_cheatView];
    }
    return _cheatView;
}
#pragma mark -- 点击事件
- (IBAction)addBtnClick {
    SMLog(@"点击了 加入优惠券按钮");
//    if (self.pushedByShelf) { //如果是从货架界面push过来的
//        [self addToShelfWhenPushedByShelf];
//    }else{ //从产品库那边的界面push过来的
//        [self addToShelfWhenPushedByStoreHouse];
//    }
    self.cheatView.isCounter = NO;
    if (!self.isPushCounter) {
        //sender.enabled = YES;
        [self.cheatView requestshelfData];
    }else
    {
        if (self.isup) {
            [self addProduct];
        }else{
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该商品已经在货架上，请勿重复添加" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVc animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }
}
//下架
- (IBAction)subTnClick:(UIButton *)sender {
    self.cheatView.isCounter = NO;
    
    if (!self.isPushCounter) {
        [self.cheatView CounterCheck];
    }else
    {
        if (!self.isup) {
            [self cutoutProduct];
        }else{
            NSArray * array = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.favorites.id inContext:[NSManagedObjectContext MR_defaultContext]];
            SMLog(@"customer  arrya =   %@",array);
            //判断是否在货架中
            for (NSInteger i=0;i<array.count;i++) {
                LocalFavoritesDetail * favdetail = array[i];
                
                if (favdetail.type.integerValue == 2) {
                    
                    if ([favdetail.itemId isEqualToString:self.coupon.id]) {
                        //有相等的
                        //是可下架的
                        [self cutoutProduct];
                        
                        break;
                    }
                    
                    if (i == array.count-1) {
                        //没有找到一样的   提醒
                        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该商品尚未上架，请先上架该商品" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [self presentViewController:alertVc animated:YES completion:nil];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                    
                }
            }

        }
    }
}
- (IBAction)counterAction:(UIButton *)sender {
    self.cheatView.isCounter = YES;
    [self.cheatView CounterCheck];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KCheatViewDisappear" object:nil];
}

- (void)addToShelfWhenPushedByStoreHouse{
    NSString *currentShelfID = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfID];
    SMLog(@"currentShelfID  %@",currentShelfID);
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableArray *arr3 = [NSMutableArray array];
    [[SKAPI shared] queryMyStorageItems:currentShelfID block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"queryMyStorageItems   currentShelfID    %@",array);
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {//是产品
                    [arr1 addObject:f.itemId];
                }else if (f.type == 1){//是活动
                    [arr2 addObject:f.itemId];
                }else if (f.type == 2){
                    [arr3 addObject:f.itemId];
                }
            }
            SMLog(@"arr3   %@",arr3);
            if (arr3.count >= 5) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的，同一货架最多只能添加5张优惠券哦～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
        }else{
            SMLog(@"error    %@",error);
        }
    }];
    
    //将现在页面显示的优惠券id 添加到数组中去
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SMLog(@"self.coupon.id    %@",self.coupon.id);
        [arr3 addObject:self.coupon.id];
        SMLog(@"arr3   %@",arr3);
        [[SKAPI shared] createItem2MyStorage:currentShelfID andName:@"" andProductIds:arr1 andActivityIds:arr2 andCouponIds:arr3 block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result   %@",result);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                SMLog(@"error    %@",error);
            }
        }];
    });
}

- (void)addToShelfWhenPushedByShelf{
    if (self.arrDiscountIDs.count >= 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的，同一货架最多只能添加5张优惠券哦～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KAddDiscountKey] = self.coupon.id;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAddDiscountNote object:self userInfo:dict];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入优惠券成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)rightBtnClick{
    SMLog(@"点击了 右边的转发/分享按钮");

    [[SKAPI shared] shareCoupon:self.coupon.id block:^(id result, NSError *error) {
        if (!error) {
            
            [self addShareMemu];
            
//            NSDate *localeDate = [NSDate date];
//            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
//            SMLog(@"timeSp :%@",timeSp); //时间戳的值
//            
//            
//            SMLog(@"(NSDictionary *)result  %@",(NSDictionary *)result[@"result"]);
//            SMLog(@"[result class]   shareCoupon   %@",[result class]);
//            NSDictionary *dict = (NSDictionary *)result;
//            self.couponCode = dict[@"result"];
//            
//            //取出照片：
//            NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
//            UIImage* image = [UIImage imageWithData:imageData];
//            NSArray* imageArray = @[image];
//            
//            //    NSArray* imageArray = @[[UIImage imageNamed:@"爽快图标120"]];
////            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.companyImage]];
////            NSArray* imageArray = @[[UIImage imageWithData:data]];
//            
//            //    NSString *headStr = [[self.currentURL componentsSeparatedByString:@"&"] firstObject];
//            NSString *headStr = self.webStr;
//            
//            SMLog(@"headStr   %@",headStr);
//            
//            NSString *urlStr = [headStr stringByAppendingString:[NSString stringWithFormat:@"?cid=%@&t=%@",self.couponCode,timeSp]];
//            
//            if (imageArray) {
//                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                [shareParams SSDKSetupShareParamsByText:self.coupon.name
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:urlStr]
//                                                  title:[NSString stringWithFormat:@"掌柜%@",userName]
//                                                   type:SSDKContentTypeAuto];
//                SMLog(@"self.currentURL   %@",urlStr);
//                SMLog(@"urlStr   %@",urlStr);
//                //2、分享（可以弹出我们的分享菜单和编辑界面）
//                [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                         items:nil
//                                   shareParams:shareParams
//                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                               
//                               switch (state) {
//                                   case SSDKResponseStateSuccess:
//                                   {
//                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                           message:nil
//                                                                                          delegate:nil
//                                                                                 cancelButtonTitle:@"确定"
//                                                                                 otherButtonTitles:nil];
//                                       [alertView show];
//                                       break;
//                                   }
//                                   case SSDKResponseStateFail:
//                                   {
//                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                       message:[NSString stringWithFormat:@"%@",error]
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"OK"
//                                                                             otherButtonTitles:nil, nil];
//                                       [alert show];
//                                       break;
//                                   }
//                                   default:
//                                       break;
//                               }
//                           }
//                 ];
//            }
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)addShareMemu{
    if (self.cheatView2) {    // 如果分享菜单正在显示，直接返回
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
    
    [[SKAPI shared] shareCoupon:self.coupon.id block:^(id result, NSError *error) {
        
            NSDate *localeDate = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
            SMLog(@"timeSp :%@",timeSp); //时间戳的值
            
            
            SMLog(@"(NSDictionary *)result  %@",(NSDictionary *)result[@"result"]);
            SMLog(@"[result class]   shareCoupon   %@",[result class]);
            NSDictionary *dict = (NSDictionary *)result;
            self.couponCode = dict[@"result"];
            
            //取出照片：
            NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
            UIImage* image = [UIImage imageWithData:imageData];
            image = [self scaleToSize:image size:CGSizeMake(100, 100)];
            NSArray* imageArray = @[image];
            
            //    NSArray* imageArray = @[[UIImage imageNamed:@"爽快图标120"]];
            //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coupon.companyImage]];
            //            NSArray* imageArray = @[[UIImage imageWithData:data]];
            
            //    NSString *headStr = [[self.currentURL componentsSeparatedByString:@"&"] firstObject];
            NSString *headStr = self.webStr;
            
            SMLog(@"headStr   %@",headStr);
            
            NSString *urlStr = [headStr stringByAppendingString:[NSString stringWithFormat:@"?cid=%@&t=%@",self.couponCode,timeSp]];
            
//            if (type == 22) {
//                urlStr = [Utils createOauthUrlForCode:@"wx0cc9d5092f1a711c" andRedirectUrl:urlStr andMoreinfo:NO];
//            }
            SMLog(@"urlStr   %@",urlStr);
            if (imageArray) {
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:self.coupon.name
                                                 images:imageArray
                                                    url:[NSURL URLWithString:urlStr]
                                                  title:[NSString stringWithFormat:@"掌柜%@",userName]
                                                   type:SSDKContentTypeAuto];
                
                SMLog(@"[NSURL URLWithString:urlStr]   %@",[NSURL URLWithString:urlStr]);
                
                
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
//                //2、分享（可以弹出我们的分享菜单和编辑界面）
//                [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                         items:nil
//                                   shareParams:shareParams
//                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                               
//                               switch (state) {
//                                   case SSDKResponseStateSuccess:
//                                   {
//                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                           message:nil
//                                                                                          delegate:nil
//                                                                                 cancelButtonTitle:@"确定"
//                                                                                 otherButtonTitles:nil];
//                                       [alertView show];
//                                       break;
//                                   }
//                                   case SSDKResponseStateFail:
//                                   {
//                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                       message:[NSString stringWithFormat:@"%@",error]
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"OK"
//                                                                             otherButtonTitles:nil, nil];
//                                       [alert show];
//                                       break;
//                                   }
//                                   default:
//                                       break;
//                               }
//                           }
//                 ];
            }

        }
    ];
}

- (void)cancelBtnDidClick{
    [self removeCheatView2];
}


//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy.MM.dd"];
    return [objDateformat stringFromDate:date];
}

-(void)refreshUI
{
    
    if (isIPhone6) {
        self.widthConstraint.constant = 80 * KMatch6;
    }else if(isIPhone6p)
    {
        self.widthConstraint.constant = 80* KMatch6p;
    }
    
    //[self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_coupon.companyImage]]];
    [self.iconImageView setShowActivityIndicatorView:YES];
    [self.iconImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_coupon.companyImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.actiomtitle.text = _coupon.name;
    self.companyName.text = [NSString stringWithFormat:@"%@",_coupon.companyName];
//    NSString *timeStart = [self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",[_coupon.startTime integerValue]]];
    //NSString *timeStart = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",self.coupon.startTime]];
    
    self.timerLable.text = [NSString stringWithFormat:@"有效期:%@-%@",[self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",_coupon.startTime ]],[self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",_coupon.endTime ]]];
    
    self.moneyLable.text = [NSString stringWithFormat:@"￥%.0lf",_coupon.money ];
    self.depositRateLable.text = [NSString stringWithFormat:@"%.2lf折",_coupon.depositRate];
    self.typeLable.text = _coupon.type ? @"优惠劵":@"兑换券";
    
    //self.ruleLable1.text  = [NSString stringWithFormat:@". %@",_coupon.descr];
    
    self.effectiveLable.text = [NSString stringWithFormat:@"有效时间：%@到%@",[self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",_coupon.startTime]],[self getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",_coupon.endTime ]]];
    
    if (_coupon.type==0) {
        self.typeLable.hidden = NO;
        self.moneyLable.hidden = NO;
        self.typeLable.text = @"代金券";
        self.moneyLable.text = [NSString stringWithFormat:@"￥%.0lf",_coupon.money];
        self.depositRateLable.hidden = YES;
        self.bgColorView.image = [UIImage imageNamed:@"youhuiquanjuse"];
    }else if(_coupon.type == 1)
    {
        self.typeLable.hidden = NO;
        self.moneyLable.hidden = NO;
        self.typeLable.text = @"折扣券";
        self.moneyLable.text = [NSString stringWithFormat:@"%.2lf折",_coupon.depositRate];
        self.depositRateLable.hidden = YES;
        self.bgColorView.image = [UIImage imageNamed:@"lansezhekouquan"];
    }else
    {
        self.depositRateLable.hidden = NO;
        self.typeLable.hidden=YES;
        self.moneyLable.hidden = YES;
        self.depositRateLable.text = @"兑换券";
        self.bgColorView.image = [UIImage imageNamed:@"ziseduihuanquan"];
    }


#warning 出现问题
    //解析出html
    
    //NSData * data =  [_coupon.descr dataUsingEncoding:NSUTF8StringEncoding];
    
  
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.lineSpacing = 5;
    style.paragraphSpacing = 10;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary] ;
    //dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dict[NSParagraphStyleAttributeName] = style;
    
//    NSAttributedString * string = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
    
    self.ruleLable1.numberOfLines = 0;
    self.ruleLable1.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    //[self.ruleLable1 setAttributedText:string];
    
//     SMLog(@"%@",string);
    //试试先
//    self.ruleLable1.text = [string string];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:self.ruleLable1.frame];
//    [label setAttributedText:string];
//    [self.view addSubview:label];
    
//    [self.view addSubview:lable];
    
    [self.webView loadHTMLString:self.coupon.descr baseURL:nil];
    SMLog(@"self.coupon.descr   %@",self.coupon.descr);
    self.webView.backgroundColor = [UIColor whiteColor];
}

-(UILabel *)ruleLable1
{
    return _ruleLable1;
}

//删除商品
-(void)cutoutProduct
{
    NSArray * array = [[NSArray alloc]initWithObjects:self.favorites.id, nil];
    
    [[SKAPI shared] removeItem:self.coupon.id fromMyStorage:array andType:2 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result = %@",result);
            //通知刷新
            NSNotification * notice = [NSNotification notificationWithName:@"DiscountRefreshData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            //  也要提示
            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
            
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

//添加商品
-(void)addProduct
{
    
    //难道要请求一次   1.获取到有多少的产品  2.获取到已有产品  防止重复添加
    [[SKAPI shared] queryMyStorageItems:self.favorites.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            NSInteger i=0;
            for (FavoritesDetail * fav in array) {
                if (fav.type == 2) {
                    i++;
                }
            }
            if (i == 5) {
                UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"一个专柜最多添加5个优惠券" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
            }else
            {
                for (FavoritesDetail *  favDetail in array) {
                        if ([self.coupon.id isEqualToString: favDetail.itemId]) {
                            UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该优惠券已在专柜中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alerView show];
                            return ;
                    }
                }
                [self add];
            }
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}
-(void)add
{
    NSArray * array = [[NSArray alloc]initWithObjects:self.favorites.id, nil];
    [[SKAPI shared] addItem:self.coupon.id toMyStorage:array andType:2 block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"result = %@",result);
            NSNotification * notice = [NSNotification notificationWithName:@"DiscountRefreshData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.popAlertView) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
