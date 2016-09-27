//
//  IntentionProductViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "IntentionProductViewController.h"
#import "IntentionProductCell.h"
#import "IntentionProductModel.h"
#import "SMNewProductDetailController.h"
#import "Product.h"

@interface IntentionProductViewController ()
@property (nonatomic,strong) NSArray *dataArray;/**< 数据源 */
@end

@implementation IntentionProductViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    IntentionProductModel *model01 = [[IntentionProductModel alloc] init];
//    model01.title = @"1213123";
//    model01.price = @"1212";
//    model01.brokerage = @"12";
//    
//    self.dataArray = @[model01];
//    [self.tableView reloadData];
    
    self.title = @"意向商品";
    
    UIView *whiteView = [[UIView alloc] init];
    self.tableView.tableFooterView = whiteView;
    
    self.tableView.separatorStyle = NO;
}

-(void)setProductArray:(NSArray *)productArray{
    _productArray = productArray;
    [self requestData];
}

-(void)requestData{
    MJWeakSelf
    SMShowPrompt(@"为您玩命加载中...");
    [[SKAPI shared] queryObject:self.productArray andType:Type_Product block:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            weakSelf.dataArray = [Product mj_objectArrayWithKeyValuesArray:result];
            [weakSelf.tableView reloadData];
        }else{
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络异常!"];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntentionProductCell *cell = [IntentionProductCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*SMMatchWidth;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //self.selectText = [self.dataArray[indexPath.row] title];
    Product *product = self.dataArray[indexPath.row];
    SMNewProductDetailController *vc = [SMNewProductDetailController new];
    vc.product = product;
    vc.productId = product.id;
    vc.mode = 2;
    vc.productName = product.name;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
