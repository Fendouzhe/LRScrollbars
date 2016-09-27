//
//  SMStoreHouseViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMStoreHouseViewController.h"
#import "SMLeftItemBtn.h"
#import "SMSearchBar.h"
#import "SMScanerBtn.h"
#import "SMSynthesizeBtn.h"
#import "SMProductCollectionViewCell.h"
#import "SMAllProductTableViewCell.h"
#import "SMAllActionTableViewCell.h"
#import "SMDetailStoreHouseController.h"
#import "SMDiscountDetailController.h"
#import "SMActionViewController.h"
#import "SMScannerViewController.h"
#import "SMPersonCenterViewController.h"
#import "SMSearchViewController.h"
#import "SMShelfDiscountCell.h"
#import "SMProductDetailController.h"
#import "SMProductClassesController.h"

#import <MagicalRecord/MagicalRecord.h>
#import "LocalStorehouse+CoreDataProperties.h"
#import "LocalActivity+CoreDataProperties.h"
#import "LocalCoupon+CoreDataProperties.h"
#import "Reachability.h"
#import "SMRightItemView.h"
#import "SMSynthesizeBtnView.h"
#import "AppDelegate.h"
#import "SMTitleView.h"
#import "SMPersonInfoViewController.h"


#define KCollectionViewCell @"productCollectionViewCell"
@interface SMStoreHouseViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SMRightItemViewDelegate,SMSynthesizeBtnViewClickDelegate>

@property (nonatomic ,strong)SMSearchBar *searchBar;

@property (nonatomic ,strong)UIView *topView;

@property (nonatomic ,strong)UIView *leftRedView;

@property (nonatomic ,strong)UIView *midRedView;

@property (nonatomic ,strong)UIView *rightRedView;
/**
 *  全部产品按钮
 */
@property (nonatomic ,strong)UIButton *allProductsBtn;
/**
 *  全部活动按钮
 */
@property (nonatomic ,strong)UIButton *allActionBtn;
/**
 *  全部活动下的 tableView
 */
@property (nonatomic ,strong)UITableView *actionTableView;
/**
 *  优惠券按钮
 */
@property (nonatomic ,strong)UIButton *discountCouponBtn;
/**
 *  优惠券下的tableView
 */
@property (nonatomic ,strong)UITableView *discountCouponTableView;
/**
 *  全部产品view 下面的整体view
 */
@property (nonatomic ,strong)UIView *underView;
/**
 *  改变显示模式的按钮
 */
@property (nonatomic ,strong)UIButton *showModelBtn;
/**
 *  佣金排序按钮
 */
@property (nonatomic ,strong)UIButton *trustBtn;
/**
 *  销量排序按钮
 */
@property (nonatomic ,strong)UIButton *salesVolumeBtn;
/**
 *  综合排序按钮
 */
@property (nonatomic ,strong)SMSynthesizeBtn *synthesizeBtn;
/**
 *  全部产品的collectionView
 */
@property (nonatomic ,strong)UICollectionView *collectionView;
/**
 *  竖向的显示模式
 */
@property (nonatomic ,assign)BOOL verticalMode;
/**
 *  全部产品下的tableView
 */
@property (nonatomic ,strong)UITableView *productTableView;
/**
 *  点击默认排序后 ，弹出来的 选择排序的小 tableView
 */
@property (nonatomic ,strong)UITableView *sequenceTableView;
/**
 *  蒙板，可以改变它的透明度来微调整个视图的颜色对比度
 */
@property (nonatomic ,strong)UIView *cheatView;

/**
 *  全部活动的数据
 */
@property (nonatomic ,copy)NSMutableArray *dataActions;
/**
 *  全部厂品数据
 */
@property (nonatomic ,copy)NSMutableArray *dataProducts;
/**
 *  优惠券数据
 */
@property (nonatomic ,copy)NSMutableArray *dataDiscounts;
/**
 *  点击“默认排序”之后弹出来的小tableView中，对应cell的indexPath，0 就是价格从低到高，1就是价格从高到低
 */
@property (nonatomic ,assign)NSInteger flag;

@property (nonatomic ,strong)SMLeftItemBtn *leftIconBtn;
/**
 *  佣金排序那一行view的高度
 */
@property (nonatomic ,assign)CGFloat sortHeight;
/**
 *  全部活动 全部产品  那一排view 的高度
 */
@property (nonatomic ,assign)CGFloat topViewHeight;

/**
 *  用于检查网络
 */
@property (nonatomic ,strong)Reachability *reach;
@property(nonatomic,assign)NSInteger isOnline;
/**
 *  page  全部产品的页码
 */
@property(nonatomic,assign)NSInteger page;
/**
 *  活动的页码
 */
@property(nonatomic,assign)NSInteger actionPage;
/**
 *  优惠劵的页码
 */
@property(nonatomic,assign)NSInteger discointsPage;

/**
 *  排序
 */
@property(nonatomic,assign)NSInteger type;

/**
 *  加载本地数据后 不允许上拉
 */
@property(nonatomic,assign)BOOL isload;
/**
 *  排序方式  佣金or销量
 */
@property(nonatomic,assign)BOOL istype;
/**
 *  商品分类
 */
@property (nonatomic ,strong)UIButton *classesBtn;
/**
 *  排序方式
 */
@property(nonatomic,assign)PRODUCT_SORT_TYPE typecount;
/**
 *  佣金按钮弹出的Tableview
 */
@property(nonatomic,strong)UITableView * commissionTableview;

/**
 *  点击搜索时  确定搜索内容
 */
@property(nonatomic,assign)NSInteger searchCount;
/**
 *  价格排序
 */
@property(nonatomic,strong)SMSynthesizeBtnView * synthesizeView;
/**
 *  佣金排序
 */
@property(nonatomic,strong)SMSynthesizeBtnView * trustView;

@end

@implementation SMStoreHouseViewController

#pragma mark -- viewDidLoad


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUI];
    
    if (self.PushedByExtension) {//如果是从我的微推广界面push 过来的，则一进来就显示到全部活动页面
        [self allActionBtnClick];
    }
    
//    [self setupRefreshHeader];
    
    [self SetupMJRefresh];
    
    //self.reach = [Reachability reachabilityWithHostName:@"baidu.com"];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    //[self.reach startNotifier];
    
    self.page = 1;
    self.actionPage = 1;
    self.discointsPage = 1;
    
    self.type = 0;
    //[self loadNewDataDiscounts];
    
    [self loadSandBox];
    [self loadcouponData];
    
    self.collectionView.backgroundColor = SMColor(244, 245, 246);
    
    //默认排序 为销量排序
    self.typecount = SortType_Sales;
    
    //self.type = 3;

    
    [self.productTableView.mj_header beginRefreshing];
    [self.discountCouponTableView.mj_header beginRefreshing]; 

}



//- (void)setupRefreshHeader{
//    __weak typeof (self) weakSelf = self;
//    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewDataProducts];
//        [weakSelf loadNewDataActions];
//    }];
//    
////    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        [weakSelf loadMoreData];
////    }];
//
//    header.automaticallyChangeAlpha = YES;
////    footer.automaticallyRefresh = NO;
//    self.productTableView.mj_header = header;
//    self.collectionView.mj_header = header;
//    self.actionTableView.mj_header = header;
////    self.tableView.mj_footer = footer;
//}

- (void)setupUI{
    
    //设置头顶的 全部产品 全部活动 优惠券 的整体视图
    [self setupTopView];
    
    //一进来就默认点一下全部产品按钮
    
    
    //全部产品view 下面的一整块，看作是一个整体的UnderView ，全部产品按钮处于选中状态时，这个view 才显示出来
    [self setupUnderView];
    
    
    [self addCollectionView];
    
    [self.view addSubview:self.productTableView];
    [self allProductsBtnClick];
//    [self salesVolumeBtnClick];
}

- (void)addCollectionView{
    [self.view addSubview:self.collectionView];
//    [self.collectionView registerClass :[UICollectionViewCell class] forCellWithReuseIdentifier:KCollectionViewCell];
//    [_collectionView registerNib:[UINib nibWithNibName:@"SMAllActionTableViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KCollectionViewCell];
}

- (void)setupUnderView{
    UIView *underView = [[UIView alloc] init];
    [self.view addSubview:underView];

    [underView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        
    }];
//    underView.backgroundColor = [UIColor yellowColor];
    
    //顶部的 排序整体view
    UIView *sequenceView = [[UIView alloc] init];
    [underView addSubview:sequenceView];
    sequenceView.backgroundColor = [UIColor whiteColor];
    [sequenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        NSNumber *num = [NSNumber numberWithFloat:self.sortHeight];
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(underView.mas_top).with.offset(0);
        make.left.equalTo(underView.mas_left).with.offset(0);
        make.right.equalTo(underView.mas_right).with.offset(0);
        make.height.equalTo(num);
    }];
//    sequenceView.backgroundColor = [UIColor greenColor];
    
    //下面给一条灰色横线
    UIView *bottomGrayLine = [[UIView alloc] init];
    [sequenceView addSubview:bottomGrayLine];
    bottomGrayLine.backgroundColor = KGrayColor;
    [bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(0);
        make.right.equalTo(sequenceView.mas_right).with.offset(0);
        make.left.equalTo(sequenceView.mas_left).with.offset(0);
        make.height.equalTo(@1);
    }];
    
//    //改变视图显示状态的按钮（右边的方格按钮）
//    UIButton *showModelBtn = [[UIButton alloc] init];
//    self.showModelBtn = showModelBtn;
//    [sequenceView addSubview:showModelBtn];
////    showModelBtn.backgroundColor = [UIColor redColor];
//    [showModelBtn setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
//    [showModelBtn setImage:[UIImage imageNamed:@"liebiao02"] forState:UIControlStateSelected];
//    showModelBtn.contentMode = UIViewContentModeCenter;
//    [showModelBtn addTarget:self action:@selector(showModelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [showModelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(sequenceView.mas_top).with.offset(0);
//        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(0);
//        make.right.equalTo(sequenceView.mas_right).with.offset(0);
//        make.width.equalTo(@37);
//    }];
    
    //商品分类
//    UIButton *classesBtn = [[UIButton alloc] init];
//    self.classesBtn = classesBtn;
//    [sequenceView addSubview:classesBtn];
//    NSMutableDictionary *dictClasses = [NSMutableDictionary dictionary];
//    dictClasses[NSFontAttributeName] = KDefaultFont;
//    dictClasses[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSAttributedString *classesStr = [[NSAttributedString alloc] initWithString:@"分类" attributes:dictClasses];
//    [classesBtn setAttributedTitle:classesStr forState:UIControlStateNormal];
//    [classesBtn addTarget:self action:@selector(classesBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [classesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(sequenceView.mas_top).with.offset(0);
//        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(0);
//        make.right.equalTo(sequenceView.mas_right).with.offset(0);
//        make.width.equalTo(@60);
//    }];

    
//    SMSynthesizeBtn *trustBtn = [SMSynthesizeBtn synthesizeBtn];
//    self.trustBtn = trustBtn;
//    [self.trustBtn setTitle:@"佣金排序" forState:UIControlStateNormal];
//    [sequenceView addSubview:trustBtn];
//    
//    [trustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(sequenceView.mas_top).with.offset(8);
//                make.bottom.equalTo(sequenceView.mas_bottom).with.offset(-8);
//                make.right.equalTo(classesBtn.mas_left).with.offset(0);
//                make.width.equalTo(@100);
//    }];
//    [trustBtn addTarget:self action:@selector(synthesizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    //佣金排序按钮
//    UIButton *trustBtn = [[UIButton alloc] init];
//    self.trustBtn = trustBtn;
//    [sequenceView addSubview:trustBtn];
//    NSMutableDictionary *dictAttributeNor = [NSMutableDictionary dictionary];
//    dictAttributeNor[NSFontAttributeName] = KDefaultFont;
//    dictAttributeNor[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"佣金排序" attributes:dictAttributeNor];
//    [trustBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//    
//    NSMutableDictionary *dictAttributeSel = [NSMutableDictionary dictionary];
//    dictAttributeSel[NSFontAttributeName] = KDefaultFont;
//    dictAttributeSel[NSForegroundColorAttributeName] = KRedColor;
//    NSAttributedString *attributeStrSel = [[NSAttributedString alloc] initWithString:@"佣金排序" attributes:dictAttributeSel];
//    [trustBtn setAttributedTitle:attributeStrSel forState:UIControlStateSelected];
//    [trustBtn addTarget:self action:@selector(trustBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [trustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(sequenceView.mas_top).with.offset(8);
//        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(-8);
//        make.right.equalTo(classesBtn.mas_left).with.offset(-10);
//        make.width.equalTo(@65);
//    }];
//    trustBtn.backgroundColor = [UIColor redColor];
    
    
    
    
    //[synthesizeBtn addTarget:self action:@selector(synthesizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //销量排序
    UIButton *salesVolumeBtn = [[UIButton alloc] init];
    self.salesVolumeBtn = salesVolumeBtn;
    [sequenceView addSubview:salesVolumeBtn];
    salesVolumeBtn.selected = YES;
    
    NSMutableDictionary *salesVolumeDictNor = [NSMutableDictionary dictionary];
    salesVolumeDictNor[NSFontAttributeName] = KDefaultFont;
    salesVolumeDictNor[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *salesVolumeStrNor = [[NSAttributedString alloc] initWithString:@"销量优先" attributes:salesVolumeDictNor];
    [salesVolumeBtn setAttributedTitle:salesVolumeStrNor forState:UIControlStateNormal];
    
    
    NSMutableDictionary *salesVolumeDictSel = [NSMutableDictionary dictionary];
    salesVolumeDictSel[NSFontAttributeName] = KDefaultFont;
    salesVolumeDictSel[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *salesVolumeStrSel = [[NSAttributedString alloc] initWithString:@"销量优先" attributes:salesVolumeDictSel];
    [salesVolumeBtn setAttributedTitle:salesVolumeStrSel forState:UIControlStateSelected];
    [salesVolumeBtn addTarget:self action:@selector(salesVolumeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //这里代码可以改进一点，少一点魔法数字
    //CGFloat margin = (KScreenWidth - 30 - 85 - 37 - 30 - 55 - 55) / 2.0;
    //CGFloat margin = (KScreenWidth - 30 - 85 - 37 - 30 - 65 - 65) / 2.0;
    [salesVolumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(sequenceView.mas_left).with.offset(KScreenWidth/2-33-13);
        //make.right.equalTo(sequenceView.mas_right).with.offset(KScreenWidth/2-33);
        make.top.equalTo(sequenceView.mas_top).with.offset(8);
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(-8);
        make.width.equalTo(@55);
    }];
    CGFloat width = 0.0;
    if (isIPhone5) {
        width = 25;
        
    }else if(isIPhone6){
        width = 25* KMatch6;
    }else{
        width = 25* KMatch6p;
    }
    
    
    SMSynthesizeBtnView * trustView = [[[NSBundle mainBundle] loadNibNamed:@"SMSynthesizeBtnView" owner:self options:nil] lastObject];
    trustView.delegate = self;
    self.trustView = trustView;
    [trustView.priceBtn setTitle:@"佣金排序" forState:UIControlStateNormal];
    [sequenceView addSubview:trustView];
    
    [trustView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sequenceView.mas_top).with.offset(1);
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(-1);
        make.right.equalTo(sequenceView.mas_right).with.offset(-width-25);
        make.width.equalTo(@70);
    }];
    
    //价格排序 按钮
    SMSynthesizeBtnView *synthesizeView = [[[NSBundle mainBundle] loadNibNamed:@"SMSynthesizeBtnView" owner:self options:nil] lastObject];
    //self.synthesizeBtn = synthesizeBtn;
    self.synthesizeView = synthesizeView;
    synthesizeView.isPrice = YES;
    synthesizeView.delegate = self;
    [sequenceView addSubview:synthesizeView];
    
    [synthesizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(sequenceView.mas_top).with.offset(1);
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(-1);
        //make.left.equalTo(sequenceView.mas_left).with.offset(90);
        make.left.equalTo(sequenceView.mas_left).with.offset(width);
        make.width.equalTo(@70);
    }];
    
    //商品分类
    UIButton *classesBtn = [[UIButton alloc] init];
    self.classesBtn = classesBtn;
    [sequenceView addSubview:classesBtn];
    NSMutableDictionary *dictClasses = [NSMutableDictionary dictionary];
    dictClasses[NSFontAttributeName] = KDefaultFont;
    dictClasses[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *classesStr = [[NSAttributedString alloc] initWithString:@"" attributes:dictClasses];
    [classesBtn setAttributedTitle:classesStr forState:UIControlStateNormal];
    [classesBtn setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
    [classesBtn addTarget:self action:@selector(classesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [classesBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(sequenceView.mas_top).with.offset(0);
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(0);
        make.right.equalTo(sequenceView.mas_right).with.offset(0);
        make.width.equalTo(@50);
    }];
    
    UIView *downGrayView = [[UIView alloc] init];
    downGrayView.backgroundColor = [UIColor lightGrayColor];
    [sequenceView addSubview:downGrayView];
    [downGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sequenceView.mas_bottom).with.offset(0);
        make.top.equalTo(sequenceView.mas_top).with.offset(0);
        make.right.equalTo(classesBtn.mas_left).with.offset(-2);
        make.width.equalTo(@0.5);
    }];
}

- (void)setupTopView{
    CGFloat margin = KScreenWidth / 2.0; //屏幕三分之一的宽度
    CGFloat marginTop = 8;//全部产品距离底部的距离
    CGFloat marginleftRight = 15;//全部产品 距离左右两遍的小间距
    NSNumber *btnH = [NSNumber numberWithFloat:27.0];
    //最顶部 全部产品 全部活动  优惠券 那一整体view
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@36);
    }];
    
    //改成搜索按钮
    UIButton * searchBtn = [[UIButton alloc]init];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"fangdajing2"] forState:UIControlStateNormal];
    searchBtn.layer.cornerRadius = 4;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.titleLabel.font = KDefaultFontBig;
    [searchBtn addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).with.offset(-8);
        make.top.equalTo(topView.mas_top).with.offset(5);
        make.left.equalTo(topView.mas_left).with.offset(8);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-5);
    }];
    
    //下面的灰色横线
    UIView *downGrayView = [[UIView alloc] init];
    downGrayView.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:downGrayView];
    [downGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //最顶部的左边灰色竖线
    UIView *leftGrayView = [[UIView alloc] init];
    leftGrayView.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:leftGrayView];
    [leftGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(topView.mas_top).with.offset(marginTop);
        make.left.equalTo(self.view.mas_left).with.offset(margin);
        make.width.equalTo(@1);
        make.height.equalTo(@12);
    }];
    
    //右边的灰色竖线
    UIView *rightGrayView = [[UIView alloc] init];
    rightGrayView.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:rightGrayView];
    [rightGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(topView.mas_top).with.offset(marginTop);
        make.right.equalTo(self.view.mas_right).with.offset(-margin);
        make.width.equalTo(@1);
        make.height.equalTo(@12);
    }];
    
    //左边红色横线
//    UIView *leftRedView = [[UIView alloc] init];
//    self.leftRedView = leftRedView;
//    leftRedView.backgroundColor = KRedColor;
//    [topView addSubview:leftRedView];
//    [leftRedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(topView.mas_bottom).with.offset(-1);
//        make.right.equalTo(leftGrayView.mas_left).with.offset(-marginleftRight);
//        make.left.equalTo(topView.mas_left).with.offset(marginleftRight);
//        make.height.equalTo(@1);
//    }];
    
    //全部产品 按钮
    UIButton *allProductsBtn = [[UIButton alloc] init];
    [topView addSubview:allProductsBtn];
    self.allProductsBtn = allProductsBtn;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColor;
    dict[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"热销商品" attributes:dict];
    [allProductsBtn setAttributedTitle:attributeStr forState:UIControlStateSelected];
    
    NSMutableDictionary *dictNor = [NSMutableDictionary dictionary];
    dictNor[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictNor[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *attributeStrNor = [[NSAttributedString alloc] initWithString:@"热销商品" attributes:dictNor];
    [allProductsBtn setAttributedTitle:attributeStrNor forState:UIControlStateNormal];
    
    [allProductsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-marginTop);
        make.right.equalTo(leftGrayView.mas_left).with.offset(-marginleftRight);
        make.left.equalTo(topView.mas_left).with.offset(marginleftRight);
        make.height.equalTo(btnH);
    }];
    
    [allProductsBtn addTarget:self action:@selector(allProductsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //中间红色横线
//    UIView *midRedView = [[UIView alloc] init];
//    self.midRedView = midRedView;
//    self.midRedView.hidden = YES;
//    midRedView.backgroundColor = KRedColor;
//    [topView addSubview:midRedView];
//    [midRedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(topView.mas_bottom).with.offset(-marginTop);
//        make.right.equalTo(rightGrayView.mas_left).with.offset(-marginleftRight);
//        make.left.equalTo(leftGrayView.mas_right).with.offset(marginleftRight);
//        make.height.equalTo(@1);
//    }];
    
    //全部活动 按钮
//    UIButton *allActionBtn = [[UIButton alloc] init];
//    [topView addSubview:allActionBtn];
//    self.allActionBtn = allActionBtn;
//    NSMutableDictionary *dictAction = [NSMutableDictionary dictionary];
//    dictAction[NSForegroundColorAttributeName] = KRedColor;
//    dictAction[NSFontAttributeName] = KDefaultFont;
//    NSAttributedString *attributeActionStr = [[NSAttributedString alloc] initWithString:@"劲爆活动" attributes:dictAction];
//    [allActionBtn setAttributedTitle:attributeActionStr forState:UIControlStateSelected];
//    
//    NSMutableDictionary *dictActionNor = [NSMutableDictionary dictionary];
//    dictActionNor[NSForegroundColorAttributeName] = [UIColor blackColor];
//    dictActionNor[NSFontAttributeName] = KDefaultFont;
//    NSAttributedString *attributeActionStrNor = [[NSAttributedString alloc] initWithString:@"劲爆活动" attributes:dictActionNor];
//    [allActionBtn setAttributedTitle:attributeActionStrNor forState:UIControlStateNormal];
//    
//    [allActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(topView.mas_bottom).with.offset(-marginTop);
//        make.right.equalTo(rightGrayView.mas_left).with.offset(-marginleftRight);
//        make.left.equalTo(leftGrayView.mas_left).with.offset(marginleftRight);
//        make.height.equalTo(btnH);
//    }];
//    
//    [allActionBtn addTarget:self action:@selector(allActionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //右边红色横线
    UIView *rightRedView = [[UIView alloc] init];
    //self.rightRedView = rightRedView;
    rightRedView.hidden = YES;
    rightRedView.backgroundColor = KRedColor;
    [topView addSubview:rightRedView];
    [rightRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-1);
        make.right.equalTo(topView.mas_right).with.offset(-marginleftRight);
        make.left.equalTo(leftGrayView.mas_right).with.offset(marginleftRight);
        make.height.equalTo(@1);
    }];
    
    //优惠券 按钮
    UIButton *discountCouponBtn = [[UIButton alloc] init];
    [topView addSubview:discountCouponBtn];
    self.discountCouponBtn = discountCouponBtn;
    NSMutableDictionary *dictDiscount = [NSMutableDictionary dictionary];
    dictDiscount[NSForegroundColorAttributeName] = KRedColor;
    dictDiscount[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *attributeDiscountStr = [[NSAttributedString alloc] initWithString:@"优惠券" attributes:dictDiscount];
    [discountCouponBtn setAttributedTitle:attributeDiscountStr forState:UIControlStateSelected];
    
    NSMutableDictionary *dictDiscountNor = [NSMutableDictionary dictionary];
    dictDiscountNor[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictDiscountNor[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *attributeDiscountStrNor = [[NSAttributedString alloc] initWithString:@"优惠券" attributes:dictDiscountNor];
    [discountCouponBtn setAttributedTitle:attributeDiscountStrNor forState:UIControlStateNormal];
    [discountCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-marginTop);
        make.right.equalTo(topView.mas_right).with.offset(-marginleftRight);
        make.left.equalTo(leftGrayView.mas_right).with.offset(marginleftRight);
        make.height.equalTo(btnH);
    }];
    
    [discountCouponBtn addTarget:self action:@selector(discountCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //最后在最下面给一条灰色横线
    UIView *lastGrayView = [[UIView alloc] init];
    [topView addSubview:lastGrayView];
    lastGrayView.backgroundColor = KGrayColor;
    [lastGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    self.allProductsBtn.hidden = YES;
    self.discountCouponBtn.hidden = YES;
    downGrayView.hidden = YES;
    leftGrayView.hidden = YES;
    rightGrayView.hidden = YES;
    rightRedView.hidden = YES;
    lastGrayView.hidden = YES;
}

- (void)setupNav{
    //头像按钮
    SMLeftItemBtn *leftItemBtn = [SMLeftItemBtn leftItemBtn];
    self.leftIconBtn = leftItemBtn;
    leftItemBtn.width = 32;
    leftItemBtn.height = 22;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItemBtn addTarget:self action:@selector(leftItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.title = @"商品库";
    
    //搜索栏
//    SMSearchBar *searchBar = [SMSearchBar searchBar];
//    self.searchBar = searchBar;
//    searchBar.delegate = self;
//    searchBar.returnKeyType = UIReturnKeySearch;
//    
//    //给搜索栏的显示长度做一个适配
//    CGFloat width = 180;
//    if (isIPhone5) {
//        width = 210;
//    }else if (isIPhone6){
//        width = 270;
//    }else if (isIPhone6p){
//        width = 300;
//    }
//    searchBar.width = width;
//    searchBar.height = 28;
//    
//    self.navigationItem.titleView = searchBar;
    
    //二维码
    SMScanerBtn *scanerBtn = [SMScanerBtn scanerBtn];
    scanerBtn.width = 22;
    scanerBtn.height = 22;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:scanerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [scanerBtn addTarget:self action:@selector(scanerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
//    SMRightItemView * rightView = [SMRightItemView rightItemView];
//    rightView.width = 85;
//    rightView.height = 22;
//    rightView.delegate = self;
////    rightView.backgroundColor = [UIColor greenColor];
//    
//    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
//    self.navigationItem.rightBarButtonItem = rightitem;
    
    SMTitleView * titleView = [SMTitleView CreatNavSwipTitleViewWithLeftTitle:@"商品" andRight:@"优惠券" andViewController:self];
    
    [titleView leftBtnClickAction:^{
        [self allProductsBtnClick];
    }];
    
    [titleView rightBtnClickAction:^{
        [self discountCouponBtnClick];
    }];
    
    
    [titleView hiddenLeftSpot];
    [titleView hiddenRightSpot];
}

- (void)searchBtnDidClick
{
    //搜索
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = self.searchCount;
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)scanerBtnDidClick
{
    [self.searchBar resignFirstResponder];
    SMLog(@"点击了 扫描二维码 的按钮");
    SMScannerViewController *scannerVc = [[SMScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerVc animated:YES];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.sequenceTableView||tableView == self.commissionTableview) {//弹出来的tableView
        return 2;
    }else if (tableView == self.actionTableView){
        SMLog(@"%zd",self.dataActions.count);
        return self.dataActions.count;
    }else if (tableView == self.productTableView){
        return self.dataProducts.count;
    }else
    {
        return self.dataDiscounts.count;
    }
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.commissionTableview) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.font = KDefaultFont;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"佣金从低到高";
           
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"佣金从高到低";
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (tableView == self.productTableView) {//全部产品
        
        SMAllProductTableViewCell *cell = [SMAllProductTableViewCell cellWithTableView:tableView];
        Product *product = self.dataProducts[indexPath.row];
        cell.product = product;
        return cell;
    }else if (tableView == self.sequenceTableView){
        
        static NSString *ID = @"sequenceTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.font = KDefaultFont;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"价格从低到高";
            //改变按钮title
            
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"价格从高到低";
            
        }
//        self.sequenceTableView.backgroundColor = [UIColor clearColor];
//        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.actionTableView){//全部活动
        
        SMAllActionTableViewCell *cell = [SMAllActionTableViewCell cellWithTableView:tableView];
//        cell.gouBtn.hidden = YES;
        Activity *action = self.dataActions[indexPath.row];
        cell.action = action;
        return cell;
        
    }else if (tableView == self.discountCouponTableView){//优惠券
        
        SMShelfDiscountCell *cell = [SMShelfDiscountCell cellWithTableView:tableView];
#pragma 可以在这里模型赋值
        cell.coupon = self.dataDiscounts[indexPath.row];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    if (tableView == self.productTableView) {
        if (isIPhone5) {
            height = 84;
        }else if (isIPhone6){
            height = 84 *KMatch6Height;
        }else if (isIPhone6p){
            height = 84 *KMatch6pHeight;
        }
    }else if (tableView == self.sequenceTableView||tableView == self.commissionTableview){
        if (isIPhone5) {
            height = 32;
        }else if (isIPhone6){
            height = 32 *KMatch6Height;
        }else if (isIPhone6p){
            height = 32 *KMatch6pHeight;
        }
    }else if (tableView == self.actionTableView){
        if (isIPhone5) {
            height = 155;
        }else if (isIPhone6){
            height = 155 *KMatch6Height;
        }else if (isIPhone6p){
            height = 155 *KMatch6pHeight;
        }
    }else if (tableView == self.discountCouponTableView){
        if (isIPhone5) {
            height = 92;
        }else if (isIPhone6){
            height = 92 *KMatch6Height;
        }else if (isIPhone6p){
            height = 92 *KMatch6pHeight;
        }
    }
    return height;
    //
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.commissionTableview) {
        [self.commissionTableview removeFromSuperview];
        
        [self.cheatView removeFromSuperview];
         self.page = 1;
        [self.synthesizeView.priceBtn setTitle:@"价格排序" forState:UIControlStateNormal];
        [self.synthesizeView.priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.trustView.priceBtn setTitleColor:SMColor(189, 34, 56) forState:UIControlStateNormal];
        
        if (indexPath.row==0) {
            self.typecount = SortType_Commission_Asc;
             [self.trustView.priceBtn setTitle:@"佣金从低到高" forState:UIControlStateNormal];
        }else
        {
            self.typecount = SortType_Commission_Desc;
             [self.trustView.priceBtn setTitle:@"佣金从高到低" forState:UIControlStateNormal];
        }
        self.salesVolumeBtn.selected=NO;
        
        [self loadNewDataProducts];
    }
    
    if (tableView == self.productTableView) {
        SMLog(@"点击了 全部产品 下面的 tableView    %zd",indexPath.row);
        //在点击的时候，记录下当前点击的是哪个cell对应的模型，传到下一个控制器中，在下一个控制器中拿到这个模型，并将相应的属性赋值给相应的控件。
        SMProductDetailController *vc = [[SMProductDetailController alloc] init];
        Product *product = self.dataProducts[indexPath.row];
        vc.product = product;
        vc.isPushCounter = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (tableView == self.sequenceTableView) {
        SMLog(@"用户选择了第 %zd 行cell",indexPath.row);
        [self.sequenceTableView removeFromSuperview];
        
        [self.cheatView removeFromSuperview];
        
        [self.trustView.priceBtn setTitle:@"佣金排序" forState:UIControlStateNormal];
        [self.trustView.priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.synthesizeView.priceBtn setTitleColor:SMColor(189, 34, 56) forState:UIControlStateNormal];
        
        //刷新排列顺序
        //[self reloadDataWithPressWithFlag:indexPath.row];
//        self.type = indexPath.row+1;
        self.page = 1;
        if (indexPath.row==0) {
            self.typecount = SortType_Price_Asc;
             [self.synthesizeView.priceBtn setTitle:@"价格从低到高" forState:UIControlStateNormal];
        }else
        {
            self.typecount = SortType_Price_Desc;
             [self.synthesizeView.priceBtn setTitle:@"价格从高到低" forState:UIControlStateNormal];
        }
        self.salesVolumeBtn.selected=NO;
        
        [self loadNewDataProducts];
        
//        [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:MAXFLOAT andSortType:SortType_Price_Asc block:^(NSArray *array, NSError *error) {
//            if (!error) {
//                for (Product *product in array) {
//                    [self.dataProducts addObject:product];
//                }
//            }else{
//                SMLog(@"%@",error);
//            }
//        }];
        
    }else if (tableView == self.actionTableView){
        SMLog(@"点击了全部活动下的cell %zd",indexPath.row);
        SMActionViewController *actionVc = [[SMActionViewController alloc] init];
        //模型赋值
        Activity *activity = self.dataActions[indexPath.row];
        actionVc.activity = activity;
        [self.navigationController pushViewController:actionVc animated:YES];
    }else if (tableView == self.discountCouponTableView){
        SMLog(@"点击了 优惠券下面的 cell %zd",indexPath.row);
        SMDiscountDetailController *discountVc = [SMDiscountDetailController new];
        
        discountVc.coupon = self.dataDiscounts[indexPath.row];
        //[discountVc refreshUI:self.dataDiscounts[indexPath.row]];
        [self.navigationController pushViewController:discountVc animated:YES];
    }
}
/**
 *  通过用户点击的哪一行去刷新排列顺序
 */
- (void)reloadDataWithPressWithFlag:(NSInteger)flag{
    
    [self.dataProducts removeAllObjects];
    if (flag == 0) {
        [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:oneTimeInfoNum andSortType:SortType_Price_Asc andClassId:@"" andIsRecommend:0 block:^(NSArray *array, NSError *error) {
            if (!error) {
                for (Product *product in array) {
                    [self.dataProducts addObject:product];
                }
                [self.collectionView reloadData];
                [self.productTableView reloadData];
            }else{
                SMLog(@"%@",error);
            }
        }];
    }else if (flag == 1){
        [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:oneTimeInfoNum andSortType:SortType_Price_Desc andClassId:@"" andIsRecommend:0 block:^(NSArray *array, NSError *error) {
            if (!error) {
                for (Product *product in array) {
                    [self.dataProducts addObject:product];
                }
                [self.collectionView reloadData];
                [self.productTableView reloadData];
            }else{
                SMLog(@"%@",error);
            }
        }];
    }
    

    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section{
    return self.dataProducts.count ;
}

-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView{
    return 1 ;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"SMProductCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:KCollectionViewCell];
   
    SMProductCollectionViewCell *cell = [SMProductCollectionViewCell productCollectionViewCell];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier: KCollectionViewCell forIndexPath:indexPath];
    
    
    
    
//    [collectionView registerNib:[UINib nibWithNibName:@"SMProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:KCollectionViewCell];
//    SMProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCollectionViewCell forIndexPath:indexPath];
  
    Product *product = self.dataProducts[indexPath.row];
    cell.product = product;
    
    
    return cell;
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    SMLog(@"点击了 collectionViewCell   %zd",indexPath.row);
    SMProductDetailController *vc = [[SMProductDetailController alloc] init];
    Product *product = self.dataProducts[indexPath.row];
    vc.product = product;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    
    CGFloat margin = 10;
    CGFloat w;
    CGFloat h;
    if (isIPhone5) {
        h = 209;
    }else if (isIPhone6){
        h = 209 *KMatch6Height;
    }else if (isIPhone6p){
        h = 209 *KMatch6pHeight;
    }
    
    if (indexPath == 0) {
        w = KScreenWidth;
    }else{
        w = (KScreenWidth - 3 * margin) / 2.0;
    }
    
    return CGSizeMake (w, h);
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section{
    
    return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
}


#pragma mark -- 点击事件

- (void)classesBtnClick{
    SMLog(@"点击了 商品分类");
    SMProductClassesController *vc = [[SMProductClassesController alloc] init];
//    vc.product = self.dataProducts[0];
    SMLog(@"vc.product   %@",vc.product);
    [self.navigationController pushViewController:vc animated:YES];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分类数据不完善，暂不做跳转" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    
}

- (void)salesVolumeBtnClick{
    SMLog(@"点击了 销量优先 按钮");
    self.salesVolumeBtn.selected = YES;
    self.trustBtn.selected = NO;
    
     [self.trustView.priceBtn setTitle:@"佣金排序" forState:UIControlStateNormal];
    [self.trustView.priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
     [self.synthesizeView.priceBtn setTitle:@"价格排序" forState:UIControlStateNormal];
    [self.synthesizeView.priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.dataProducts removeAllObjects];
//    self.istype = NO;
    self.typecount = SortType_Sales;
    [self loadNewDataProducts];
}

- (void)synthesizeBtnClick:(UIButton * )btn{
    if (btn == self.synthesizeBtn) {
        self.synthesizeBtn.selected = !self.synthesizeBtn.selected;
        //添加萌版 弹出选择视图
        //    CGFloat height = 32 * 3;
        //    CGFloat y = 30 + 36;
        
        UIView *cheatView = [[UIView alloc] init];
        [self.view addSubview:cheatView];
        self.cheatView = cheatView;
        cheatView.backgroundColor = [UIColor lightGrayColor];
        cheatView.frame = self.view.bounds;
        cheatView.alpha = 0.4;
        [self.view addSubview:self.sequenceTableView];
    }else
    {
        self.trustBtn.selected = !self.trustBtn.selected;
        //添加萌版 弹出选择视图
        //    CGFloat height = 32 * 3;
        //    CGFloat y = 30 + 36;
        
        UIView *cheatView = [[UIView alloc] init];
        [self.view addSubview:cheatView];
        self.cheatView = cheatView;
        cheatView.backgroundColor = [UIColor lightGrayColor];
        cheatView.frame = self.view.bounds;
        cheatView.alpha = 0.4;
        [self.view addSubview:self.commissionTableview];
       
        
        //给约束
//        [self.commissionTableview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.underView.mas_bottom).with.offset(0);
//            make.right.equalTo(self.trustBtn.mas_right).with.offset(0);
//            make.left.equalTo(self.trustBtn.mas_left).with.offset(0);
//            //make.width.equalTo(@120);
//            make.height.equalTo(@64);
//            
//        }];
    }
 
}

#pragma mark -- 代理   给注释啊
-(void)priceBtnClick:(UIButton *)btn
{
    //btn.selected = !btn.selected;
    UIView *cheatView = [[UIView alloc] init];
    [self.view addSubview:cheatView];
    self.cheatView = cheatView;
    cheatView.backgroundColor = [UIColor lightGrayColor];
    cheatView.frame = self.view.bounds;
    cheatView.alpha = 0.4;
    [self.view addSubview:self.sequenceTableView];
}

-(void)trustBtnClick:(UIButton *)btn
{
    //btn.selected = !btn.selected;
    
    UIView *cheatView = [[UIView alloc] init];
    [self.view addSubview:cheatView];
    self.cheatView = cheatView;
    cheatView.backgroundColor = [UIColor lightGrayColor];
    cheatView.frame = self.view.bounds;
    cheatView.alpha = 0.4;
    [self.view addSubview:self.commissionTableview];
    
}
- (void)trustBtnClick{
    SMLog(@"点击了 佣金排序 按钮");
    self.salesVolumeBtn.selected = NO;
    self.trustBtn.selected = YES;
    
    [self.dataProducts removeAllObjects];
    //代表佣金排序方式   默认为销量
    //self.istype = YES;
    //也需要弹出tableview
    
    [self loadNewDataProducts];
   
    
//    [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:oneTimeInfoNum andSortType:SortType_Commission block:^(NSArray *array, NSError *error) {
//       
//        if (!error) {
//            for (Product *product in array) {
//                [self.dataProducts addObject:product];
//            }
//            [self.collectionView reloadData];
//            [self.productTableView reloadData];
//        }else{
//            SMLog(@"%@",error);        }
//    }];
   
}

- (void)showModelBtnClick{
    SMLog(@"点击了 改变显示模式 按钮");
    self.showModelBtn.selected = !self.showModelBtn.selected;
    self.verticalMode = !self.verticalMode;
    if (_verticalMode) {
        self.collectionView.hidden = YES;
        self.productTableView.hidden = NO;
    }else{
        self.collectionView.hidden = NO;
        self.productTableView.hidden = YES;
    }
    self.page = 0;
    [self loadNewDataProducts];
}

- (void)discountCouponBtnClick{
    SMLog(@"点击了 优惠券 按钮");
    self.allProductsBtn.selected = NO;
    self.allActionBtn.selected = NO;
    self.discountCouponBtn.selected = YES;
    
    self.leftRedView.hidden = !self.allProductsBtn.selected;
    self.midRedView.hidden = !self.allActionBtn.selected;
    self.rightRedView.hidden = !self.discountCouponBtn.selected;
    
    [self.view addSubview:self.discountCouponTableView];
    
    self.underView.hidden = !self.allProductsBtn.selected;
    self.collectionView.hidden = self.verticalMode;
    self.productTableView.hidden = !self.verticalMode;
    self.discountCouponTableView.hidden = !self.discountCouponBtn.selected;
    self.actionTableView.hidden = !self.allActionBtn.selected;
    
    self.searchCount = 1;
    //[self loadNewDataDiscounts];
}
#pragma mark - 获取优惠劵的信息
- (void)loadNewDataDiscounts{
    
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    //SMLog(@"companyId = %@",Id);
    [[SKAPI shared] queryCompanyId:Id  andKeyword:@"" andPage:self.discointsPage andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"请求成功");
            SMLog(@"Discounts=%@",array);
            if (array.count>0) {
                
                //保存
                [self saveCouponDataWithDataArray:[array mutableCopy]];
                [self.discountCouponTableView reloadData];
                
                [self.discountCouponTableView.mj_footer  endRefreshing];
                [self.discountCouponTableView.mj_header endRefreshing];
                
//                if (self.dataDiscounts.count<10) {
//                    [self.discountCouponTableView.mj_footer endRefreshingWithNoMoreData];
//                }
               
            }else
            {
                [self.discountCouponTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else
        {
//            SMLog(@"%@",error);
//            [self.dataDiscounts removeAllObjects];
//            [self loadcouponData];
//            [self.discountCouponTableView reloadData];
            [self.discountCouponTableView.mj_footer  endRefreshing];
            [self.discountCouponTableView.mj_header endRefreshing];
        }
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.discountCouponTableView.mj_footer  endRefreshing];
//        [self.discountCouponTableView.mj_header endRefreshing];
//    });
}

- (void)allActionBtnClick{
    SMLog(@"点击了 全部活动 按钮");
    self.allProductsBtn.selected = NO;
    self.allActionBtn.selected = YES;
    self.discountCouponBtn.selected = NO;
    
    self.leftRedView.hidden = !self.allProductsBtn.selected;
    self.midRedView.hidden = !self.allActionBtn.selected;
    self.rightRedView.hidden = !self.discountCouponBtn.selected;
    
    [self.view addSubview:self.actionTableView];
    self.underView.hidden = !self.allProductsBtn.selected;
    self.collectionView.hidden = self.verticalMode;
    self.productTableView.hidden = !self.verticalMode;
    self.discountCouponTableView.hidden = !self.discountCouponBtn.selected;
    self.actionTableView.hidden = !self.allActionBtn.selected;
//    SMLog(@"%zd",self.actionTableView.hidden);
    //加载数据
    //[self loadNewDataActions];
    
    self.searchCount = 1;
}

/**
 *  加载活动tableView的新数据
 */
- (void)loadNewDataActions{
//    if (self.dataActions.count == 0) {
//        [[SKAPI shared] queryActivitysByPage:1 andSize:oneTimeInfoNum block:^(NSArray *array, NSError *error) {
//            
//            if (!error) {
//                for (Activity *action in array) {
//                    [self.dataActions addObject:action];
//                }
//                [self.actionTableView reloadData];
//            }else{
//                SMLog(@"%@",error);
//            }
//        }];
//    }
    //修改了 chang  self.dataActions.count == 0
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
        [[SKAPI shared] queryActivityByCompanyId:Id andKeyword:@"" andIsRecommend:YES andPage:self.actionPage andSize:10 block:^(NSArray *array, NSError *error) {
            
            if (!error) {
                //[self.actionTableView reloadData];
                if (array.count>0) {
                    
                    
                    [self saveActivityDataWithDataArray:[array mutableCopy]];
                    [self.actionTableView reloadData];
                    
                    [self.actionTableView.mj_header endRefreshing];
                    [self.actionTableView.mj_footer endRefreshing];
                    
                }else
                {
                    [self.actionTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                SMLog(@"%@",error);
                [self.actionTableView.mj_header endRefreshing];
                [self.actionTableView.mj_footer endRefreshing];
            }
        }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.actionTableView.mj_header endRefreshing];
//        [self.actionTableView.mj_footer endRefreshing];
//    });

}

- (void)allProductsBtnClick{
    SMLog(@"点击了 全部产品 按钮");
    self.allProductsBtn.selected = YES;
    self.allActionBtn.selected = NO;
    self.discountCouponBtn.selected = NO;
    
    self.leftRedView.hidden = !self.allProductsBtn.selected;
    self.midRedView.hidden = !self.allActionBtn.selected;
    self.rightRedView.hidden = !self.discountCouponBtn.selected;
    
    self.underView.hidden = !self.allProductsBtn.selected;
    self.collectionView.hidden = self.verticalMode;
    self.productTableView.hidden = !self.verticalMode;
    self.discountCouponTableView.hidden = !self.discountCouponBtn.selected;
    self.actionTableView.hidden = !self.allActionBtn.selected;
    
    self.searchCount = 0;
    //[self loadNewDataProducts];
}
//加载全部产品数据
- (void)loadNewDataProducts{
    
//    if (!self.productTableView.hidden) {
//        [self.productTableView reloadData];
//    }else if (!self.collectionView.hidden){
//        [self.collectionView reloadData];
//    }
    
//    if (self.dataProducts.count == 0) {//没有数据时加载
//        [[SKAPI shared] queryProductByName:@"" andPage:1 andSize:oneTimeInfoNum andSortType:SortType_Default block:^(NSArray *array, NSError *error) {
//            
//            if (!error) {
//                for (Product *product in array) {
//                    [self.dataProducts addObject:product];
//                }
//                
//                if (!self.productTableView.hidden) {
//                    [self.productTableView reloadData];
//                }else if (!self.collectionView.hidden){
//                    [self.collectionView reloadData];
//                }
//            }else{
//                SMLog(@"%@",error);
//            }
//        }];
//    }
    
//    if (!self.productTableView.hidden) {
//        [self.productTableView reloadData];
//    }else if (!self.collectionView.hidden){
//        [self.collectionView reloadData];
//    }
    //修改了  chang
    
    [[SKAPI shared] queryProductByName:@"" andPage:self.page andSize:oneTimeInfoNum andSortType:self.typecount andClassId:@"" andIsRecommend:0 block:^(NSArray *array, NSError *error) {
            if (!error) {
                if (array.count>0) {
                    
                    [self saveProductDataWhitDataArray:[array mutableCopy]];
                    
                    if (!self.productTableView.hidden) {
                        if (!self.productTableView.mj_footer.isRefreshing) {
                            [self.dataProducts removeAllObjects];
                        }
                        for (Product *product in array) {
                            [self.dataProducts addObject:product];
                        }
                        [self.productTableView reloadData];
                    }else if (!self.collectionView.hidden){
                        if (!self.collectionView.mj_footer.isRefreshing) {
                            [self.dataProducts removeAllObjects];
                            SMLog(@"removeAllObjects");
                        }
                        for (Product *product in array) {
                            [self.dataProducts addObject:product];
                        }
                        [self.collectionView reloadData];
                    }
                    [self.collectionView.mj_footer endRefreshing];
                    [self.collectionView.mj_header endRefreshing];
                }else
                {
                    [self.productTableView.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                SMLog(@"%@",error);
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"刷新失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
//                NSArray * dataArray = [LocalStorehouse MR_findAll];
//                [self.dataProducts removeAllObjects];
//                for (Product * localStorehouse in dataArray) {
//                    [self.dataProducts addObject:localStorehouse];
//                    
//                    if (!self.productTableView.hidden) {
//                        [self.productTableView reloadData];
//                    }else if (!self.collectionView.hidden){
//                        [self.collectionView reloadData];
//                    }
//                }
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
            }
        }];

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.productTableView.mj_header endRefreshing];
//        [self.productTableView.mj_footer endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//        [self.collectionView.mj_header endRefreshing];
//    });

}

//这里可能传UIBarButtonItem
- (void)leftItemDidClick:(UIButton *)btn{
    [self.searchBar resignFirstResponder];
    SMLog(@"点击了 左上角的头像 按钮  %@",[btn class]);
    SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString objectArrayWithKeyValuesArray:] objectindex :0
    if ([string isEqualToString:@"\n"]) {
        [self.searchBar resignFirstResponder];
        SMLog(@"点击了键盘的搜索键  ，执行搜索代码");
    }
    return YES;
}

//当搜索栏开始输入文字编辑的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    SMSearchViewController *vc = [[SMSearchViewController alloc] init];
    vc.categoryType = 0;
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.cheatView removeFromSuperview];
    [self.sequenceTableView removeFromSuperview];
    [self.commissionTableview removeFromSuperview];
}

#pragma mark -- 懒加载

- (CGFloat)sortHeight{
    if (_sortHeight == 0) {
        _sortHeight = 36;
    }
    return _sortHeight;
}

- (CGFloat)topViewHeight{
    if (_topViewHeight == 0) {
        _topViewHeight = 36;
    }
    return _topViewHeight;
}

- (NSMutableArray *)dataDiscounts{
    if (_dataDiscounts == nil) {
        _dataDiscounts = [NSMutableArray array];
    }
    return _dataDiscounts;
}

- (NSMutableArray *)dataProducts{
    if (_dataProducts == nil) {
        _dataProducts = [NSMutableArray array];
    }
    return _dataProducts;
}

- (NSMutableArray *)dataActions{
    if (_dataActions == nil) {
        _dataActions = [NSMutableArray array];
    }
    return _dataActions;
}

- (UITableView *)discountCouponTableView{
    if (_discountCouponTableView == nil) {
        _discountCouponTableView = [[UITableView alloc] init];
        _discountCouponTableView.dataSource = self;
        _discountCouponTableView.delegate = self;
        _discountCouponTableView.hidden = YES;
        _discountCouponTableView.frame = CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight - KTabBarHeight);
        _discountCouponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _discountCouponTableView;
}

- (UITableView *)actionTableView{
    if (_actionTableView == nil) {
        _actionTableView = [[UITableView alloc] init];
        _actionTableView.dataSource = self;
        _actionTableView.delegate = self;
        _actionTableView.frame = CGRectMake(0, self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - KStateBarHeight - KTabBarHeight);
        _actionTableView.hidden = YES;
        _actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _actionTableView;
}

- (UITableView *)sequenceTableView{
    
    CGFloat height = 0.0;
    if (isIPhone5) {
        height = 32;
    }else if (isIPhone6){
        height = 32*KMatch6Height;
    }else if (isIPhone6p){
        height = 32* KMatch6pHeight;
    }
    if (_sequenceTableView == nil) {
        _sequenceTableView = [[UITableView alloc] init];
        _sequenceTableView.dataSource = self;
        _sequenceTableView.delegate = self;
        CGFloat w = KScreenWidth / 3.0;
        _sequenceTableView.frame = CGRectMake(0, self.topViewHeight + self.sortHeight,w, height * 2);
        //_sequenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _sequenceTableView;
}

-(UITableView *)commissionTableview
{
    CGFloat height = 0.0;
    if (isIPhone5) {
        height = 32;
    }else if (isIPhone6){
        height = 32*KMatch6Height;
    }else if (isIPhone6p){
        height = 32* KMatch6pHeight;
    }
    if (!_commissionTableview) {
        _commissionTableview = [[UITableView alloc]init];
        _commissionTableview.dataSource = self;
        _commissionTableview.delegate = self;
        [_commissionTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        CGFloat x = KScreenWidth / 3.0 * 2;
        CGFloat w = KScreenWidth / 3.0;
        _commissionTableview.frame = CGRectMake(x-50, self.topViewHeight + self.sortHeight,w, height * 2);
    }
    return _commissionTableview;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topViewHeight+ self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - self.topViewHeight - KStateBarHeight - KTabBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView. delegate = self;
        _collectionView. dataSource = self;
    }
    return _collectionView;
}

- (UITableView *)productTableView{
    if (_productTableView == nil) { 
        _productTableView = [[UITableView alloc] init];
        _productTableView.dataSource = self;
        _productTableView.delegate = self;
        _productTableView.frame = CGRectMake(0, self.topViewHeight+ self.sortHeight, KScreenWidth, KScreenHeight - self.topViewHeight - self.sortHeight - KStateBarHeight - KTabBarHeight);
        _productTableView.hidden = YES;
        _productTableView.backgroundColor = KControllerBackGroundColor;
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _productTableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//     self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        self.leftIconBtn.customImageView.image = image;
    }
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

//#pragma mark - 判断网络状态
//- (void)reachabilityChanged{
//    switch (self.reach.currentReachabilityStatus) {
//        case NotReachable:
//        {
//            SMLog(@"没有联网");
//            self.isOnline = 0;
//            [self loadNewDataProducts];
//            [self loadNewDataActions];
//            [self loadNewDataDiscounts];
//        }
//            break;
//        case ReachableViaWiFi:
//        {
//            SMLog(@"wifi上网");
//            self.isOnline = 1;
//            self.page = 0;
//            self.actionPage = 0;
//            self.discointsPage = 0;
//            [self loadNewDataProducts];
//            [self loadNewDataActions];
//            [self loadNewDataDiscounts];
//        }
//            break;
//        case ReachableViaWWAN:
//            //手机上模拟才写的这段代码，后面可以删掉这句代码
//        {
//            SMLog(@"手机流量上网");
//            self.isOnline = 2;
//            self.page = 0;
//            self.actionPage = 0;
//            self.discointsPage = 0;
//            [self loadNewDataProducts];
//            [self loadNewDataActions];
//            [self loadNewDataDiscounts];
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - 缓存全部产品数据
-(void)saveProductDataWhitDataArray:(NSMutableArray * )array
{
    NSArray * localArray = [LocalStorehouse MR_findAll];
    for (LocalStorehouse * model in localArray) {
        if (model.isPlace.integerValue == 1) {
            [model MR_deleteEntity];
        }
        
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (Product * productModel in array) {
                LocalStorehouse * LocalStorehouseModel = [LocalStorehouse MR_createEntityInContext:localContext];
                LocalStorehouseModel.id = productModel.id;
                LocalStorehouseModel.name = productModel.name;
                LocalStorehouseModel.followers = [NSNumber numberWithInteger:productModel.followers];
                LocalStorehouseModel.lastUpdate = [NSNumber numberWithInteger:productModel.lastUpdate];
                LocalStorehouseModel.imagePath = productModel.imagePath;
                LocalStorehouseModel.price = productModel.price;
                LocalStorehouseModel.finalPrice = productModel.finalPrice;
                LocalStorehouseModel.companyName = productModel.companyName;
                LocalStorehouseModel.commission = productModel.commission;
                LocalStorehouseModel.stock = [NSNumber numberWithInteger:productModel.stock];
                LocalStorehouseModel.sales = [NSNumber numberWithInteger:productModel.sales];
                LocalStorehouseModel.isPlace = [NSNumber numberWithInteger:1];
            }
            } completion:^(BOOL contextDidSave, NSError *error) {
                
            }];
}

#pragma mark - 缓存活动页面
-(void)saveActivityDataWithDataArray:(NSMutableArray *)array
{
    if (!self.actionTableView.mj_footer.isRefreshing) {
        [self.dataActions removeAllObjects];
        for (LocalActivity* action in [LocalActivity MR_findAll]) {
            if (action.isPlace.integerValue == 1) {
                [action MR_deleteEntity];
            }

        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    for (Activity *action in array) {
        [self.dataActions addObject:action];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (Activity * activity in array) {
            LocalActivity * localActivity = [LocalActivity MR_createEntityInContext:localContext];
            localActivity.id = activity.id;
            localActivity.createAt = [NSNumber numberWithInteger:activity.createAt];
            localActivity.content = activity.content;
            localActivity.name = activity.name;
            localActivity.title = activity.title;
            localActivity.lastUpdate = [NSNumber numberWithInteger:activity.lastUpdate];
            localActivity.companyId = activity.companyId;
            localActivity.startTime = [NSNumber numberWithInteger:activity.startTime];
            localActivity.endTime = [NSNumber numberWithInteger:activity.endTime];
            localActivity.imagePaths = activity.imagePaths;
            localActivity.isPlace = [NSNumber numberWithInteger:1];
         }
        } completion:^(BOOL contextDidSave, NSError *error) {
            
        }];
    
}
#pragma mark - 缓存优惠劵的数据
-(void)saveCouponDataWithDataArray:(NSMutableArray *)array
{
    if (!self.discountCouponTableView.mj_footer.isRefreshing) {
        [self.dataDiscounts removeAllObjects];
        for (LocalCoupon* coupon in [LocalCoupon MR_findAll]) {
            [coupon MR_deleteEntity];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    for (Coupon * coupon in array) {
        [self.dataDiscounts addObject:coupon];
    }
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (Coupon * coupon in array) {
                LocalCoupon * localcoupon = [LocalCoupon MR_createEntityInContext:localContext];
                localcoupon.id = coupon.id;
                localcoupon.code = coupon.code;
                localcoupon.name = coupon.name;
                localcoupon.startTime = [NSNumber numberWithInteger:coupon.startTime];
                localcoupon.endTime = [NSNumber numberWithInteger:coupon.endTime];
                localcoupon.descr = coupon.descr;
                localcoupon.status = [NSNumber numberWithInteger:coupon.status];
                localcoupon.type = [NSNumber numberWithInteger:coupon.type];
                localcoupon.companyId = coupon.companyId;
                localcoupon.companyImage = coupon.companyImage;
                localcoupon.companyName = coupon.companyName;
                localcoupon.money = [NSNumber numberWithDouble:coupon.money];
                localcoupon.depositRate = [NSNumber numberWithDouble:coupon.depositRate];
                }
            } completion:^(BOOL contextDidSave, NSError *error) {
                
            }]; 
       
    }

-(void)loadcouponData
{
    [self.dataDiscounts removeAllObjects];
    NSArray * array = [LocalCoupon MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    if (array.count>0) {
        for (NSInteger i = 0; i<array.count; i++) {
            
            LocalCoupon * localcoupon = array[i];
            Coupon * coupon = [Coupon new];
            coupon.id = localcoupon.id;
            coupon.code = localcoupon.code;
            coupon.name = localcoupon.name;
            coupon.startTime = localcoupon.startTime.integerValue;
            coupon.endTime = localcoupon.endTime.integerValue;
            coupon.descr = localcoupon.descr;
            coupon.status = localcoupon.status.integerValue;
            coupon.type = localcoupon.type.integerValue;
            coupon.companyId = localcoupon.companyId;
            coupon.companyImage = localcoupon.companyImage;
            coupon.companyName = localcoupon.companyName;
            coupon.money = localcoupon.money.integerValue;
            coupon.depositRate = localcoupon.depositRate.integerValue;
            
            [self.dataDiscounts addObject:coupon];
        }
        if (self.dataDiscounts.count<10) {
            [self.discountCouponTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.discountCouponTableView reloadData];
    }else
    {
        [self loadNewDataDiscounts];
    }
    
    
}

#pragma mark - MJRefresh

-(void)SetupMJRefresh
{
    MJRefreshNormalHeader *Productheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNewDataProducts];
        
        //显示出上拉
        self.collectionView.mj_footer.hidden = NO;
        
    }];
    MJRefreshNormalHeader *Producttableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNewDataProducts];
        //显示出上拉
         self.productTableView.mj_footer.hidden = NO;
    }];
    self.productTableView.mj_header = Producttableviewtheader;
    self.collectionView.mj_header = Productheader;
    
    MJRefreshBackNormalFooter *Productfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadNewDataProducts];
        
    }];
    MJRefreshBackNormalFooter *Producttableviewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadNewDataProducts];
        
    }];
    self.productTableView.mj_footer = Producttableviewfooter;
    self.collectionView.mj_footer = Productfooter;
    
    
    
    MJRefreshNormalHeader *activitytableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.actionPage = 1;
        [self loadNewDataActions];
        self.actionTableView.mj_footer.hidden = NO;
    }];
    self.actionTableView.mj_header = activitytableviewtheader;
    MJRefreshAutoNormalFooter *activitytableviewfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.actionPage++;
        [self loadNewDataActions];
        
    }];
    self.actionTableView.mj_footer = activitytableviewfooter;
    
    MJRefreshNormalHeader *discountstableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.discointsPage = 1;
        [self loadNewDataDiscounts];
        //self.discountCouponTableView.mj_footer.hidden = NO;
    }];
    self.discountCouponTableView.mj_header = discountstableviewtheader;
    
    MJRefreshBackNormalFooter *discountstableviewfooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.discointsPage++;
        [self loadNewDataDiscounts];
        
    }];
    self.discountCouponTableView.mj_footer = discountstableviewfooter;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        alertView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - 读取本地数据
-(void)loadSandBox
{
    NSMutableArray * array = [NSMutableArray array];
    //全部产品
    NSArray * localarray = [LocalStorehouse MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalStorehouse * storehouse in localarray) {
        if (storehouse.isPlace.integerValue == 1) {
            [array addObject:storehouse];
        }
    }
    
    if (array.count>0) {
        for (NSInteger i = 0; i<array.count; i++) {
            
            Product * productModel = [Product new];
            LocalStorehouse * localstorehouse = array[i];
            if (localstorehouse.isPlace.integerValue == 1) {
                productModel.id = localstorehouse.id;
                productModel.name = localstorehouse.name;
                productModel.followers = localstorehouse.followers.integerValue;
                productModel.lastUpdate = localstorehouse.lastUpdate.integerValue;
                productModel.imagePath = localstorehouse.imagePath;
                productModel.price = localstorehouse.price;
                productModel.finalPrice = localstorehouse.finalPrice;
                productModel.companyName = localstorehouse.companyName;
                productModel.commission = localstorehouse.commission;
                productModel.stock = localstorehouse.stock.integerValue;
                productModel.sales = localstorehouse.sales.integerValue;
                [self.dataProducts addObject:productModel];
                
            }
        }
        [self.productTableView reloadData];
        [self.collectionView reloadData];
    }else
    {
        [self loadNewDataProducts];
    }
    
    
    //[self.collectionView.mj_header beginRefreshing];
    
    NSMutableArray * actionArray = [NSMutableArray array];
    
    //全部活动
    NSArray * localactionArray = [LocalActivity MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalActivity * localaction in localactionArray) {
        if (localaction.isPlace.integerValue == 1) {
            [actionArray addObject:localaction];
        }
    }
    if (actionArray.count>0) {
        for (NSInteger i=0; i<actionArray.count; i++) {
            
            Activity * action = [Activity new];
            LocalActivity * localActivity = actionArray[i];
            if (localActivity.isPlace.integerValue == 1) {
                action.id = localActivity.id;
                action.createAt = localActivity.createAt.integerValue;
                action.content = localActivity.content;
                action.name = localActivity.name;
                action.title = localActivity.title;
                action.lastUpdate = localActivity.lastUpdate.integerValue;
                action.companyId = localActivity.companyId;
                action.startTime = localActivity.startTime.integerValue;
                action.endTime = localActivity.endTime.integerValue;
                action.imagePaths = localActivity.imagePaths;
                [self.dataActions addObject:action];
            }
        }
        [self.actionTableView reloadData];
        
    }else
    {
        [self loadNewDataActions];
    }
    
    
//    [self loadNewDataActions];
    
    
    //隐藏上拉
//    self.collectionView.mj_footer.hidden = YES;
//    self.productTableView.mj_footer.hidden = YES;
//    self.actionTableView.mj_footer.hidden = YES;
//    self.discountCouponTableView.mj_footer.hidden = YES;
    
}

@end
