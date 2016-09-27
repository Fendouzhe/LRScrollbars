//
//  SMOrderManagerViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderManagerViewController.h"
#import "SMOrderManagerCell.h"
#import "SMOrderHeaderView.h"
#import "SMOrderFootterView.h"
#import "SMOrderDetailViewController.h"
#import "SMStatusTrackingViewController.h"
#import <AFNetworking.h>
#import "LocalSalesOrder+CoreDataProperties.h"
#import "LocalOrderProduct+CoreDataProperties.h"
#import "AppDelegate.h"

@interface SMOrderManagerViewController ()<UITableViewDelegate,UITableViewDataSource,SMOrderFootterViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSMutableArray * orderArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isload;

@end

@implementation SMOrderManagerViewController

#pragma mark -懒加载
-(NSMutableArray *)orderArray
{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

#pragma mark -生命周期

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [self setupTopView];
    
    //[self requestDataWithSn:@""];
    
    //添加监听搜索textfield
    [self addobserverTextFieldChange];
    
    [self setupRefresh];
    //读取本地数据
    [self loadSalesDatas];
    
    [self observeNET];
    SMLog(@"dewdewdewewdwed");
}

- (void)setupTopView{
    self.topView.backgroundColor = KControllerBackGroundColor;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"fangdajing2"];
    
    searchIcon.width = 28;
    searchIcon.height = 28;
    searchIcon.contentMode = UIViewContentModeCenter;
    self.searchField.leftView = searchIcon;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    
    self.title = @"订单管理";
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
//下面的数据在接入网络接口之后，都需要做一些调整
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 2;
    return self.orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 10;
//    }else{
//        return 1;
//    }
    return [[self.orderArray[section] products] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMOrderManagerCell *cell = [SMOrderManagerCell cellWithTableView:tableView];
    OrderProduct * product = [self.orderArray[indexPath.section] products][indexPath.row];
    [cell refrshUI:product];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMOrderHeaderView* heraderView = [SMOrderHeaderView orderHeaderView];
    //头部赋值
    SalesOrder * order = self.orderArray[section];
    heraderView.orderNum.text = [NSString stringWithFormat:@"订单号:%@",order.sn];
    heraderView.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",order.createAt]];
    
    return heraderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SMOrderFootterView *footter = [SMOrderFootterView orderFootterView];
    footter.delegate = self;
    [footter refreshUI:self.orderArray[section]];
    return footter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 82;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMOrderDetailViewController *detailVc = [[SMOrderDetailViewController alloc] init];
    detailVc.salesOrder = self.orderArray[indexPath.section];
    //detailVc.orderProduct = [self.orderArray[indexPath.section] products][indexPath.row];
    detailVc.products = [self.orderArray[indexPath.section] products];
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -- SMOrderFootterViewDelegate
- (void)followBtnDidClick{
    SMLog(@"点击了 跟踪状态 按钮");
    SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
    [self.navigationController pushViewController:trackingVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchField resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        SMLog(@"点击了键盘的搜索键  ，执行搜索代码");
        //没有数据字段 
    }
    return YES;
}

#warning 缓存
-(void)requestDataWithSn:(NSString *)sn
{
    if (self.isload) {
        [self.orderArray removeAllObjects];
        self.isload = NO;
        [self.tableView reloadData];
    }
//    [[SKAPI shared] queryOrderBySn:sn andPage:self.page andSize:2 block:^(NSArray *array, NSError *error) {
//        SMLog(@"订单管理:%@",array);
//        if (!error) {
//            if (array.count>0) {
//                if(!self.tableView.mj_footer.isRefreshing)
//                {
//                    if (self.orderArray.count>0) {
//                        [self.orderArray removeAllObjects];
//                    }
//                }
//                
//                for (SalesOrder * order in array) {
//                    [self.orderArray addObject:order];
//                }
//                //保存下来
//                [self saveSaleOrderWith:[self.orderArray copy]];
//                
//                [self.tableView reloadData];
//                
//                [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshing];
//            }else
//            {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            
//        }else
//        {
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败,请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//        }
//        
//        
//    }];
}

#pragma mark - 进行缓存  刷新
//监听网络状态
-(void)observeNET
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                SMLog(@"未识别的网络");
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                SMLog(@"不可达的网络(未连接)");
                UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接中断" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                SMLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                SMLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
}

#pragma mark - 是否需要上下拉刷新
-(void)setupRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self requestDataWithSn:@""];
        self.tableView.mj_footer.hidden = NO;
    }];
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestDataWithSn:@""];
    }];
    self.tableView.mj_footer.mj_origin = CGPointMake(0, 667);
    self.tableView.mj_footer = footer;
    
}
#pragma mark - 搜索
//监听搜索
-(void)addobserverTextFieldChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldchange) name:UITextFieldTextDidChangeNotification object:self.searchField];
}

-(void)TextFieldchange
{
    SMLog(@"执行搜索");
//    [[SKAPI shared] queryOrderBySn:self.searchField.text andPage:0 andSize:10 block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            if (!self.tableView.mj_footer.isRefreshing) {
//                if (self.orderArray.count>0) {
//                    [self.orderArray removeAllObjects];
//                }
//            }
//            for (SalesOrder * order in array) {
//                [self.orderArray addObject:order];
//            }
//            
//            [self.tableView reloadData];
//        }
//        
//    }];
}

-(void)saveSaleOrderWith:(NSArray *)array
{
    for (LocalSalesOrder * orderModel in [LocalSalesOrder MR_findAll]) {
        [orderModel MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (SalesOrder * order in array) {
            LocalSalesOrder * localSalesOrder = [LocalSalesOrder MR_createEntityInContext:localContext];
            localSalesOrder.id = order.id;
            localSalesOrder.createAt = [NSNumber numberWithInteger:order.createAt];
            localSalesOrder.sn = order.sn;
            //localSalesOrder.products = (id)order.products;
            //模型不好存 先转换为字典
            localSalesOrder.products = [NSMutableArray array];
            for (OrderProduct * op in order.products) {
                NSDictionary * dic = [op mj_JSONObject];
                [localSalesOrder.products addObject:dic];
            }
           
            localSalesOrder.buyerName = order.buyerName;
            localSalesOrder.buyerPhone = order.buyerPhone;
            localSalesOrder.buyerAddress = order.buyerAddress;
            localSalesOrder.shippingFee = [NSNumber numberWithDouble:order.shippingFee];
            localSalesOrder.companyId = order.companyId;
            localSalesOrder.companyName = order.companyName;
            localSalesOrder.sumCommission = [NSNumber numberWithDouble:order.sumCommission];
            localSalesOrder.sumPrice = [NSNumber numberWithDouble:order.sumPrice];
            localSalesOrder.sumAmount = [NSNumber numberWithInteger:order.sumAmount];
            localSalesOrder.status = [NSNumber numberWithInteger:order.status];
            localSalesOrder.dealTime = [NSNumber numberWithInteger:order.createAt];
            localSalesOrder.sendTime = [NSNumber numberWithInteger:order.sendTime];
            localSalesOrder.payTime = [NSNumber numberWithInteger:order.payTime];
            localSalesOrder.realPayMoney = [NSNumber numberWithDouble:order.realPayMoney];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        
    }];
}

-(void)loadSalesDatas
{
    //进来先清空
    [self.orderArray removeAllObjects];
    self.page = 0;
    NSArray * array = [LocalSalesOrder MR_findAll];
    for (LocalSalesOrder * localsalesOrder in array) {
        SalesOrder * order = [SalesOrder new];
        order.id =  localsalesOrder.id;
        order.createAt =  localsalesOrder.createAt.integerValue;
        order.sn = localsalesOrder.sn;
        //恢复到模型
        NSMutableArray * mutArray = [NSMutableArray array];
        for (NSDictionary * dic in localsalesOrder.products) {
            OrderProduct * opp = [OrderProduct new];
             opp = [OrderProduct mj_objectWithKeyValues:dic];
            [mutArray addObject:opp];
        }
        order.products = [NSArray arrayWithArray:mutArray];
        order.buyerName = localsalesOrder.buyerName;
        order.buyerPhone = localsalesOrder.buyerPhone;
        order.buyerAddress = localsalesOrder.buyerAddress;
        order.shippingFee = localsalesOrder.shippingFee.doubleValue;
        order.companyId = localsalesOrder.companyId;
        order.companyName = localsalesOrder.companyName;
        order.sumCommission = localsalesOrder.sumCommission.doubleValue;
        order.sumPrice = localsalesOrder.sumPrice.doubleValue;
        order.sumAmount = localsalesOrder.sumAmount.doubleValue;
        order.status = localsalesOrder.status.integerValue;
        order.createAt = localsalesOrder.dealTime.integerValue;
        order.sendTime = localsalesOrder.sendTime.integerValue;
        order.payTime = localsalesOrder.payTime.integerValue;
        order.realPayMoney = localsalesOrder.realPayMoney.doubleValue;
        [self.orderArray addObject:order];
    }
    //主动触发刷新
    //[self.tableView.mj_header beginRefreshing];
    self.isload = YES;
    self.page = 0;
    [self requestDataWithSn:@""];
//    [self.tableView reloadData];
    
    //隐藏上拉刷新
    //self.tableView.mj_footer.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchField];
}


@end
