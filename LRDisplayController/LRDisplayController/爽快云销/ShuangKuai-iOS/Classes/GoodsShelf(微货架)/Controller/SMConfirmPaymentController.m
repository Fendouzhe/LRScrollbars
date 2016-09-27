//
//  SMConfirmPaymentController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMConfirmPaymentController.h"
#import "SMConfirmPaymentBottomView.h"
#import "SMConfirmPaymentCell.h"
#import "SMConfirmPayHeaderCell.h"
#import "SMPayViewController.h"
#import "AppDelegate.h"
#import "SMShippingController.h"

@interface SMConfirmPaymentController ()<UITableViewDelegate,UITableViewDataSource,SMConfirmPaymentCellDelegate,SMConfirmPaymentBottomViewClickDelegate>

@property (nonatomic ,strong)SMConfirmPaymentBottomView *bottomView;

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,assign)CGFloat bottomViewH;

@property (nonatomic ,copy)NSMutableArray * parametersArray;

@property (nonatomic ,assign)BOOL isLoading; /**< 为了防止连续跳转控制器两次来判断的bool值 */

@property (nonatomic ,strong)SMConfirmPaymentCell *cell;/**< <#注释#> */

@end

@implementation SMConfirmPaymentController

-(NSMutableArray *)parametersArray{
    if (!_parametersArray) {
        _parametersArray = [NSMutableArray array];
    }
    return _parametersArray;
}
-(NSMutableArray *)cartArray{
    if (!_cartArray) {
        _cartArray = [NSMutableArray array];
    }
    return _cartArray;
}
-(NSMutableArray *)arrProductIDs{
    if (!_arrProductIDs) {
        _arrProductIDs = [NSMutableArray array];
    }
    return _arrProductIDs;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认支付";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    SMLog(@"self.cartArray   %@    self.arrProductIDs   %@",self.cartArray,self.arrProductIDs);
    for (Cart *cart in self.cartArray) {
        SMLog(@"cart.productFinalPrice  viewDidLoad  %@",cart.productFinalPrice);
    }
    [self setupBottomView];
    
    [self setupTableView];
    
    for (Cart * cart in self.cartArray) {
        NSDictionary *parameters = @{@"productId": cart.productId
                                     , @"amount": [NSNumber numberWithInteger:cart.amount],@"selected":[NSNumber numberWithInteger:cart.isSelect]};
        
        [self.parametersArray addObject:parameters];
    }
    
    [self calculateMoney:nil and:nil];
}

- (void)setupTableView{
    [self.view addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
//        make.top.equalTo(self.view.mas_top).with.offset(0);
//    }];
}

- (void)setupBottomView{
    
    SMConfirmPaymentBottomView *bottomView = [SMConfirmPaymentBottomView confirmPaymentBottomView];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    self.bottomViewH = 44;
    bottomView.delegate =self;
    
    CGFloat H;
    if (isIPhone5) {
        H = self.bottomViewH;
    }else if (isIPhone6){
        H = self.bottomViewH *KMatch6Height;
    }else if (isIPhone6p){
        H = self.bottomViewH *KMatch6pHeight;
    }
    
    //NSNumber *height = [NSNumber numberWithFloat:H];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        //make.top.equalTo(self.tableView.mas_top).with.offset(0);
        make.height.with.offset(self.bottomViewH);
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//收货人详情
        SMConfirmPayHeaderCell *cell = [SMConfirmPayHeaderCell cellWithTableView:tableView];
        cell.modle = self.address;
        return cell;
    }else{//产品详情
        SMConfirmPaymentCell *cell = [SMConfirmPaymentCell cellWithTanleView:tableView];
        cell.specPrice = self.specPrice;
        cell.specName = self.specName;
        cell.cart = self.cartArray[indexPath.row];
        self.cell = cell;
        
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    if (indexPath.section == 0) {//收货人详情
        if (isIPhone5) {
            height = 60;
        }else if (isIPhone6){
            height = 60 *KMatch6Height;
        }else if (isIPhone6p){
            height = 60 *KMatch6pHeight;
        }
    }else{//产品详情
        if (isIPhone5) {
            height = 150;
        }else if (isIPhone6){
            height = 150 *KMatch6Height;
        }else if (isIPhone6p){
            height = 150 *KMatch6pHeight;
        }
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        SMShippingController * shipping = [SMShippingController new];
        shipping.specPrice = self.specPrice;
        for (Cart * cart in self.cartArray) {
            [shipping.cartArray addObject:cart];
        }
        [self.navigationController pushViewController:shipping animated:YES];
    }
}


#pragma mark -- SMConfirmPaymentBottomViewClickDelegate
//确认  结算
-(void)ConfirmPaymentBottomViewRetainClick:(UIButton *)btn{
    if (self.isLoading) {  //如果上一个请求正在执行，那就直接返回。避免连续跳转两次页面
        return;
    }
    
    self.isLoading = YES;
//    NSMutableArray * array = [NSMutableArray array];
    if (self.arrProductIDs.count == 0) {
        for (Cart * cart in self.cartArray) {
            if (cart.isSelect) {
                [self.arrProductIDs addObject:cart.productId];
            }
        }
    }
    
    SMLog(@"self.address.name  %@, self.address.phone %@,self.address.address  %@,self.arrProductIDs  %@",self.address.name,self.address.phone,self.address.address,self.arrProductIDs);
    NSNumber *amount;
    if (self.isPushedByBuyNew) {
        amount = [NSNumber numberWithInteger:self.cell.buyCountLabel.text.integerValue];
    }else{
        amount = nil;
    }
    
    SMLog(@"amount    settleOrderByBuyer   %@",amount);
    [[SKAPI shared] settleOrderByBuyer:self.address.name andBuyerPhone:self.address.phone andAddress:self.address.address andBuyerTel:@"" andMemo:@"" andProductIds:self.arrProductIDs andAmount:amount andExtra:@{} block:^(id result, NSError *error) {
        if (!error) {
            NSLog(@"settleOrderByBuyer   %@",result);
            if ([result[@"message"] isEqualToString:@"success"]) {
                self.isLoading = NO;
                SMPayViewController * pay = [SMPayViewController new];
                pay.orderStr = result[@"result"][@"masterOrderSn"];
                [self.navigationController pushViewController:pay animated:YES];
            }
            self.isLoading = NO;
        }else{
            self.isLoading = NO;
            NSLog(@"error  settleOrderByBuyer  %@",error);
//            SMShowErrorNet;
        }
    }];
}


//cell 代理
-(void)ConfirmPaymentCellPlusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters{
    [self calculateMoney:cart and:parameters];
}
-(void)ConfirmPaymentCellMinusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters{
    [self calculateMoney:cart and:parameters];
}
-(void)ConfirmPaymentCellSelectBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters{
    [self calculateMoney:cart and:parameters];
}

-(void)calculateMoney:(Cart *)cart and :(NSDictionary *)pr{
    
    //SMLog(@"%@",pr);
    //将新的参数替换掉原来的参数
    for (NSInteger i= 0; i < self.parametersArray.count; i++) {
        
        NSDictionary * dic = self.parametersArray[i];
        
        if ([dic[@"productId"] isEqualToString:pr[@"productId"]]) {
            [self.parametersArray replaceObjectAtIndex:[self.parametersArray indexOfObject:dic] withObject:pr];
        }
    }
    
    [[SKAPI shared] calculateMyCartItems:self.parametersArray andIsCalcSf:YES block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"calculateMyCartItems   %@   ",result);
            //通知到 bottom
            
            if ([result[@"result"][@"sumMoney"] doubleValue] == 0.0) {
                //等于0  获取商品的价格 传过去
                NSMutableArray * array = [NSMutableArray array];
                for (Cart * cart1 in self.cartArray) {
                    [array addObject:cart1];
                }
                self.bottomView.dataArray = [array mutableCopy];
            }else{
                self.bottomView.dataDic = result[@"result"];
            }
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"RetainMoney" object:self userInfo:result[@"result"]];
        }else{
            SMLog(@"%@",error);
            SMShowErrorNet;
        }
    }];
    
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - self.bottomViewH - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
