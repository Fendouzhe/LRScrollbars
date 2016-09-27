//
//  SMDataStationController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDataStationController.h"
#import "SMDataStationCell.h"
#import <AVQuery.h>
#import "SMDataStation.h"
#import "UIBarButtonItem+Extension.h"
#import "SMDataStation.h"

@interface SMDataStationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< tableView */

@property (nonatomic ,strong)NSMutableArray *arr;/**< <#注释#> */

@property (nonatomic ,assign)BOOL isFirstComeIn; /**< <#注释#> */

@property (nonatomic ,copy)NSString *objectId;/**< <#注释#> */

@property (nonatomic ,strong)NSMutableArray *arr2;/**<  */

@property (nonatomic,strong) NSNumber *lastVersion;/**< 最新的version */

@end

@implementation SMDataStationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"数据台";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backBtnClick) image:@"fanhuihong" highImage:@"fanhuihong"];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swichBtnDidClick:) name:@"KSwichBtnClick" object:nil];
    
//    AVQuery *query = [AVQuery queryWithClassName:@"StudioDataSet"];
//    [query whereKey:@"UserId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    MJWeakSelf
    NSString *versionStr = [NSString stringWithFormat:@"select * from DataVersion"];
    
    [AVQuery doCloudQueryInBackgroundWithCQL:versionStr callback:^(AVCloudQueryResult *result, NSError *error) {
        if (!error) {
            SMLog(@"results:%@", result.results);
            AVObject *obj = result.results.firstObject;
            NSNumber *version = [[obj objectForKey:@"localData"] objectForKey:@"Version"];
            weakSelf.lastVersion = version;
            
            NSString *cql = [NSString stringWithFormat:@"select * from StudioDataSet where UserId ='%@'",userId];
            [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error){
                
                if (!error) {
                    SMLog(@"results:%@", result.results);
                    weakSelf.isFirstComeIn = !result.results.count;
                    if (result.results.count <= 0) {  //如果拿到的是空数组，就去 StudioDataSetDefaultList 这个表里面去拿数据
                        [weakSelf getDataFromDefaultList];
                    }else{ // 返回的有数据
                        SMLog(@"返回的有数据");
                        //                SMLog(@"result   %@",result.results);
                        AVObject *obj = result.results.firstObject;
                        self.objectId = obj.objectId;
                        self.arr = [SMDataStation mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"localData"] objectForKey:@"DataSet"]];
//                        [self.tableView reloadData];
                        NSNumber *versionStr = [[obj objectForKey:@"localData"] objectForKey:@"Version"];
                        if (weakSelf.lastVersion==versionStr) {
                            [weakSelf.tableView reloadData];
                        }else{
                            NSString *newKeys = [NSString stringWithFormat:@"select * from StudioDataSetDefaultList"];
                            
                            [AVQuery doCloudQueryInBackgroundWithCQL:newKeys callback:^(AVCloudQueryResult *result, NSError *error) {
                                if (!error) {
                                    AVObject *obj = result.results.firstObject;
                                    NSArray *newKeysArray = [SMDataStation mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"localData"] objectForKey:@"DataSet"]];
                                    for (SMDataStation *dataNew in newKeysArray) {
                                        for (SMDataStation *dataOld in weakSelf.arr) {
                                            if ([dataNew.name isEqualToString:dataOld.name]) {
                                                dataNew.status = dataOld.status;
                                                break;
                                            }
                                        }
                                    }
                                    weakSelf.arr = newKeysArray;
                                    [weakSelf.tableView reloadData];
                                }
                            }];
                        }
                    }
                }else{
                    
                    SMLog(@"error  %@",error);
                    [self getDataFromDefaultList];
                }
            }];
        }else{
            
        }
    }];
    
    

}

- (void)swichBtnDidClick:(NSNotification *)noti{
    SMDataStation *data = noti.userInfo[@"KSwichBtnClickModelKey"];
    NSNumber *atRow = noti.userInfo[@"KSwichBtnClickAtRowKey"];
    [self.arr2 replaceObjectAtIndex:atRow.integerValue withObject:data];
}

- (void)getDataFromDefaultList{
    AVQuery *query = [AVQuery queryWithClassName:KLeanCloudFormNameDefault];
    [query getObjectInBackgroundWithId:KLeanCloudObjectIdDefault block:^(AVObject *object, NSError *error) {
        // object 就是 id 为 558e20cbe4b060308e3eb36c 的 Todo 对象实例

        if (!error) {
            self.arr = [SMDataStation mj_objectArrayWithKeyValuesArray:[[object objectForKey:@"localData"] objectForKey:@"DataSet"]];
            SMLog(@"getObjectInBackgroundWithId  %@",[[object objectForKey:@"localData"] objectForKey:@"DataSet"]);
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}

- (void)backBtnClick{
    SMLog(@"点击了 自定义的返回");

    //保存数据
    [self saveData];
}

- (void)saveData{
    AVObject *save = [AVObject objectWithClassName:KLeanCloudFormName];
    
    
//    NSDictionary *dict = [self.arr.firstObject mj_keyValues];
    
    
    // 将拿到的对象数据数组 转化为json字符串 ，再作为参数存到leanCloud数据库
    NSArray *dictArray = [SMDataStation mj_keyValuesArrayWithObjectArray:self.arr];
    
    NSData *msgData = [NSJSONSerialization dataWithJSONObject:dictArray options:0 error:NULL];
    NSString *jsonStr = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
    SMLog(@"jsonStr   %@",jsonStr);
    SMLog(@"self.isFirstComeIn   %zd",self.isFirstComeIn);
    if (!self.isFirstComeIn) {   //如果是第一次进来，就创建表格，否则就只做刷新
//        [save setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID] forKey:@"objectId"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KUserID]) {
            save.objectId = self.objectId;
        }
    }
    [save setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KUserID]  forKey:@"UserId"];
    [save setObject:jsonStr forKey:@"DataSet"];
    [save setObject:self.lastVersion forKey:@"Version"];
    
    [save saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(refreshSection0Data)]) {
                [self.delegate refreshSection0Data];
            }
        }else{
            SMLog(@"error   %@",error);
            [MBProgressHUD showError:@"保存失败"];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMDataStationCell *cell = [SMDataStationCell cellWithTableView:tableView];
    cell.atRow = indexPath.row;
    cell.dataModel = self.arr[indexPath.row];
    if (indexPath.row != 0) {
        [cell hideTopLine];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 *SMMatchHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KControllerBackGroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)arr{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

@end
