//
//  SMCounterController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/2.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCounterController.h"
#import "SMNewHotProductCell.h"
#import "SMCounterHeaderView.h"
#import "SMCounterCellSection0.h"
#import "SMSection1TitleCell.h"
#import "SMProductDetailController.h"
#import "SMShareMenu.h"
#import "SMNewShelfManagerController.h"
#import "SMNewOrderManagerViewController.h"
#import "SMShoppingCartController.h"
#import "SMStroreHouseForShelfController.h"
#import "SMPersonInfoViewController.h"
#import "SMNewFav.h"
#import <UIImageView+WebCache.h>
#import "SMNewProductDetailController.h"
#import "SMNewPersonInfoController.h"

#define KPikerVIewHeight 200
#define KInvitePartner [NSString stringWithFormat:@"%@sk_invite.html",SKAPI_PREFIX_SHARE]
#define KInviteShelf [NSString stringWithFormat:@"%@sk_sales.html",SKAPI_PREFIX_SHARE]


@interface SMCounterController ()<UITableViewDelegate,UITableViewDataSource,SMCounterCellSection0Delegate,SMSection1TitleCellDelegate,SMCounterHeaderViewDelegate,SMShareMenuDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)Favorites *fav;

@property (nonatomic ,strong)NSMutableArray *arrHotProducts;

@property (nonatomic ,strong)SMCounterHeaderView *header;

@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;

@property (nonatomic ,copy)NSString *webStr;

@property (nonatomic ,strong)SMShareMenu *menu3;

@property (nonatomic ,strong)UIView *cheatView3;

@property (nonatomic ,strong)SMNewFav *favNew;

@property (nonatomic ,assign)NSInteger page; /**< 刷新page */

@end

@implementation SMCounterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:self.tableView];
    
    [self SetupMJRefresh];
    
    [self setupTableViewHeader];
    
    //[self getProductData];
    
    self.webStr = KInviteShelf;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShelfProducts) name:KRefreshShelfProducts object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentShelfID:) name:KRefreshCounterProductNoti object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)refreshShelfProducts{
    [self getProductData];
}

-(void)SetupMJRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getProductData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    self.header.icon.image = [UIImage imageWithData:data];
    self.header.shopKeeper.text = [NSString stringWithFormat:@"掌柜：%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserName]];
    
    NSData * bgImageData = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfBgImage];
    if (bgImageData) {
        self.header.bjIcon.image = [UIImage imageWithData:bgImageData];
    }else{
        self.header.bjIcon.image = [UIImage imageNamed:@"微货架-beijing 5"];
    }
    
    self.header.counterName.text = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfName];
}

- (void)refreshCurrentShelfID:(NSNotification *)noti{
    
    NSDictionary *dict =  noti.userInfo;
    NSString *favID = dict[@"KRefreshCounterProductNotiKey"];
    SMNewFav *newFav = dict[@"KRefreshCounterProductNotiKeyNewFav"];
    self.favNew = newFav;
    NSString *imagePath = [newFav.bgImage stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=60",KScreenWidth *2.2,135 *SMMatchHeight *2.2]];
    //[self.header.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"]];
    [self.header.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //保存当前柜台背景图
        NSData *imageData = nil;
        if (UIImageJPEGRepresentation(image, 1.0)) {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }else{
            imageData = UIImagePNGRepresentation(image);
        }
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:KCurrentShelfBgImage];
    }];
    self.header.counterName.text = newFav.favName;
    
    //保存当前货柜名字和背景图
    [[NSUserDefaults standardUserDefaults] setObject:newFav.favName forKey:KCurrentShelfName];
    //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    //[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:KCurrentShelfBgImage];
    
    [[SKAPI shared] queryMyStorageItems:favID block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrHotProducts removeAllObjects];
            //再重新添加新数据
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [self.arrHotProducts addObject:f];
                }
            }
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)getProductData{
//    NSInteger currentSelectedCounter = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentSelectedShelf];
    NSString *currentSHelfID = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfID];
    //SMLog(@"currentSHelfID = %@",currentSHelfID);
    if (currentSHelfID.length == 0) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    [[SKAPI shared] queryMyStorageItems:currentSHelfID block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrHotProducts removeAllObjects];
            //再重新添加新数据
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [self.arrHotProducts addObject:f];
                }
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            SMLog(@"error   %@",error);
            [self.tableView.mj_header endRefreshing];
        }
    }];

}

- (void)getHotProductsDataWith:(Favorites *)fav{
    
    [[SKAPI shared] queryMyStorageItems:fav.id block:^(NSArray *array, NSError *error) {
        
        if (!error) {
            [self.arrHotProducts removeAllObjects];
            //再重新添加新数据
            for (FavoritesDetail *f in array) {
                if (f.type == 0) {
                    [self.arrHotProducts addObject:f];
                }
            }
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)setupTableViewHeader{
    SMCounterHeaderView *header = [SMCounterHeaderView counterHeaderView];
    self.header = header;
    header.width = KScreenWidth;
    header.height = 100 *SMMatchHeight;
    header.delegate = self;
    self.header = header;
    self.tableView.tableHeaderView = header;
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];    
    header.icon.image = [UIImage imageWithData:data];
    header.shopKeeper.text = [NSString stringWithFormat:@"掌柜：%@",[[NSUserDefaults standardUserDefaults] objectForKey:KUserName]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (self.arrHotProducts.count > 5) {  //如果返回的数据大于5 就只显示6行   如果返回的数据小于5  就显示返回的数据个数
            return 6;
        }else{
            return self.arrHotProducts.count + 1;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMCounterCellSection0 *cell = [SMCounterCellSection0 cellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        SMSection1TitleCell *cell = [SMSection1TitleCell cellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }else{
        SMNewHotProductCell *cell = [SMNewHotProductCell cellWithTableView:tableView];
        cell.favoritesDetail = self.arrHotProducts[indexPath.row - 1];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50 *SMMatchHeight + 1;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 5 + 30 *SMMatchHeight;
    }else{
        return 5 + 205 * SMMatchHeight + 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row >= 1) {
        FavoritesDetail *favDetail = self.arrHotProducts[indexPath.row -1];
//        [[SKAPI shared] queryProductById:favDetail.itemId  block:^(Product *product, NSError *error) {
//            if (!error) {
//                SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//                vc.product = product;
//                vc.isBelongCounter = YES;
//                vc.isGoodsShelf = YES;
//                vc.favorites = self.fav;
//                
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                SMLog(@"error   %@",error);
//            }
//        }];
        
//        SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//        vc.itemId = favDetail.itemId;
//        vc.isBelongCounter = YES;
//        vc.isGoodsShelf = YES;
//        vc.favorites = self.fav;
//        [self.navigationController pushViewController:vc animated:YES];
        
        SMNewProductDetailController *vc = [SMNewProductDetailController new];
        vc.productId = favDetail.itemId;
        vc.mode = 2;
        vc.productName = favDetail.itemName;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark --  点击事件
- (void)moreBtnDidCLick{
    SMLog(@"点击了 更多商品");
    SMStroreHouseForShelfController *vc = [SMStroreHouseForShelfController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)partnerViewDidClick{
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
        
        NSString *endStr = [path stringByAppendingString:para];
        /*
        if (type == 22) { //分享到微信
            endStr = [endStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
            endStr = [endStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
            endStr = [endStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
            endStr = [endStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            endStr = [endStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            SMLog(@"urlStr   %@",endStr);
            endStr = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:endStr andMoreinfo:NO];
        }
        */
        NSURL *url = [NSURL URLWithString:endStr];
        
        
        
        SMLog(@"最终分享出去的url   %@",endStr);
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:@"加入我的团队，正品保障，无需囤货，一对一指导，轻松赚取丰厚佣金"
                                         images:image
                                            url:url
                                          title:@"加入我的团队，带你赚钱带你飞"
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
        
        [self removeCheatView2];
        
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
        
        SMLog(@"[[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfID]  share   %@",[[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfID]);
        NSString *para = [NSString stringWithFormat:@"?favId=%@&mode=1",[[NSUserDefaults standardUserDefaults] objectForKey:KCurrentShelfID]];
        
        NSString *urlStr = [self.webStr stringByAppendingString:para];
        
        if (type == 24) {  //分享到QQ  截取掉前面的http://
            urlStr = [urlStr substringFromIndex:7];
        }
        
        
        SMLog(@"urlStr  substringFromIndex   %@",urlStr);
        
        NSString *headStr = [[urlStr componentsSeparatedByString:@"&"] firstObject];
        SMLog(@"headStr   %@",headStr);
        
        NSString *urlChang5;
        urlChang5 = [headStr stringByAppendingString:[NSString stringWithFormat:@"&mode=0&t=%@",timeSp]];
        
        
        
        SMLog(@"urlChang5   %@",urlChang5);
        /*
        if (type == 22) { //分享到微信
            NSString *urlChang1 = [urlChang5 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
            NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
            NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
            NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            
            urlChang5 = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:urlChang5 andMoreinfo:NO];
        }
        */
        SMLog(@"urlChang5  createOauthUrlForCode      %@",urlChang5);
//        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"这些宝贝很不错喔！"
                                         images:imageArray
                                            url:[NSURL URLWithString:urlChang5]
                                          title:[NSString stringWithFormat:@"%@",self.header.counterName.text]
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
        [self removeCheatView3];
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


- (void)cutShelfViewDidClick{
    SMLog(@"点击了 切换柜台");
    SMNewShelfManagerController *vc = [[SMNewShelfManagerController alloc] init];

    [self.navigationController pushViewController:vc animated:NO];
}
- (void)orderViewDidClick{
    SMLog(@"点击了 查看订单");
    SMNewOrderManagerViewController * manager = [SMNewOrderManagerViewController new];
    
    [self.navigationController pushViewController:manager animated:YES];
}
- (void)cartViewDidClick{
    SMLog(@"点击了 购物车");
    SMShoppingCartController * shopping = [SMShoppingCartController new];
    
    [self.navigationController pushViewController:shopping animated:YES];
}

- (void)iconDidClick{
    SMLog(@"点击了 头像");
    //SMPersonInfoViewController * info = [SMPersonInfoViewController new];
    SMNewPersonInfoController *info = [SMNewPersonInfoController new];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)shareBtnDidClick{
    SMLog(@"点击了 分享");
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

#pragma mark -- 懒加载
- (NSMutableArray *)arrHotProducts{
    if (_arrHotProducts == nil) {
        _arrHotProducts = [NSMutableArray array];
    }
    return _arrHotProducts;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        //_tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49);
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
