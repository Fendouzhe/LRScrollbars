//
//  SMExpertViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMExpertViewController.h"
#import "SMExpertTableViewCell.h"
#import "SMPersonInfoViewController.h"
#import "AppDelegate.h"
#import "SMSuperManTableViewCell.h"
#import "SMSuperManHeaderView.h"
#import "SMNewPersonInfoController.h"

#define Three 3
#define ButtonTagOff 10

@interface SMExpertViewController ()<UITableViewDataSource,UITableViewDelegate,SMSuperManHeaderViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

/**
 *  今日排名的数组
 */
@property(nonatomic,copy)NSMutableArray * todayArray;
/**
 *  周排名数组
 */
@property(nonatomic,copy)NSMutableArray * weekArray;
/**
 *  月排名数组
 */
@property(nonatomic,copy)NSMutableArray * monthArray;
/**
 *  type 用来区分
 */
@property(nonatomic,assign)NSInteger type;


@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)SMSuperManHeaderView *headerView;

@property(nonatomic,strong)UIButton *selectButton;

@end

@implementation SMExpertViewController

#pragma mark - 懒加载
-(NSMutableArray *)todayArray
{
    if (!_todayArray) {
        _todayArray = [NSMutableArray array];
    }
    return _todayArray;
}
-(NSMutableArray *)weekArray
{
    if (!_weekArray) {
        _weekArray = [NSMutableArray array];
    }
    return _weekArray;
}
-(NSMutableArray *)monthArray
{
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

#pragma mrak - 生命周期

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"达人榜";
    // 创建TopView
    [self creatTopView];
    //创建tableview
    [self creatTableView];
    
    [self setupMJRefresh];
}

-(void)setupMJRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithSortType:self.selectButton.tag-ButtonTagOff];
    }];
}

- (void)requestDataWithSortType:(NSInteger)type{
    
    [[SKAPI shared] queryRanking:type block:^(NSArray *array, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view];
            if (type==0) {
                [self.todayArray removeAllObjects];
                for (User * user in array) {
                    [self.todayArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.todayArray];
                [self.tableView reloadData];
            }else if (type==1){
                [self.weekArray removeAllObjects];
                for (User * user in array) {
                    [self.weekArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.weekArray];
                [self.tableView reloadData];
            }else if (type==2){
                [self.monthArray removeAllObjects];
                for (User * user in array) {
                    [self.monthArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.monthArray];
                [self.tableView reloadData];
            }
            [self.tableView.mj_header endRefreshing];
        }else
        {
            [MBProgressHUD showError:@"网络不给力！"];
            [self.tableView.mj_header endRefreshing];
            //SMLog(@"%@",error);
        }
    }];
    
}

-(void)creatTopView
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = SMColor(240, 66, 88);
    view.tag = 20;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    CGFloat width = KScreenWidth/3.0;
    NSNumber * numwidth = [NSNumber numberWithFloat:width];
    //循坏创建三个按钮
    NSArray * array = @[@"今日排名",@"本周排名",@"本月排名"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton * btn = [UIButton new];
        [view addSubview:btn];
        //正常状态下的黑色
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];//[UIColor blackColor];
        NSAttributedString * string = [[NSAttributedString alloc]initWithString:array[i] attributes:dict];
        [btn setAttributedTitle:string forState:UIControlStateNormal];
        
//        //选中状态的红色
//        NSMutableDictionary * selectdict = [NSMutableDictionary dictionary];
//        selectdict[NSFontAttributeName] = KDefaultFontBig;
//        selectdict[NSForegroundColorAttributeName] = [UIColor whiteColor];//KRedColor;
//        NSAttributedString * selectString = [[NSAttributedString alloc]initWithString:array[i] attributes:selectdict];
//        [btn setAttributedTitle:selectString forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"buttonSelector"] forState:UIControlStateSelected];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = ButtonTagOff+i;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).with.offset(0);
            make.left.equalTo(view.mas_left).with.offset(width*i);
            make.width.equalTo(numwidth);
            make.height.equalTo(@44);
        }];
        
//        //下面的红线
//        UILabel * line = [[UILabel alloc]init];
//        line.backgroundColor = [UIColor yellowColor];//KRedColor;
//        line.tag = 30+i;
//        line.hidden = YES;
//        [view addSubview:line];
//        //线的长度
//        //NSNumber * num = [NSNumber numberWithFloat:width];
//        
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(view.mas_top).with.offset(42);
//            make.left.equalTo(view.mas_left).with.offset(width*i);
//            make.width.equalTo(numwidth);
//            make.height.equalTo(@2);
//        }];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //刚开始选中第一个
    UIButton * btn = [view viewWithTag:ButtonTagOff];
    btn.selected = YES;
    self.selectButton = btn;
    UILabel * line = [view viewWithTag:btn.tag+20];
    line.hidden = NO;
    self.type = 0;
    [self requestDataWithType:self.type];
    //[self requestDataWithSortType:self.selectButton.tag-ButtonTagOff];
}


-(void)creatTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(44);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SMExpertTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SMSuperManTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SMSuperManTableViewCell"];
    
    SMSuperManHeaderView *headerView = [SMSuperManHeaderView superManHeaderView];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    self.headerView.delegate = self;
}

#pragma 点击事件
-(void)btnClick:(UIButton *)btn
{
    SMLog(@"%ld",btn.tag);
    //取出父控件
    UIView * view = [self.view viewWithTag:20];
    //确定选中的按钮
    for (NSInteger i=0; i<3; i++) {
        UIButton * b = [view viewWithTag:ButtonTagOff+i];
        if (btn.tag == b.tag) {
            btn.selected = YES;
            UILabel * line = [view viewWithTag:btn.tag+20];
            line.hidden = NO;
            self.selectButton = btn;
        }else
        {
            b.selected = NO;
            UILabel * line = [view viewWithTag:b.tag+20];
            line.hidden = YES;
        }
    }
    //将tableview 的视图移到最上面
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView setContentOffset:CGPointZero];
    
    //分别请求数据 刷新UI
    switch (btn.tag) {
        case ButtonTagOff:
        {
            self.type = 0;
            if (self.todayArray.count==0) {
                [self requestDataWithType:self.type];
            }else
            {
                [self getHeaderViewDataWithArr:self.todayArray];
                [self.tableView reloadData];
            }
        }
            break;
        case 11:
        {
            self.type = 1;
            if (self.weekArray.count==0) {
                [self requestDataWithType:self.type];
            }else
            {
                [self getHeaderViewDataWithArr:self.weekArray];
                [self.tableView reloadData];
            }
        }
            break;
        case 12:
        {
            self.type = 2;
            if (self.monthArray.count==0) {
                [self requestDataWithType:self.type];
            }else
            {
                [self getHeaderViewDataWithArr:self.monthArray];
                [self.tableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type==0) {
        return self.todayArray.count-Three;
    }else if (self.type==1)
    {
        return self.weekArray.count-Three;
    }else
    {
        return self.monthArray.count-Three;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SMExpertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    SMSuperManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSuperManTableViewCell"];
    if (self.type==0) {
        [cell refreshUI:self.todayArray[indexPath.row + Three] andPlace:indexPath.row + 1 + Three];
        //SMLog(@"hahah%@",user.companyName);
        cell.pushblock = ^{
            
            //SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
            SMNewPersonInfoController *infoVc = [[SMNewPersonInfoController alloc] init];
            //给user
            infoVc.user = self.todayArray[indexPath.row + Three];
            [self.navigationController pushViewController:infoVc animated:YES];
        };
    }else if (self.type==1)
    {
        [cell refreshUI:self.weekArray[indexPath.row + Three] andPlace:indexPath.row+1 + Three];
        cell.pushblock = ^{
            //SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
            SMNewPersonInfoController *infoVc = [[SMNewPersonInfoController alloc] init];
            //给user
            infoVc.user = self.weekArray[indexPath.row + Three];
            [self.navigationController pushViewController:infoVc animated:YES];
        };
    }else
    {
        if (self.monthArray.count>indexPath.row) {
            [cell refreshUI:self.monthArray[indexPath.row + Three] andPlace:indexPath.row+1 + Three];
            cell.pushblock = ^{
                //SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
                SMNewPersonInfoController *infoVc = [[SMNewPersonInfoController alloc] init];
                //给user
                infoVc.user = self.monthArray[indexPath.row + Three];
                [self.navigationController pushViewController:infoVc animated:YES];
            };
        }
        
    }
    
//    if (self.type==0) {
//        [cell refreshUI:self.todayArray[indexPath.row] andPlace:indexPath.row + 1];
//        //SMLog(@"hahah%@",user.companyName);
//        cell.pushblock = ^{
//            SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
//            //给user
//            infoVc.user = self.todayArray[indexPath.row];
//            [self.navigationController pushViewController:infoVc animated:YES];
//        };
//    }else if (self.type==1)
//    {
//        [cell refreshUI:self.weekArray[indexPath.row] andPlace:indexPath.row+1];
//        cell.pushblock = ^{
//            SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
//            //给user
//            infoVc.user = self.weekArray[indexPath.row];
//            [self.navigationController pushViewController:infoVc animated:YES];
//        };
//    }else
//    {
//        if (self.monthArray.count>indexPath.row) {
//            [cell refreshUI:self.monthArray[indexPath.row] andPlace:indexPath.row+1];
//            cell.pushblock = ^{
//                SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
//                //给user
//                infoVc.user = self.monthArray[indexPath.row];
//                [self.navigationController pushViewController:infoVc animated:YES];
//            };
//        }
//        
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMSuperManTableViewCell *cell = (SMSuperManTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.pushblock();
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark -请求数据相关. 用不同的数组刷新tableview即可

-(void)requestDataWithType:(NSInteger)type
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    [[SKAPI shared] queryRanking:type block:^(NSArray *array, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view];
            if (type==0) {
                [self.todayArray removeAllObjects];
                for (User * user in array) {
                    [self.todayArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.todayArray];
                [self.tableView reloadData];
            }else if (type==1){
                [self.weekArray removeAllObjects];
                for (User * user in array) {
                    [self.weekArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.weekArray];
                [self.tableView reloadData];
            }else{
                [self.monthArray removeAllObjects];
                for (User * user in array) {
                    [self.monthArray addObject:user];
                }
                [self getHeaderViewDataWithArr:self.monthArray];
                [self.tableView reloadData];
            }
            
        }else
        {
            [MBProgressHUD showError:@"网络不给力!"];
            [MBProgressHUD hideHUDForView:self.view];
            SMLog(@"%@",error);
        }
    }];
}
//设置headerView 数据
- (void)getHeaderViewDataWithArr:(NSMutableArray *)arr{
    
//    self.headerView.firstLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[arr[0] sumMoney].doubleValue];
//    self.headerView.secondLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[arr[1] sumMoney].doubleValue];
//    self.headerView.threeLabel.text = [NSString stringWithFormat:@"业绩:¥%.2f",[arr[2] sumMoney].doubleValue];
//    
//    [self.headerView.firstIconImage sd_setImageWithURL:[NSURL URLWithString:[arr[0] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
//    [self.headerView.secondIconImage sd_setImageWithURL:[NSURL URLWithString:[arr[1] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
//    [self.headerView.threeIconImage sd_setImageWithURL:[NSURL URLWithString:[arr[2] portrait]] placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"]];
    
    NSMutableArray *userArr = [NSMutableArray array];
    for (int index = 0; index < Three; index++) {
        [userArr addObject:arr[index]];
    }
    self.headerView.userArr = userArr;
    [self.tableView reloadData];
}

#pragma mark - SMSuperManHeaderViewDelegate

- (void)superManHeaderViewIconViewClick:(User *)user{
    //SMLog(@"%s---%@",__func__,user);
    SMNewPersonInfoController *infoVc = [[SMNewPersonInfoController alloc] init];
    //SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
    //给user
    infoVc.user = user;
    [self.navigationController pushViewController:infoVc animated:YES];
}

@end
