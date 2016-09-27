//
//  SMCustomerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerController.h"
#import "SMTitleView.h"
#import "SMWantBuyCustomerController.h"
#import "SMOldCustomerController.h"
#import "CreatNewCustomerViewController.h"

@interface SMCustomerController ()<SMWantBuyCustomerControllerDelegate,SMOldCustomerControllerDelegate>

@property (nonatomic ,strong)SMTitleView *titleView;/**<  */

@property (nonatomic ,strong)UIView *searchView;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *searchBtn;/**< <#注释#> */

@property (nonatomic ,strong)UIView *bottomView;/**< <#注释#> */

@property (nonatomic ,strong)SMWantBuyCustomerController *vc1;/**< 意向客户  对应的控制器view*/

@property (nonatomic ,strong)SMOldCustomerController *vc2;/**< 老客户 对应的控制器view */

@end

@implementation SMCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    //[self setupSearchView];
    
    [self setupBottomView];
    
    
}

- (void)setupBottomView{
    self.bottomView = [[UIView alloc] init];
//    self.bottomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        //make.top.equalTo(self.searchView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    //意向客户
    SMWantBuyCustomerController *vc1 = [SMWantBuyCustomerController new];
    vc1.pushNav = self.navigationController;
    self.vc1 = vc1;
    vc1.delegate = self;
    vc1.selectorCustom = self.selectorCustom;
    [self.bottomView addSubview:vc1.view];

    
    //老客户
    SMOldCustomerController *vc2 = [SMOldCustomerController new];
    vc2.pushNav = self.navigationController;
    self.vc2 = vc2;
    vc2.view.hidden = YES;
    vc2.delegate = self;
    vc2.selectorCustom = self.selectorCustom;
    [self.bottomView addSubview:vc2.view];

    
}

#pragma mark -- SMWantBuyCustomerControllerDelegate
- (void)presentVc:(MFMessageComposeViewController *)vc{
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dismissVc{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- SMOldCustomerControllerDelegate
- (void)presentVc2:(MFMessageComposeViewController *)vc{
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dismissVc2{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSearchView{
    self.searchView = [[UIView alloc] init];
    self.searchView.backgroundColor = KControllerBackGroundColor;
    [self.view addSubview:self.searchView];
    
    NSNumber *searchViewHeight = [NSNumber numberWithFloat:44 *SMMatchHeight];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(searchViewHeight);
    }];
    
    //分割线
//    UIView *bottomLine = [[UIView alloc] init];
//    bottomLine.backgroundColor = [UIColor lightGrayColor];
//    [self.searchView addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(self.searchView.mas_bottom).with.offset(0);
//        make.left.equalTo(self.searchView.mas_left).with.offset(0);
//        make.right.equalTo(self.searchView.mas_right).with.offset(0);
//        make.height.equalTo(@1);
//    }];
    
    
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setImage:[UIImage imageNamed:@"fangdajing2"] forState:UIControlStateNormal];
    [self.searchView addSubview:self.searchBtn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" 搜索客户" attributes:dict];
    [self.searchBtn setAttributedTitle:str forState:UIControlStateNormal];
    self.searchBtn.backgroundColor = [UIColor whiteColor];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.layer.cornerRadius = SMCornerRadios;
    self.searchBtn.clipsToBounds = YES;
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.searchView.mas_top).with.offset(8);
        make.left.equalTo(self.searchView.mas_left).with.offset(15);
        make.right.equalTo(self.searchView.mas_right).with.offset(-15);
        make.bottom.equalTo(self.searchView.mas_bottom).with.offset(-8);
    }];
}

- (void)searchBtnClick{
    SMLog(@"点击了 搜索客户");
}

- (void)setupNav{
    //自定义titleView
    SMTitleView * titleView = [SMTitleView CreatNavSwipTitleViewWithLeftTitle:@"意向客户" andRight:@"老客户" andViewController:self];
    self.titleView = titleView;
    [titleView leftBtnClickAction:^{
        SMLog(@"击左边按钮");
        [self showVc1];
        
    }];
    [titleView rightBtnClickAction:^{
        SMLog(@"点击右边按钮");
        [self showVc2];
    }];
    [titleView hiddenLeftSpot];
    [titleView hiddenRightSpot];
    
    
    if (self.selectorCustom) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    }

    self.view.backgroundColor = KControllerBackGroundColor;
}

- (void)showVc1{
    self.vc1.view.hidden = NO;
    self.vc2.view.hidden = YES;
    [self.vc1.tableView reloadData];
}

- (void)showVc2{
    self.vc1.view.hidden = YES;
    self.vc2.view.hidden = NO;
    [self.vc2.tableView reloadData];
}

- (void)rightItemClick{
    SMLog(@"点击了 右边的新建");
    CreatNewCustomerViewController *vc = [[CreatNewCustomerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
