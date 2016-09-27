//
//  SMClassesController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMClassesController.h"
#import "SMClassesLevel1.h"
#import "SMClassesLevel2.h"
#import "SMClassesCell.h"
#import "SMClassesHeaderView.h"
#import "SMSearchProductViewController.h"

@interface SMClassesController ()<UITableViewDelegate,UITableViewDataSource,SMClassesHeaderViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arrData;/**< SMClassesLevel1 */



@end

@implementation SMClassesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品分类";
    self.view.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:self.tableView];
    
    [self setupData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToSearchVc2:) name:@"KSearchProductByClassNoti2" object:nil];
}



- (void)pushToSearchVc2:(NSNotification *)noti{
    SMClassesLevel2 *model2 = noti.userInfo[@"KSearchProductByClassNotiKey2"];
    SMSearchProductViewController *vc = [SMSearchProductViewController new];
    vc.classId = model2.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupData{
    
    [[SKAPI shared] queryProductClass:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result queryProductClass  %@",result);
            [self.arrData removeAllObjects];
            
            //取出所有的level1
            for (NSDictionary *dict in (NSArray *)[result objectForKey:@"classes"]) {
                NSString *level = dict[@"level"];
                if ([level isEqualToString:@"1"]) {
                    SMClassesLevel1 *leve1Model = [SMClassesLevel1 mj_objectWithKeyValues:dict];
                    [self.arrData addObject:leve1Model];
                }
            }
            
            //取出所有的level2 并放到level1中的数组中去
            for (SMClassesLevel1 *leve1Model in self.arrData) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dict in (NSArray *)[result objectForKey:@"classes"]) {
                    NSString *level = dict[@"level"];
                    NSString *parentId = dict[@"parentId"];
                    if ([level isEqualToString:@"2"] && [parentId isEqualToString:leve1Model.id]) {
                        
                        SMClassesLevel2 *leve2Model = [SMClassesLevel2 mj_objectWithKeyValues:dict];
                        [arr addObject:leve2Model];
                        
                    }
                    
                }
                leve1Model.arrLevel2s = (NSArray *)arr;
            }
            
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SMLog(@"self.arrData.count  %zd",self.arrData.count);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMClassesCell *cell = [SMClassesCell cellWithTableView:tableView];
    SMClassesLevel1 *model1 = self.arrData[indexPath.section];
    cell.arrLevel2s = model1.arrLevel2s;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMClassesLevel1 *model1 = self.arrData[indexPath.section];
    NSInteger count = model1.arrLevel2s.count;
    NSInteger rows = (count + 2 - 1) / 2;
    if (rows == 0) {
        return 0;
    }else{
        return 40 *SMMatchHeight + (10 + 40 *SMMatchHeight) *(rows - 1) + 2;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SMClassesHeaderView *header = [SMClassesHeaderView classesHeaderView];
    header.delegate = self;
    SMClassesLevel1 *model1 = self.arrData[section];
    header.model1 = model1;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 *SMMatchHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -- SMClassesHeaderViewDelegate
//查看全部按钮点击
- (void)chectAllButtonClickWithHeaderView:(SMClassesHeaderView *)view{
    SMClassesLevel1 *model1 = view.model1;
    SMSearchProductViewController *vc = [SMSearchProductViewController new];
    vc.classId = model1.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorColor = KGrayColorSeparatorLine;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)arrData{
    if (_arrData == nil) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

@end
