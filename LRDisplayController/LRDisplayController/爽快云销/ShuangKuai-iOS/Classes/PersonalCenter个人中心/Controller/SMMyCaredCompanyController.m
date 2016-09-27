//
//  SMMyCaredCompanyController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/22.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyCaredCompanyController.h"
#import "SMMyCaredCompanyCell.h"
#import "SMCompanyHouseViewController.h"
#import "AppDelegate.h"

@interface SMMyCaredCompanyController ()

@property(nonatomic,copy)NSMutableArray * datasArray;

@property(nonatomic,strong)UILabel *label;

@end

@implementation SMMyCaredCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNav{
    self.title = @"我关注的企业";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 40;
    rightBtn.height = 25;
    //        rightBtn.backgroundColor = [UIColor greenColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"企业库" attributes:dict];
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 点击事件
- (void)rightBtnClick{
    SMLog(@"点击了 企业库");
    
    SMCompanyHouseViewController *companyHouseVc = [[SMCompanyHouseViewController alloc] init];
    [self.navigationController pushViewController:companyHouseVc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 5;
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMMyCaredCompanyCell *cell = [SMMyCaredCompanyCell cellWithTableView:tableView];
    
    Company *company = self.datasArray[indexPath.row];
    cell.company = company;

    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
    [_label removeFromSuperview];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(NSMutableArray *)datasArray
{
    if (!_datasArray ) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

-(void)requestData
{
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    [[SKAPI shared] queryMyFollowCompany:userid block:^(NSArray *array, NSError *error) {
        if(!error)
        {
            SMLog(@"%@",array);
            self.datasArray  = [array mutableCopy];
            if (array.count>0) {
                [self remindLable:NO];
            }else
            {
                [self remindLable:YES];
            }
            [self.tableView reloadData];
        }else
        {
            SMLog(@"%@",error);
        }
        
    }];
}

-(void)remindLable:(BOOL)isRemind
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0,200,KScreenWidth,100)];
    //_label.center = self.view.center;
    [_label setTextColor:[UIColor grayColor]];
    _label.text = @"暂时没有关注的企业,可以到企业库关注更多企业.....";
    if (isRemind) {
         [self.tableView addSubview:_label];
    }else
    {
        [_label removeFromSuperview];
    }
   
}

@end
