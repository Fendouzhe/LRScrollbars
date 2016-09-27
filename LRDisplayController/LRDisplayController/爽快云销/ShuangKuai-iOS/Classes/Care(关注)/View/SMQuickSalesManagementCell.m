//
//  SMQuickSalesManagementCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMQuickSalesManagementCell.h"

@interface SMQuickSalesManagementCell ()

@property (nonatomic ,strong)UILabel *quickSalestitle;
//我的柜台
@property (nonatomic ,strong)UIButton *myCounter;
//合伙人
@property (nonatomic ,strong)UIButton *partnerBtn;
//我的收入
@property (nonatomic ,strong)UIButton *myIncomeBtn;

//我的柜台
@property (nonatomic ,strong)UILabel *myCounterLabel;
//合伙人
@property (nonatomic ,strong)UILabel *partnerLabel;
//我的收入
@property (nonatomic ,strong)UILabel *myIncomeLabel;
//我的订单
@property (nonatomic ,strong)UILabel *myOrderLabel;

//伙伴连线
@property (nonatomic ,strong)UIButton *connectBtn;
//任务日程
@property (nonatomic ,strong)UIButton *taskBtn;
//客户管理
@property (nonatomic ,strong)UIButton *customerBtn;
//外勤签到
@property (nonatomic ,strong)UIButton *signInBtn;
//优惠券兑换
@property (nonatomic ,strong)UIButton *discountBtn;
//优惠券兑换
@property (nonatomic ,strong)UILabel *discountLabel;
//伙伴连线
@property (nonatomic ,strong)UILabel *connectLabel;

@property (nonatomic ,strong)UILabel *tsakLabel;

@property (nonatomic ,strong)UILabel *signInLabel;

@property (nonatomic ,strong)UILabel *customerLabel;

@end

@implementation SMQuickSalesManagementCell

+ (instancetype)cellWithTableview:(UITableView *)tableView{
    
    static NSString *ID = @"quickSalesManagementCell";
    SMQuickSalesManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMQuickSalesManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //是否为二级
//        NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
//        self.isLevel2 = level2;
         //快销管理标题
        UILabel *quickSalestitle = [[UILabel alloc] init];
        self.quickSalestitle = quickSalestitle;
        [self.contentView addSubview:quickSalestitle];
        quickSalestitle.text = @"快销管理";
        quickSalestitle.font = KDefaultFontBig;
        
//        //为1级
//        if (!level2) {
//            [self setupOneUI];
//        }else{
//            [self setupTwoUI];
//        }
        [self setupOneUI];
        
    }
    return self;
}

#pragma mark -- 点击事件

- (void)discountBtnClick{
    if ([self.delegate respondsToSelector:@selector(discountBtnDidClick)]) {
        [self.delegate discountBtnDidClick];
    }
}

- (void)signInBtnClick{
    if ([self.delegate respondsToSelector:@selector(signInBtnDidClick)]) {
        [self.delegate signInBtnDidClick];
    }
}

- (void)customerBtnClick{
    if ([self.delegate respondsToSelector:@selector(customerBtnDidClick)]) {
        [self.delegate customerBtnDidClick];
    }
}

- (void)taskBtnClick{
    if ([self.delegate respondsToSelector:@selector(taskBtnDidClick)]) {
        [self.delegate taskBtnDidClick];
    }
}

- (void)connectBtnClick{
    if ([self.delegate respondsToSelector:@selector(connectBtnDidClick)]) {
        [self.delegate connectBtnDidClick];
    }
}

- (void)myOrderBtnBtnClick{
    if ([self.delegate respondsToSelector:@selector(myOrderBtnBtnDidClick)]) {
        [self.delegate myOrderBtnBtnDidClick];
    }
}

- (void)myIncomeBtnClick{
    if ([self.delegate respondsToSelector:@selector(myIncomeBtnDidClick)]) {
        [self.delegate myIncomeBtnDidClick];
    }
}

- (void)myCounterClick{
    if ([self.delegate respondsToSelector:@selector(myCounterDidClick)]) {
        [self.delegate myCounterDidClick];
    }
}

- (void)partnerBtnClick{
    if ([self.delegate respondsToSelector:@selector(partnerBtnDidClick)]) {
        [self.delegate partnerBtnDidClick];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //是否为二级
//    NSInteger level2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"KUserLevel2"];
    //快销管理
    NSNumber *height = [NSNumber numberWithFloat:20 *SMMatchHeight];
    [self.quickSalestitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.height.equalTo(height);
    }];
    
    //为1级
//    if (!level2) {
//        [self layoutOne];
//    }else{
//        [self layoutTwo];   //二级的没有合伙人选项
//    }
    
    [self layoutOne];
}

-(void)setupOneUI{
    
    
    //创建 4个图标按钮
    //优惠券兑换
    UIButton *discountBtn = [[UIButton alloc] init];
    self.discountBtn = discountBtn;
    [self.contentView addSubview:discountBtn];
    [self.discountBtn setBackgroundImage:[UIImage imageNamed:@"youhuiquanduihuan"] forState:UIControlStateNormal];
    [self.discountBtn addTarget:self action:@selector(discountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //合伙人  如果不是二级  才有合伙人的选项
//    if (!self.isLevel2) {
        UIButton *partnerBtn = [[UIButton alloc] init];
        self.partnerBtn = partnerBtn;
        [self.contentView addSubview:partnerBtn];
        [self.partnerBtn setBackgroundImage:[UIImage imageNamed:@"合伙人"] forState:UIControlStateNormal];
        [self.partnerBtn addTarget:self action:@selector(partnerBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    //我的收入
    UIButton *myIncomeBtn = [[UIButton alloc] init];
    self.myIncomeBtn = myIncomeBtn;
    [self.contentView addSubview:myIncomeBtn];
    [self.myIncomeBtn setBackgroundImage:[UIImage imageNamed:@"00000000"] forState:UIControlStateNormal];
    [self.myIncomeBtn addTarget:self action:@selector(myIncomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //我的订单
    UIButton *myOrderBtn = [[UIButton alloc] init];
    self.myOrderBtn = myOrderBtn;
    [self.contentView addSubview:myOrderBtn];
    [self.myOrderBtn setBackgroundImage:[UIImage imageNamed:@"订单管理"] forState:UIControlStateNormal];
    [self.myOrderBtn addTarget:self action:@selector(myOrderBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //伙伴连线
    UIButton *connectBtn = [[UIButton alloc] init];
    self.connectBtn = connectBtn;
    [self.contentView addSubview:connectBtn];
    [self.connectBtn setBackgroundImage:[UIImage imageNamed:@"huobanlianxian"] forState:UIControlStateNormal];
    [self.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //任务日程
    UIButton *taskBtn = [[UIButton alloc] init];
    self.taskBtn = taskBtn;
    [self.contentView addSubview:taskBtn];
    [self.taskBtn setBackgroundImage:[UIImage imageNamed:@"任务日程-1"] forState:UIControlStateNormal];
    [self.taskBtn addTarget:self action:@selector(taskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //客户管理
    UIButton *customerBtn = [[UIButton alloc] init];
    self.customerBtn = customerBtn;
    [self.contentView addSubview:customerBtn];
    [self.customerBtn setBackgroundImage:[UIImage imageNamed:@"kehuguanli"] forState:UIControlStateNormal];
    [self.customerBtn addTarget:self action:@selector(customerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //外勤签到
    UIButton *signInBtn = [[UIButton alloc] init];
    self.signInBtn = signInBtn;
    [self.contentView addSubview:signInBtn];
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"qiandao"] forState:UIControlStateNormal];
    [self.signInBtn addTarget:self action:@selector(signInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //创建  4个按钮相对应的名字label
    //优惠券兑换
    UILabel *discountLabel = [[UILabel alloc] init];
    self.discountLabel = discountLabel;
    [self.contentView addSubview:discountLabel];
    discountLabel.text = @"优惠券兑换";
    discountLabel.font = KDefaultFontBig;
    discountLabel.textAlignment = NSTextAlignmentCenter;
    
    //合伙人
//    if (!self.isLevel2) {
        UILabel *partnerLabel = [[UILabel alloc] init];
        self.partnerLabel = partnerLabel;
        [self.contentView addSubview:partnerLabel];
        partnerLabel.text = @"合伙人";
        partnerLabel.font = KDefaultFontBig;
        partnerLabel.textAlignment = NSTextAlignmentCenter;
//    }
    
    //我的收入
    UILabel *myIncomeLabel = [[UILabel alloc] init];
    self.myIncomeLabel = myIncomeLabel;
    [self.contentView addSubview:myIncomeLabel];
    myIncomeLabel.text = @"我的收入";
    myIncomeLabel.font = KDefaultFontBig;
    myIncomeLabel.textAlignment = NSTextAlignmentCenter;
    
    //我的订单
    UILabel *myOrderLabel = [[UILabel alloc] init];
    self.myOrderLabel = myOrderLabel;
    [self.contentView addSubview:myOrderLabel];
    myOrderLabel.text = @"我的订单";
    myOrderLabel.font = KDefaultFontBig;
    myOrderLabel.textAlignment = NSTextAlignmentCenter;
    
    //伙伴连线
    UILabel *connectLabel = [[UILabel alloc] init];
    self.connectLabel = connectLabel;
    [self.contentView addSubview:connectLabel];
    connectLabel.text = @"伙伴连线";
    connectLabel.font = KDefaultFontBig;
    connectLabel.textAlignment = NSTextAlignmentCenter;
    
    //任务日程
    UILabel *tsakLabel = [[UILabel alloc] init];
    self.tsakLabel = tsakLabel;
    [self.contentView addSubview:tsakLabel];
    tsakLabel.text = @"任务日程";
    tsakLabel.font = KDefaultFontBig;
    tsakLabel.textAlignment = NSTextAlignmentCenter;
    
    //外勤签到
    UILabel *signInLabel = [[UILabel alloc] init];
    self.signInLabel = signInLabel;
    [self.contentView addSubview:signInLabel];
    signInLabel.text = @"外勤签到";
    signInLabel.font = KDefaultFontBig;
    signInLabel.textAlignment = NSTextAlignmentCenter;
    
    //客户管理
    UILabel *customerLabel = [[UILabel alloc] init];
    self.customerLabel = customerLabel;
    [self.contentView addSubview:customerLabel];
    customerLabel.text = @"客户管理";
    customerLabel.font = KDefaultFontBig;
    customerLabel.textAlignment = NSTextAlignmentCenter;
}

//-(void)setupTwoUI{
//    //创建 4个图标按钮
//    //我的柜台
//    UIButton *myCounter = [[UIButton alloc] init];
//    self.myCounter = myCounter;
//    [self.contentView addSubview:myCounter];
//    [self.myCounter setBackgroundImage:[UIImage imageNamed:@"柜台管理"] forState:UIControlStateNormal];
//    [self.myCounter addTarget:self action:@selector(myCounterClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //我的收入
//    UIButton *myIncomeBtn = [[UIButton alloc] init];
//    self.myIncomeBtn = myIncomeBtn;
//    [self.contentView addSubview:myIncomeBtn];
//    [self.myIncomeBtn setBackgroundImage:[UIImage imageNamed:@"00000000"] forState:UIControlStateNormal];
//    [self.myIncomeBtn addTarget:self action:@selector(myIncomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //我的订单
//    UIButton *myOrderBtn = [[UIButton alloc] init];
//    self.myOrderBtn = myOrderBtn;
//    [self.contentView addSubview:myOrderBtn];
//    [self.myOrderBtn setBackgroundImage:[UIImage imageNamed:@"订单管理"] forState:UIControlStateNormal];
//    [self.myOrderBtn addTarget:self action:@selector(myOrderBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //创建  4个按钮相对应的名字label
//    //我的柜台
//    UILabel *myCounterLabel = [[UILabel alloc] init];
//    self.myCounterLabel = myCounterLabel;
//    [self.contentView addSubview:myCounterLabel];
//    myCounterLabel.text = @"我的柜台";
//    myCounterLabel.font = KDefaultFont;
//    myCounterLabel.textAlignment = NSTextAlignmentCenter;
//    
//    //我的收入
//    UILabel *myIncomeLabel = [[UILabel alloc] init];
//    self.myIncomeLabel = myIncomeLabel;
//    [self.contentView addSubview:myIncomeLabel];
//    myIncomeLabel.text = @"我的收入";
//    myIncomeLabel.font = KDefaultFont;
//    myIncomeLabel.textAlignment = NSTextAlignmentCenter;
//    
//    //我的订单
//    UILabel *myOrderLabel = [[UILabel alloc] init];
//    self.myOrderLabel = myOrderLabel;
//    [self.contentView addSubview:myOrderLabel];
//    myOrderLabel.text = @"我的订单";
//    myOrderLabel.font = KDefaultFont;
//    myOrderLabel.textAlignment = NSTextAlignmentCenter;
//}

-(void)layoutOne{
    //连续四个按钮
    CGFloat margin = 30 *SMMatchWidth; //左右间距
//    if (isIPhone5) {
//        margin = 25;
//    }else if (isIPhone6){
//        margin = 25 *KMatch6;
//    }else if (isIPhone6p){
//        margin = 25 *KMatch6p;
//    }
    
    CGFloat marginUpDown = 15 *SMMatchHeight; //上下间距
    CGFloat wh = (KScreenWidth - margin * 5) / 4.0;
    NSNumber *whNum = [NSNumber numberWithFloat:wh];
    NSNumber *labelHeight = [NSNumber numberWithFloat:(15.0 *SMMatchHeight)];
    //伙伴连线
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.contentView.mas_left).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //任务日程
    [self.taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.connectBtn.mas_right).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //客户管理
    [self.customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.taskBtn.mas_right).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //我的订单
    [self.myOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.customerBtn.mas_right).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
//连续4个按钮相对应的名字  label
    //伙伴连线
    [self.connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.connectBtn.mas_centerX);
        make.top.equalTo(self.connectBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //任务日程
    [self.tsakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.taskBtn.mas_centerX);
        make.top.equalTo(self.taskBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //客户管理
    [self.customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customerBtn.mas_centerX);
        make.top.equalTo(self.customerBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //我的订单
    [self.myOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.myOrderBtn.mas_centerX);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
//第二行
    //我的收入
    [self.myIncomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.connectLabel.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.contentView.mas_left).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //外勤签到
    [self.signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tsakLabel.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.myIncomeBtn.mas_right).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //优惠券兑换
    [self.discountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tsakLabel.mas_bottom).with.offset(marginUpDown);
        make.left.equalTo(self.signInBtn.mas_right).with.offset(margin);
        make.width.equalTo(whNum);
        make.height.equalTo(whNum);
    }];
    
    //合伙人
//    if (!self.isLevel2) {
        [self.partnerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.myOrderLabel.mas_bottom).with.offset(marginUpDown);
            make.left.equalTo(self.discountBtn.mas_right).with.offset(margin);
            make.width.equalTo(whNum);
            make.height.equalTo(whNum);
        }];
//    }
    
    
//第二行下面的文字label
    //我的收入
    [self.myIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.myIncomeBtn.mas_centerX);
        make.top.equalTo(self.myIncomeBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //外勤签到
    [self.signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.signInBtn.mas_centerX);
        make.top.equalTo(self.signInBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //优惠券兑换
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.discountBtn.mas_centerX);
        make.top.equalTo(self.discountBtn.mas_bottom).with.offset(marginUpDown);
        make.height.equalTo(labelHeight);
    }];
    
    //合伙人

        [self.partnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.partnerBtn.mas_centerX);
            make.top.equalTo(self.partnerBtn.mas_bottom).with.offset(marginUpDown);
            make.height.equalTo(labelHeight);
        }];

    
    
    
    
    self.cellHeight = CGRectGetMaxY(self.signInLabel.frame) + marginUpDown;
}

//-(void)layoutTwo{
//    //连续三个按钮
//    CGFloat margin; //左右间距
//    if (isIPhone5) {
//        margin = 15;
//    }else if (isIPhone6){
//        margin = 15 *KMatch6;
//    }else if (isIPhone6p){
//        margin = 15 *KMatch6p;
//    }
//    CGFloat marginUpDown = 15; //上下间距
//    CGFloat wh = (KScreenWidth - margin * 4) / 4.0;
//    CGFloat NewMargin = (KScreenWidth-3*wh)/4;
//    NSNumber *whNum = [NSNumber numberWithFloat:wh];
//    
//    //我的收入
//    [self.myIncomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
////        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
////        make.left.equalTo(self.myCounter.mas_right).with.offset(margin);
//        make.centerX.equalTo(self.contentView.mas_centerX).with.offset(0);
//        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
//        make.width.equalTo(whNum);
//        make.height.equalTo(whNum);
//    }];
//    
//    //我的柜台
//    [self.myCounter mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
//        make.centerY.equalTo(self.myIncomeBtn.mas_centerY).with.offset(0);
//        make.right.equalTo(self.myIncomeBtn.mas_left).with.offset(-NewMargin);
//        make.width.equalTo(whNum);
//        make.height.equalTo(whNum);
//    }];
//    //我的订单
//    [self.myOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
////        make.top.equalTo(self.quickSalestitle.mas_bottom).with.offset(marginUpDown);
//        make.centerY.equalTo(self.myIncomeBtn.mas_centerY).with.offset(0);
//        make.left.equalTo(self.myIncomeBtn.mas_right).with.offset(NewMargin);
//        make.width.equalTo(whNum);
//        make.height.equalTo(whNum);
//    }];
//    
//    //连续4个按钮相对应的名字  label
//    //我的柜台
//    [self.myCounterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.myCounter.mas_centerX);
//        make.top.equalTo(self.myCounter.mas_bottom).with.offset(marginUpDown);
//    }];
//    
//    //我的收入
//    [self.myIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.myIncomeBtn.mas_centerX);
//        make.top.equalTo(self.myIncomeBtn.mas_bottom).with.offset(marginUpDown);
//    }];
//    
//    //我的订单
//    [self.myOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.myOrderBtn.mas_centerX);
//        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(marginUpDown);
//    }];
//    
//    self.cellHeight = CGRectGetMaxY(self.myOrderLabel.frame) + marginUpDown;
//}
@end
