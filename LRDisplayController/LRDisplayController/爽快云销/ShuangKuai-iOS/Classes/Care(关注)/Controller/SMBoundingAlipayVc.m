//
//  SMBoundingAlipayVc.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMBoundingAlipayVc.h"
#import "SMBoundingAliayCell.h"

@interface SMBoundingAlipayVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrTitles;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrPlaceHolders;/**< <#注释#> */

@property (nonatomic ,strong)UIButton *nextBtn;/**< <#注释#> */

@property (nonatomic ,strong)SMBoundingAliayCell *cell0;/**< <#注释#> */
@property (nonatomic ,strong)SMBoundingAliayCell *cell1;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *dataArr;/**< <#注释#> */

@property (nonatomic ,copy)NSString *bottomBtnTitle;/**< <#注释#> */

@end

@implementation SMBoundingAlipayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付宝";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    self.arrTitles = @[@"姓名",@"支付宝帐号"];
    self.arrPlaceHolders = @[@"请输入真实姓名",@"请输入支付宝帐号"];
    
    [self.view addSubview:self.tableView];
    
    [[SKAPI shared] queryCard:2 block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array queryCard  %@",array);
            self.dataArr = array;
            if (array.count > 0) {
                self.bottomBtnTitle = @"解除绑定";
                
            }else{
                self.bottomBtnTitle = @"绑定支付宝";
            }
            [self setupNextBtn];
            [self.tableView reloadData];
        }else{
            SMShowErrorNet;
            SMLog(@"error queryCard  %@",error);
            
        }
    }];
    
    
}

- (void)setupNextBtn{
    self.nextBtn = [[UIButton alloc] init];
    self.nextBtn.backgroundColor = KRedColorLight;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = KDefaultFontBig;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.bottomBtnTitle attributes:dict];
    [self.nextBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    self.nextBtn.layer.cornerRadius = SMCornerRadios;
    self.nextBtn.clipsToBounds = YES;
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.tableView.mas_bottom).with.offset(30);
        make.left.equalTo(self.view.mas_left).with.offset(25);
        make.right.equalTo(self.view.mas_right).with.offset(-25);
        make.height.equalTo(@(40 *SMMatchHeight));
    }];
}

- (void)nextBtnClick{
    SMLog(@"点击了 下一步");
    if ([self.cell0.inputField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入真实姓名" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.cell1.inputField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入支付宝帐号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.bottomBtnTitle isEqualToString:@"解除绑定"]) {
        [self ubBounding];
    }else if ([self.bottomBtnTitle isEqualToString:@"绑定支付宝"]){
        [self bounding];
    }
    
    

    
    
    [self.view endEditing:YES];
}

- (void)ubBounding{
    BankCard *modle = self.dataArr.firstObject;
    [[SKAPI shared] unbindCard:modle.account andType:2 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  unbindCard  %@",result);
            [MBProgressHUD showSuccess:@"解除绑定成功！"];
            self.cell0.userInteractionEnabled = YES;
            self.cell0.userInteractionEnabled = YES;
            self.cell0.inputField.text = @"";
            self.cell1.inputField.text = @"";
            self.bottomBtnTitle = @"绑定支付宝";
            
            [self setupNextBtn];
        }else{
            SMLog(@"error  unbindCard  %@",error );
            
        }
    }];
}

- (void)bounding{
    [[SKAPI shared] bindAlipayAcount:self.cell1.inputField.text userName:self.cell0.inputField.text block:^(id result, NSError *error) {
        if (!error) {
            [MBProgressHUD showSuccess:@"绑定成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            SMLog(@"result  bindAlipayAcount   %@",result);
            
        }else{
            SMLog(@"error  bindAlipayAcount   %@",error);
            
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMBoundingAliayCell *cell = [SMBoundingAliayCell cellWithTableView:tableView];
    cell.name = self.arrTitles[indexPath.row];
    cell.holder = self.arrPlaceHolders[indexPath.row];
    
    if (indexPath.row == 0) {
        self.cell0 = cell;
    }else if (indexPath.row == 1){
        self.cell1 = cell;
    }
    
    if (self.dataArr.count > 0) {
        BankCard *model = self.dataArr.firstObject;
        self.cell0.inputField.text = model.userName;
        self.cell1.inputField.text = model.account;
        
        self.cell0.userInteractionEnabled = NO;
        self.cell1.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55 *SMMatchHeight;
}

#pragma mark --  懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = KGrayColorSeparatorLine;
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, 55 *SMMatchHeight *self.arrTitles.count );
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
@end
