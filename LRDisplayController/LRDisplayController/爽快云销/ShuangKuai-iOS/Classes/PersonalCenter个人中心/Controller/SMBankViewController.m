//
//  SMBankViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/23.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMBankViewController.h"
#import "SMBankCardCell.h"
#import "SMBankDetailInfoController.h"
#import "SMBoundCardViewController.h"
//#import "LocalBankCard+CoreDataProperties.h"
#import "AppDelegate.h"

@interface SMBankViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  添加银行卡
 */
@property (weak, nonatomic) IBOutlet UIButton *addBankCardBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  装cell 颜色的数组，最后一个元素是选中时的灰色.   后面这些掩饰是由后台返回过来的
 */
@property (nonatomic ,strong)NSArray *arrColor;

@property(nonatomic,copy)NSMutableArray * datasArray;


@end

@implementation SMBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
   
}

- (void)setup{
    [self.addBankCardBtn setBackgroundColor:KRedColorLight];
    self.addBankCardBtn.layer.cornerRadius = SMCornerRadios;
    self.addBankCardBtn.clipsToBounds = YES;
    
    self.title = @"银行卡";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = KControllerBackGroundColor;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return 5;
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMBankCardCell *cell = [SMBankCardCell cellWithTableView:tableView];
    cell.colorView.backgroundColor = self.arrColor[indexPath.row];
    [cell refreshUI:self.datasArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"点击了 cell   %zd",indexPath.row);
    SMBankDetailInfoController *vc = [[SMBankDetailInfoController alloc] init];
    vc.bankcard = self.datasArray[indexPath.row];
    vc.bankColor = self.arrColor[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 点击事件
- (IBAction)addBankCardBtnClick {
    SMLog(@"点击了添加银行卡");
    SMBoundCardViewController *vc = [[SMBoundCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 懒加载
//装cell 颜色的数组，最后一个元素是选中时的灰色
- (NSArray *)arrColor{
    if (_arrColor == nil) {
        _arrColor = [NSArray array];
        _arrColor = @[SMColor(31, 120, 127),SMColor(241, 0, 90),SMColor(240, 102, 34),SMColor(230, 80, 53),SMColor(10, 82, 168),SMColor(76, 0, 116),SMColor(18, 139, 55),SMColor(117, 65, 143),SMColor(12, 96, 89),SMColor(228, 73, 5),SMColor(110, 111, 112)];
    }
    return _arrColor;
}

-(NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestDatas];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    //记录到该界面  用于后面返回
    application.boundCardVC = self;
}
#pragma mark - 显示我绑定的银行卡
-(void)requestDatas{
    [[SKAPI shared] queryCard:1 block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array  queryCard %@",array);
            
            self.datasArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
            
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}
@end
