//
//  SMShoppingCartController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShoppingCartController.h"
#import "SMShoppingBottomView.h"
#import "SMShoppingCell.h"
#import "SMProductDetailController.h"
#import "SMShippingController.h"
#import "AppDelegate.h"
#import "SMNewProductDetailController.h"

@interface SMShoppingCartController ()<UITableViewDelegate,UITableViewDataSource,SMShoppingBottomViewClickDelegate,SMShoppingCellClickDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)UIView *bottomView;

@property (nonatomic ,copy)NSMutableArray * dataArray;

@property (nonatomic,copy)NSMutableArray * cartArray;

@end

@implementation SMShoppingCartController

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = KGrayColorSeparatorLine;
    }
    return _tableView;
}

-(NSMutableArray *)cartArray{
    if (!_cartArray) {
        _cartArray = [NSMutableArray array];
    }
    return _cartArray;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    
    [self setupBottomView];
    
    [self addTableView];
   
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoney) name:@"RetainMoney" object:nil];
}

-(void)refreshMoney{
    [self requestData];
}
- (void)addTableView{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
    }];
}

- (void)setupBottomView{
    SMShoppingBottomView *bottomView = [SMShoppingBottomView shoppingBottomView];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
    CGFloat H;
    if (isIPhone5) {
        H = 44;
    }else if (isIPhone6){
        H = 44 *KMatch6Height;
    }else if (isIPhone6p){
        H = 44 *KMatch6pHeight;
    }
    NSNumber *height = [NSNumber numberWithFloat:H];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(height);
    }];
}

#pragma mark - SMShoppingBottomDelegate
///点击了结算
-(void)shoppingBottomViewAccountClick:(UIButton *)btn{
    //直接跳转了
    SMLog(@"点击了结算");
    //通过模型的isSelect 属性获得选中商品
    NSMutableArray * selectArray = [NSMutableArray array];
    
    for (Cart * cart in self.dataArray) {
        if (cart.isSelect) {
            //已选中
            [selectArray addObject:cart];
        }
    }
    if (selectArray.count>0) {
        SMShippingController *vc = [[SMShippingController alloc] init];
        for (Cart * cart in selectArray) {
            [vc.cartArray addObject:cart];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择需要结算的商品" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertC addAction:cancelAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - SMShoppingCellDelegate
//添加商品数量
-(void)shoppingCellPlusBtnClick:(Cart *)cart  andParameters:(NSDictionary *)parameters{
    [self calculateMoney:cart and:parameters];
}
//减少商品数量
-(void)shoppingCellMinusBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters{
    
    
    [self calculateMoney:cart and:parameters];
}
//删除商品
-(void)shoppingCellDeleteBtnClick:(Cart *)cart{
    
    [[SKAPI shared] removeMyCartItem:@[cart.id] block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            //删除数组,刷新UI
            Cart * removeCart = [Cart new];
            
            for (Cart * cart1 in self.dataArray) {
                if ([cart1.productId isEqualToString:cart.productId]) {
                    removeCart = cart1;
                }
            }
            [self.dataArray removeObject:removeCart];
            
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
}
//选中商品
-(void)shoppingCellSelectBtnClick:(Cart *)cart andParameters:(NSDictionary *)parameters {
    //选中一个就得加钱
    [self calculateMoney:cart and:parameters];
}
//图片点击
-(void)shoppingCellProductImageBtnClick:(Cart *)cart{
    
    SMNewProductDetailController *vc = [SMNewProductDetailController new];
    vc.productId = cart.productId;
    vc.mode = 3;
    vc.productName = cart.productName;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMShoppingCell *cell = [SMShoppingCell cellWithTableView:tableView];
    cell.cart = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100 *SMMatchHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMNewProductDetailController *vc = [SMNewProductDetailController new];
    Cart *cart = self.dataArray[indexPath.row];
    vc.productId = cart.productId;
    vc.mode = 3;
    vc.productName = cart.productName;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)requestData{
    
    [[SKAPI shared] queryMyCart:^(id result, NSError *error) {
        if (!error) {
            
            
            SMLog(@"queryMyCart    %@ ",result);
            [self.dataArray removeAllObjects];
            for (Cart * cart in result) {
                
                [self.dataArray addObject:cart];
                SMLog(@"cart.sku  queryMyCart  %@  cart.id  %@  ,cart.companyId %@",cart.sku,cart.id,cart.companyId);
                
                NSDictionary *parameters = @{@"productId": cart.productId,
                                             @"classModel": cart.classModel,
                                             @"amount": [NSNumber numberWithInteger:cart.amount],
                                             @"selected":[NSNumber numberWithInteger:cart.isSelect]};
                
               // NSDictionary * dic = @{@"productId":@"89756945879",@"amount":@"2",@"selected":@"1"};
                
                [self.cartArray addObject:parameters];
            }

            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

//全选的按钮
-(void)shoppingBottomViewAllSelectedClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        for (Cart * cart in self.dataArray) {
            if ([cart.classModel isEqualToString:@"trip"]) {
                cart.isSelect = NO;
            }else{
                cart.isSelect = YES;
            }
            //cart.isSelect = YES;
        }
        for (NSInteger i = 0; i<self.cartArray.count; i++) {
            
            NSDictionary * dic = self.cartArray[i];

//            NSDictionary *parameters = @{@"productId":dic[@"productId"],
//                                         @"classModel":dic[@"classModel"],
//                                         @"amount":dic[@"amount"],
//                                         @"selected":[NSNumber numberWithInteger:1]};
            NSDictionary *parameters = nil;
            if ([dic[@"classModel"] isEqualToString:@"trip"]) {
                parameters = @{@"productId":dic[@"productId"],
                               @"classModel":dic[@"classModel"],
                               @"amount":dic[@"amount"],
                               @"selected":[NSNumber numberWithInteger:0]};
            }else{
                parameters = @{@"productId":dic[@"productId"],
                               @"classModel":dic[@"classModel"],
                               @"amount":dic[@"amount"],
                               @"selected":[NSNumber numberWithInteger:1]};
            }
   
            [self.cartArray replaceObjectAtIndex:[self.cartArray indexOfObject:dic] withObject:parameters];
        }
    }else{
        for (Cart * cart in self.dataArray) {
            cart.isSelect = NO;
        }
        for (NSInteger i = 0; i<self.cartArray.count; i++) {
            
            NSDictionary * dic = self.cartArray[i];
            
            NSDictionary *parameters = @{@"productId":dic[@"productId"],
                                         @"classModel":dic[@"classModel"],
                                         @"amount":dic[@"amount"],
                                         @"selected":[NSNumber numberWithInteger:0]};
            
            [self.cartArray replaceObjectAtIndex:[self.cartArray indexOfObject:dic] withObject:parameters];
        }
    }
    
    [self calculateMoney:nil and:nil];
    
    [self.tableView reloadData];
}

///计算金额
-(void)calculateMoney:(Cart *)cart and :(NSDictionary *)pr{
    
    //SMLog(@"%@",pr);
   //将新的参数替换掉原来的参数
    for (NSInteger i= 0; i<self.cartArray.count; i++) {
        
        NSDictionary * dic = self.cartArray[i];
        
        if ([dic[@"productId"] isEqualToString:pr[@"productId"]]) {
            [self.cartArray replaceObjectAtIndex:[self.cartArray indexOfObject:dic] withObject:pr];
        }
        
    }
    
     for (NSInteger i= 0; i<self.dataArray.count; i++) {
         Cart * cart1 = self.dataArray[i];
        if ([cart1.productId isEqualToString:pr[@"productId"]]) {
            cart1.amount = [pr[@"amount"] integerValue];
            [self.dataArray replaceObjectAtIndex:[self.dataArray indexOfObject:cart1] withObject:cart];
        }
    }
    //计算总金额
    
    [[SKAPI shared] calculateMyCartItems:self.cartArray andIsCalcSf:NO block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            //通知到 bottom
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Money" object:self userInfo:result[@"result"]];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

@end
