//
//  SMOrderSubViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMOrderSubViewController.h"
#import "SMOrderManagerCell.h"
#import "SMOrderHeaderView.h"
#import "SMOrderFootterView.h"
#import "SMStatusTrackingViewController.h"
#import "SMOrderDetailViewController.h"
#import "LocalSalesOrder.h"
#import "SMPayViewController.h"
#import "AppDelegate.h"
#import "SMTrackInfo.h"

@interface SMOrderSubViewController ()<UITableViewDelegate,UITableViewDataSource,SMOrderFootterViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

/**
 *  刷新用的页码
 */
@property(nonatomic,assign)NSInteger page;

/**
 *  数据保存数组
 */
@property(nonatomic,copy)NSMutableArray * orderArray;

@property (nonatomic ,strong)MBProgressHUD *HUD;/**< 提示框 */

@property (nonatomic, assign) NSInteger OrderType;
@end

@implementation SMOrderSubViewController

#pragma mark - 懒加载
-(NSMutableArray *)orderArray
{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.OrderType = -100;
    
    //创建tableview
    [self creatTableView];
    
    [self setupMJRefresh];
    
    [self requestData];
    
//    [self loadSalesDatas];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotice) name:@"orderRefresh" object:nil];
    MBProgressHUD *HUD = [MBProgressHUD showMessage:@""];
    self.HUD = HUD;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
-(void)refreshNotice{
    [self requestData];
}

-(void)creatTableView{
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KControllerBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.orderArray[section] products] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMOrderManagerCell *cell = [SMOrderManagerCell cellWithTableView:tableView];

    OrderProduct * product = [self.orderArray[indexPath.section] products][indexPath.row];
    
    [cell refrshUI:product];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86 *SMMatchHeight;
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
    SalesOrder *model = self.orderArray[section];
    footter.type = model.status;
    [footter refreshUI:model];
    footter.salesOrder = model;
    return footter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (82 + 36) *SMMatchHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21 *SMMatchHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMOrderDetailViewController *detailVc = [[SMOrderDetailViewController alloc]init];
    detailVc.salesOrder = self.orderArray[indexPath.section];
//    detailVc.orderProduct = [self.orderArray[indexPath.section] products][indexPath.row];
    detailVc.products =  [self.orderArray[indexPath.section] products];
    
    if (self.type == 0) {//目前显示的是待付款界面
        detailVc.pushedByWaitForPay = YES;
    }else if (self.type == 3){
        detailVc.pushedByAlreadyDone = YES;
    }else if (self.type == 4){
        detailVc.pushedBuyClosed = YES;
    }else if (self.type == 56){
        detailVc.pushedByRefund = YES;
    }
    
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -- SMOrderFootterViewDelegate
- (void)followBtnDidClick:(SalesOrder *)salesOrder{
    SMLog(@"点击了 跟踪状态 按钮");
    if (salesOrder.status == 0) {//待付款
        SMPayViewController * payViewC = [SMPayViewController new];
        payViewC.orderStr = salesOrder.sn;
        [self.navigationController pushViewController:payViewC animated:YES];
    }else if (salesOrder.status == 1){// 待发货
        SMLog(@"提醒发货");
        [[SKAPI shared] remindOrder:salesOrder.id block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  %@",result);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已提醒发货" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                SMLog(@"error  %@",error);
            }
        }];
    }else if (salesOrder.status == 5 || salesOrder.status == 6){
        SMLog(@"退款中或已退款");
    }else{
        SMStatusTrackingViewController *trackingVc = [[SMStatusTrackingViewController alloc] init];
        trackingVc.orderString = salesOrder.sn;
        trackingVc.saleOrder = salesOrder;
        [self.navigationController pushViewController:trackingVc animated:YES];
    }
}

#pragma mark - 创建上下拉刷新
-(void)setupMJRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self requestData];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestData];
    }];
    self.tableView.mj_footer = footer;
}


-(void)requestData{
    
    if (self.type == 5 || self.type == 6) {
        self.type = 56;
    }

    SMLog(@"self.type  requestData  %zd",self.type);
    [[SKAPI shared] queryOrderBySn:@"" andStatus:self.type andType:self.OrderType andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            
            [self.HUD hide:YES];
            
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.orderArray removeAllObjects];
            }
            
            SMLog(@"array self.type  %zd = %@",self.type,array);
            
            if (array.count>0) {
                
                for (SalesOrder * order in array) {
                    [self.orderArray addObject:order];
                    SMLog(@"order   %@",order);
                }
//                [self writeSqliteWith:self.orderArray];
                SMLog(@"%@",self.orderArray);
                
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }else
            {   [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }else{
            [self.HUD hide:YES];
            [MBProgressHUD showError:@"读取失败，网络异常。"];
            [[SKAPI shared] relist];
            SMLog(@"error  queryOrderBySn  %@",error);
        }
    }];
}


- (void)requestType:(NSInteger)type
{
//    if (type == -1) {
//        
//        [self requestData];
//        
//        return;
//    }
    
    self.OrderType = type;
    [self requestData];
//    
//    [[SKAPI shared] queryOrderBySn:@"" andType:type andPage:self.page andSize:10 block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            
//            [self.HUD hide:YES];
//            
//            if (!self.tableView.mj_footer.isRefreshing) {
//                [self.orderArray removeAllObjects];
//                SMLog(@"%@", self.orderArray);
//            }
//            
//            SMLog(@"array self.type  %zd = %@",self.type,array);
//            
//            if (array.count>0) {
//                
//                for (SalesOrder * order in array) {
//                    [self.orderArray addObject:order];
//                    SMLog(@"order   %@",order);
//                }
//                //                [self writeSqliteWith:self.orderArray];
//                SMLog(@"%@",self.orderArray);
//                
//                [self.tableView.mj_footer endRefreshing];
//                [self.tableView.mj_header endRefreshing];
//            }else
//            {   [self.tableView.mj_header endRefreshing];
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.tableView reloadData];
//            });
//        }else{
//            [self.HUD hide:YES];
//            [MBProgressHUD showError:@"读取失败，网络异常。"];
//            [[SKAPI shared] relist];
//            SMLog(@"error  queryOrderBySn  %@",error);
//        }
//    }];
// 
}

#pragma mark - 保存数据
-(void)writeSqliteWith:(NSArray *)array
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
    self.page = 1;
    NSArray * array = [LocalSalesOrder MR_findByAttribute:@"status" withValue:[NSNumber numberWithInteger:self.type]];
    if (array.count>0) {
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
        self.page = 1;
        //[self requestData];
        // [self.tableView reloadData];
        
        //隐藏上拉刷新
        //self.tableView.mj_footer.hidden = YES;
    }else
    {
        [self requestData];
    }
    
}
@end
