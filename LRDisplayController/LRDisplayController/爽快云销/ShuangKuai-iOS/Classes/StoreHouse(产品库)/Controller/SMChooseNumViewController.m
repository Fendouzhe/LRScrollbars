//
//  SMChooseNumViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMChooseNumViewController.h"
#import "SMChooseTableViewCell.h"
@interface SMChooseNumViewController ()<UITableViewDelegate,UITableViewDataSource,SMChooseTableViewCellDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//页数现显示
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
//下一页
@property (weak, nonatomic) IBOutlet UIButton *nextPageBtn;
//上一页
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;
////当前页码
//@property (nonatomic ,assign)NSInteger currentPage;

//适配
//最上面view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
//最下面view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (nonatomic ,strong)UIButton *phoneNumBtn;

@property (nonatomic ,strong)NSArray *arrNums;

@property (nonatomic ,assign)NSInteger page;

@property (nonatomic ,assign)NSInteger searchPage;

@property (nonatomic ,strong)UIAlertView *alert;

@end

@implementation SMChooseNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self setupUI];
    
    [self match];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getNums];
    
    self.searchPage = 1; //初始化数字
    self.page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChanged{
    SMLog(@"self.inputTextField.text    %@",self.inputTextField.text);
    if ([self.inputTextField.text isEqualToString:@""]) {
        self.page = 1;
        [self getNums];
    }
}

- (void)getNums{
    
    [[SKAPI shared] queryPhoneListByPage:self.page andSize:16 andProductId:self.productID andKeyword:self.inputTextField.text block:^(id result, NSError *error) {
        if (!error) {
            self.arrNums = result;
            SMLog(@"self.arrNums.count   %zd",self.arrNums.count);
            if (self.arrNums.count < 16) {
                [self.nextPageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else{
                [self.nextPageBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
            }
            for (id m in self.arrNums) {
                SMLog(@"[m class]  %@",m);
            }
            
            [self.tableView reloadData];
        }else{
            SMLog(@"error   queryPhoneListByPage   %@",error);
        }
    }];
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupNav{
    self.title = @"选择号码";

}

#pragma mark -- 适配
- (void)match{
    if (isIPhone5) {
        self.topViewHeight.constant = 50;
        self.bottomViewHeight.constant = 50;
    }else if (isIPhone6){
        self.topViewHeight.constant = 50 *KMatch6Height;
        self.bottomViewHeight.constant = 50 *KMatch6Height;
    }else if (isIPhone6p){
        self.topViewHeight.constant = 50 *KMatch6pHeight;
        self.bottomViewHeight.constant = 50 *KMatch6pHeight;
    }
}

#pragma mark -- 点击事件
- (IBAction)nextPageClick {
    SMLog(@"点击了 下一页");
    if ([self.nextPageBtn.currentTitleColor isEqual:[UIColor darkGrayColor]]) {
        
        return;
    }
    self.page++;
//    self.currentPage++;
    [self getNums];
    self.pageLabel.text = [NSString stringWithFormat:@"第%zd页",self.page];
    if (self.page > 1) {
        [self.previousBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    }
}

- (IBAction)searchBtnClick {
    SMLog(@"点击了 搜索");
    self.page = 1;
    self.pageLabel.text = [NSString stringWithFormat:@"第%zd页",self.page];
    [self.previousBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self getNums];
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    SMLog(@"textField.text    %@   string   %@",textField.text,string);
//    return YES;
//}


- (IBAction)previousBtnClick {
    SMLog(@"点击了 上一页");
    if (self.page == 1){
        return;
    }
    self.page--;
//    self.currentPage--;
    [self.nextPageBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    if (self.page == 1) {
        [self.previousBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    self.pageLabel.text = [NSString stringWithFormat:@"第%zd页",self.page];
    [self getNums];
}

-(void)setupUI{
    self.searchBtn.layer.cornerRadius = 4;
    self.searchBtn.layer.masksToBounds = YES;
    self.searchBtn.backgroundColor = KRedColorLight;
    self.bottomGrayView.backgroundColor = KControllerBackGroundColor;
    [self.nextPageBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SMChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.page = 1;
    self.pageLabel.text = [NSString stringWithFormat:@"第%zd页",self.page];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.arrNums.count + 1) / 2;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMChooseTableViewCell * cell = [SMChooseTableViewCell cellWithTableView:tableView];
    SMLog(@"[self.arrNums class]   %@",[self.arrNums class]);
    cell.leftNum = self.arrNums[indexPath.row *2];
    SMLog(@"self.arrNums[indexPath.row *2]   %@",self.arrNums[indexPath.row *2]);
    if (indexPath.row *2 + 1 < self.arrNums.count) {
        cell.rightNum = self.arrNums[indexPath.row * 2 +1];
        
        SMLog(@"self.arrNums[indexPath.row * 2 +1]    %@",self.arrNums[indexPath.row * 2 +1]);
    }else{
        cell.rightNum = nil;
    }
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (KScreenHeight - 64 - self.topViewHeight.constant - self.bottomViewHeight.constant) / 8.0;
}

#pragma mark -- SMChooseTableViewCellDelegate
- (void)choosePhoneNum:(UIButton *)phoneNumBtn{
    
    if (self.isBelongCounter) {
        self.phoneNumBtn = phoneNumBtn;
        [phoneNumBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请问您是否要选择%@这个号码？",phoneNumBtn.currentTitle] delegate:self cancelButtonTitle:@"就这个啦！" otherButtonTitles:@"我再选选", nil];
        self.alert = alert;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您需要把次商品添加到您的微柜台，并从微柜台界面进入，才可以进行选号喔。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.phoneNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (buttonIndex == 0 && alertView == self.alert) {
        SMLog(@"用户确定了号码");
        //先在本地存一份这个号码，因为在另外一个地方也需要发布这个通知，需要拿出这个号码
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumBtn.currentTitle forKey:KUserChoosedThePhoneNum];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"KChooseThePhoneNumKey"] = self.phoneNumBtn.currentTitle;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KChooseThePhoneNum" object:nil userInfo:dict];
        if ([self.delegate respondsToSelector:@selector(userHasChooseNum)]) {
            [self.delegate userHasChooseNum];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -- 懒加载




@end
