//
//  SMMyCodeViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/1.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyCodeViewController.h"
#import "AppDelegate.h"
@interface SMMyCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@end

@implementation SMMyCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    self.iconView.image = image;
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    self.nameLabel.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
