//
//  SMSearchClassesController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchClassesController.h"


@interface SMSearchClassesController ()<UITextFieldDelegate>
/**
 *  上面灰色的整体view
 */
@property (nonatomic ,strong)UIView *topView;
/**
 *  取消按钮
 */
@property (nonatomic ,strong)UIButton *cancelBtn;
/**
 *  输入框
 */
@property (nonatomic ,strong)UITextField *inputField;
/**
 *  下面整体view
 */
@property (nonatomic ,strong)UIView *bottomView;
/**
 *  装选择种类名字的数组
 */
@property (nonatomic ,strong)NSArray *arrClasses;
/**
 *  装 选项按钮的数组
 */
@property (nonatomic ,strong)NSMutableArray *arrBtns;

@end

@implementation SMSearchClassesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopView];
    
    [self setupBottomView];
}

- (void)setupBottomView{
    //下面整体的view
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    
    //循环创建按钮
    NSInteger oneRowNum = 3;
    CGFloat margin = 15;
    CGFloat btnW = (KScreenWidth - margin * (oneRowNum + 1)) / oneRowNum *1.0;
    CGFloat btnH = 30;
    
    for (NSInteger i = 0; i < self.arrClasses.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [bottomView addSubview:btn];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFont;
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.arrClasses[i] attributes:dict];
        [btn setAttributedTitle:str forState:UIControlStateNormal];
        
        NSMutableDictionary *dictSel = [NSMutableDictionary dictionary];
        dictSel[NSFontAttributeName] = KDefaultFont;
        dictSel[NSForegroundColorAttributeName] = KRedColor;
        NSAttributedString *strSel = [[NSAttributedString alloc] initWithString:self.arrClasses[i] attributes:dictSel];
        [btn setAttributedTitle:strSel forState:UIControlStateSelected];
        
//        [btn setTitle:self.arrClasses[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"heikuang-1"] forState:UIControlStateNormal];
        btn.tag = i;
        
        NSInteger atRow = i / oneRowNum;
        NSInteger atCol = i % oneRowNum;
        
        CGFloat btnX = margin + (btnW + margin) * atCol;
        CGFloat btnY = margin + (btnH + margin) * atRow;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.arrBtns addObject:btn];
    }
    
}

- (void)classBtnClick:(UIButton *)btn{
    SMLog(@"点击了选择搜索类别的按钮    %zd",btn.tag);
    
    for (UIButton *btns in self.arrBtns) {
        btns.selected = NO;
    }
    btn.selected = YES;
    switch (btn.tag) {
        case 0:
            SMLog(@"选择了 商品");
            break;
        case 1:
            SMLog(@"选择了 活动");
            break;
        case 2:
            SMLog(@"选择了 优惠券");
            break;
        case 3:
            SMLog(@"选择了 爽快圈");
            break;
        case 4:
            SMLog(@"选择了 企业动态");
            break;
        case 5:
            SMLog(@"选择了 伙伴连线");
            break;
        case 6:
            SMLog(@"选择了 订单");
            break;
        case 7:
            SMLog(@"选择了 联系人");
            break;
        case 8:
            SMLog(@"选择了 客服连线");
            break;
            
        default:
            break;
    }
}

- (void)setupTopView{
    //上面灰色的整体view
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    self.topView = topView;
    topView.frame = CGRectMake(0, 0, KScreenWidth, KStateBarHeight);
    topView.backgroundColor = KControllerBackGroundColor;
    
    //上半部20高度
    UIView *view20 = [[UIView alloc] init];
    [topView addSubview:view20];
    view20.backgroundColor = KControllerBackGroundColor;
    view20.frame = CGRectMake(0, 0, KScreenWidth, 20);
    
    //下半部view 44高度
    UIView *view44 = [[UIView alloc] init];
    view44.backgroundColor = KControllerBackGroundColor;
    [topView addSubview:view44];
    [view44 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.top.equalTo(view20.mas_bottom).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    [view44 addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = KRedColor;
    dict[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *cancelStr = [[NSAttributedString alloc] initWithString:@"取消" attributes:dict];
    [cancelBtn setAttributedTitle:cancelStr forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(view44.mas_centerY);
        make.right.equalTo(view44.mas_right).with.offset(-10);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    //输入框
    UITextField *inputField = [[UITextField alloc] init];
    self.inputField = inputField;
    [view44 addSubview:inputField];
    inputField.delegate = self;
    NSMutableDictionary *dictInput = [NSMutableDictionary dictionary];
    dictInput[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//    dictInput[NSFontAttributeName] = KDefaultFont;
    NSAttributedString *inputStr = [[NSAttributedString alloc] initWithString:@"搜索产品" attributes:dictInput];
    inputField.attributedPlaceholder = inputStr;
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.backgroundColor = SMColor(212, 212, 212);
    inputField.layer.cornerRadius = SMCornerRadios;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"fangdajing2"];
    
    searchIcon.width = 28;
    searchIcon.height = 28;
    inputField.contentMode = UIViewContentModeCenter;
    inputField.rightView = searchIcon;
    inputField.rightViewMode = UITextFieldViewModeAlways;
    inputField.keyboardType = UIKeyboardTypeWebSearch;
    
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(view44.mas_centerY);
        make.right.equalTo(cancelBtn.mas_left).with.offset(-10);
        make.left.equalTo(view44.mas_left).with.offset(20);
//        make.height.equalTo(@44);
    }];
    
    
//    SMSearchBar *search = [SMSearchBar searchBar];
//    [view44 addSubview:search];
//    search.delegate = self;
//    search.backgroundColor = SMColor(212, 212, 212);
//    
//    UIImageView *searchIcon = [[UIImageView alloc] init];
//    searchIcon.image = [UIImage imageNamed:@"fangdajing"];
    
//    searchIcon.width = 28;
//    searchIcon.height = 28;
//    searchIcon.contentMode = UIViewContentModeCenter;
//    search.rightView = searchIcon;
//    search.rightViewMode = UITextFieldViewModeAlways;
//    search.keyboardType = UIKeyboardTypeWebSearch;
    
//    [search mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.equalTo(view44.mas_centerY);
//        make.right.equalTo(cancelBtn.mas_left).with.offset(-10);
//        make.left.equalTo(view44.mas_left).with.offset(20);
//        make.height.equalTo(@44);
//    }];
    
    
}

- (void)cancelBtnClick{
    SMLog(@"点击了取消按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- 懒加载
- (NSArray *)arrClasses{
    if (_arrClasses == nil) {
        _arrClasses = @[@"商品",@"活动",@"优惠券",@"爽快圈",@"企业动态",@"伙伴连线",@"订单",@"联系人",@"客服连线"];
    }
    return _arrClasses;
}

- (NSMutableArray *)arrBtns{
    if (_arrBtns == nil) {
        _arrBtns = [NSMutableArray array];
    }
    return _arrBtns;
}

@end
