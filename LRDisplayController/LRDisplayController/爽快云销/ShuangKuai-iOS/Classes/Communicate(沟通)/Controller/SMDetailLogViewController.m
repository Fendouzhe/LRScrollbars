//
//  SMDetailLogViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailLogViewController.h"
#import "AppDelegate.h"

@interface SMDetailLogViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageConstraint;
@end

@implementation SMDetailLogViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KControllerBackGroundColor;
    self.title = @"日志详情";
    
    [self refreshUIWithLocalworklog:self.localworklog andWithLocalCustomer:self.localCustomer];
}


-(void)refreshUIWithLocalworklog:(LocalWorkLog*)localworklog andWithLocalCustomer:(LocalCustomer*)localCustomer
{
    //NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    
    //self.iconImage.image = [UIImage imageWithData:data];
    //把头像去掉
    self.iconImageConstraint.constant = 0;
    
    self.iconImage.image = nil;
    
    self.nameLabel.text = localCustomer.fullname;
    self.contentLabel.text = localworklog.content;
    self.timeLabel.text = localworklog.createAt;
    
}

@end
