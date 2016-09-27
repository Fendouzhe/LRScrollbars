//
//  SMLocationViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/12.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMLocationViewController.h"
#import <AMapLocationKit/AMapLocationManager.h>
//#import <AMapLocationKit/AMapLocationServices.h>
//#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapLocation.h"
#import "SMCircelLocationCell.h"
#import "AppDelegate.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
//#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SMLocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topGrayView;

@property (weak, nonatomic) IBOutlet UITextField *searchFiled;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong)AMapLocationManager *locationManager;

@property (nonatomic ,strong)NSArray *arrLocations;

@property (nonatomic ,copy)NSString *cityName;
/**
 *  记录当前选中的是哪个位置cell
 */
@property (nonatomic ,strong)SMCircelLocationCell *cell;

@end

@implementation SMLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self getCityName];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)getCityName{
    [AMapServices sharedServices].apiKey =@"3b86bf20b3bd229fb83d087903f02d59";
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];//百米精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            SMLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            SMLog(@"error    %@",error);
            
            //            if (error.code == AMapLocatingErrorLocateFailed)
            //            {
            //                return;
            //            }
        }
        
        SMLog(@"location: %@", location);
        
        if (regeocode){
            SMLog(@"reGeocode:%@", regeocode);
            SMLog(@"regeocode.city   %@",regeocode.city);
            self.cityName = regeocode.city;
            
        }else{
            self.cityName = @"广州";
            SMLog(@"self.cityName 值为空");
        }
        
        [self.searchFiled resignFirstResponder];
        [[SKAPI shared] queryMapKeyword:self.searchFiled.text andCity:self.cityName andPage:0 andSize:10 block:^(NSArray *array, NSError *error) {
            if (!error) {
                self.arrLocations = array;
                SMLog(@"self.arrLocations    %@",self.arrLocations);
                [self.tableView reloadData];
            }else{
                SMLog(@"%@",error);
            }
        }];
    }];
}




- (void)setup{
    self.title = @"所在位置";
    self.topGrayView.backgroundColor = KControllerBackGroundColor;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"fangdajing2"];
    self.searchFiled.backgroundColor = KControllerBackGroundColor;
    searchIcon.width = 28;
    searchIcon.height = 28;
    searchIcon.contentMode = UIViewContentModeCenter;
    self.searchFiled.leftView = searchIcon;
    self.searchFiled.leftViewMode = UITextFieldViewModeAlways;
    self.searchFiled.keyboardType = UIKeyboardTypeWebSearch;
    
    [self.view addSubview:self.tableView];
    
    [self.searchFiled becomeFirstResponder];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *ID = @"locationCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    MapLocation *location = self.arrLocations[indexPath.row];
//    cell.textLabel.text = location.name;
//    cell.textLabel.font = KDefaultFont;
//    cell.detailTextLabel.text = location.address;
//    cell.detailTextLabel.font = KDefaultFontSmall;
//    
//    UIImageView *rightView = [[UIImageView alloc] init];
//    rightView.image = [UIImage imageNamed:@"gou"];
//    cell.accessoryView = rightView;
//    cell.accessoryView.hidden = NO;
//    return cell;
    
    SMCircelLocationCell *cell = [SMCircelLocationCell cellWithTableView:tableView];
    MapLocation *location = self.arrLocations[indexPath.row];
    cell.topLabel.text = location.name;
    cell.bottomLabel.text = location.address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMCircelLocationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cell = cell;
    cell.gouBtn.hidden = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"位置选择成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    //再做跳转
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [self.searchFiled resignFirstResponder];
        [[SKAPI shared] queryMapKeyword:self.searchFiled.text andCity:self.cityName andPage:0 andSize:10 block:^(NSArray *array, NSError *error) {
            if (!error) {
                self.arrLocations = array;
                SMLog(@"self.arrLocations    %@",self.arrLocations);
                [self.tableView reloadData];
            }else{
                SMLog(@"%@",error);
            }
        }];
    }
    return YES;
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(locationCellDidSelected:)]) {
            [self.delegate locationCellDidSelected:self.cell.topLabel.text];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight - CGRectGetHeight(self.topGrayView.frame)) style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSArray *)arrLocations{
    if (_arrLocations == nil) {
        _arrLocations = [NSArray array];
    }
    return _arrLocations;
}

@end
