//
//  SMDetailProductInfoController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductInfoController.h"
#import "SMPictureTextCell.h"
#import "SMPictureTextHeaderView.h"
#import "SMSpecificationView.h"
#import "SMProductCommentCell.h"
#import "AppDelegate.h"

@interface SMDetailProductInfoController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  顶部，图文信息的父类view
 */
@property (nonatomic ,strong)UIView *topView;
/**
 *  图文信息
 */
@property (nonatomic ,strong)UIButton *pictureTextBtn;
/**
 *  产品规格
 */
@property (nonatomic ,strong)UIButton *specificationBtn;
/**
 *  产品规格下的view
 */
@property (nonatomic ,strong)SMSpecificationView *specificationView;
/**
 *  评论
 */
@property (nonatomic ,strong)UIButton *commentBtn;
/**
 *  评论下面的tableView
 */
@property (nonatomic ,strong)UITableView *commentTableView;
/**
 *  评论按钮上面显示的文字
 */
@property (nonatomic ,copy)NSString *commentBtnTitle;
/**
 *  三个红色的横线
 */
@property (nonatomic ,strong)UIView *redViewLeft;
@property (nonatomic ,strong)UIView *redViewMid;
@property (nonatomic ,strong)UIView *redViewRight;
/**
 *  图文信息下面的tableView
 */
@property (nonatomic ,strong)UITableView *pictureTextTableView;
/**
 *  评论下面tableView 的cell 高度
 */
@property (nonatomic ,assign)CGFloat commentCellHeight;
/**
 *  按钮高度
 */
@property (nonatomic ,assign)CGFloat btnHeight;

@end

@implementation SMDetailProductInfoController

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"grayNavView"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"注册" attributes:dict];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui2"] forState:UIControlStateNormal];
    leftBtn.width = 22;
    leftBtn.height = 22;
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *jumpBtn = [[UIButton alloc] init];
    switch (self.fromNum) {
        case 0:
            jumpBtn = self.pictureTextBtn;
            break;
        case 1:
            jumpBtn = self.specificationBtn;
            break;
        case 2:
            jumpBtn = self.commentBtn;
            break;
        default:
            break;
    }
    [self topButtonClick:jumpBtn];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohangtiao"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.width = 22;
    leftBtn.height = 22;
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setupNav];
    
    [self setupTopView];
    
    //图文信息下的tableView
    [self addPictureTextTableView];
    //添加产品规格 下的view
    [self addSpecificationView];
    
    [self addCommentTableView];
    
    [self topButtonClick:self.pictureTextBtn];
//    self.view.backgroundColor = [UIColor clearColor];
    

}

- (void)addCommentTableView{
    [self.view addSubview:self.commentTableView];
}

- (void)addSpecificationView{
    
    
    SMSpecificationView *specificationView = [SMSpecificationView specificationView];
    self.specificationView = specificationView;
    [self.view addSubview:specificationView];
//    specificationView.backgroundColor = [UIColor greenColor];
    [specificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}

- (void)addPictureTextTableView{
    [self.view addSubview:self.pictureTextTableView];
    
    SMPictureTextHeaderView *headerView = [SMPictureTextHeaderView pictureTextHeaderView];
    headerView.width = KScreenWidth;
    headerView.height = headerView.headerHeight;
    self.pictureTextTableView.tableHeaderView = headerView;
}

- (void)setupNav{
    self.title = @"图文信息";
}

- (void)setupTopView{
    //顶部的整体view
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    //最下面的灰色横线
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    //中间的红色view
    CGFloat buttonW;
    if (isIPhone5) {
        buttonW = 76;
    }else if (isIPhone6){
        buttonW = 76 *KMatch6;
    }else if (isIPhone6p){
        buttonW = 76 *KMatch6p;
    }
//    CGFloat buttonW = 76;
    NSNumber *buttonWidthNum = [NSNumber numberWithFloat:buttonW];
    CGFloat margin =( KScreenWidth - buttonW * 3 ) / 4;
    
    UIView *redViewMid = [[UIView alloc] init];
    redViewMid.backgroundColor = KRedColor;
    self.redViewMid = redViewMid;
    redViewMid.hidden = YES;
    [topView addSubview:redViewMid];
    [redViewMid mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(topView.mas_centerX);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(@1);
    }];
    
    //左边的红色view
    UIView *redViewLeft = [[UIView alloc] init];
    redViewLeft.backgroundColor = KRedColor;
    self.redViewLeft = redViewLeft;
    [topView addSubview:redViewLeft];
    [redViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView.mas_left).with.offset(margin);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(@1);
    }];
    
    //右边的红色view
    UIView *redViewRight = [[UIView alloc] init];
    redViewRight.backgroundColor = KRedColor;
    self.redViewRight = redViewRight;
    redViewRight.hidden = YES;
    [topView addSubview:redViewRight];
    [redViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(topView.mas_right).with.offset(-margin);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(@1);
    }];
    
    //左边的按钮  图文信息
    UIButton *pictureTextBtn = [[UIButton alloc] init];
    self.pictureTextBtn = pictureTextBtn;
    [topView addSubview:pictureTextBtn];
    pictureTextBtn.selected = YES;
    pictureTextBtn.tag = 0;
    NSMutableDictionary *dictNor = [NSMutableDictionary dictionary];
    dictNor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictNor[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"图文信息" attributes:dictNor];
    [pictureTextBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
    NSMutableDictionary *dictSel = [NSMutableDictionary dictionary];
    dictSel[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictSel[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *attributeStrSel = [[NSAttributedString alloc] initWithString:@"图文信息" attributes:dictSel];
    [pictureTextBtn setAttributedTitle:attributeStrSel forState:UIControlStateSelected];
    NSNumber *btnHeightNum = [NSNumber numberWithFloat:self.btnHeight];
    [pictureTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView.mas_left).with.offset(margin);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-10);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(btnHeightNum);
    }];
    [pictureTextBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间的按钮  产品规格
    UIButton *specificationBtn = [[UIButton alloc] init];
    self.specificationBtn = specificationBtn;
    [topView addSubview:specificationBtn];
    specificationBtn.tag = 1;
    NSMutableDictionary *dictNor2 = [NSMutableDictionary dictionary];
    dictNor2[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictNor2[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"产品规格" attributes:dictNor2];
    [specificationBtn setAttributedTitle:attributeStr2 forState:UIControlStateNormal];
    
    NSMutableDictionary *dictSel2 = [NSMutableDictionary dictionary];
    dictSel2[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictSel2[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *attributeStrSel2 = [[NSAttributedString alloc] initWithString:@"产品规格" attributes:dictSel2];
    [specificationBtn setAttributedTitle:attributeStrSel2 forState:UIControlStateSelected];
    [specificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(pictureTextBtn.mas_right).with.offset(margin);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-10);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(btnHeightNum);
    }];
    [specificationBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //右边的按钮  评论
    UIButton *commentBtn = [[UIButton alloc] init];
    self.commentBtn = commentBtn;
    [topView addSubview:commentBtn];
    commentBtn.tag = 2;
    self.commentBtnTitle = @"评论（1）";//这里需要根据评论的数量来显示这个文字
    
    NSMutableDictionary *dictNor3 = [NSMutableDictionary dictionary];
    dictNor3[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictNor3[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:self.commentBtnTitle attributes:dictNor3];
    [commentBtn setAttributedTitle:attributeStr3 forState:UIControlStateNormal];
    
    NSMutableDictionary *dictSel3 = [NSMutableDictionary dictionary];
    dictSel3[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dictSel3[NSForegroundColorAttributeName] = KRedColor;
    NSAttributedString *attributeStrSel3 = [[NSAttributedString alloc] initWithString:self.commentBtnTitle attributes:dictSel3];
    [commentBtn setAttributedTitle:attributeStrSel3 forState:UIControlStateSelected];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(topView.mas_right).with.offset(-margin);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-10);
        make.width.equalTo(buttonWidthNum);
        make.height.equalTo(btnHeightNum);
    }];
    [commentBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 点击事件

- (void)topButtonClick:(UIButton *)btn{
    self.pictureTextBtn.selected = NO;
    self.specificationBtn.selected = NO;
    self.commentBtn.selected = NO;
    btn.selected = YES;
    
    self.redViewLeft.hidden = !self.pictureTextBtn.selected;
    self.redViewMid.hidden = !self.specificationBtn.selected;
    self.redViewRight.hidden = !self.commentBtn.selected;
    
    self.pictureTextTableView.hidden = !self.pictureTextBtn.selected;
    self.specificationView.hidden = !self.specificationBtn.selected;
    self.commentTableView.hidden = !self.commentBtn.selected;
    
    if (btn.tag == 0) {
        SMLog(@"点击了 图文信息 按钮");
    }else if (btn.tag == 1){
        SMLog(@"点击了 产品规格 按钮");
    }else if (btn.tag == 2){
        SMLog(@"点击了 评论 按钮");
    }
}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.pictureTextTableView) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (tableView == self.pictureTextTableView) {
        num = 1;
    }else if (tableView == self.commentTableView){
        num = 1;//这个数字需要根据网络返回的数据来写
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.pictureTextTableView) {
        return [SMPictureTextCell cellWithTableView:tableView];
    }else if (tableView == self.commentTableView){
        SMProductCommentCell *cell = [SMProductCommentCell cellWithTableView:tableView];
        self.commentCellHeight = cell.cellHeight;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (tableView == self.pictureTextTableView) {
        if (isIPhone5) {
            height = 187;
        }else if (isIPhone6){
            height = 187 *KMatch6;
        }else if (isIPhone6p){
            height = 187 *KMatch6p;
        }
    }else if (tableView == self.commentTableView){
        return self.commentCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.pictureTextTableView) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.pictureTextTableView) {
        return 1;
    }
    return 0;
}


#pragma mark -- 懒加载
- (CGFloat)btnHeight{
    if (_btnHeight == 0) {
        if (isIPhone5) {
            _btnHeight = 14;
        }else if (isIPhone6){
            _btnHeight = 14 *KMatch6;
        }else if (isIPhone6p){
            _btnHeight = 14 *KMatch6p;
        }
    }
    return _btnHeight;
}

-(UITableView *)pictureTextTableView{
    if (_pictureTextTableView == nil) {
        CGFloat y = CGRectGetMaxY(self.topView.frame) + 44;
        _pictureTextTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, KScreenWidth, KScreenHeight - y - 64) style:UITableViewStyleGrouped];
        _pictureTextTableView.dataSource = self;
        _pictureTextTableView.delegate = self;
        //        _pictureTextTableView.backgroundColor = [UIColor greenColor];
    }
    return _pictureTextTableView;
}

- (UITableView *)commentTableView{
    if (_commentTableView == nil) {
        CGFloat y = CGRectGetMaxY(self.topView.frame) + 44;
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, KScreenWidth, KScreenHeight - y - 64) style:UITableViewStylePlain];
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _commentTableView.backgroundColor = [UIColor yellowColor];
    }
    return _commentTableView;
}



@end
