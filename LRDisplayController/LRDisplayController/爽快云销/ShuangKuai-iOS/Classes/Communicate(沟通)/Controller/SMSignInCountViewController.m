//
//  SMSignInCountViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/20.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSignInCountViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "WorkLog.h"
#import "AppDelegate.h"

@interface SMSignInCountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *signInCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SMSignInCountViewController

#pragma mark -生命周期

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到统计";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = KControllerBackGroundColor;
    
    [self refreshIconandName];
//    [self createRightItem];
    
}
//-(void)createRightItem
//{
//    UIButton * btn = [[UIButton alloc]init];
//    btn.width = 22;
//    btn.height = 22;
//    [btn setBackgroundImage:[UIImage imageNamed:@"zhuangfa"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(shareItem) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}
-(void)shareItem
{
    SMLog(@"点击分享");
}
-(void)refreshIconandName
{
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    self.iconView.image = image;
    //名字
    NSString * Name = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    self.nameLabel.text = Name;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.signHistoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"signInCountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //cell.textLabel.text = @"星期三：2015－11-12   09:00";
    WorkLog* worklog = self.signHistoryArray[indexPath.row];
    //
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd hh:mm"];
    NSString *  locationString=[dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[worklog.createAt floatValue]]];
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@ :%@",locationString,worklog.address];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    //签到天数
    self.signInCountLabel.text = [NSString stringWithFormat:@"本月已签到%zd天",[self.signHistoryArray count]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(void)setSignHistoryArray:(NSMutableArray *)signHistoryArray
{
    _signHistoryArray = [signHistoryArray mutableCopy];
    
    [self.tableView reloadData];
}
@end
