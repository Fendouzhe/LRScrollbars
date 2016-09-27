//
//  SMSearchViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchViewController.h"
#import "SMSearchCell.h"
#import "SMSearchFooterView.h"
#import "SMDetailStoreHouseController.h"
#import "LocalSearchHistory.h"
#import "fotterView.h"
#import "SMCircleHomeViewController.h"
#import "SMNewOrderManagerViewController.h"
#import "SMSearchProductViewController.h"
#import "SMSearchActionViewController.h"
#import "SMSearchDiscountViewController.h"
#import "SMNewsController.h"
#import "SMSearchOrderViewController.h"
#import "SMPartnerConnectViewController.h"
#import "SMCustomContactViewController.h"
#import "SMPersonInfoViewController.h"
#import "SMSearchPersonViewController.h"
#import "SMSeacrhFriendViewController.h"
#import "TaskSearchController.h"
#import "SMSearchAllMessageViewController.h"

@interface SMSearchViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**
 *  输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputFIeld;
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**
 *  顶部灰色view
 */
@property (weak, nonatomic) IBOutlet UIView *topGrayView;
/**
 *  左边红线
 */
@property (weak, nonatomic) IBOutlet UIView *leftRedView;
/**
 *  右边红线
 */
@property (weak, nonatomic) IBOutlet UIView *rightRedView;
/**
 *  产品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
/**
 *  企业按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
/**
 *  产品对应的tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableViewProduct;
/**
 *  企业对应的tabelView
 */
@property (weak, nonatomic) IBOutlet UITableView *companyTableView;

@property(nonatomic,assign)NSInteger productPage;
@property(nonatomic,assign)NSInteger companyPage;

@property(nonatomic,copy)NSMutableArray * productArray;

@property(nonatomic,copy)NSMutableArray * companyArray;

@property(nonatomic,copy)NSMutableArray * categoryArray;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)UILabel *historyRecordLabel;

@end

@implementation SMSearchViewController

-(NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        NSArray * array = @[@"商品",@"优惠券",@"爽快圈",@"企业动态",@"伙伴连线",@"订单",@"联系人",@"客户连线",@"添加朋友",@"任务日程",@"聊天记录"];
        _categoryArray = [NSMutableArray arrayWithArray:array];
    }
    return _categoryArray;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       // _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"fotterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
        
//        UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
//        
//        collectionViewLayout.footerReferenceSize = CGSizeMake(KScreenWidth, 50);
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = KControllerBackGroundColor;
    self.productPage=0;
    self.companyPage=0;
    self.inputFIeld.delegate = self;
    
    [self setupUI];
 
    //[self productBtnClick];
        
    //[self setupMJRefresh];
    [self.inputFIeld becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //[self.inputFIeld becomeFirstResponder];

}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //创建下面流动的历史记录
//    self.collectionView.frame = CGRectMake(0, self.historyRecordLabel.origin.y+20, KScreenWidth, KScreenHeight-self.historyRecordLabel.origin.y-20);
//    [self.view addSubview:self.collectionView];
//}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupUI{
    
    self.topGrayView.backgroundColor = KControllerBackGroundColor;
    
    //取消按钮字体颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *cancelStr = [[NSAttributedString alloc] initWithString:@"取消" attributes:dict];
    [self.cancelBtn setAttributedTitle:cancelStr forState:UIControlStateNormal];
    
//    //产品按钮字体颜色
//    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
//    dict2[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    dict2[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSAttributedString *productStr = [[NSAttributedString alloc] initWithString:@"产 品" attributes:dict2];
//    [self.productBtn setAttributedTitle:productStr forState:UIControlStateNormal];
//    
//    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
//    dict3[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    dict3[NSForegroundColorAttributeName] = KRedColor;
//    NSAttributedString *productStr2 = [[NSAttributedString alloc] initWithString:@"产 品" attributes:dict3];
//    [self.productBtn setAttributedTitle:productStr2 forState:UIControlStateSelected];
//    
//    //企业按钮字体颜色
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    dict4[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    dict4[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSAttributedString *companyStr = [[NSAttributedString alloc] initWithString:@"企 业" attributes:dict4];
//    [self.companyBtn setAttributedTitle:companyStr forState:UIControlStateNormal];
//    
//    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
//    dict5[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    dict5[NSForegroundColorAttributeName] = KRedColor;
//    NSAttributedString *companyStr2 = [[NSAttributedString alloc] initWithString:@"企 业" attributes:dict5];
//    [self.companyBtn setAttributedTitle:companyStr2 forState:UIControlStateSelected];
//    
//    self.tableViewProduct.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.companyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    //进来时 默认选中产品
//    self.productBtn.selected = YES;
//    self.companyBtn.selected = NO;
    
    //监听textfield
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldchange) name:UITextFieldTextDidChangeNotification object:self.inputFIeld];

   
    //循环创建按钮
    for (NSInteger i=0; i<self.categoryArray.count; i++) {
        [self CreateButton:self.categoryArray[i] andCount:i];
    }
    
    //从哪跳转过来选择哪
    UIButton * b = [self.view viewWithTag:10+self.categoryType];
    [self btnClick:b];
    
    
    //创建搜索历史记录
    //获取最后一个btn的坐标
    UIButton * btn = [self.view viewWithTag:10+self.categoryArray.count-1];
    CGPoint point = CGPointMake(btn.origin.x, btn.origin.y);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, point.y+50, KScreenWidth, 21)];
    label.tag = 30;
    label.text = @"搜索历史记录";
    label.font = KDefaultFont;
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    self.historyRecordLabel = label;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //创建下面流动的历史记录----移到viewDidApear添加
        self.collectionView.frame = CGRectMake(0, label.origin.y+20, KScreenWidth, KScreenHeight-label.origin.y-20);
        [self.view addSubview:self.collectionView];
    });
    
}

-(void)CreateButton:(NSString *)title andCount:(NSInteger)count
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSInteger width = KScreenWidth/3.0;
    NSInteger height = 50;
    
    btn.frame = CGRectMake(10+count%3*width, 70+count/3*height, width-20, 32);
    //正常状态
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = KDefaultFont;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    
    btn.tag = 10+count;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

}

-(void)btnClick:(UIButton *)btn
{
    //记录到点击的按钮
    self.categoryType = btn.tag-10;
    
    [self.inputFIeld resignFirstResponder];
    
    if (btn.tag-10 == 5) {
        self.inputFIeld.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else
    {
        self.inputFIeld.keyboardType = UIKeyboardTypeDefault;
    }
    
    [self.inputFIeld becomeFirstResponder];
    
    for (NSInteger i=0; i<self.categoryArray.count; i++) {
        //循环获取btn
        UIButton * b = [self.view viewWithTag:10+i];
       //于点击的btn比较
        if (btn.tag == b.tag) {
            //选中状态
            b.layer.borderWidth = 0.5;
            b.layer.borderColor = SMColor(203, 100, 117).CGColor;
            b.layer.cornerRadius = 5;
            b.layer.masksToBounds = YES;
            [b setTitleColor:SMColor(203, 100, 117) forState:UIControlStateNormal];
            //改变搜索框的提示语
            self.inputFIeld.placeholder = [NSString stringWithFormat:@"搜索%@",self.categoryArray[btn.tag-10]];
        }else
        {
            //未选中状态
            b.layer.borderWidth = 0.5;
            b.layer.borderColor = [UIColor blackColor].CGColor;
            b.layer.cornerRadius = 5;
            b.layer.masksToBounds = YES;
            [b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //self.inputFIeld.keyboardType = UIKeyboardTypeDefault;
        }
    }
    
}

-(void)historyBtnClick:(UIButton *)btn
{
    [self.inputFIeld becomeFirstResponder];
    self.inputFIeld.text = btn.titleLabel.text;
   
}

- (IBAction)cancelBtnClick {
    SMLog(@"点击了 取消按钮");
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textfieldchange
{
    SMLog(@"%@",self.inputFIeld.text);
    if (![self.inputFIeld.text isEqualToString:@""]) {
        //在这执行搜索
        //记录搜索的
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.inputFIeld resignFirstResponder];
    //在这执行搜索  跳转到指定显示界面
    SMLog(@"点击执行搜索");
    //进行相应的跳转
    switch (self.categoryType) {
        case 0:
        {
            //跳转到商品显示界面
            SMSearchProductViewController * hotProduct = [SMSearchProductViewController new];
            hotProduct.keyWord = self.inputFIeld.text;
            [self.navigationController pushViewController:hotProduct animated:YES];
        }
            break;
        case 1:
        {
//            //跳转到活动显示界面
//            SMSearchActionViewController * action = [SMSearchActionViewController new];
//            action.keyWord = self.inputFIeld.text;
//            [self.navigationController pushViewController:action animated:YES];
            
            //跳转到优惠券显示界面
            //还有这个.....
            SMSearchDiscountViewController * discount = [SMSearchDiscountViewController new];
            discount.keyWord = self.inputFIeld.text;
            [self.navigationController pushViewController:discount animated:YES];
        }
            break;
        case 2:
        {
            //跳转到爽快圈显示界面
            //直接跳转到爽快圈
            SMCircleHomeViewController * circle = [SMCircleHomeViewController new];
            circle.isSearch = YES;
            circle.keyWord = self.inputFIeld.text;
            [self.navigationController pushViewController:circle animated:YES];
        }
            break;
        case 3:
        {
            
            //跳转到企业动态显示界面
            SMNewsController * news = [SMNewsController new];
            news.keyWord = self.inputFIeld.text;
            [self.navigationController pushViewController:news animated:YES];
        }
             break;
        case 4:
        {

            //跳转到伙伴连线显示界面
            SMLog(@"跳转到伙伴连线（对话）界面");
            //TODO: 搜索功能
//            SMPartnerConnectViewController * partner = [[SMPartnerConnectViewController alloc]init];
//            partner.isSearchPartner = YES;
//            partner.partnerKeyWord = self.inputFIeld.text;
//            [self.navigationController pushViewController:partner animated:YES];
        }
            break;
        case 5:
        {

            
            //跳转到订单显示界面
            SMSearchOrderViewController * orderManager = [SMSearchOrderViewController new];
            orderManager.keyWord = self.inputFIeld.text;
            orderManager.titleName = @"搜索结果";
            [self.navigationController pushViewController:orderManager animated:YES];
            
        }
            break;
        case 6:
        {

            //跳转到联系人显示界面
            
//            SMPartnerConnectViewController * partner = [[SMPartnerConnectViewController alloc]init];
//            partner.keyWord = self.inputFIeld.text;
//            partner.isSearchContact = YES;
//            [self.navigationController pushViewController:partner animated:YES];
            SMSearchPersonViewController *vc = [[SMSearchPersonViewController alloc] init];
            vc.keyStr = self.inputFIeld.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            //跳转到客户连线显示界面
            
            SMCustomContactViewController * customer = [SMCustomContactViewController new];
            customer.customerKeyWord = self.inputFIeld.text;
            customer.isSearchCustomer = YES;
            [self.navigationController pushViewController:customer animated:YES];
        }
            break;
        case 8:
        {
            //跳转到查询到人的个人资料界面
            
//            [[SKAPI shared] queryFriend:self.inputFIeld.text block:^(NSArray *array, NSError *error) {
//                if (!error) {
//                    if (array.count == 1) {//只搜出一个结果
//                        
//                        User *user = array[0];
//                        SMPersonInfoViewController *vc = [[SMPersonInfoViewController alloc] init];
//                        vc.user = user;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    
//                    for (id m in array) {
//                        SMLog(@"[m class]   %@",[m class]);
//                    }
//                }else{
//                    SMLog(@"error  %@",error);
//                }
//            }];
            
//            SMPartnerConnectViewController * partner = [[SMPartnerConnectViewController alloc]init];
//            partner.keyWord = self.inputFIeld.text;
//            partner.isSearchFriend = YES;
//            [self.navigationController pushViewController:partner animated:YES];
            
            SMSeacrhFriendViewController *vc = [[SMSeacrhFriendViewController alloc] init];
            vc.keyWord = self.inputFIeld.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            TaskSearchController *vc = [[TaskSearchController alloc] init];
            vc.keyWords = self.inputFIeld.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            //聊天记录
            SMSearchAllMessageViewController *vc = [[SMSearchAllMessageViewController alloc] init];
            vc.keyWords = self.inputFIeld.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
    //记录搜索的历史
    
    if (![textField.text isEqualToString:@""]) {
        //首先判断是否有一样的
        NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
        for (LocalSearchHistory * localHistory in array) {
            if ([localHistory.searchName isEqualToString:textField.text]) {
                return YES;
            }
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            LocalSearchHistory * localHistory = [LocalSearchHistory MR_createEntityInContext:localContext];
            localHistory.searchName = textField.text;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self CreateHistoryBtn];
            [self.collectionView reloadData];
        });
    }
    
    
    return YES;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.inputFIeld];
}


#pragma mark - collection相关
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    return array.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    CGSize size = [self CalculateStringSize:[array[array.count-1-indexPath.row] searchName]];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.font = KDefaultFontSmall;
    label.text = [array[array.count-1-indexPath.row] searchName];
    
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    cell.backgroundView = label;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度按照计算得到
    NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    CGSize size = [self CalculateStringSize:[array[array.count-1-indexPath.row] searchName]];
    
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 10, 8, 10);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter){
        
        fotterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.refreshCollection = ^{
            [self.collectionView reloadData];
        };
        reusableview = footerView;
        
    }
    
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(KScreenWidth, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击事件
    //获取到字段
    
    NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    NSString * string = [array[array.count-1-indexPath.row] searchName];
    
    //成为第一响应
    [self.inputFIeld becomeFirstResponder];
    
    self.inputFIeld.text = string;
    
}

-(CGSize)CalculateStringSize:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFontSmall} context:nil].size;
    CGSize fullsize = CGSizeMake(size.width+10, size.height+20);
    
    return fullsize;
}









































//#pragma mark -- UITableViewDelegate,UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        //return 3;
//        if (self.productBtn.selected) {
//            return self.productArray.count;
//        }else
//        {
//            return self.companyArray.count;
//        }
//    }else{
//        return 0;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        SMSearchCell *cell = [SMSearchCell cellWithTableView:tableView];
//        cell.textLabel.font = [UIFont systemFontOfSize:12];
//        if (tableView == self.tableViewProduct) {
//            //cell.leftLabel.text = @"华为手机";
//            Product * product = self.productArray[indexPath.row];
//            cell.leftLabel.text = product.name;
//        }else if (tableView == self.companyTableView){
//            //cell.leftLabel.text = @"腾讯公司";
//            Company * company = self.companyArray[indexPath.row];
//            cell.leftLabel.text = company.name;
//        }
//        
//        return cell;
//    }
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        SMSearchFooterView *view = [SMSearchFooterView searchFooterView];
//        view.width = KScreenWidth;
//        view.height = 70;
//        view.delegate = self;
//        return view;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return 52;
//    }else{
//        return 0;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0) {
//        if (tableView == self.tableViewProduct) {
//            SMDetailStoreHouseController * detail = [SMDetailStoreHouseController new];
//            detail.product = self.productArray[indexPath.row];
//            //[self presentViewController:detail animated:YES completion:nil];
//            [self.navigationController pushViewController:detail animated:YES];
//        }
//        if (tableView == self.companyTableView) {
//#pragma mark - 企业详情界面
//        }
//    }
//}
//
//#pragma mark -- 点击事件
//- (IBAction)productBtnClick {
//    SMLog(@"点击了 产品按钮");
//    
//    if (!self.productBtn.selected&&![self.inputFIeld.text isEqualToString:@""]) {
//        [self searchProduct];
//    }
//    self.productBtn.selected = YES;
//    self.companyBtn.selected = NO;
//    
//    self.tableViewProduct.hidden = !self.productBtn.selected;
//    self.companyTableView.hidden = !self.companyBtn.selected;
//    
//    self.leftRedView.hidden = !self.productBtn.selected;
//    self.rightRedView.hidden = !self.companyBtn.selected;
//    
//    
//    
//}
//
//- (IBAction)companyBtnClick {
//    SMLog(@"点击了 企业按钮");
//    if (!self.companyBtn.selected&&![self.inputFIeld.text isEqualToString:@""]) {
//       [self searchCompany];
//    }
//    
//    self.productBtn.selected = NO;
//    self.companyBtn.selected = YES;
//    
//    self.tableViewProduct.hidden = !self.productBtn.selected;
//    self.companyTableView.hidden = !self.companyBtn.selected;
//    
//    self.leftRedView.hidden = !self.productBtn.selected;
//    self.rightRedView.hidden = !self.companyBtn.selected;
//    
//    
//}
//

//
//#pragma mark -- SMSearchFooterViewDelegate
//- (void)clearRecordBtnDidClick{
//    SMLog(@"点击了 清除记录按钮");
//    //用数组记录每一行的数据。在这里清除数组内的数据，然后刷新tableView    reloadData
//    if (self.productArray.count>0) {
//        [self.productArray removeAllObjects];
//        [self.tableViewProduct reloadData];
//    }
//    if (self.companyArray.count>0) {
//        [self.companyArray removeAllObjects];
//        [self.companyTableView reloadData];
//    }
//    
//}
//

//
//
//#pragma mark - 懒加载
//-(NSMutableArray *)productArray
//{
//    if (!_productArray) {
//        _productArray = [NSMutableArray array];
//    }
//    return _productArray;
//}
//-(NSMutableArray *)companyArray
//{
//    if (!_companyArray) {
//        _companyArray = [NSMutableArray array];
//    }
//    return _companyArray;
//}

//
////-(void)setupMJRefresh
////{
////    MJRefreshNormalHeader *Productheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        self.productPage = 0;
////        [self searchProduct];
////        
////    }];
////    MJRefreshNormalHeader *Companyheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        self.companyPage = 0;
////        
////        [self searchCompany];
////    }];
////    self.tableViewProduct.mj_header = Productheader;
////    self.companyTableView.mj_header = Companyheader;
////    
////    
////    MJRefreshAutoNormalFooter *Productfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        self.productPage++;
////        [self searchProduct];
////        
////    }];
////    MJRefreshAutoNormalFooter *Companyfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        self.companyPage++;
////        [self searchCompany];
////        
////    }];
////    self.tableViewProduct.mj_footer = Productfooter;
////    self.companyTableView.mj_footer = Companyfooter;
////    
////    self.tableViewProduct.mj_footer.hidden = YES;
////    self.companyTableView.mj_footer.hidden = YES;
////}
//
//-(void)searchProduct
//{
//    if (!self.tableViewProduct.mj_footer.isRefreshing) {
//        if (self.productArray.count>0) {
//            [self.productArray removeAllObjects];
//        }
//    }
//    [[SKAPI shared] queryProductByName:self.inputFIeld.text andPage:self.productPage andSize:10 andSortType:SortType_Default block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            SMLog(@"%@",array);
//            for (Product * product in array) {
//                [self.productArray addObject:product];
//            }
//            if (self.productArray.count>10) {
//                self.tableViewProduct.mj_footer.hidden = NO;
//            }
//            [self.tableViewProduct reloadData];
//            
//            [self.tableViewProduct.mj_footer endRefreshing];
//            [self.tableViewProduct.mj_header endRefreshing];
//        }else
//        {
//            SMLog(@"%@",error);
//        }
//    }];
//}
//
//-(void)searchCompany
//{
//    if (!self.companyTableView.mj_footer.isRefreshing) {
//        if (self.companyArray.count>0) {
//            [self.companyArray removeAllObjects];
//        }
//    }
//    
//    [[SKAPI shared] queryCompanyByName:self.inputFIeld.text isRecommend:YES andPage:self.companyPage andSize:10 block:^(NSArray *array, NSError *error) {
//        if (!error) {
//            SMLog(@"%@",array);
//            for (Company * company in array) {
//                [self.companyArray addObject:company];
//            }
//            if (self.companyArray.count>10) {
//                self.companyTableView.mj_footer.hidden = NO;
//            }
//            [self.companyTableView reloadData];
//            [self.companyTableView.mj_header endRefreshing];
//            [self.companyTableView.mj_footer endRefreshing];
//        }else
//        {
//            SMLog(@"%@",error);
//        }
//    }];
//}
//
//


@end
