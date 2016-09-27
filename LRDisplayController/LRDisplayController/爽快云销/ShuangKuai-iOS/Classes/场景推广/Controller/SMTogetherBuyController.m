//
//  SMTogetherBuyController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTogetherBuyController.h"
#import "SMTogetherBuyCell.h"
#import "SMTogetherBuyWebVc.h"
#import "SMNavigationViewController.h"
#import "SMGroupbuyDetailList.h"
#import "SMPingtuanHeaderView.h"
#import "SMTogetherBuySection2Cell.h"

@interface SMTogetherBuyController ()<UITableViewDelegate,UITableViewDataSource,SMTogetherBuySection2CellDelegate>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSTimer *timer;/**< <#注释#> */

//特价拼团放送专场数据
@property (nonatomic ,strong)NSArray *arrData;/**< GroupBuyMaster */

//特价拼团单品专场数据
@property (nonatomic ,strong)NSMutableArray *groupbuyDetailArr;/*groupbuyDetailList*/

@property(nonatomic,strong)NSMutableDictionary *dicHeight;

@end

@implementation SMTogetherBuyController

#pragma mark 保存cell高度
- (NSMutableDictionary *)dicHeight {
    if(_dicHeight == nil) {
        _dicHeight = [[NSMutableDictionary alloc] init];
    }
    return _dicHeight;
}

- (NSMutableArray *)groupbuyDetailArr{
    if (_groupbuyDetailArr == nil) {
        _groupbuyDetailArr = [NSMutableArray array];
    }
    return _groupbuyDetailArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拼团促销";
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = KTuiGuangVcBgColor;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLastTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //[self getData];
    
    UIImage *image = [[UIImage imageNamed:@"问号"] scaleToSize:ScaleToSize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    [self setupMJRefresh];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupMJRefresh{
    MJRefreshNormalHeader *TableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    self.tableView.mj_header = TableViewheader;
}

- (void)rightItemClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拼团促销" message:@"您能在这儿获取到企业近期发布的拼团促销活动，点击其中一个活动进入详情，可分享给您的好友。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    alert.view.tintColor = [UIColor redColor];
    //[action setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)getData{
    [[SKAPI shared] queryPromotionGroupBuyingList:10000 andLastTimestamp:0 block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result  queryPromotionGroupBuyingList  %@",result);
            self.arrData = [GroupBuyMaster mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"groupbuyMasterList"]];
            NSArray * grouDetaiarr = [SMGroupbuyDetailList mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"groupbuyDetailList"]];
            //groupbuyStatus 为1的才显示
            [grouDetaiarr enumerateObjectsUsingBlock:^(SMGroupbuyDetailList *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.groupbuyStatus == 1) {
                    [self.groupbuyDetailArr addObject:model];
                }
            }];
            [self.tableView reloadData];
            
        }else{
            SMLog(@"error   %@",error);
            [MBProgressHUD showError:@"网络不给力,请重试!"];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)refreshLastTime{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshLastTimNotification object:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLastTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    SMLog(@"dealloc");

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;//self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 1;
    if (section == 0) {
        return self.arrData.count;
    }else{
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        SMTogetherBuyCell *cell = [SMTogetherBuyCell cellWithTableView:tableView];
        cell.master = self.arrData[indexPath.section];
        return cell;
        
    }else{
        SMTogetherBuySection2Cell *cell2 = [SMTogetherBuySection2Cell cellWithTableView:tableView];
        cell2.dataArr = self.groupbuyDetailArr;
        cell2.delegate = self;
        cell2.indexPath = indexPath;
        return cell2;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 220 *SMMatchHeight;
    }else{
        //偶数
//        if (self.groupbuyDetailArr.count % 2 == 0) {
//            return self.groupbuyDetailArr.count / 2 * (KTuiguangCollectionCellHeight * KMatch + 10);
//        }else{//加1变偶数
//            return ((self.groupbuyDetailArr.count + 1) / 2) * (KTuiguangCollectionCellHeight * KMatch + 10);
//        }
        if (self.dicHeight[indexPath]) {
            NSNumber *num = self.dicHeight[indexPath];
            return [num floatValue];
        }else{
            return KTuiguangCollectionCellHeight * KMatch + 10;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //return 10;
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    SMPingtuanHeaderView *headerView = [[SMPingtuanHeaderView alloc] init];
    if (section == 0) {
        if (self.arrData.count == 0) {
            return nil;
        }else{
            headerView.title = @"特价拼团放送专场";
            return headerView;
        }
    }else if (section == 1){
        if (self.groupbuyDetailArr.count == 0) {
            return nil;
        }else{
            headerView.title = @"特价拼团热销单品";
            return headerView;
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMTogetherBuyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.master.clickState == 1) {//活动尚未开始
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动尚未开始" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
        GroupBuyMaster *master = self.arrData[indexPath.row];
        vc.pId = master.id;
        vc.titleName = master.name;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (cell.master.clickState == 2){//活动正在进行
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动正在进行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
        GroupBuyMaster *master = self.arrData[indexPath.row];
        vc.pId = master.id;
        vc.titleName = master.name;
        vc.imageUrl = [cell.master.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (cell.master.clickState == 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动已结束" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"其他情况" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


#pragma mark --  SMTogetherBuySection2CellDelegate
//热销单品点击
- (void)togetherBuyCollectionViewCellClickWithModel:(SMGroupbuyDetailList *)model{
    SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
    vc.isSingle = YES;
    vc.pId = model.id;
    vc.titleName = model.productName;
    NSArray *imagePathArr = [NSString mj_objectArrayWithKeyValuesArray:model.imagePath];
    NSString *imageStr = imagePathArr[0];
    vc.imageUrl = [imageStr stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)uodataTableViewCellHight:(SMTogetherBuySection2Cell *)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.dicHeight[indexPath] isEqualToNumber: @(hight)]) {
        self.dicHeight[indexPath] = @(hight);
        NSLog(@"indexPath.row = %ld",indexPath.row);
        NSLog(@"高度 = %lf",[@(hight) floatValue]);
        [self.tableView reloadData];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        //40为顶部滚动标题栏高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - LRTitleScrollViewHeight - 49 + 10 ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
