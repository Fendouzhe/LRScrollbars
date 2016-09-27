//
//  SliderShopViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SliderShopViewController.h"
#import "SliderShopScrollView.h"
#import "SliderShopView.h"
#import "SliderShopModel.h"
#import "SliderShopListCell.h"
#import "SliderShopListModel.h"

#define TableViewOffset @"TableViewOffset"
#define TableViewDataSource @"TableViewOffset"

@interface SliderShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *dataArray;/**< <#属性#> */
@property (nonatomic,weak) SliderShopView *topView;/**< <#属性#> */
@property (nonatomic,strong) UITableView *tableView;/**< <#属性#> */
@property (nonatomic,strong) NSMutableDictionary *dataDic;/**< 属性 */
@property (nonatomic,assign) NSInteger selectNumber;/**< 顶部滑动条选择 */
@end

@implementation SliderShopViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    SliderShopView *topView = [[SliderShopView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    self.topView = topView;
    
    SliderShopModel *model1 = [[SliderShopModel alloc] init];
    model1.title = @"1";
    model1.detail = @"a1";
    
    SliderShopModel *model2 = [[SliderShopModel alloc] init];
    model2.title = @"2";
    model2.detail = @"a2";
    
    SliderShopModel *model3 = [[SliderShopModel alloc] init];
    model3.title = @"3";
    model3.detail = @"a3";
    
    SliderShopModel *model4 = [[SliderShopModel alloc] init];
    model4.title = @"4";
    model4.detail = @"a4";
    
    SliderShopModel *model5 = [[SliderShopModel alloc] init];
    model5.title = @"5";
    model5.detail = @"a5";
    
    SliderShopModel *model6 = [[SliderShopModel alloc] init];
    model6.title = @"6";
    model6.detail = @"a6";
    
    SliderShopModel *model7 = [[SliderShopModel alloc] init];
    model7.title = @"7";
    model7.detail = @"a7";
    
    SliderShopModel *model8 = [[SliderShopModel alloc] init];
    model8.title = @"8";
    model8.detail = @"a8";
    
    SliderShopModel *model9 = [[SliderShopModel alloc] init];
    model9.title = @"9";
    model9.detail = @"a9";
    
    SliderShopModel *model10 = [[SliderShopModel alloc] init];
    model10.title = @"10";
    model10.detail = @"a10";
    
    NSArray *tempArray = @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10];
    
    topView.dataArray = tempArray;
    
    [self requestData];
}



-(void)requestData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < 10; i++) {
        NSNumber *numberNumber = [NSNumber numberWithInt:i];
        NSArray *tempArray = [NSArray array];
        NSDictionary *tempDic = @{TableViewOffset:@(0.0f),TableViewDataSource:tempArray};
        [dic setObject:tempDic forKey:numberNumber];
    }
    
    SliderShopListModel *model1 = [[SliderShopListModel alloc] init];
    model1.title = @"fafasfffffff";
    model1.price = @"1233";
    model1.oldPrice = @"2000";
    model1.grabEnd = NO;
    model1.personNumber = 1000;
    
    SliderShopListModel *model2 = [[SliderShopListModel alloc] init];
    model2.title = @"fafasfffffff";
    model2.price = @"1233";
    model2.oldPrice = @"2000";
    model2.grabEnd = NO;
    model2.personNumber = 1000;
    
    SliderShopListModel *model3 = [[SliderShopListModel alloc] init];
    model3.title = @"fafasfffffff";
    model3.price = @"1233";
    model3.oldPrice = @"2000";
    model3.grabEnd = NO;
    model3.personNumber = 1000;
    
    SliderShopListModel *model4 = [[SliderShopListModel alloc] init];
    model4.title = @"fafasfffffff";
    model4.price = @"1233";
    model4.oldPrice = @"2000";
    model4.grabEnd = NO;
    model4.personNumber = 1000;
    
    SliderShopListModel *model5 = [[SliderShopListModel alloc] init];
    model5.title = @"fafasfffffff";
    model5.price = @"1233";
    model5.oldPrice = @"2000";
    model5.grabEnd = NO;
    model5.personNumber = 1000;
    
    SliderShopListModel *model6 = [[SliderShopListModel alloc] init];
    model6.title = @"fafasfffffff";
    model6.price = @"1233";
    model6.oldPrice = @"2000";
    model6.grabEnd = NO;
    model6.personNumber = 1000;
    
    self.dataArray = @[model1,model2,model3,model4,model5,model6];
    [self.tableView reloadData];
    self.tableView.contentOffset = CGPointMake(0, 100);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SliderShopListCell *cell = [SliderShopListCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (170*SMMatchWidth + 80);
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
