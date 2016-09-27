//
//  SMIndustryController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMIndustryController.h"
#import "SMIndustryCell.h"
#import "SMIndustry.h"
#import "AppDelegate.h"

@interface SMIndustryController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *arrDatas;
/**
 *  行业
 */
@property (nonatomic ,copy)NSString *industryStr;

@end

@implementation SMIndustryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.title = @"行业选项";
    [self loadDatas];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)loadDatas{

    [[SKAPI shared] queryInduTags:^(id result, NSError *error) {
        if (!error) {
           
//            self.arrDatas = (NSArray *)result;
            for (NSString *title in (NSArray *)result) {
                SMIndustry *industry = [[SMIndustry alloc] init];
                industry.title = title;
                [self.arrDatas addObject:industry];
            }
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMIndustryCell *cell = [SMIndustryCell cellWithTableView:tableView];
    SMIndustry *industry = self.arrDatas[indexPath.row];
    cell.industry = industry;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (SMIndustry *indu in self.arrDatas) {
        indu.isSelected = NO;
    }
    SMIndustryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.industry.isSelected = YES;
    [self.tableView reloadData];
    self.industryStr = cell.industry.title;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定选择此行业？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark -- 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    SMLog(@"buttonIndex  %zd",buttonIndex);
    if (buttonIndex == 0) {//点了 取消，什么也不做
        
    }else if (buttonIndex == 1){// 点了确定
        if ([self.delegate respondsToSelector:@selector(sureBtnDidClick:)]) {
            [self.delegate sureBtnDidClick:self.industryStr];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGFloat H = KScreenHeight - KStateBarHeight;
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, H);
    }
    return _tableView;
}

//- (NSArray *)arrDatas{
//    if (_arrDatas == nil) {
//        _arrDatas = [NSArray array];
//    }
//    return _arrDatas;
//}

- (NSMutableArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

@end
