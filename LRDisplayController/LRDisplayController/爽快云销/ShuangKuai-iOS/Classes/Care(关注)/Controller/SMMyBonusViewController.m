//
//  SMMyBonusViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMMyBonusViewController.h"
#import "SMBonusTableViewCell.h"
#import "BMDatePickerView.h"
#import <ShareSDK/ShareSDK.h>
#import "SMShareMenu.h"


#define KInvitePartner [NSString stringWithFormat:@"%@sk_invite.html",SKAPI_PREFIX_SHARE]
@interface SMMyBonusViewController ()<UITableViewDelegate,UITableViewDataSource,SMShareMenuDelegate>

@property(nonatomic,strong)UITableView * tableView;

//数据源
@property(nonatomic,copy)NSMutableArray * dataArray;

//总奖金数
@property(nonatomic,strong)UILabel * moneyLabel;
//年和月
@property(nonatomic,strong)UIButton * yearMonthBtn;
//刷新数据用的时间戳
@property(nonatomic,assign)NSInteger lastTimestamp;
//查询的年月
@property(nonatomic,copy)NSString * yearMonth;

@property (nonatomic ,strong)UIView *cheatView2;

@property (nonatomic ,strong)SMShareMenu *menu;

@end

@implementation SMMyBonusViewController

#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的奖金";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupUI];
    
    //获取到当前的年月
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString * yearAndMonth = [dateFormatter stringFromDate:date];
    
    
    self.yearMonth = yearAndMonth;
    self.lastTimestamp = 0;
    
    //[self creatMJRefresh];
    //请求出最近的奖金
    [self requestData];
}

-(void)setupUI{
    self.view.backgroundColor = KControllerBackGroundColor;
    CGFloat topHeight = 0.0;
    if (isIPhone5) {
        topHeight = 120;
    }else if (isIPhone6){
        topHeight = 120*KMatch6Height;
    }else if (isIPhone6p){
        topHeight = 120*KMatch6pHeight;
    }
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = KRedColorLight;
    [self.view addSubview:topView];
    
    topView.layer.cornerRadius = 4;
    //topView.layer.masksToBounds = YES;
    topView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    topView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    topView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    topView.layer.shadowRadius = 2;//阴影半径，默认3
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.top.equalTo(self.view.mas_top).with.offset(8);
        make.height.with.offset(topHeight);
    }];
    
    UILabel * title = [[UILabel alloc]init];
    title.backgroundColor = KControllerBackGroundColor;
    title.font = KDefaultFontBig;
    title.text = @"  本月奖金记录";
    title.textColor = SMColor(110, 110, 110);
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(8);
        make.top.equalTo(topView.mas_bottom).with.offset(8);
        make.height.with.offset(21);
    }];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SMBonusTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(title.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    UIButton * titleBtn = [[UIButton alloc]init];
    [titleBtn setTitle:@"当月奖金∨" forState:UIControlStateNormal];
    self.yearMonthBtn = titleBtn;
    titleBtn.titleLabel.font = KDefaultFont;
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:titleBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).with.offset(10);
        make.top.equalTo(topView.mas_top).with.offset(8);
    }];
    
    UIButton * morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [morebtn setTitle:@"赚更多奖金?" forState:UIControlStateNormal];
    morebtn.titleLabel.font = KDefaultFont;
    [morebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [morebtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:morebtn];
    
    [morebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).with.offset(-10);
        //make.top.equalTo(topView.mas_top).with.offset(10);
        make.centerY.equalTo(titleBtn.mas_centerY).with.offset(0);
        make.height.equalTo(@(30 *SMMatchHeight));
    }];
    
    UILabel * moneyLable = [[UILabel alloc]init];
    self.moneyLabel = moneyLable;
    moneyLable.text =@"￥100";
    moneyLable.font = [UIFont systemFontOfSize:30];
    moneyLable.textColor = [UIColor whiteColor];
    [topView addSubview:moneyLable];
    
    [moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX).with.offset(0);
        make.centerY.equalTo(topView.mas_centerY).with.offset(0);
    }];
    
}

#pragma mark - 点击事件
-(void)moreClick:(UIButton *)btn{
    SMLog(@"点击了 更多奖金的按钮");
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
    SMLog(@"邀请合伙人");
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

-(void)monthClick:(UIButton *)btn{
    SMLog(@"点击了 当月奖金按钮");
    //弹出选择器
    //[self.view addSubview:self.loadDatePicker];
    BMDatePickerView *datePickerView = [BMDatePickerView BMDatePickerViewCertainActionBlock:^(NSString *selectYearMonthString) {
        SMLog(@"选择的时间是: %@",selectYearMonthString);
        NSString *yearStr = [selectYearMonthString substringToIndex:4];
        NSString *monthStr = [selectYearMonthString substringFromIndex:4];
        SMLog(@"YearStr  %@  monthStr  %@",yearStr,monthStr);
        self.yearMonth = [NSString  stringWithFormat:@"%@-%@",yearStr,monthStr];
        [self requestData];
        //获取到时间  进行处理 显示数据
    }];
    [datePickerView show];
}

#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMBonusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.bonus = self.dataArray [indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64 *SMMatchHeight;
}

-(void)creatMJRefresh{
    MJRefreshNormalHeader *Producttableviewtheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.lastTimestamp = 0;
        [self requestData];
    }];
    self.tableView.mj_header = Producttableviewtheader;
    MJRefreshAutoNormalFooter *Productfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Bonus * bonus = [self.dataArray lastObject];
        self.lastTimestamp = bonus.createAt;
        [self requestData];
    }];
    self.tableView.mj_footer = Productfooter;
}

-(void)requestData{
    
    SMLog(@"%@",self.yearMonth);
    
    [[SKAPI shared] queryBonus:self.yearMonth andOffset:65535 andLastTimestamp:self.lastTimestamp block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dic in result[@"bonuses"]) {
                Bonus * bonus = [Bonus mj_objectWithKeyValues:dic];
                [self.dataArray addObject:bonus];
            }
            self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2lf",[result[@"monthBonus"] doubleValue]];
            [self.yearMonthBtn setTitle:[NSString stringWithFormat:@"%@∨",self.yearMonth] forState:UIControlStateNormal];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

@end
