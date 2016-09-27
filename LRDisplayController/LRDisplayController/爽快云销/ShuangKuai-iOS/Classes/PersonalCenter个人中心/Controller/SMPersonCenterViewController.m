//
//  SMPersonCenterViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/30.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPersonCenterViewController.h"
#import "SMPersonCenterCell.h"
#import "SMPersonCenterCell2.h"
#import "SMPersonInfoViewController.h"
#import "SMOrderManagerViewController.h"
#import "SMCommissionSettlementViewController.h"
#import "SMSettingViewController.h"
#import "SMShelfTemplateViewController.h"
#import "SMBankViewController.h"
#import "SMMyCaredCompanyController.h"
#import "SMNewOrderManagerViewController.h"
#import "SMMyCodeViewController.h"
#import "AppDelegate.h"


@interface SMPersonCenterViewController ()<SMPersonCenterCellDelegate>

@property (nonatomic ,strong)SMPersonCenterCell *section0Cell;


@end

@implementation SMPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.view.backgroundColor = SMColor(230, 231, 231);
    
    //[self loginGetDatas];
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //取出本地缓存的照片：]
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    if (image) {
        [self.section0Cell.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
//    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
//    NSString *info = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
//    NSString *caredCompany = [NSUserDefaults standardUserDefaults]
    
}

- (void)setupNav{
    self.title = @"个人中心";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    rightBtn.width = 22;
    rightBtn.height = 22;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)rightBtnClick{
    SMLog(@"点击了 设置按钮");
    SMSettingViewController *settingVc = [[SMSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMPersonCenterCell *cell = [SMPersonCenterCell cellWithTableView:tableView];
        cell.delegate = self;
        self.section0Cell = cell;
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
        if (image) {
            [cell.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        [self.section0Cell.circleNumBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"tweets"] forState:UIControlStateNormal];
        [self.section0Cell.caredCompanyNumBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"follows"] forState:UIControlStateNormal];
        
        self.section0Cell.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
        self.section0Cell.infoLabel.text  = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        return cell;
    }else{
        SMPersonCenterCell2 *cell = [SMPersonCenterCell2 cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
//            cell.nameLabel.text = @"订单管理";
//            cell.iconView.image = [UIImage imageNamed:@"02"];
            cell.nameLabel.text = @"佣金结算";
            cell.iconView.image = [UIImage imageNamed:@"01"];
            cell.nameLabel.font = [UIFont systemFontOfSize:15];
        }else if (indexPath.row == 1){
//            cell.nameLabel.text = @"红包";
//            cell.iconView.image = [UIImage imageNamed:@"04"];
            cell.nameLabel.text = @"银行卡";
            cell.iconView.image = [UIImage imageNamed:@"07"];
            cell.nameLabel.font = [UIFont systemFontOfSize:15];
        }else if (indexPath.row == 2){
//            cell.nameLabel.text = @"柜台管理";
//            cell.iconView.image = [UIImage imageNamed:@"03"];
//            cell.nameLabel.text = @"草稿箱";
//            cell.iconView.image = [UIImage imageNamed:@"06"];
        }else if (indexPath.row == 3){
//            cell.nameLabel.text = @"分销团队";
//            cell.iconView.image = [UIImage imageNamed:@"05"];
            
        }else if (indexPath.row == 4){
            
        }else if (indexPath.row == 5){
            
        }else if (indexPath.row == 6){
           
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    
        return 80;
    }else{
        CGFloat height;
        if (isIPhone5) {
            height = 42;
        }else if (isIPhone6){
            height = 42 *KMatch6;
        }else if (isIPhone6p){
            height = 42 *KMatch6p;
        }
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
        
        [self.navigationController pushViewController:infoVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){//佣金结算
//        SMOrderManagerViewController *orderVc = [[SMOrderManagerViewController alloc] init];
//        [self.navigationController pushViewController:orderVc animated:YES];
//        SMNewOrderManagerViewController * newOrder = [SMNewOrderManagerViewController new];
//        [self.navigationController pushViewController:newOrder animated:NO];
        
        SMCommissionSettlementViewController *commisionVc = [[SMCommissionSettlementViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:commisionVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        SMLog(@"点击了银行卡");
        SMBankViewController *bankVc = [[SMBankViewController alloc] init];
        [self.navigationController pushViewController:bankVc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 3){//货架模版
//        SMLog(@"点击了货架模版");
//        SMShelfTemplateViewController *shelfVc = [[SMShelfTemplateViewController alloc] init];
//        [self.navigationController pushViewController:shelfVc animated:YES];
       
        
    }else if (indexPath.section == 1 && indexPath.row == 6){//银行卡
        
    }
}

#pragma mark -- SMPersonCenterCellDelegate
- (void)iconBtnDidClick{
    SMLog(@"点击了 头像按钮");
//    SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
//    
//    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)circleBtnDidClick{
    SMLog(@"点击了 爽快圈按钮");
//    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
//    SMLog(@"%@",secret);
    
    //SMCircleViewController * circle = [self.tabBarController viewControllers][4];
    
    SMPersonInfoViewController *infoVc = [[SMPersonInfoViewController alloc] init];
    infoVc.circleBtn.selected = YES;
    infoVc.select = YES;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)caredBtnDidClick{
    SMLog(@"点击了 关注的企业按钮");
    
    SMMyCaredCompanyController * caredCompany = [SMMyCaredCompanyController new];
    
    [self.navigationController pushViewController:caredCompany animated:YES];
}

- (void)erWeiMaDidClick{
    SMLog(@"点击了 二维码");
//    SMMyCodeViewController *vc = [[SMMyCodeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


//#pragma mark - 必须再次登录获取基本信息，需要刷新关注和爽快圈的数据
//-(void)loginGetDatas
//{
//    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
//    
//    
//    [[SKAPI shared] queryUserProfile:ID block:^(id result, NSError *error) {
//        if (error) {//请求失败
//            SMLog(@"%@",error);
//        }else{//请求成功
//            User * user = (User *)result;
//            
//            SMLog(@"%@",user);
//            [[NSUserDefaults standardUserDefaults] setObject:user.userid forKey:KUserID];
//            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:KUserName];
//            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserAccount];
//            //[[NSUserDefaults standardUserDefaults] setObject:user.password forKey:KUserSecret];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",user.tweets] forKey:@"tweets"];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",user.follows] forKey:@"follows"];
//            
//            //存头像
//            if (user.portrait) {
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.portrait]];
//                UIImage *image = [UIImage imageWithData:data];
//                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
//            }else{
//                UIImage * image = [UIImage imageNamed:@"me"];
//                [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserIcon];
//            }
//            
//            [[NSUserDefaults standardUserDefaults] setObject:user.intro forKey:KUserInfo];
//            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:KUserTelephoneNum];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:user.address forKey:KUserCompanyAddress];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:user.induTag forKey:KUserIndustry];
//            
//            if (user.gender) {
//                [[NSUserDefaults standardUserDefaults] setObject:user.gender-1?@"女":@"男" forKey:KUserSex];
//            }else{
//                [[NSUserDefaults standardUserDefaults] setObject:@"未知性别" forKey:KUserSex];
//            }
//            
//            //[[NSUserDefaults standardUserDefaults] setObject:user.address forKey:KUserCompanyAddress];
//            
//            //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",user.gender] forKey:KUserSex];
//            
////            [self.section0Cell.circleNumBtn setTitle:[NSString stringWithFormat:@"%zd",user.tweets] forState:UIControlStateNormal];
////            [self.section0Cell.caredCompanyNumBtn setTitle:[NSString stringWithFormat:@"%zd",user.follows] forState:UIControlStateNormal];
////            [self.section0Cell.iconBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
////            self.section0Cell.nameLabel.text = user.name;
////            self.section0Cell.infoLabel.text  = user.intro;
//            
//            [self.tableView reloadData];
//        }
//    }];
//}
@end
