//
//  SMProductDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductDetailController.h"
#import "SMCarouselView.h"
#import "SMDetailProductSection0Cell.h"
#import "SMDetailProductSection1Cell.h"
#import "SMDetailProductSection2Cell.h"
#import "SMDetailProductSection3Cell.h"
#import "skuSelected.h"
#import "SMSection3Row1Cell.h"
#import "SMDetailProductSection4Cell.h"
#import "SMDetailProductFootterView.h"
#import "SMSubSelectTableViewCell.h"
#import "SMSubSelectHeaderView.h"
#import "SMSubSelectFooterView.h"
#import "SMCheatView.h"
#import "sku.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SMNewFooterView.h"
#import "SMShoppingCartController.h"
#import "AppDelegate.h"
#import "LocalFavoritesDetail.h"
#import "SMJumpUpView.h"
#import <UIButton+WebCache.h>
#import "addressModle.h"
#import "SMConfirmPaymentController.h"
#import "MHPhotoBrowserController.h"
#import <UIImageView+WebCache.h>
#import "SMShippingController.h"
#import "SMConfirmPaymentController.h"
#import "addressModle.h"
#import "SYPhotoBrowser.h"
#import "SVProgressHUD.h"
#import "SMChooseNumViewController.h"
#import "SMNetworkViewController.h"
#import "SMShareMenu.h"
#import "SMProductVideoTableViewCell.h"
#import "SMProductTopView.h"


#define KTableViewOffset 20
#define KBtnWH 30
#define KBtnY 20
//#define KWebString @"http://www.shuangkuai.co:1224/shuangkuai_app/sk_product_detail.html"
//#define KWebString @"http://www.shuangkuai.co:1234/shuangkuai_app/sk_product_detail.html"
@interface SMProductDetailController ()<UITableViewDelegate,UITableViewDataSource,SMCarouselViewDelegate,SMDetailProductFootterViewDelegate,UIAlertViewDelegate,SMJoinGoodsShelfDelegate,SMJumpUpViewDeledate,SMChooseNumViewControllerDelegate,SMShareMenuDelegate,SMDetailProductSection4CellDelegate>

@property (nonatomic ,strong)UITableView *tableView;
/**
 *  第0组
 */
@property (nonatomic ,strong)SMDetailProductSection0Cell *section0Cell;
///**
// *  拿到详细数据的产品模型
// */
//@property (nonatomic ,strong)Product *productDetail;

@property (nonatomic ,strong)SMDetailProductSection3Cell *section3Row0Cell;
/**
 *  展开产品规格选项的数据
 */
@property (nonatomic ,strong)NSArray *arrSkuS;

@property (nonatomic ,assign)NSInteger section3CellCount;

@property (nonatomic ,assign)CGFloat cellHeight1;
/**
 *  蒙版
 */
@property (nonatomic ,strong)SMCheatView * cheatView;

@property(nonatomic,strong)UIAlertView * popAlertView;

@property (nonatomic ,copy)NSString *webStr;

@property (nonatomic ,strong)SMJumpUpView *upView;

@property (nonatomic ,strong)UIView *grayView;

@property (nonatomic ,strong)UIButton *topIconBjView;

//记录有没有点开过商品规格。（新改的逻辑是必须让商品规格出现一次）
@property (nonatomic ,assign)BOOL flag;
//购物车按钮
@property (nonatomic ,strong)UIButton *cartBtn;

//正在点击的是购物车
@property (nonatomic ,assign)BOOL isClickingCart;
//正在点击的是立即购买
@property (nonatomic ,assign)BOOL isClickingBuyNow;
//执行动画的图片
@property (nonatomic ,strong)UIImageView *imageView;

@property(nonatomic,assign)NSInteger buyCount;

@property (nonatomic ,strong)UIImage *theSaveImage;

//提示是否保存到相册的alertView
@property (nonatomic ,strong)UIAlertView *photoBrowserAlert;

@property (nonatomic ,strong)UIButton *shareBtn;
//是否已经选择过号码
@property (nonatomic ,assign)BOOL haveChooseNum;
//分享菜单的萌版
@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;

@property (nonatomic ,strong)ProductSpec *spec;
//imageView 正在执行动画
@property (nonatomic ,assign)BOOL imageViewIsAnimating;
//购买的电话号
@property (nonatomic ,copy)NSString *phoneNum;

@property (nonatomic,strong) NSIndexPath *lastIndex;/**< 最后的一个 */
@property (nonatomic,assign) CGFloat cellHeight;/**< cell高度 */
//@property (nonatomic,assign) BOOL setCellHeightOnce;/**< 设置一次高度 */

@property (nonatomic ,strong)NSString *specName;/**< 用户选择到的规格 */

@property (nonatomic ,copy)NSString *specPrice;/**< 选择玩规格之后显示的价格 这个会清空变为@"" */

@property (nonatomic ,copy)NSString *specPrice2;/**< 选择玩规格之后显示的价格 这个不会清空 */

@property(nonatomic,strong)NSMutableDictionary *heightDic;
@end

@implementation SMProductDetailController

-(Product *)product
{
    if (!_product) {
        _product = [Product new];
    }
    return _product;
}

static NSString * const reuserIdentifier4 = @"detailProductSection4Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KControllerBackGroundColor;
    NSString *headStr = SKAPI_PREFIX_SHARE;
    NSString *footStr = SKAPI_FOOTER_SHARE;
    self.webStr = [headStr stringByAppendingString:footStr];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self.view addSubview:self.tableView];
    
    [self loadDatas];
    
    //[self setupHeadeerView];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 294)];
    self.tableView.tableHeaderView = view;
    
    [self setupBackBtn];
    
//    [self setupFootter];
    
    [self setupBottomView];
    
    
    self.tableView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight - KTableViewOffset);
    self.tableView.contentOffset = CGPointMake(0, KTableViewOffset);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBtnClick) name:KProductDetailCancelNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseNumJump:) name:@"chooseNumNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSpecName:) name:@"KSpecifications" object:nil];
    
//    if (self.isBelongCounter) {
//        [self.tableView reloadData];
//    }
    [self.tableView registerClass:[SMDetailProductSection4Cell class] forCellReuseIdentifier:reuserIdentifier4];
    
    // 用于缓存cell高度
    self.heightDic = [[NSMutableDictionary alloc] init];
    
    // 注册加载完成高度的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewNotification:) name:@"WEBVIEW_HEIGHT" object:nil];
}

- (void)webViewNotification:(NSNotification *)notice
{
    SMDetailProductSection4Cell *cell = [notice object];
    //获取cell所在索引
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    CGFloat height = [notice.userInfo[@"rowHeight"] floatValue];
    SMLog(@"indexPath = %lu,%lu---%lf",indexPath.section,indexPath.row,height);
    if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue] != height)
    {
        [self.heightDic setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)refreshSpecName:(NSNotification *)noti{
    self.specName = noti.userInfo[@"KSpecificationsSpecName"];
    SMLog(@"refreshSpecName   KSpecificationsSpecName  %@",self.specName);
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)chooseNumJump:(NSNotification *)noti{
    NSInteger isBelongCounter = [noti.userInfo[@"chooseNumNotiKey"] integerValue];
    SMLog(@"isBelongCounter     %zd",isBelongCounter);
    SMChooseNumViewController *vc = [[SMChooseNumViewController alloc] init];
    vc.delegate = self;
    vc.productID = self.product.id;
    if (isBelongCounter) {
        vc.isBelongCounter = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMChooseNumViewControllerDelegate
- (void)userHasChooseNum{
    self.haveChooseNum = YES;
}

- (void)setupBottomView{
    
    if (self.isGoodsShelf) {
        SMNewFooterView * footer = [[[NSBundle mainBundle] loadNibNamed:@"SMNewFooterView" owner:self options:nil] lastObject];
        footer.delegate = self;
        [self.view addSubview:footer];
        
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.tableView.mas_bottom).with.offset(-5);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        
        //购物车按钮
        CGFloat shareX = CGRectGetMinX(self.shareBtn.frame);
        CGFloat x = shareX - KBtnWH - 10;
        CGFloat y;
        
        CGFloat width;
        CGFloat height;
        
        if (isIPhone5) {
            y = KBtnY;
            width = KBtnWH;
            height = KBtnWH;
        }else if (isIPhone6){
            y = KBtnY *KMatch6;
            width = KBtnWH *KMatch6;
            height = KBtnWH *KMatch6;
        }else if (isIPhone6p){
            y = KBtnY *KMatch6p;
            width = KBtnWH *KMatch6p;
            height = KBtnWH *KMatch6p;
        }
        
        UIButton *cartBtn = [[UIButton alloc] init];
        [self.view addSubview:cartBtn];
        self.cartBtn = cartBtn;
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"gouwucheddd"] forState:UIControlStateNormal];
        cartBtn.frame = CGRectMake(x, y, width, height);
        [cartBtn addTarget:self action:@selector(cartBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        cartBtn.backgroundColor = [UIColor yellowColor];
        
    }else{
        SMDetailProductFootterView *bottomView = [SMDetailProductFootterView detailProductFootterView];
        bottomView.delegate = self;
        if (self.isPushCounter) {
            bottomView.isClick = YES;
        }
        
        [self.view addSubview:bottomView];
        //    bottomView.frame = CGRectMake(0, KScreenHeight - 44 - 20, KScreenWidth, 44);
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.tableView.mas_bottom).with.offset(-5);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }];
    }
 
}

- (void)cartBtnClick{
    SMLog(@"点击了 购物车");
    SMShoppingCartController *vc = [[SMShoppingCartController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMJoinGoodsShelfDelegate
//微柜台 加入购物车按钮
-(void)joinBtnClick{
    SMLog(@"点击了 加入购物车");
    if ([self.product.classModel isEqualToString:@"dianxin"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电信选号类商品不可加入购物车，请点立即购买。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.flag) { //如果已经选择过商品规格了
        //加到购物车  , 可以缓存 形式  添加
        
        SMLog(@"self.spec.id  %@  self.product.id  %@",self.spec.id,self.product.id);
        NSString *ID;
        if (self.spec) {
            ID = self.spec.id;
        }else{
            ID = self.product.id;
        }
        SMLog(@"如果已经选择过商品规格了   ID  %@",ID);
        [[SKAPI shared] putCartByProductId:ID andAmount:1 block:^(id result, NSError *error) {
            if (!error) {
                //添加成功
                SMLog(@"%@",result);
//                SMShoppingCartController *vc = [[SMShoppingCartController alloc] init];
//                
//                [self.navigationController pushViewController:vc animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                //添加失败
                SMLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车失败，请重新添加." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }else{ //之前还没有选择过商品规格的，就显示商品规格出来.
        self.isClickingCart = YES;
        [self showUpView];
    }
    
    
}

- (void)goToCounterDidClick{
    SMLog(@"点击了 进入柜台   其实就是直接返回到上一个界面");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyNowBtnDidClick{
    SMLog(@"点击了 立即购买");
    
    //如果是电信商品
    if ([self.product.classModel isEqualToString:@"dianxin"]) {
        if (self.haveChooseNum) { //如果已经选择过号码了，就跳到上传证件界面
            SMNetworkViewController *vc = [[SMNetworkViewController alloc] init];
            vc.isDianxin = YES;
            vc.productID = self.product.id;
            SMLog(@"self.spec buyNowBtnDidClick  %@",self.spec);
//            vc.spec = self.spec;
//            vc.phoneNum = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
        }else{  //如果还没有选择号码，弹出选择规格界面
            [self showUpView];
        }
        
        return;
    }
    
    
    //先做一个标记，目前是通过点击“立即购买” 进入的 upView 界面
    self.isClickingBuyNow = YES;
    
    if (self.flag) {//如果已经选择过商品规格,就可以直接跳到支付界面购买
        
        SMLog(@"直接跳到支付界面购买");
        
        NSString * nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
        NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
        NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
        NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
        
        addressModle * modle = [addressModle new];
        modle.name = nameStr;
        modle.phone = phoneStr;
         
        modle.address = [NSString stringWithFormat:@"%@%@",provinceStr,detailAddress];
        
        //产品cart
        Cart * cart = [Cart new];
        cart.id = self.product.id;
        
#warning 购买数量给定
        cart.amount = self.buyCount;
//        cart.productId = self.product.id;
        if (self.arrSkuS.count) { //有规格
            cart.productId = self.spec.id;
        }else{  //没规格
            cart.productId = self.product.id;
        }
        
        cart.productName = self.product.name;
        cart.productPrice = self.product.price;
        cart.productFinalPrice = self.product.finalPrice;
        
        SMLog(@"cart.productPrice  %@  cart.productFinalPrice  %@",cart.productPrice,cart.productFinalPrice);
        cart.imagePath = self.product.imagePath;
        //            cart.companyId = self.product.com
        cart.companyName  = self.product.companyName;
        cart.shippingFee = self.product.shippingFee;
        cart.isSelect = YES;
        if (nameStr && phoneStr && provinceStr && detailAddress) { //如果已经填写过收货地址信息
#pragma mark -- 为了修改立即购买的bug  这里先加入购物车  再跳转购买界面测试
            //直接跳转到购买界面
            
            NSString *ID;
            if (self.arrSkuS.count > 0) { //有规格
                ID = self.spec.id;
            }else{  //没规格
                ID = self.product.id;
            }
            SMLog(@"如果已经选择过商品规格了   ID  %@",ID);
            
            [[SKAPI shared] putCartByProductId:ID andAmount:1 block:^(id result, NSError *error) {
                if (!error) {
                    //添加成功
                    SMLog(@"putCartByProductId  result  %@",result);
                    //                SMShoppingCartController *vc = [[SMShoppingCartController alloc] init];
                    //
                    //                [self.navigationController pushViewController:vc animated:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
                    
                    
                    SMConfirmPaymentController * confirm = [[SMConfirmPaymentController alloc]init];
                    //cart.shippingFee  = self.product.ship
                    confirm.address = modle;
                    [confirm.cartArray addObject:cart];
                    
                    SMLog(@"self.upView.topView.priceLabel.text   %@",self.upView.topView.priceLabel.text);
                    confirm.specPrice = self.specPrice2;
                    confirm.specName = self.specName;
                    [self.navigationController pushViewController:confirm animated:YES];
                    
                }else{
                    //添加失败
                    SMLog(@"%@",error);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车失败，请重新添加." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
            
            
        }else{ //还没填写收货地址信息，跳转到填写地址信息界面
            
            SMShippingController * shipping = [[SMShippingController alloc]init];
            [shipping.cartArray addObject:cart];
            shipping.specPrice = self.specPrice2;
            shipping.specName = self.specName;
            [self.navigationController pushViewController:shipping animated:YES];
        }


    }else{//还有没有选择商品规格
        [self showUpView];
    }
    
}

//- (void)setupFootter{
//    SMDetailProductFootterView *footter = [SMDetailProductFootterView detailProductFootterView];
//    footter.frame = CGRectMake(0, 0, KScreenWidth, 44);
//    self.tableView.tableFooterView = footter;
//    footter.delegate = self;
//}

#pragma mark -- SMDetailProductFootterViewDelegate
- (void)upBtnDidClick:(UIButton *)sender{
    SMLog(@"点击了 上架");
    //需要给出选择tabelview  具体的高度  并刷新
    self.cheatView.isCounter = NO;
    
    if (!self.isPushCounter) {  //如果不是从微柜台过来的
        
        [self.cheatView requestshelfData]; 
    }else{ //微柜台过来的
        if (self.isup) {
           [self addProduct];
            
        }else{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该商品已经在货架上，请勿重复添加" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVc animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }
    
}

- (void)downBtnDidClick{
    SMLog(@"点击了 下架");
    //需要给出选择tabelview  具体的高度  并刷新
    self.cheatView.isCounter = NO;
    
    if (!self.isPushCounter) {
        [self.cheatView CounterCheck];
    }else
    {
        if (!self.isup) {
            [self cutoutProduct];
        }else{
//
            //应该判断是否在改柜台中  若不在改柜台上就不能下架
            //可以读取本地数据  也可以获取网络上的额
            NSArray * array = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.favorites.id inContext:[NSManagedObjectContext MR_defaultContext]];
            SMLog(@"customer  arrya =   %@",array);
            //判断是否在货架中
            for (NSInteger i=0;i<array.count;i++) {
                LocalFavoritesDetail * favdetail = array[i];
                
                if (favdetail.type.integerValue == 0) {
                    
                    if ([favdetail.itemId isEqualToString:self.product.id]) {
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

- (void)goToShelfBtnDidClick{
    SMLog(@"点击了 进入微柜台");
    
    self.cheatView.isCounter = YES;
    [self.cheatView CounterCheck];
}

- (void)setupBackBtn{
    CGFloat x = 10;
    CGFloat y;

    CGFloat width;
    CGFloat height;
    
    if (isIPhone5) {
        y = KBtnY;
        width = KBtnWH;
        height = KBtnWH;
    }else if (isIPhone6){
        y = KBtnY *KMatch6;
        width = KBtnWH *KMatch6;
        height = KBtnWH *KMatch6;
    }else if (isIPhone6p){
        y = KBtnY *KMatch6p;
        width = KBtnWH *KMatch6p;
        height = KBtnWH *KMatch6p;
    }
    
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui-1"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(x, y, width, height);
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor greenColor];
    
    //分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    [self.view addSubview:shareBtn];

    [shareBtn setBackgroundImage:[UIImage imageNamed:@"fenxiangDetailProduct"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(KScreenWidth - x - width, y, width, height);
    
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    shareBtn.backgroundColor = [UIColor greenColor];
    self.shareBtn = shareBtn;
}

- (void)shareBtnClick{
    SMLog(@"点击了 分享按钮");
    
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

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
 
    NSDate *localeDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SMLog(@"timeSp :%@",timeSp); //时间戳的值
    
    
    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
    //拿到第一张图片地址
    NSString *imageStr = arrStrs[0];
    NSString *imageStr2 = [imageStr stringByAppendingString:@"?w=100&h=100&q=30"];

    SMLog(@"imageStr2   %@",imageStr2);
    
    NSString *headStr = self.webStr;
    
    SMLog(@"headStr   %@",headStr);
    //拿到自己的userID拼接到分享出去的网页参数上
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    
    NSString *urlStr = [headStr stringByAppendingString:[NSString stringWithFormat:@"?pid=%@&mode=0&sid=%@&t=%@",self.product.id,userID,timeSp]];
    
//    NSString *urlChang1 = [urlStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
//    NSString *urlChang2 = [urlChang1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
//    NSString *urlChang3 = [urlChang2 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
//    NSString *urlChang4 = [urlChang3 stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
//    NSString *urlChang5 = [urlChang4 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//    SMLog(@"urlChang5   %@",urlChang5);
    
    /*
    if (type == 22) { //分享到微信
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        SMLog(@"urlStr   %@",urlStr);
        urlStr = [Utils createOauthUrlForCode:KWechatAcunt andRedirectUrl:urlStr andMoreinfo:NO];
    }
    */
    
    SMLog(@"最终分享出去的url   %@",urlStr);
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",self.product.name]
                                     images:imageStr2
                                        url:[NSURL URLWithString:urlStr]
                                      title:[NSString stringWithFormat:@"%@掌柜",userName]
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

- (void)cancelBtnDidClick{
    [self removeCheatView2];
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDatas{
    
    if (self.itemId.length > 0) {
        
        [[SKAPI shared] queryProductById:self.itemId  block:^(Product *product, NSError *error) {
            if (!error) {
                
                self.product = product;
                
                SMLog(@"self.product.id  %@   self.product  %@",self.product.id,self.product);
                [[SKAPI shared] queryProductById:self.product.id block:^(Product *product, NSError *error) {
                    if (!error) {
                        if (product == nil) {
                            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该商品已下架" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            
                            [self.popAlertView show];
                        }else{
                            self.product = product;
                            //            [self setupHeadeerView];
                            [self.tableView reloadData];
                            [self setupHeadeerView];
                            SMLog(@"product =    %@",product.videoPath);
                        }
                        SMLog(@"queryProductById  product   %@    self.product.descr,%@",self.product,self.product.descr);
                    }else{
                        SMLog(@"error  %@",error);
                    }
                }];
                
                
            }else{
                SMLog(@"error   %@",error);
            }
        }];
        
    }else{
        
        SMLog(@"self.product.id  %@   self.product  %@",self.product.id,self.product);
        [[SKAPI shared] queryProductById:self.product.id block:^(Product *product, NSError *error) {
            if (!error) {
                if (product == nil) {
                    self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该商品已下架" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

                    [self.popAlertView show];
                }else{
                    self.product = product;
                    //            [self setupHeadeerView];
                    [self.tableView reloadData];
                    [self setupHeadeerView];
                    SMLog(@"product =    %@",product.videoPath);
                }
                SMLog(@"queryProductById  product   %@    self.product.descr,%@",self.product,self.product.descr);
            }else{
                SMLog(@"error  %@",error);
            }
        }];
    
    }
    
}

- (void)setupHeadeerView{
    SMCarouselView *carouse = [[SMCarouselView alloc] initWithModel:self.product];
//    carouse.product = self.product;
    carouse.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth);
    self.tableView.tableHeaderView = carouse;
    carouse.delegate = self;
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cheatViewDisappear) name:@"KCheatViewDisappear" object:nil];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KCheatViewDisappear" object:nil];
}

-(void)cheatViewDisappear
{
    [self.cheatView disappearClick];
    SMLog(@"disappearClick");
}

#pragma mark -- UITableViewDelegate,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
//    if (section == 3) {//第三组
//        self.section3CellCount = self.arrSkuS.count + 1;
//        return self.section3CellCount;
//    }
//    return 1;

    if (section == 0) { //第一组
        self.lastIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        return 4;
    }else{  //第二组
        if (self.product.videoPath && ![self.product.videoPath isEqualToString:@""]) {
//            self.lastIndex = [NSIndexPath indexPathForRow:1 inSection:1];
            return 2;
        }else{
//            self.lastIndex = [NSIndexPath indexPathForRow:0 inSection:1];
            return 1;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 3 && indexPath.row == 0) {//如果点击的是第三组的最顶部cell
//        self.section3Row0Cell.rightBtn.selected = !self.section3Row0Cell.rightBtn.selected;
//        if (self.section3Row0Cell.rightBtn.selected) {
////            NSArray *arrSkuS = [skuSelected mj_objectArrayWithKeyValuesArray:self.product.skuSelected];
//            NSArray *arrSkuS = [sku mj_objectArrayWithKeyValuesArray:self.product.sku];
//            self.arrSkuS = arrSkuS;
//            SMLog(@"skuS   %@  --   %@",arrSkuS,self.product.skuSelected);
//            [self.tableView reloadData];
//            
//        }else{
//            self.arrSkuS = nil;
//            [self.tableView reloadData];
//        }
//
//    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        [self showUpView];
    }
}

- (void)showUpView{
    //先给个标记，证明在这个页面已经打开过商品规格界面了。
    self.flag = YES;
    
    NSArray *arrSkuS = [sku mj_objectArrayWithKeyValuesArray:self.product.sku];
    self.arrSkuS = arrSkuS;
    SMLog(@"skuS   %@  --   %@",arrSkuS,self.product.skuSelected);
    //        [self.tableView reloadData];
    
    
    SMJumpUpView *upView = [[SMJumpUpView alloc] init];
    
    if ([self.product.classModel isEqualToString:@"dianxin"]) {
        upView.isDianxin = YES;
    }
    if (self.isBelongCounter) {
        upView.isBelongCounter = YES;
    }
    upView.product = self.product;
    upView.arrSkus = arrSkuS;
    self.upView = upView;
    upView.deledate = self;
    
    
    
//    if (self.isBelongCounter || self.isGoodsShelf || self.isPushCounter) {
//        upView.isNotCounter = YES;
//    }else{
//        upView.isNotCounter = NO;
//    }
    
    
    //蒙板
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor lightGrayColor];
    grayView.alpha = 0.4;
    [self.view addSubview:grayView];
    grayView.frame = self.view.bounds;
    self.grayView = grayView;
    
    CGFloat upViewHeight;
    if (isIPhone5) {
        upViewHeight = 398;
    }else if (isIPhone6){
        upViewHeight = 398 *KMatch6Height;
    }else if (isIPhone6p){
        upViewHeight = 398 *KMatch6pHeight;
    }
    
    
    //添加upView
    [self.view addSubview:upView];
    upView.frame = CGRectMake(0, KScreenHeight - upViewHeight, KScreenWidth, upViewHeight);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGrayView)];
    [grayView addGestureRecognizer:tap];
    
    //最上面突出来的imageView
    UIButton *topIconBjView = [[UIButton alloc] init];
    //        topIconBjView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topIconBjView];
    self.topIconBjView = topIconBjView;
    CGFloat topIconHeight;
    if (isIPhone5) {
        topIconHeight = 90;
    }else if (isIPhone6){
        topIconHeight = 90 *KMatch6Height;
    }else if (isIPhone6p){
        topIconHeight = 90 *KMatch6pHeight;
    }
    topIconBjView.frame = CGRectMake(10, KScreenHeight - upViewHeight - 23, topIconHeight, topIconHeight);
    topIconBjView.layer.cornerRadius = SMCornerRadios * 2;
    topIconBjView.clipsToBounds = YES;
    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
    NSString *imageStr = arrStrs[0];
    [topIconBjView setBackgroundImage:[UIImage imageNamed:@"220"] forState:UIControlStateNormal];

    [topIconBjView sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
    topIconBjView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)cancelBtnClick{
    
    self.specPrice2 = self.upView.topView.priceLabel.text;
    SMLog(@"self.specPrice2  cancelBtnClick   %@",self.specPrice2);
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
    [self hideUpView];
}

- (void)specificationsDidClick:(ProductSpec *)spec{
    self.spec = spec;
    SMLog(@"spec.id  specificationsDidClick  %@",spec.id);
//    
//    [[SKAPI shared] putCartByProductId:spec.id andAmount:1 block:^(id result, NSError *error) {
//        if (!error) {
//            //添加成功
//            SMLog(@"putCartByProductId  result  specificationsDidClick   添加到购物车成功 %@",result);
//            [self hideUpView];
//            
//            
//        }else{
//            //添加失败
//            SMLog(@"加入购物车失败，请重新添加  %@",error);
//        }
//    }];

}



#pragma mark -- SMJumpUpViewDeledate
- (void)sureBtnDidClick:(NSInteger)buyCount andPhoneNum:(NSString *)phoneNum{
    
    self.specPrice = self.upView.topView.priceLabel.text;
    self.specPrice2 = self.upView.topView.priceLabel.text;
    SMLog(@"self.specPrice  sureBtnDidClick  %@ ",self.specPrice);
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
    self.phoneNum = phoneNum;
    SMLog(@"[self.imageView isAnimating]   %zd",[self.imageView isAnimating]);
    if (self.imageViewIsAnimating) { //如果imageView 正在执行动画 就不继续响应这个事件
        return;
    }
#pragma mark -- 在这里面跳转到确认支付页面
    SMLog(@"点击了确定    sureBtnDidClick");
    SMLog(@"phoneNum    %@  buyCount  %zd",phoneNum,buyCount);
    if ([phoneNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，此商品需要选择号码的喔" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    

    self.buyCount = buyCount;
    if (self.buyCount == 0) {
        self.buyCount = 1;
    }
    //如果选择的数量大于库存量，则提示库存不够
    if (self.product.stock < buyCount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱哒，库存不够这么多喔～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self.buyCount =self.product.stock;
        return;
    }
    
    if (!self.isClickingCart && !self.isClickingBuyNow) {//如果既不是点购物车进来的，又不是点立即购买进来的。（直接点商品规格进来的这个uoView界面）
        //这个情况暂时处理是直接隐藏upView。  （如果以后增加了规格的借口，这里就需要把用户点了确认是选择的规格传给后台去）
        
        
        
        
        [self hideUpView];
        
    }
    
    if (self.isClickingCart) {//如果是通过直接点加入购物车跳到的这个upView界面
        
        NSString *ID;
        if (self.spec) {
            ID = self.spec.id;
        }else{
            ID = self.product.id;
        }
        
        //加到购物车  , 可以缓存 形式  添加
        [[SKAPI shared] putCartByProductId:ID andAmount:1 block:^(id result, NSError *error) {
            if (!error) {
                //添加成功
                [self goToCartAnimate];
            }else{
                //添加失败
                SMLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入购物车失败，请重新添加." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    
    if (self.isClickingBuyNow) {//如果是通过点击 立即购买跳进来的 这个upView界面
        
        if ([self.product.classModel isEqualToString:@"dianxin"]) { //如果是电信选号商品，跳到填写身份证信息界面
            SMNetworkViewController *vc = [[SMNetworkViewController alloc] init];
            vc.isDianxin = YES;
            vc.productID = self.product.id;
            vc.spec = self.spec;
            vc.phoneNum = phoneNum;
            vc.phoneNum = self.phoneNum;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{  //如果是普通商品，跳到支付界面 (有判断是否填写过收货地址)
            //进到支付界面去(有判断是否填写过收货地址)
            SMLog(@"跳到支付界面去");
            NSString * nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
            NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
            NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
            NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
            
            addressModle * modle = [addressModle new];
            modle.name = nameStr;
            modle.phone = phoneStr;
            
            modle.address = [NSString stringWithFormat:@"%@%@",provinceStr,detailAddress];
            
            //产品cart
            Cart * cart = [Cart new];
            cart.id = self.product.id;
            cart.amount = buyCount;
//            cart.productId = self.product.id;
            if (self.arrSkuS.count) { //有规格
                cart.productId = self.spec.id;
            }else{  //没规格
                cart.productId = self.product.id;
            }
            
            cart.productName = self.product.name;
            cart.productPrice = self.product.price;
            cart.productFinalPrice = self.product.finalPrice;
            cart.imagePath = self.product.imagePath;
            //            cart.companyId = self.product.com
            cart.companyName  = self.product.companyName;
            cart.shippingFee = self.product.shippingFee;
            cart.isSelect = YES;
            
            SMLog(@"self.arrSkuS.count  %zd",self.arrSkuS.count);
            if (nameStr && phoneStr && provinceStr && detailAddress) {
                //先加入购物车  然后 跳转到购买界面
                
                if (self.arrSkuS.count) { //有规格
                    [[SKAPI shared] putCartByProductId:self.spec.id andAmount:1 block:^(id result, NSError *error) {
                        if (!error) {
                            //添加成功
                            SMLog(@"putCartByProductId  result  %@",result);
                            
                            SMConfirmPaymentController * confirm = [[SMConfirmPaymentController alloc]init];
                            confirm.address = modle;
                            [confirm.cartArray addObject:cart];
                            confirm.specPrice = self.upView.topView.priceLabel.text;
                            confirm.specName = self.specName;
                            [self.navigationController pushViewController:confirm animated:YES];
                            
                        }else{
                            //添加失败
                            SMLog(@"加入购物车失败，请重新添加  %@",error);
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert show];
                        }
                    }];
                }else{  //没规格
                    [[SKAPI shared] putCartByProductId:self.product.id andAmount:1 block:^(id result, NSError *error) {
                        if (!error) {
                            //添加成功
                            SMLog(@"putCartByProductId  result  %@",result);
                            
                            SMConfirmPaymentController * confirm = [[SMConfirmPaymentController alloc]init];
                            confirm.address = modle;
                            [confirm.cartArray addObject:cart];
                            [self.navigationController pushViewController:confirm animated:YES];
                            
                        }else{
                            //添加失败
                            SMLog(@"加入购物车失败，请重新添加  %@",error);
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert show];
                        }
                    }];

                }
                
                
                
                
            }else{
                SMShippingController * shipping = [[SMShippingController alloc]init];
                [shipping.cartArray addObject:cart];
                shipping.specPrice = self.upView.topView.priceLabel.text;
                shipping.specName = self.specName;
                [self.navigationController pushViewController:shipping animated:YES];
            }
            
        }
    }
    
    self.specPrice = @"";
}

//点击加入购物车后，商品图像移动的动画
- (void)goToCartAnimate{
    self.imageViewIsAnimating = YES;
    //执行动画
    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
    NSString *imageStr = arrStrs[0];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    [self.view addSubview:imageView];
    imageView.frame = self.topIconBjView.frame;
    imageView.layer.cornerRadius = SMCornerRadios *2;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [UIView animateWithDuration:1 animations:^{
        imageView.frame = self.cartBtn.frame;
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        [self hideUpView];
    }];
}

- (void)tapGrayView{
    self.specPrice2 = self.upView.topView.priceLabel.text;
    SMLog(@"self.specPrice2  cancelBtnClick   %@",self.specPrice2);
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    
    [self hideUpView];
}

- (void)hideUpView{
    self.imageViewIsAnimating = NO;
    [self.grayView removeFromSuperview];
    [self.upView removeFromSuperview];
    [self.topIconBjView removeFromSuperview];
    self.grayView = nil;
    self.upView = nil;
    self.topIconBjView = nil;
    
    self.isClickingCart = NO;
    self.isClickingBuyNow = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
//    if (indexPath.section == 0) {
//        SMDetailProductSection0Cell *section0Cell = [SMDetailProductSection0Cell cellWithTableView:tableView];
//        self.section0Cell = section0Cell;
//        
//        //模型赋值，在set方法里实现内部各属性的相应赋值
//        section0Cell.product = self.product;
//        return section0Cell;
//        
//    }else if (indexPath.section == 1){
//        SMDetailProductSection1Cell *cell = [SMDetailProductSection1Cell cellWithTableView:tableView];
//        cell.product = self.product;
//        return cell;
//    }else if (indexPath.section == 2){
//        return [SMDetailProductSection2Cell cellWithTableView:tableView];
//    }else if (indexPath.section == 3){//第三组
//        if (indexPath.row == 0) {//商品规格
//            SMDetailProductSection3Cell *cell = [SMDetailProductSection3Cell cellWithTableView:tableView];
//            self.section3Row0Cell = cell;
//            SMLog(@"self.product   cell.product = self.product   %@",self.product);
//            return cell;
//        }else{//商品规格内详情
//            skuSelected *skuS = self.arrSkuS[indexPath.row - 1];
//            SMSection3Row1Cell *cell = [SMSection3Row1Cell cellWithTableView:tableView andModel:skuS];
//            cell.skuS = skuS;
//            cell.belongToCounter = self.isBelongCounter;
//            self.cellHeight1 = cell.cellHeight;
//            return cell;
//        }
//    }else{//第四组
//        SMDetailProductSection4Cell *cell = [SMDetailProductSection4Cell cellWithTableView:tableView];
//        cell.product = self.product;
//        SMLog(@"self.product   SMDetailProductSection4Cell  %@",self.product);
//        return cell;
//    }
    }
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {
            SMDetailProductSection0Cell *section0Cell = [SMDetailProductSection0Cell cellWithTableView:tableView];
            self.section0Cell = section0Cell;
            
            //模型赋值，在set方法里实现内部各属性的相应赋值
            section0Cell.specPrice = self.specPrice;
            section0Cell.specPrice2 = self.specPrice2;
            section0Cell.product = self.product;
            
            return section0Cell;
        }else if (indexPath.row == 1){
            SMDetailProductSection3Cell *cell = [SMDetailProductSection3Cell cellWithTableView:tableView];
            self.section3Row0Cell = cell;
            cell.specName = self.specName;
            SMLog(@"self.product   cell.product = self.product   %@",self.product);
            return cell;
        }else if (indexPath.row == 2){
            SMDetailProductSection1Cell *cell = [SMDetailProductSection1Cell cellWithTableView:tableView];
            cell.product = self.product;
            return cell;
        }else{
            return [SMDetailProductSection2Cell cellWithTableView:tableView];
        }
    }else{//第二组
        SMLog(@"self.product.videoPath    %@ ",self.product.videoPath);
        if (self.product.videoPath && ![self.product.videoPath isEqualToString:@""]) {  //如果有视频 ，就展示
            if (indexPath.row == 0) {
                SMProductVideoTableViewCell * cell = [SMProductVideoTableViewCell cellWithTableView:tableView];
                [cell loadVideo:self.product.videoPath];
                return cell;
            }else{
                
                SMDetailProductSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier4 forIndexPath:indexPath];//[SMDetailProductSection4Cell cellWithTableView:tableView];
                cell.product = self.product;
                SMLog(@"self.product   SMDetailProductSection4Cell  %@",self.product);
                return cell;
            }
        }else{  //没有视频就隐藏视频那个cell
            SMDetailProductSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier4 forIndexPath:indexPath];//[SMDetailProductSection4Cell cellWithTableView:tableView];
            cell.product = self.product;
            cell.delegate = self;
            SMLog(@"self.product   SMDetailProductSection4Cell  %@",self.product);
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
//    if (indexPath.section == 0) {
////        CGFloat height;
////        if (isIPhone5) {
////            height = 70;
////        }else if (isIPhone6){
////            height = 70 *KMatch6;
////        }else if (isIPhone6p){
////            height = 70 *KMatch6p;
////        }
//        return 75;
//    }else if (indexPath.section == 1){
//        CGFloat height;
//        if (isIPhone5) {
//            height = 64;
//        }else if (isIPhone6){
//            height = 64 *KMatch6;
//        }else if (isIPhone6p){
//            height = 64 *KMatch6p;
//        }
//        return height;
//    }else if (indexPath.section == 2){
//        CGFloat height;
//        if (isIPhone5) {
//            height = 44;
//        }else if (isIPhone6){
//            height = 44 *KMatch6;
//        }else if (isIPhone6p){
//            height = 44 *KMatch6p;
//        }
//        return height;
//    }else if (indexPath.section == 3){
//        if (indexPath.row == 0) {
//            return 44;
//        }else{
//            return self.cellHeight1;
//        }
//    }else{
//        //400是webView 高度   30 是@“图文详情” 高度
//        return 400 + 30;
//    }
    }
    CGFloat height = 0.0;
    if (isIPhone5) {
        height = 44;
    }else if (isIPhone6){
        height = 44 *KMatch6;
    }else if (isIPhone6p){
        height = 44 *KMatch6p;
    }
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {
            //动态计算高度
            //文本名字的高度  +  下面的高度  3行label 的高度  63
            CGSize size = [self.product.name boundingRectWithSize:CGSizeMake(KScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            SMLog(@"size.height  %f",size.height);
            return size.height + 40 + 20;
            
            
        }else if (indexPath.row == 1){
            return height;
        }else if (indexPath.row == 2){
            return height;
        }else{
            return height;
        }
    }else{//第二组
        if (self.product.videoPath && ![self.product.videoPath isEqualToString:@""]) {  //有视频
            if (indexPath.row == 0) {
                CGFloat height;
                if (isIPhone5) {
                    height = 200;
                }else if (isIPhone6){
                    height = 200 *KMatch6Height;
                }else if (isIPhone6p){
                    height = 200 *KMatch6pHeight;
                }
                return height;
            }else{//        400是webView 高度   30 是@“图文详情” 高度
                return [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
            }
        }else{  //没视频
            return [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark - cell delegate
-(void)backToTableView{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}

-(void)setWebViewCellHeight:(CGFloat)height{
    self.cellHeight = height;
    [self.tableView reloadData];
}

#pragma mark - SYPhotoBrowser Delegate

- (void)photoBrowser:(SYPhotoBrowser *)photoBrowser didLongPressImage:(UIImage *)image {
    self.theSaveImage = image;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否保存图片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.photoBrowserAlert = alert;
    [alert show];
}

//保存到相册
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView == self.photoBrowserAlert) {//如果响应的是提示是否保存到相册的提示框，并且用户选择了“是”
        UIImageWriteToSavedPhotosAlbum(self.theSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else if (alertView == self.popAlertView && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark -- SMCarouselViewDelegate
- (void)headerViewDidClickedPage:(NSInteger)page{
    SMLog(@"点击了headerView    %zd",page);
    
    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:arrStrs delegate:self];
    photoBrowser.initialPageIndex = page;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
    
//    MHPhotoBrowserController *vc = [MHPhotoBrowserController new];
//    NSMutableArray * bigImgArray = [NSMutableArray new];
//    
//    for (NSString *imageStr in arrStrs) {
//        [bigImgArray addObject:[MHPhotoModel photoWithURL:[NSURL URLWithString:imageStr]]];
//    }
//    
//    vc.currentImgIndex = (int)page;
//    vc.displayTopPage = YES;
//    vc.displayDeleteBtn = YES;
//    vc.imgArray = bigImgArray;
//    
//    [self presentViewController:vc animated:NO completion:nil];
    
    
//    //点击大图，不带拖拽动画的代码
//    NSArray *arrStrs = [NSString mj_objectArrayWithKeyValuesArray:self.product.imagePath];
//    MHPhotoBrowserController *vc = [MHPhotoBrowserController new];
//    NSMutableArray * bigImgArray = [NSMutableArray new];
//    
//    for (NSString *imageStr in arrStrs) {
//        [bigImgArray addObject:[MHPhotoModel photoWithURL:[NSURL URLWithString:imageStr]]];
//    }
//    
//    vc.currentImgIndex = (int)page;
//    vc.displayTopPage = YES;
//    vc.displayDeleteBtn = YES;
//    vc.imgArray = bigImgArray;
//    
//    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect rectTableView = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49);
        _tableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = KGrayColorSeparatorLine;
        _tableView.delegate = self;
        _tableView.dataSource  = self;
    }
    return _tableView;
}

- (NSArray *)arrSkuS{
    if (_arrSkuS == nil) {
        _arrSkuS = [NSArray array];
    }
    return _arrSkuS;
}

-(SMCheatView *)cheatView
{
    if (!_cheatView) {
        _cheatView = [SMCheatView initWithID:self.product.id andType:0 andHeight:0];
        
        _cheatView.pushblock =^(UIViewController * Vc){
            [self.navigationController pushViewController:Vc animated:YES];
        };
        
        [self.view addSubview:_cheatView];
    }
    return _cheatView;
}

//删除商品
-(void)cutoutProduct
{
    NSArray * array = [[NSArray alloc]initWithObjects:self.favorites.id, nil];
    
    [[SKAPI shared] removeItem:self.product.id fromMyStorage:array andType:0 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result = %@",result);
            //通知刷新
            NSNotification * notice = [NSNotification notificationWithName:@"RefreshData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
            
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

//添加商品
- (void)addProduct{
    //难道要请求一次   1.获取到有多少的产品  2.获取到已有产品  防止重复添加
    [[SKAPI shared] queryMyStorageItems:self.favorites.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            NSInteger i=0;
            for (FavoritesDetail * fav in array) {
                if (fav.type == 0) {
                    i++;
                }
            }
            if (i==5) {
                UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"一个专柜最多添加5个商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
            }else
            {
                for (FavoritesDetail *  favDetail in array) {
                    if (favDetail.type==0) {
                        if ([self.product.id isEqualToString: favDetail.itemId]) {
                            UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该商品已在专柜中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alerView show];
                            return ;
                        }
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
    [[SKAPI shared] addItem:self.product.id toMyStorage:array andType:0 block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"result = %@",result);
            NSNotification * notice = [NSNotification notificationWithName:@" " object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
           self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
            
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}
@end
