//
//  SMMyTeamController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyTeamController.h"
#import "SMMyTemCell.h"
#import "SMPersonInfoViewController.h"
@interface SMMyTeamController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property(nonatomic,copy)NSMutableArray * dataArray;

//选中的Id 数组
@property(nonatomic,copy)NSMutableArray * IdArray;
//添加好友时的textfield的内容
@property(nonatomic,copy)NSString * remark;
@end

@implementation SMMyTeamController
#pragma mark -  懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)IdArray{
    if (!_IdArray) {
        _IdArray = [NSMutableArray array];
    }
    return _IdArray;
}
-(NSArray *)initialArray{
    if (!_initialArray) {
        _initialArray = [NSMutableArray array];
    }
    return _initialArray;
}
-(NSMutableArray *)showArray{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self addTableView];
    
    self.title = @"我的团队";
    
    if (self.type == 2) {
        for (User * user in self.showArray) {
            [self.dataArray addObject:user];
        }
        [self.tableView reloadData];
    }else{
        [self requestData];
    }
    
    
}

-(void)setupNav{
    
//    if (self.type == 1) {
//        UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.width = 30;
//        rightBtn.height = 25;
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        dic[NSFontAttributeName] = KDefaultFontBig;
//        dic[NSForegroundColorAttributeName] = KRedColorLight;
//        NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:@"保存" attributes:dic];
//        [rightBtn setAttributedTitle:attribute forState:UIControlStateNormal];
//        [rightBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        self.navigationItem.rightBarButtonItem = rightItem;
//    }

}

-(void)saveClick{
    //保存 数组中user  并传递给上个控制器
    SMLog(@"%zd",self.IdArray.count);
   
    if (self.type == 1) {
        self.returnIdArrayBlock([self.IdArray copy]);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)requestData{
    MJWeakSelf
    [[SKAPI shared] queryMyTeamList:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result =     %@",result);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            for (User * user in self.initialArray) {
                [dic setObject:@"" forKey:user.id];
            }
            
            for (User * user in result) {
                [weakSelf.dataArray addObject:user];
                
                if (dic[user.id]) {
                    user.isSelect = YES;
                    [weakSelf.IdArray addObject:user];
                }else{
                    user.isSelect = NO;
                }
                
            }
            
            [[SKAPI shared] queryFriend:@"" block:^(NSArray *array, NSError *error) {
                if (!error) {
                    SMLog(@"%@",array);
                    //进行处理
                    for (User * user in weakSelf.dataArray) {
                        for (User * user1 in array) {
                            if ([user.userid isEqualToString:user1.userid]) {
                                //是自己好友
                                user.isFriend = YES;
                                break;
                            }
                            
                            user.isFriend = NO;
                        }
                    }
                    [self.tableView reloadData];
                }else{
                    SMLog(@"%@",error);
                }
            }];
            
            SMLog(@"%@",self.IdArray);
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)addTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 7;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMyTemCell *cell = [SMMyTemCell cellWithTableview:tableView];
    
    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    if (!level2  && (self.type == 0 || self.type == 2)) {
        //1级  隐藏掉按钮
        cell.rightBtn.hidden = YES;
    }else{
        cell.rightBtn.hidden = NO;
    }
    
    cell.user = self.dataArray[indexPath.row];
    cell.type = self.type;
    
    cell.editIdArrayBlock = ^(BOOL isadd){
        if (isadd) {
            //添加
            [self.IdArray addObject:self.dataArray[indexPath.row]];
        }else{
            //删除
            [self.IdArray removeObject:self.dataArray[indexPath.row]];
            SMLog(@"%zd",self.IdArray.count);
        }
    };
    
    __weak typeof (SMMyTemCell *) weakCell = cell;
    cell.alertblock = ^{
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"添加好友" message:weakCell.user.name preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //实现方法
            [[SKAPI shared] addFriend:weakCell.user.userid andRemark:self.remark block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"%@",result);
                }else{
                    SMLog(@"%@",error);
                }
            }];
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入验证消息";
            textField.delegate = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        
        [alertVC addAction:ok];
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMPersonInfoViewController * info = [SMPersonInfoViewController new];
    info.user = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
}
#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)alertTextFieldTextDidChange:(NSNotification *)notification
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    
    if (alert) {
        UITextField *lisen = [alert.textFields lastObject];
        self.remark = lisen.text;
    }
}
@end
