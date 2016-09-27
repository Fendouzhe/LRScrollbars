//
//  SMShippingController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShippingController.h"
#import "SMProvince.h"
#import "SMCity.h"
#import "SMConfirmPaymentController.h"
#import "AppDelegate.h"
#import "SMSurePayController.h"
#import "SMCustomerController.h"

@interface SMShippingController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *shippingField;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;

@property (weak, nonatomic) IBOutlet UITextField *detailAddress;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic ,strong)UIPickerView *pickerView;
/**
 *  最外层的大数组
 */
@property (nonatomic ,strong)NSArray *biggestArr;

@property (nonatomic ,strong)NSMutableArray *arrProvince;

@property (nonatomic ,strong)NSMutableArray *arrCity;

@property (nonatomic ,strong)NSMutableArray *arrQu;

/**
 *  确定
 */
@property (nonatomic ,strong)UIButton *sureBtn;
/**
 *  取消
 */
@property (nonatomic ,strong)UIButton *cancelBtn;

/**
 *  省
 */
@property (nonatomic ,copy)NSString *province;
/**
 *  市
 */
@property (nonatomic ,copy)NSString *city;
/**
 *  区
 */
@property (nonatomic ,copy)NSString *qu;

@end

@implementation SMShippingController

-(NSMutableArray *)cartArray{
    if (!_cartArray) {
        _cartArray = [NSMutableArray array];
    }
    return _cartArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customMessageNotic:) name:CustomMessageNotification object:nil];
    
}

- (void)customMessageNotic:(NSNotification *)notice{
    //SMLog(@"notice.userInfo == %@",notice.userInfo);
    NSDictionary *dict = notice.userInfo;
    self.shippingField.text = dict[@"name"];
    self.phoneField.text = dict[@"phone"];
    self.detailAddress.text = dict[@"address"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupModels];
    
    self.saveBtn.backgroundColor = KRedColor;
    self.saveBtn.layer.cornerRadius = SMCornerRadios;
    self.saveBtn.clipsToBounds = YES;
    self.title = @"填写收货地址";
    
    NSString * nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeName];
    NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneePhone];
    NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeProvince];
    NSString * detailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:KConsigneeDetailAddress];
    
    self.shippingField.text = nameStr;
    self.phoneField.text = phoneStr;
    
    if (provinceStr) {
      [self.provinceBtn setTitle:provinceStr forState:UIControlStateNormal];
    }
    
    self.detailAddress.text = detailAddress;
    
    
    [self setupRightItem];
    
}
- (void)setupRightItem{
    UIButton *button = [[UIButton alloc] init];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"选择客户" attributes:dict];
    
    [button setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [button sizeToFit];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [button addTarget:self action:@selector(selectorCustom) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)selectorCustom{
    SMCustomerController *vc = [[SMCustomerController alloc] init];
    vc.selectorCustom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setupModels{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil];
    NSDictionary *addressDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
//    self.biggestArr = addressDict[@"address"];
//
//    //转成省份的模型，再装进数组
//    NSMutableArray *arrProvince = [NSMutableArray array];
//    for (NSDictionary *dict in self.biggestArr) {
//        SMProvince *provice = [[SMProvince alloc] initWithDict:dict];
//        //        [arrProvince addObject:provice];
//        NSMutableArray *arrCity = [NSMutableArray array];
//        for (NSDictionary *dict in provice.sub) {
//            SMCity *city = [SMCity cityWithDict:dict];
//            [arrCity addObject:city];
//        }
//        provice.sub = arrCity;
//        [arrProvince addObject:provice];
//    }
//    self.arrProvince = arrProvince;

    self.arrProvince = addressDict[@"address"];
    self.arrCity = [[self.arrProvince objectAtIndex:0] objectForKey:@"sub"];
    self.arrQu = [[self.arrCity objectAtIndex:0] objectForKey:@"sub"];
}

#pragma mark -- 点击事件
- (IBAction)provinceBtnClick:(UIButton *)sender {
    SMLog(@"选择 省/市/区");
    [self.view endEditing:YES];
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.height.equalTo(@200);
    }];
    
    if (!self.sureBtn) {
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc] init];
        self.sureBtn = sureBtn;
        [self.view addSubview:sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.bottom.equalTo(self.pickerView.mas_top).with.offset(0);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
        [sureBtn setBackgroundColor:[UIColor whiteColor]];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.cancelBtn) {
        UIButton *cancelBtn = [[UIButton alloc] init];
        self.cancelBtn = cancelBtn;
        [self.view addSubview:cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.bottom.equalTo(self.pickerView.mas_top).with.offset(0);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    NSInteger quIndex = 0;
    
    //省份
    if (self.province == nil) {
        
//        [self pickerView:self.pickerView didSelectRow:18 inComponent:0];
//       
//        [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
//        
//        [self pickerView:self.pickerView didSelectRow:4 inComponent:2];
        
        [self.pickerView selectRow:18 inComponent:0 animated:NO];
        [self.pickerView reloadComponent:0];
        
        self.arrCity = [[self.arrProvince objectAtIndex:18] objectForKey:@"sub"];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView reloadComponent:1];
        
        self.arrQu = [[self.arrCity objectAtIndex:0] objectForKey:@"sub"];
        [self.pickerView selectRow:3 inComponent:2 animated:NO];
        [self.pickerView reloadComponent:2];
        
    }else{
        //获取到相对应的行 列
        for (NSInteger i=0; i<self.arrProvince.count; i++) {
            NSString * province = [self.arrProvince[i] objectForKey:@"name"];
            if ([province isEqualToString:self.province]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                provinceIndex = i;
            }
        }
    }
    
    if (self.city == nil) {
//        [self.pickerView selectRow:0 inComponent:1 animated:YES];
//        //[self pickerView:self.pickerView didSelectRow:0 inComponent:1];
//        [self.pickerView reloadComponent:1];
        
        self.arrCity = [[self.arrProvince objectAtIndex:18] objectForKey:@"sub"];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView reloadComponent:1];
        
    }else{
        //获取到相对应的行 列
        self.arrCity = [[self.arrProvince objectAtIndex:provinceIndex] objectForKey:@"sub"];
        
        for (NSInteger i=0; i<self.arrCity.count; i++) {
            NSString * city = [self.arrCity[i] objectForKey:@"name"];
            if ([city isEqualToString:self.city]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                //[self pickerView:self.pickerView didSelectRow:i inComponent:1];
                [self.pickerView reloadComponent:1];
                cityIndex = i;
            }
        }
    }

    if (self.qu == nil) {
//        [self.pickerView selectRow:4 inComponent:2 animated:YES];
//        //[self pickerView:self.pickerView didSelectRow:4 inComponent:2];
//        [self.pickerView reloadComponent:2];
    }else{
        //获取到相对应的行 列
        self.arrCity = [[self.arrProvince objectAtIndex:provinceIndex] objectForKey:@"sub"];
        self.arrQu = [[self.arrCity objectAtIndex:cityIndex] objectForKey:@"sub"];
        for (NSInteger i=0; i<self.arrQu.count; i++) {
            NSString * qu = self.arrQu[i];
            if ([qu isEqualToString:self.qu]) {
                [self.pickerView selectRow:i inComponent:2 animated:YES];
                //[self pickerView:self.pickerView didSelectRow:i inComponent:2];
                [self.pickerView reloadComponent:2];
                quIndex = i;
            }
        }
    }
    
    [self.pickerView reloadAllComponents];
}

- (void)cancelBtnClick{
    SMLog(@"点了 取消");
    [self.pickerView removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
    
    self.pickerView = nil;
    self.sureBtn = nil;
    self.cancelBtn = nil;
}

- (void)sureBtnClick{
    SMLog(@"点了 确定");
    if (self.province == nil) {
        self.province = @"广东省";
    }
    if (self.city == nil){
        self.city = @"广州市";
    }
    if (self.qu == nil){
        self.qu = @"天河区";
    }
    
    NSString *str1 = [self.province stringByAppendingString:self.city];
    NSString *str2 = [str1 stringByAppendingString:self.qu];
    [self.provinceBtn setTitle:str2 forState:UIControlStateNormal];
    
    [self.pickerView removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
    
    self.pickerView = nil;
    self.sureBtn = nil;
    self.cancelBtn = nil;
}

- (IBAction)saveBtnClick:(UIButton *)sender {
    SMLog(@"点了保存");
    //先把收货人信息存到本地，方便下次直接取出来显示
    if (![self.shippingField.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.shippingField.text forKey:KConsigneeName];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写收货人姓名" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self.phoneField.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneField.text forKey:KConsigneePhone];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写收货人联系电话" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self.provinceBtn.titleLabel.text isEqualToString:@"省/市/区"]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.provinceBtn.titleLabel.text forKey:KConsigneeProvince];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择省/市／区" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self.detailAddress.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.detailAddress.text forKey:KConsigneeDetailAddress];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写详细地址" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    if (self.isDianxin) {  //电信产品
        SMSurePayController *vc = [SMSurePayController new];
        vc.productID = self.productID;
        vc.name = self.name;
        vc.cardNum = self.cardNum;
        vc.token1 = self.token1;
        vc.token2 = self.token2;
        vc.token3 = self.token3;
        if (self.spec) {
            vc.spec = self.spec;
        }else{
            vc.specId = self.specId;
        }
        
        vc.phoneNumPara = self.phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    }else{  //非电信产品
        SMConfirmPaymentController *vc = [[SMConfirmPaymentController alloc] init];
        vc.isPushedByBuyNew = YES;
        addressModle * modle = [addressModle new];
        modle.name = self.shippingField.text;
        modle.phone = self.phoneField.text;
        
        modle.address = [NSString stringWithFormat:@"%@%@",self.provinceBtn.titleLabel.text,self.detailAddress.text];
        
        for (Cart * cart in self.cartArray) {
            [vc.cartArray addObject:cart];
        }
        
        vc.address = modle;
        vc.specName = self.specName;
        vc.specPrice = self.specPrice;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [self.arrProvince count];
            break;
        case 1:
            return [self.arrCity count];
            break;
        case 2:
            return [self.arrQu count];
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [[self.arrProvince objectAtIndex:row] objectForKey:@"name"];
    }else if (component == 1){
        return [[self.arrCity objectAtIndex:row] objectForKey:@"name"];
    }else if (component == 2){
        return [self.arrQu objectAtIndex:row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        [self.pickerView selectRow:row inComponent:0 animated:YES];
        [self.pickerView reloadComponent:0];
        
        self.arrCity = [[self.arrProvince objectAtIndex:row] objectForKey:@"sub"];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView reloadComponent:1];
        
        self.arrQu = [[self.arrCity objectAtIndex:0] objectForKey:@"sub"];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadComponent:2];
        
        self.province = [[self.arrProvince objectAtIndex:row] objectForKey:@"name"];
        self.city = [[self.arrCity objectAtIndex:0] objectForKey:@"name"];
        if (self.arrQu.count > 0) {
            self.qu = [self.arrQu objectAtIndex:0];
        }else{
            self.qu = @"";
        }
        //    self.qu = self.arrQu[row];
        
    }else if (component == 1){
        
        self.city = [[self.arrCity objectAtIndex:row] objectForKey:@"name"];
        
        self.arrQu = [[self.arrCity objectAtIndex:row] objectForKey:@"sub"];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadComponent:2];
        
        
        
        if (self.arrQu.count > 0) {
            self.qu = [self.arrQu objectAtIndex:0];
        }else{
            self.qu = @"";
        }
    }else if (component == 2){
        
        [self.pickerView selectRow:row inComponent:2 animated:YES];
        [self.pickerView reloadComponent:2];
        if (self.arrQu.count > 0) {
            self.qu = [self.arrQu objectAtIndex:row];
        }else{
            self.qu = @"";
        }
    }
    SMLog(@"%@ %@  %@",self.province,self.city,self.qu);
    SMLog(@"%zd列%zd行",component,row);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --    懒加载
- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
