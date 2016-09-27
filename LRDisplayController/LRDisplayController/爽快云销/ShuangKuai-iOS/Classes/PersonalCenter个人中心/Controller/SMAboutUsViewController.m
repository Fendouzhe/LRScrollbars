//
//  SMAboutUsViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/31.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMAboutUsViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"
@interface SMAboutUsViewController ()

@end

@implementation SMAboutUsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"关于我们";
    //介绍文字
    UILabel *aboutUs = [[UILabel alloc] init];
    [self.view addSubview:aboutUs];                    
    aboutUs.font = KDefaultFontBig;
    aboutUs.numberOfLines = 0;
    aboutUs.text = @"     “爽快”个性化O2O快销倍增平台旨在为各大企业提供先进的互联网推广、电商营销、O2O营销、数据库精准营销的整合营销解决方案，并提供互联网及线下分销渠道提供应用系统开发、线上推广、线下拓展、服务运营、支付结算、电子销售工具、数据库服务，打造整合社会自由职业人开展互联网及O2O方式的产品销售、快速分销、体验营销、销售培训的创业平台。";
    //设置字号和行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;//行间距
    
    NSDictionary *ats = @{
                          NSFontAttributeName : KDefaultFontBig,
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    aboutUs.attributedText = [[NSAttributedString alloc] initWithString:aboutUs.text attributes:ats];//设置行间距
    
    [aboutUs mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(30);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];

//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"fanhui" highImage:@"fanhui"];
    
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    //英文label
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"%@(%@)",infoDict[@"CFBundleShortVersionString"],infoDict[@"CFBundleVersion"]];//@"1.6.4(28)";
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    //英文label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Copyright©2016";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(versionLabel.mas_top).with.offset(-10);
    }];
    
    //公司名字
    UILabel *companyName = [[UILabel alloc] init];
    companyName.textColor = [UIColor grayColor];
    companyName.font = KDefaultFontBig;
    companyName.text = @"广州宇中网络科技有限公司";
    companyName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyName];
    
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(label.mas_top).with.offset(-10);
        make.height.equalTo(@16);
    }];
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
