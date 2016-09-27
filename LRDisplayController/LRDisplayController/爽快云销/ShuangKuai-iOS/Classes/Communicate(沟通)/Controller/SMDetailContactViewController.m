//
//  SMDetailContactViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/16.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailContactViewController.h"
#import "SMChatViewController.h"
#import "AppDelegate.h"

@interface SMDetailContactViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
/**
 *  手机
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneCallBtn;
/**
 *  固定电话
 */
@property (weak, nonatomic) IBOutlet UILabel *fixPhoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *fixPhoneBtn;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UIButton *startTalkingBtn;


@end

@implementation SMDetailContactViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    
    
}

- (void)setup{
    self.title = @"联系人详情";
    self.addressLabel.numberOfLines = 0;
    self.startTalkingBtn.backgroundColor = SMColor(168, 8, 30);
    self.view.backgroundColor = KControllerBackGroundColor;
    self.topView.backgroundColor = KControllerBackGroundColor;
    self.startTalkingBtn.layer.cornerRadius = SMCornerRadios;
    self.startTalkingBtn.clipsToBounds = YES;
    
//    self.icon.layer.cornerRadius = SMCornerRadios;
//    self.icon.clipsToBounds = YES;
    CGFloat width = 100;
    NSString *strEnd = [NSString stringWithFormat:@"?w=%.0f&h=%.0f",width,width];
    NSString *iconStr = [self.user.portrait stringByAppendingString:strEnd];
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    
    [self.icon setShowActivityIndicatorView:YES];
    [self.icon setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nameLabel.text = self.user.name;
    self.phoneNumLabel.text = self.user.phone;
    self.addressLabel.text = self.user.address;
    self.fixPhoneLabel.text = self.user.telephone;
}

- (IBAction)phoneBtnCLick {
    SMLog(@"点击了 拨打手机电话 按钮");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneNumLabel.text];
    //            SMLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (IBAction)fixPhoneBtnClick {
    SMLog(@"点击了 拨打固定电话 按钮");
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.fixPhoneLabel.text];
    //            SMLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)addressBtnClick {
    SMLog(@"点击了 地图定位 按钮");
}

- (IBAction)startTalkingBtnClick {
    SMLog(@"点击了 发起会话 按钮");
    SMChatViewController *chaVc = [[SMChatViewController alloc] init];
    [self.navigationController pushViewController:chaVc animated:YES];
    
}

@end
