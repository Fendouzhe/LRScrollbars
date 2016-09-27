//
//  SMProductClassesController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductClassesController.h"
#import "SMProductClassesCell.h"
#import "skuSelected.h"
#import "SMProductClassesHeaderView.h"
#import "AppDelegate.h"
#import "Classify.h"
#import "SMSearchProductViewController.h"
@interface SMProductClassesController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSArray *arrDatas;

@property (nonatomic ,strong)Product *productDetail;

@property (nonatomic ,assign)CGFloat cellHeight;

@property (nonatomic,copy)NSMutableArray * dataArray;  //Classify

@property (nonatomic,copy)NSMutableDictionary * dataDic;

@property(nonatomic,copy)NSMutableArray * level1Array;

@end

@implementation SMProductClassesController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
-(NSMutableArray *)level1Array{
    if (!_level1Array) {
        _level1Array = [NSMutableArray array];
    }
    return _level1Array;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品分类";
    [self.view addSubview:self.tableView];
    
    
    [[SKAPI shared] queryProductClass:^(id result, NSError *error) {
        if (!error) {

            SMLog(@"分类%@",result[@"classes"]);
            for (NSDictionary * dic in result[@"classes"]) {
                
                SMLog(@"companyId  %@",dic[@"companyId"]);
                Classify * classify = [Classify mj_objectWithKeyValues:dic];
                
                [self.dataArray addObject:classify];
            }
            
            //对数据进行处理
            //先找到第一级
            NSMutableArray * level1Array = [NSMutableArray array];
            
            for (Classify * level in self.dataArray) {
                if ([level.level isEqualToString:@"1"]) {
                    [level1Array addObject:level];
                    //获取第一级
                    [self.level1Array addObject:level];
                }
            }
            
            for (Classify * level1 in level1Array) {
                NSMutableArray * level2Array = [NSMutableArray array];
                for (Classify * level in self.dataArray) {
                    if ([level.level isEqualToString:@"2"] && [level.parentId isEqualToString:level1.id]) {
                        //成立 就是该1级下面的2级
                        [level2Array addObject:level];
                    }
                }
                //添加
                SMLog(@"level2Array      %@",level2Array);
                [self.dataDic setObject:level2Array forKey:level1.id];
            }
            
            
            [self.tableView reloadData];
            
        }else{
            SMLog(@"%@",error);
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    SMLog(@"self.level1Array.count  %zd",self.level1Array.count);
    return self.level1Array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        //获取1级
        Classify * leve1 = self.level1Array[indexPath.section];
        
        SMProductClassesCell *cell = [SMProductClassesCell cellWithTableView:tableView andModel:self.dataDic[leve1.id]];
    cell.classifyArray = [self.dataDic[leve1.id] mutableCopy];
        cell.showblock =^(NSString * id){
            SMLog(@"sssss%@",id);
            SMSearchProductViewController * VC = [SMSearchProductViewController new];
            VC.classId = id;
            VC.keyWord = @"";
            [self.navigationController pushViewController:VC animated:YES];
        };
    
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        self.cellHeight = cell.cellHeight;
        SMLog(@"self.cellHeight  %f",self.cellHeight);
    
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SMProductClassesHeaderView *header = [SMProductClassesHeaderView productClassesHeaderView];
    header.classify = self.level1Array[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect rect = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

@end
