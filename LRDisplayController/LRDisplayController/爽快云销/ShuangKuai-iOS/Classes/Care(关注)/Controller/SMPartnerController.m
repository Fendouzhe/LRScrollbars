//
//  SMPartnerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPartnerController.h"
#import "SMPartnerCell.h"
#import "SMPartnerSectionHeader.h"
#import "SMPartnerDetailController.h"
#import "SMShareMenu.h"
#import <UIButton+WebCache.h>
#import "SMChatViewController.h"

#define KInvitePartner [NSString stringWithFormat:@"%@sk_invite.html",SKAPI_PREFIX_SHARE]
@interface SMPartnerController ()<UITableViewDelegate,UITableViewDataSource,SMPartnerCellDelegate,SMShareMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;

@property(nonatomic,copy)NSMutableArray * dataArray;

@property (nonatomic ,strong)SMShareMenu *menu;

@property (nonatomic ,strong)UIView *cheatView2;

@end

@implementation SMPartnerController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"合伙人";
    self.view.backgroundColor = KControllerBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self match];
    
    [self requestData];
}

- (void)match{
    if (isIPhone5) {
        self.topViewHeight.constant = 70;
        self.iconW.constant = 40;
        self.iconH.constant = self.iconW.constant;
    }else if (isIPhone6){
        self.topViewHeight.constant = 70 *KMatch6Height;
        self.iconW.constant = 40 *KMatch6;
        self.iconH.constant = self.iconW.constant;
    }else if (isIPhone6p){
        self.topViewHeight.constant = 70 *KMatch6pHeight;
        self.iconW.constant = 40 *KMatch6p;
        self.iconH.constant = self.iconW.constant;
    }
    self.iconBtn.layer.cornerRadius = self.iconW.constant / 2.0;
    self.iconBtn.clipsToBounds = YES;
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMPartnerCell *cell = [SMPartnerCell cellWithTanleView:tableView];
    cell.delegate = self;
    cell.user = self.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SMPartnerSectionHeader *view = [SMPartnerSectionHeader partnerSectionHeader];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMPartnerDetailController *vc = [[SMPartnerDetailController alloc] init];
    vc.user = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (isIPhone5) {
        height = 75;
    }else if (isIPhone6){
        height = 75 *KMatch6Height;
    }else if (isIPhone6p){
        height = 75 *KMatch6pHeight;
    }
    return height;
}

#pragma mark -- 点击事件
- (IBAction)invitePartner1 {
    [self invitePartner];
}

- (IBAction)invitePartner2 {
    [self invitePartner];
}

- (IBAction)invitePartner3 {
    [self invitePartner];
}

- (void)invitePartner{
    SMLog(@"点击了  邀请合伙人");
    [self addShareMemu];
}

- (void)addShareMemu{
    if (self.cheatView2) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    UIView *cheatView2 = [[UIView alloc] init];
    self.cheatView2 = cheatView2;
    cheatView2.backgroundColor = [UIColor blackColor];
    [window addSubview:cheatView2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCheatView2)];
    [cheatView2 addGestureRecognizer:tap];
    cheatView2.frame = window.bounds;
    
    SMShareMenu *menu = [SMShareMenu shareMenu];
    menu.delegate = self;
    [window addSubview:menu];
    self.menu = menu;
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
        make.width.equalTo(@300);
        make.height.equalTo(@270);
    }];
    
    // 动画
    cheatView2.alpha = 0;
    menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    [UIView animateWithDuration:0.35 animations:^{
        menu.transform = CGAffineTransformMakeScale(1, 1);
        cheatView2.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeCheatView2{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.menu.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        self.cheatView2.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView2 removeFromSuperview];
        self.cheatView2 = nil;
        [self.menu removeFromSuperview];
        self.menu = nil;
    }];
}

#pragma mark -- SMShareMenuDelegate  分享
- (void)shareBtnDidClick:(SSDKPlatformType)type{
    SMLog(@"type    %zd",type);
    
    NSDate *localeDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    SMLog(@"timeSp :%@",timeSp); //时间戳的值
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    UIImage* image = [UIImage imageWithData:imageData];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    NSString *eid = [[NSUserDefaults standardUserDefaults] objectForKey:KUserCompanyId];
    
    NSString *para = [NSString stringWithFormat:@"?uid=%@&eid=%@&t=%@",uid,eid,timeSp];
    NSString *path = KInvitePartner;
    NSURL *url = [NSURL URLWithString:[path stringByAppendingString:para]];
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"加入我的团队，正品保障，无需囤货，一对一指导，轻松赚取丰厚佣金"
                                     images:image
                                        url:url
                                      title:@"加入我的团队，带你赚钱带你飞"
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
    
}

- (void)cancelBtnDidClick{
    [self removeCheatView2];
}



#pragma mark -- SMPartnerCellDelegate
- (void)chatBtnDidClick:(User *)user{
    SMLog(@"点击了  进入聊天按钮");
        SMChatViewController * chat = [SMChatViewController new];
        chat.user = user;
        chat.targetRtcKey = user.rtcKey;
        [self.navigationController pushViewController:chat animated:YES];
}

-(void)requestData{
    [[SKAPI shared] queryMyTeamList:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            for (User * user in array) {
                [self.dataArray addObject:user];
            }
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

@end
