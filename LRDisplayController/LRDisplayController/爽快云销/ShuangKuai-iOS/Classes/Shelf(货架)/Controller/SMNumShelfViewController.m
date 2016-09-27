//
//  SMNumShelfViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNumShelfViewController.h"
#import "SMShelfProductViewController.h"
#import "SMShelfActionViewController.h"
#import "SMShelfDiscountController.h"
#import "SMImitateProductController.h"
#import "SMDiscountDetailController.h"
#import "SMActionViewController.h"
#import "SMDetailStoreHouseController.h"
#import "SMChangeShelfNameController.h"
#import "SMProductDetailController.h"
#import "AppDelegate.h"

@interface SMNumShelfViewController ()<SMShelfDiscountControllerDelegate,SMShelfActionViewControllerDelegate,SMShelfProductViewControllerDelegate,SMChangeShelfNameControllerDelegate>



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  第一页 产品
 */
@property (nonatomic ,strong)SMShelfProductViewController *vc;
/**
 *  第二页 活动
 */
@property (nonatomic ,strong)SMShelfActionViewController *vc2;
/**
 *  第三页 优惠券
 */
@property (nonatomic ,strong)SMShelfDiscountController *vc3;
/**
 *  中间的灰色View
 */
@property (weak, nonatomic) IBOutlet UIView *grayView;
/**
 *    正在处于批量管理状态  （显示出来了勾勾）
 */
@property (nonatomic ,assign)BOOL isManaging;
/**
 *  中间红线
 */
@property (weak, nonatomic) IBOutlet UIView *midRedLine;
/**
 *  左边红线
 */
@property (weak, nonatomic) IBOutlet UIView *leftRedLine;
/**
 *  右边红线
 */
@property (weak, nonatomic) IBOutlet UIView *rightRedLine;
/**
 *  添加产品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addProductBtn;
/**
 *  添加活动按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addActionBtn;

@property (weak, nonatomic) IBOutlet UILabel *addActionLabel;

/**
 *  添加优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addDisCountBtn;


@end

@implementation SMNumShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setup];
    
    [self setupScrollView];
    
//    [[SKAPI shared] queryMyStorageItems:self.favorite.id block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            SMLog(@"queryMyStorageItems   %@",array);
//        }else{
//            SMLog(@"error  %@",error);
//        }
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClick) name:@"KDeleteBtnClickNoteProduct" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClickNote) name:@"KDeleteBtnClickNoteAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnDidClick) name:@"KDeleteBtnClickNoteDiscount" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)deleteBtnDidClick{
    [self rightItemClick];
}

- (void)deleteBtnClickNote{
    [self rightItemClick];
}

- (void)deleteBtnClick{
    [self rightItemClick];
}

- (void)setup{
    self.grayView.backgroundColor = KControllerBackGroundColor;
    self.leftRedLine.backgroundColor = KRedColor;
    self.midRedLine.backgroundColor = KRedColor;
    self.rightRedLine.backgroundColor = KRedColor;
    
    self.midRedLine.hidden = YES;
    self.rightRedLine.hidden = YES;
    self.shelfNameLabel.text = self.shelfName;
    SMLog(@"self.shelfNameLabel.text       %@",self.shelfName);
    
    //暂时先屏蔽掉活动按钮
    self.addActionBtn.hidden = YES;
    self.addActionLabel.hidden = YES;
}

- (void)setupScrollView{    
    self.scrollView.contentSize = CGSizeMake(KScreenWidth *2,KScreenHeight - KStateBarHeight - 40 - 10 - 65);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    //    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    SMShelfProductViewController *vc = [[SMShelfProductViewController alloc] init];
    self.vc = vc;
    vc.fav = self.favorite;
    vc.delegate = self;
    
    SMShelfActionViewController *vc2 = [[SMShelfActionViewController alloc] init];
    //self.vc2 = vc2;
    vc2.fav = self.favorite;
    vc2.delegate = self;
    
    SMShelfDiscountController *vc3 = [[SMShelfDiscountController alloc] init];
    self.vc3 = vc3;
    vc3.fav = self.favorite;
    vc3.delegate = self;
    
    CGFloat height = KScreenHeight - KStateBarHeight - 40 - 10 - 65;
    
    
    vc.view.frame = CGRectMake(0, 0, KScreenWidth, self.scrollView.height);
    [self.scrollView addSubview:vc.view];
    
//    vc2.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, height);
//    [self.scrollView addSubview:vc2.view];
    
    vc3.view.frame = CGRectMake(KScreenWidth , 0, KScreenWidth, height);
    [self.scrollView addSubview:vc3.view];
}

- (void)setupNav{
    //self.title = [NSString stringWithFormat:@"%zd号专柜",self.currentShelfNum];
    
    self.title = self.shelfName;
    
    //右边的 发布 按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"批量管理" attributes:dict];
    
    rightBtn.width = 60;
    rightBtn.height = 20;
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)rightItemClick{
    SMLog(@"点击了 批量管理 按钮");
    self.isManaging = !self.isManaging;
    
    if (self.isManaging) {
        [self.vc managerAllClick];
        [self.vc2 managerAllClick];
        [self.vc3 managerAllClick];
    }else{
        [self.vc managerAllClickAgain];
        [self.vc2 managerAllClickAgain];
        [self.vc3 managerAllClickAgain];
    }
}

#pragma mark -- 点击事件
- (IBAction)addProductBtnClick {
    SMLog(@"点击了 添加产品");
    self.addProductBtn.selected = YES;
    self.addActionBtn.selected = NO;
    self.addDisCountBtn.selected = NO;
    
    self.leftRedLine.hidden = !self.addProductBtn.selected;
    self.midRedLine.hidden = !self.addActionBtn.selected;
    self.rightRedLine.hidden = !self.addDisCountBtn.selected;
  
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    SMImitateProductController *vc = [[SMImitateProductController alloc] init];
    vc.favID = self.favorite.id;
//    vc.arrActionIDs = self.vc.arrProducts;
//    vc.arrProductIDs = self.vc2.arrDatas;
//    vc.arrDiscountIDs =
    
    for (FavoritesDetail *f in self.vc.arrProducts) {
        [vc.arrProductIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc2.arrDatas) {
        [vc.arrActionIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc3.arrDatas) {
        [vc.arrDiscountIDs addObject:f.itemId];
    }
    [self.navigationController pushViewController:vc animated:NO];
   
}

- (IBAction)addActionBtnClick {
    SMLog(@"点击了 添加活动");
    self.addProductBtn.selected = NO;
    self.addActionBtn.selected = YES;
    self.addDisCountBtn.selected = NO;
    
    self.leftRedLine.hidden = !self.addProductBtn.selected;
    self.midRedLine.hidden = !self.addActionBtn.selected;
    self.rightRedLine.hidden = !self.addDisCountBtn.selected;
    
    [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    
    SMImitateProductController *vc = [[SMImitateProductController alloc] init];
    vc.pushedByAction = YES;
    vc.favID = self.favorite.id;
    
    for (FavoritesDetail *f in self.vc.arrProducts) {
        [vc.arrProductIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc2.arrDatas) {
        [vc.arrActionIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc3.arrDatas) {
        [vc.arrDiscountIDs addObject:f.itemId];
    }
    
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)addDiscountBtnClick {
    SMLog(@"点击了 添加优惠券");
    self.addProductBtn.selected = NO;
    self.addActionBtn.selected = NO;
    self.addDisCountBtn.selected = YES;
    
    self.leftRedLine.hidden = !self.addProductBtn.selected;
    self.midRedLine.hidden = !self.addActionBtn.selected;
    self.rightRedLine.hidden = !self.addDisCountBtn.selected;
    
    [self.scrollView setContentOffset:CGPointMake(KScreenWidth *2, 0) animated:YES];
    
    SMImitateProductController *vc = [[SMImitateProductController alloc] init];
    vc.pushedByDiscount = YES;
    vc.favID = self.favorite.id;
    
    //拿到现在已经显示出来的数据id  先加到下一个页面中去
    for (FavoritesDetail *f in self.vc.arrProducts) {
        [vc.arrProductIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc2.arrDatas) {
        [vc.arrActionIDs addObject:f.itemId];
    }
    for (FavoritesDetail *f in self.vc3.arrDatas) {
        [vc.arrDiscountIDs addObject:f.itemId];
    }
    
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)changeNameClick1 {
    [self changeName];
}

- (IBAction)changeNameClick2 {
    [self changeName];
}

- (void)changeName{
    SMLog(@"跳转至 更货架改名字界面");
    
    SMChangeShelfNameController *vc = [[SMChangeShelfNameController alloc] init];
    vc.currentShelfNum = self.currentShelfNum;
    vc.shelfID = self.favorite.id;
    vc.arrProductDatas = self.vc.arrProducts;
    vc.arrActionDatas = self.vc2.arrDatas;
    vc.arrDiscountDatas = self.vc3.arrDatas;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- scrollView代理方法
/**
 * 减速完毕时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    SMLog(@"scrollViewDidEndDragging");
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    // 获得偏移量
    CGPoint offset = scrollView.contentOffset;
    // 根据偏移量计算当前要显示的页码
    NSInteger page = (offset.x + width * 0.5) / width;
    
    if (page == 0) {
        self.leftRedLine.hidden = NO;
        self.midRedLine.hidden = YES;
        self.rightRedLine.hidden = YES;
    }else if (page == 1){
//        self.leftRedLine.hidden = YES;
//        self.midRedLine.hidden = NO;
//        self.rightRedLine.hidden = YES;
        self.leftRedLine.hidden = YES;
        self.midRedLine.hidden = YES;
        self.rightRedLine.hidden = NO;
    }else if (page == 2){
        self.leftRedLine.hidden = YES;
        self.midRedLine.hidden = YES;
        self.rightRedLine.hidden = NO;
    }
}

#pragma mark -- 代理方法 SMShelfDiscountControllerDelegate
- (void)discountCellDidClick:(NSInteger)index{
    
#pragma mark   可以在这模型赋值
    FavoritesDetail *f = self.vc3.arrDatas[index];
    NSString *discountID = f.itemId;
    SMLog(@"index   %zd",index);
    SMLog(@"discountId =    %@",discountID);
    [[SKAPI shared] queryObject:@[discountID] andType:Type_Coupon block:^(NSArray * result, NSError *error) {
        if (!error) {
            SMLog(@"discountCellDidClick    result    %@",result);
            Coupon *coupon = [Coupon mj_objectWithKeyValues:result.firstObject];
            SMDiscountDetailController *vc = [[SMDiscountDetailController alloc] init];
            vc.coupon = coupon;
            vc.pushedByShelf = YES;
            vc.favorites = self.favorite;
            vc.isPushCounter = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];

//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionCellDidClick:(NSInteger)index{
    
#pragma mark   可以在这模型赋值
    FavoritesDetail *f = self.vc2.arrDatas[index];
    [[SKAPI shared] queryObject:@[f.itemId] andType:Type_Activity block:^(NSArray *result, NSError *error) {
        if (!error) {
            SMLog(@"result.firstObject  %@",result.firstObject);
            SMActionViewController *vc = [[SMActionViewController alloc] init];
            vc.activity = [Activity mj_objectWithKeyValues:result.firstObject];
            vc.favorites = self.favorite;
            vc.isPushCounter = YES;
            SMLog(@"vc.activity    %@",vc.activity);
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
    
}

#pragma mark -- 代理方法 SMShelfProductViewControllerDelegate
- (void)productCellDidClick:(NSInteger)index isBelongToCounter:(BOOL)isBelongCounter{
    //SMDetailStoreHouseController *vc = [[SMDetailStoreHouseController alloc] init];
    
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    
#pragma mark   可以在这模型赋值
    FavoritesDetail *f = self.vc.arrProducts[index];
    Product * product =  [Product new];
    product.id = f.itemId;
    product.imagePath = f.imagePath;
    vc.product = product;
    
    vc.favorites = self.favorite;
    vc.isPushCounter = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)productCellDidClick:(NSInteger)index{
//    //SMDetailStoreHouseController *vc = [[SMDetailStoreHouseController alloc] init];
//    
//    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
//
//#pragma mark   可以在这模型赋值
//    FavoritesDetail *f = self.vc.arrProducts[index];
//    Product * product =  [Product new];
//    product.id = f.itemId;
//    product.imagePath = f.imagePath;
//    vc.product = product;
//    
//    vc.favorites = self.favorite;
//    vc.isPushCounter = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark -- SMChangeShelfNameControllerDelegate
- (void)saveSuccessName:(NSString *)name{
    self.shelfNameLabel.text = name;
    //通知刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NameRefreshData" object:nil];
}

@end
