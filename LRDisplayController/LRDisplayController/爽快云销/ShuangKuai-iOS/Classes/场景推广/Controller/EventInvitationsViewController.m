//
//  EventInvitationsViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "EventInvitationsViewController.h"
//#import "EventInvitationsCell.h"
#import "SMEventInvitationsCell.h"
#import "EventInvitatModel.h"
#import "SMActiveWebVc.h"
#import "PromotionMaster.h"

@interface EventInvitationsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *tableView;/**< <#属性#> */
@property (nonatomic,strong) NSArray *dataSource;/**< <#属性#> */
@end

@implementation EventInvitationsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"活动邀请";
    
    [self.view addSubview:self.tableView];

    //[self requestData];
    
    
    UIImage *image = [[UIImage imageNamed:@"问号"] scaleToSize:ScaleToSize];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];

    [self setupMJRefresh];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupMJRefresh{
    MJRefreshNormalHeader *TableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    self.tableView.mj_header = TableViewheader;
}

- (void)rightItemClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"活动邀请" message:@"您能在这儿获取到企业近期发布的活动，点击其中一个活动进入详情，可分享给您的好友。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    //[action setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    alert.view.tintColor = [UIColor redColor];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)requestData{
    MJWeakSelf
    //SMShowPrompt(@"正在加载...");
    [[SKAPI shared] queryPromotionEventsInvitationList:10000 andLastTimestamp:-1 block:^(id result, NSError *error) {
        
        //[HUD hide:YES];
        if (!error) {
            
            weakSelf.dataSource = result;
            [weakSelf.tableView reloadData];
        }else{
            SMShowErrorNet;
        }
        [self.tableView.mj_header endRefreshing];
    }];
} 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
//    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    EventInvitationsCell *cell = [EventInvitationsCell cellWithTableView:tableView];
//    cell.cellData = self.dataSource[indexPath.section];
//    return cell;
    
    SMEventInvitationsCell *cell = [SMEventInvitationsCell cellWithTableView:tableView];
    
    cell.cellData = self.dataSource[indexPath.section];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 340*SMMatchWidth;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"%s",__func__);
    //EventInvitationsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SMActiveWebVc *vc = [[SMActiveWebVc alloc] init];
    PromotionMaster *master = self.dataSource[indexPath.section];
    vc.titleName = master.name;
    vc.pId = master.id;
    vc.imageUrl = [master.posterImage stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - LRTitleScrollViewHeight - 49 + 10 ) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate  = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
