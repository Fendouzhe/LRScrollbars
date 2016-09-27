//
//  SMSignInViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/20.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSignInViewController.h"
#import "SMSignInCountViewController.h"
#import "NSString+WeekDay.h"

//#import <AMapLocationKit/AMapLocationKit.h>
//#import <AMapLocationKit/AMapLocationServices.h>
#import "AppDelegate.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
//#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface SMSignInViewController ()<AMapSearchDelegate,UIAlertViewDelegate>
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  一共签到的次数
 */
@property (weak, nonatomic) IBOutlet UILabel *signInTimesLabel;
/**
 *  当前日期
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/**
 *  当前时间
 */
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 *  详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
/**
 *  提示签到（如果当天已签到，则显示已签到）
 */
@property (weak, nonatomic) IBOutlet UILabel *promptSignInLabel;

/**
 *  星期几
 */
@property (nonatomic ,copy)NSString *weekdayStr;
/**
 *  日期
 */
@property (nonatomic ,copy)NSString *dateStr;
/**
 *  定时器
 */
@property(nonatomic,strong) NSTimer *timer;

@property (nonatomic ,strong)AMapLocationManager *locationManager;

//@property (nonatomic ,strong)MAMapView *mapView;

//@property (nonatomic ,strong)UIButton *bottomSureBtn;

@property (nonatomic ,strong)AMapSearchAPI *search;

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

/**
 *  上一次进来时的日期
 */
@property (nonatomic ,copy)NSString *lastDate;

@property(nonatomic,assign)BOOL isrefreshTimer;
/**
 *  上次进来的天数
 */
@property(nonatomic,assign)NSInteger lastDay;

@property(nonatomic,copy)NSMutableArray *signArray;
//重新定位
@property (strong, nonatomic) IBOutlet UIButton *againLocation;

//第一次进来这个界面
@property (nonatomic ,assign)BOOL isFirstTimeComeIn;

@end

@implementation SMSignInViewController

#pragma mark -- 懒加载
//- (UIButton *)bottomSureBtn{
//    if (_bottomSureBtn == nil) {
//        _bottomSureBtn = [[UIButton alloc] init];
//        
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确  定" attributes:dict];
//        [_bottomSureBtn setAttributedTitle:str forState:UIControlStateNormal];
//        _bottomSureBtn.backgroundColor = KRedColor;
//        
//        [_bottomSureBtn addTarget:self action:@selector(bottomSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _bottomSureBtn;
//}

-(NSMutableArray *)signArray
{
    if (!_signArray) {
        _signArray = [NSMutableArray array];
    }
    return _signArray;
}

#pragma mark --viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = KControllerBackGroundColor;
    
    
    [self setupNav];
    self.detailAddressLabel.numberOfLines = 0;
    
    [self getDateAndTime];
    
    [self addTimer];
    
    //一次性定位
    [self oneTimeLocation];
    //搜附近
//    [self searchNearby];
    
//    [self judgeDate];
    
    self.lastDate = self.dateLabel.text;
    
//    self.isrefreshTimer = NO;
//    self.lastDay = 0;
//    self.isrefreshTimer = [[NSUserDefaults standardUserDefaults] boolForKey:@"RefreshTimer"];
//    self.lastDay = [[NSUserDefaults standardUserDefaults] integerForKey:@"Day"];
//    
//    if (self.isrefreshTimer) {
//        self.promptSignInLabel.text = @"已签到";
//        self.signInBtn.enabled = NO;
//    }
    
    //给定重新定位按钮的颜色
    [self.againLocation setTitleColor:KRedColorLight forState:UIControlStateNormal];
}

//一次性定位
- (void)oneTimeLocation{
    
    [MBProgressHUD showMessage:@"正在更新位置"];
    [AMapServices sharedServices].apiKey =@"3b86bf20b3bd229fb83d087903f02d59";
//    [AMapLocationServices sharedServices].apiKey =@"3b86bf20b3bd229fb83d087903f02d59";
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//最精确 精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            [MBProgressHUD hideHUD];
            SMLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败，请重新定位." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [MBProgressHUD hideHUD];
            if (self.isFirstTimeComeIn) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            self.isFirstTimeComeIn = YES;
        }
        
        SMLog(@"location:%@", location);
        
        if (regeocode){
            SMLog(@"reGeocode:%@", regeocode.formattedAddress);
            self.detailAddressLabel.text = regeocode.formattedAddress;
            self.addressLabel.text = regeocode.formattedAddress;
            SMLog(@"regeocode.city   %@",regeocode.city);
           
        }
    }];
}
//重新定位按钮
- (IBAction)againLocationAction:(UIButton *)sender {
    SMLog(@"重新定位");
    [self oneTimeLocation];
}

/**
 *  添加定时器
 */
- (void)addTimer{
    //只要在当前这个页面里。每过30秒，就更新一下当前日期和时间。当页面被销毁时，这个方法菜停止调用
    self.timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(getDateAndTime) userInfo:nil repeats:YES];
    // 只要将定时器对象添加到运行循环，就会自动开启定时器
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    self.iconView.image = image;
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    self.nameLabel.text = name;
    
    [self requestSign];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;

}

#pragma mark -- 获得当前星期几，日期，时间
- (void)getDateAndTime{
    [self getWeekday];
    
    [self getDate];
    
    [self getTime];

}

- (void)getTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
//    [dateformatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    self.currentTime.text = [NSString stringWithFormat:@"当前时间：%@",locationString];
    SMLog(@"locationString     %@",locationString);
}

- (void)getDate{
    //获得系统日期
    NSDate *  senddate=[NSDate date];
    SMLog(@"senddate   %@",senddate);
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
//    NSString *  nsDateString= [NSString  stringWithFormat:@"%4ld年%2ld月%2ld日",(long)year,(long)month,(long)day];
    self.dateStr = [NSString stringWithFormat:@"%4ld-%2ld-%2ld",(long)year,(long)month,(long)day];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@:%@",self.weekdayStr,self.dateStr];
   
    //add chang  判断是否要刷新签到
//    _lastDay =[[NSUserDefaults standardUserDefaults] integerForKey:@"Day"];
//    _isrefreshTimer = [[NSUserDefaults standardUserDefaults] boolForKey:@"RefreshTimer"];
//    if (self.lastDay != day) {
//        self.isrefreshTimer = NO;
//        [[NSUserDefaults standardUserDefaults] setInteger:day forKey:@"Day"];
//        [[NSUserDefaults standardUserDefaults] setBool:self.isrefreshTimer forKey:@"RefreshTimer"];
//        self.promptSignInLabel.text = @"点击图标签到";
//        self.signInBtn.enabled = YES;
//    }
//    SMLog(@"lastDay%zd",self.lastDay);
//    SMLog(@"isrefresh=%zd",self.isrefreshTimer);

}

- (void)getWeekday{
    NSDate *now = [NSDate date];
    
    self.weekdayStr = [NSString weekdayStringFromDate:now];
}

- (void)setupNav{
    self.title = @"签到";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColorLight;
    dict[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *attrbuteStr = [[NSAttributedString alloc] initWithString:@"签到统计" attributes:dict];
    [rightBtn setAttributedTitle:attrbuteStr forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- 点击事件

- (void)rightItemClick{
    SMLog(@"点击了 签到统计 按钮");
    SMSignInCountViewController *signInCountVc = [[SMSignInCountViewController alloc] init];
    signInCountVc.signHistoryArray = [self.signArray mutableCopy];
    [self.navigationController pushViewController:signInCountVc animated:YES];
}

- (IBAction)signInBtn:(UIButton *)sender {
    SMLog(@"点击了 签到 按钮");
    
    //开始定位，NO为关闭定位
   // _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = 1;
//    add chang  打卡签到
    [[SKAPI shared] pounchIn:self.detailAddressLabel.text block:^(id result, NSError *error) {
        if (error) {
            SMLog(@"%@",error);
        }else{
            SMLog(@"%@",result);
            
            [self requestSign];
            
//            [self openMapView];
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"签到成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            //定位成功，将按钮变为不可点击
            //isrefreshTimer控制日期改变后刷新签到
//            if (self.isrefreshTimer) {
//                //将按钮变为不可点击
//                self.signInBtn.enabled = NO;
//                
//            }else
//            {   //签到成功 ，写入本地 已签到
//                if ([result[@"message"] isEqualToString:@"success"]){
//                    self.isrefreshTimer = YES;
//                    [[NSUserDefaults standardUserDefaults] setBool:self.isrefreshTimer forKey:@"RefreshTimer"];
//                   //定位成功再签到
//                }
//                
//            }
        }
    }];
}

/*
- (void)openMapView{
    //显示地图
    [AMapServices sharedServices].apiKey =@"79bddc0d65eafd8eea8bbd41dd0cf67c";
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    [self.view addSubview:self.mapView];
    
}*/

-(void)requestSign
{
    [self.signArray removeAllObjects];
    [[SKAPI shared] queryPounchinByPage:0 andSize:300 block:^(NSArray *array, NSError *error) {
        if (!error) {
            //SMLog(@"%@",array);
            for (WorkLog * log in array) {
                //获取到年月份  只显示本月相关签到
                NSDateFormatter  *fmr=[[NSDateFormatter alloc] init];
                [fmr setDateFormat:@"yyyy-MM"];
                NSString *  signstring =[fmr stringFromDate:[NSDate dateWithTimeIntervalSince1970:[log.createAt floatValue]]];
                //获取到现在的年份和月份
                NSDate * date = [NSDate date];
                NSString * nowstring = [fmr stringFromDate:date];
                if ([signstring isEqualToString:nowstring]) {
                    [self.signArray addObject:log];
                }
            }
            //签到天数
            self.signInTimesLabel.text = [NSString stringWithFormat:@"本月已签到%zd次",self.signArray.count];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

@end
