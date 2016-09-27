//
//  SMDetailStoreHouseController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailStoreHouseController.h"
#import "SMCarouselView.h"
#import "SMDetailProductSection0Cell.h"
#import "SMDetailProductSection1Cell.h"
#import "SMDetailProductSection2Cell.h"
#import "SMDetailProductSection4Cell.h"
#import "SMExtendedCell1.h"
#import "SMExtendedCell2.h"
#import "SMAccessoryCell.h"
#import "SMDetailProductInfoController.h"
#import "SMNumShelfViewController.h"
#import "AppDelegate.h"


@interface SMDetailStoreHouseController ()<SMCarouselViewDelegate,SMExtendedCell1Delegate,SMExtendedCell2Delegate>

@property (nonatomic ,assign)NSInteger section2Count;
/**
 *  是否展开状态，记录用户是不是点击了颜色按钮，界面是否处于展开状态。
 */
@property (nonatomic ,assign)BOOL extended;

@property (nonatomic ,assign)CGFloat extendedCellH1;

@property (nonatomic ,assign)CGFloat extendedCellH2;

@property (nonatomic ,strong)SMDetailProductSection0Cell *section0Cell;

@end

@implementation SMDetailStoreHouseController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView];
    //三目
    self.section2Count = self.extended?3:1;
    
    [self setupBackBtn];
    self.tableView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight - 20);
    self.tableView.contentOffset = CGPointMake(0, 20);
    SMLog(@"SMDetailStoreHouseController   self.product.name     %@",self.product.name);
    SMLog(@"SMDetailStoreHouseController    self.product.id     %@",self.product.id);
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    //进来请求详细数据
    [self requestDeatilProduct];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

//第二组显示几个
- (NSInteger)section2Count{
    //    _section2Count = self.extended?3:1;
    if (self.extended) {
        _section2Count = 3;
    }else{
        _section2Count = 1;
    }
    return _section2Count;
}

- (void)setupBackBtn{
    CGFloat x = 20;
    CGFloat y = 20;
    CGFloat width = 22;
    CGFloat height = 22;
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"fenxiangDetailProduct"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(x, y, width, height);
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    [self.view addSubview:shareBtn];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"zhuangfa"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(KScreenWidth - x - width, y, width, height);
    
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareBtnClick{
    SMLog(@"点击了 分享按钮");
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeaderView{
    SMCarouselView *carouse = [[SMCarouselView alloc] init];
    carouse.product = self.product;
    carouse.frame = CGRectMake(0, 0, KScreenWidth, 294);
    self.tableView.tableHeaderView = carouse;
    carouse.delegate = self;
}

#pragma mark -- SMCarouselViewDelegate
- (void)headerViewDidClickedPage:(NSInteger)page{
    SMLog(@"点击了headerView    %zd",page);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 2) {
        return self.section2Count;
    }else if (section == 3){
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SMDetailProductSection0Cell *section0Cell = [SMDetailProductSection0Cell cellWithTableView:tableView];
        self.section0Cell = section0Cell;
        
        //模型赋值，在set方法里实现内部各属性的相应赋值
        section0Cell.product = self.product;
        return section0Cell;
        
    }else if (indexPath.section == 1){
        SMDetailProductSection1Cell *cell = [SMDetailProductSection1Cell cellWithTableView:tableView];
        cell.product = self.product;
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return [SMDetailProductSection2Cell cellWithTableView:tableView];
        }else if (indexPath.row == 1){
            SMExtendedCell1 *cell = [SMExtendedCell1 cellWithTableView:tableView];
            self.extendedCellH1 = cell.totalHeight;
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == 2){
            SMExtendedCell2 *cell = [SMExtendedCell2 cellWithTableView:tableView];
            self.extendedCellH2 = cell.totalHeight;
            cell.delegate = self;
            return cell;
        }
    }else if (indexPath.section == 3){
        
        SMAccessoryCell *cell = [SMAccessoryCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = KDefaultFont;
        if (indexPath.row == 0) {
            cell.infoLabel.text = @"图文详情";
        }else if (indexPath.row == 1){
            cell.infoLabel.text = @"产品规格";
        }else if (indexPath.row == 2){
            cell.infoLabel.text = @"产品评论";
        }
        
        return cell;
    }else if (indexPath.section == 4){
//        SMDetailProductSection4Cell *cell = [SMDetailProductSection4Cell cellWithTableView:tableView];
//        cell.joinShelfBtn.backgroundColor = SMColor(249, 44, 6);
//        cell.shareBtn.backgroundColor = SMColor(179, 0, 30);
//        cell.delegate = self;
//        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 115;
    }else if (indexPath.section == 1){
        CGFloat height;
        if (isIPhone5) {
            height = 64;
        }else if (isIPhone6){
            height = 64 *KMatch6;
        }else if (isIPhone6p){
            height = 64 *KMatch6p;
        }
        return height;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CGFloat height;
            if (isIPhone5) {
                height = 64;
            }else if (isIPhone6){
                height = 64 *KMatch6;
            }else if (isIPhone6p){
                height = 64 *KMatch6p;
            }
            return height;
        }else if (indexPath.row == 1){
            return self.extendedCellH1;
        }else if (indexPath.row == 2){
            return self.extendedCellH2;
        }
    }else if (indexPath.section == 3){
        CGFloat height;
        if (isIPhone5) {
            height = 54;
        }else if (isIPhone6){
            height = 54 *KMatch6;
        }else if (isIPhone6p){
            height = 54 *KMatch6p;
        }
        return height;
    }else if (indexPath.section == 4){
        CGFloat height;
        if (isIPhone5) {
            height = 49;
        }else if (isIPhone6){
            height = 49 *KMatch6;
        }else if (isIPhone6p){
            height = 49 *KMatch6p;
        }
        return height;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"选中了  第%zd组  第%zd行",indexPath.section,indexPath.row);
    if (indexPath.section == 2 && indexPath.row == 0) {
        self.extended = !self.extended;
        SMDetailProductSection2Cell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        if (self.extended) {
            cell.arrowView.image = [UIImage imageNamed:@"xiangxiajiantou"];
        }else{
            cell.arrowView.image = [UIImage imageNamed:@"fanhuijiantou"];
        }
        [self.tableView reloadData];
    }else if (indexPath.section == 3) {
        SMDetailProductInfoController *infoVc = [[SMDetailProductInfoController alloc] init];
        infoVc.fromNum = indexPath.row;
        [self.navigationController pushViewController:infoVc animated:YES];
    }
    
    
    
}

#pragma mark -- 点击事件 SMDetailProductSection4CellDelegate

- (void)bottomBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        SMLog(@"点击了 加入微货架 按钮");
        if (self.arrProductIDs.count >= 5) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的，最多只能添加5个商品哦～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[KAddProductKey] = self.product.id;
        [[NSNotificationCenter defaultCenter] postNotificationName:KAddProductNote object:self userInfo:dict];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入微货架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else if (btn.tag == 1){
        SMLog(@"点击了  分享 按钮");
    }
}

#pragma mark -- SMExtendedCell1Delegate,SMExtendedCell2Delegate
- (void)colorBtnDidClick:(UIButton *)btn{
    SMLog(@"点击了 选择颜色的 按钮  %zd",btn.tag);
}

- (void)sizeBtnDidClick:(UIButton *)btn{
   SMLog(@"点击了 选择尺寸的 按钮  %zd",btn.tag); 
}

#pragma mark -- 懒加载
- (NSMutableArray *)arrProductIDs{
    if (_arrProductIDs == nil) {
        _arrProductIDs = [NSMutableArray array];
    }
    return _arrProductIDs;
}


#pragma mark - 需要请求一起更详细的数据
-(void)requestDeatilProduct
{
    NSString *productID;
    if (self.product.id) {
        productID = self.product.id;
    }else if (self.productID){
        productID = self.productID;
    }
    
    [[SKAPI shared] queryProductById:productID block:^(Product *product, NSError *error) {
        if (!error) {
            SMLog(@"requestDeatilProduct    %@",product);
            self.product = product;
            [self.tableView reloadData];
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}
@end
