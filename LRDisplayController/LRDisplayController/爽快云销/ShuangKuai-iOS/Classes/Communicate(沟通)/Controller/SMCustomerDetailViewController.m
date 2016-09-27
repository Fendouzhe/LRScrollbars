//
//  SMCustomerDetailViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/19.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomerDetailViewController.h"
#import "SMCustomerDetailTableViewCell.h"
#import "SMCustomerDetailTableViewCell2.h"
#import "NSString+Extension.h"
#import "SMKeyBoardHeader.h"
#import "LocalWorkLog+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"
#import "SMChangeLevelController.h"

@interface SMCustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SMCustomerDetailTableViewCellDelegate,UITextFieldDelegate,SMKeyBoardHeaderDelegate,SMChangeLevelControllerDelegate>
/**
 *  头部背景头像的高度
 */
@property (nonatomic ,assign)CGFloat backgroundImageViewH;

@property (nonatomic ,strong)UILabel *companyNameLabel;

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,assign)BOOL isClickedMoreBtn;
/**
 *  第一组cell的个数
 */
@property (nonatomic ,assign)NSInteger oneSectionCellCount;
/**
 *  用户评论占据的size大小
 */
@property (nonatomic ,assign)CGSize commentSize;
/**
 *  评论数量
 */
@property (nonatomic ,assign)NSInteger commentCount;

@property (nonatomic ,strong)SMKeyBoardHeader *keyBoardHeaderView;

@property(nonatomic,copy)NSArray* stateArray;

@property(nonatomic,copy)NSMutableArray* infoArray;

@property(nonatomic,copy)NSArray* informationArray;

@property(nonatomic,strong)UIView * stateView;

@property(nonatomic,strong)UITableView * stateTableView;

@property(nonatomic,strong)UIImageView * backgroundImageView;

@property (nonatomic ,strong)NSArray *arrLogs;

@end

@implementation SMCustomerDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
    NSData* bjImageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserInfoBjImage];
    UIImage* bjImage = [UIImage imageWithData:bjImageData];
    if (bjImage) {
        self.backgroundImageView.image = bjImage;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(refreshTableView)]) {
        [self.delegate refreshTableView];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.backgroundImageViewH, KScreenWidth, KScreenHeight - self.backgroundImageViewH - self.keyBoardHeaderView.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self addNotification];
    
    [self loadSextion0Data];
    
    [self loadSextion1Data];
    
    
}

/**
 *  用来监听键盘的弹出/隐藏
 */
-(void)keyboardWillChange:(NSNotification *)note{
    
    // 获得通知信息
    NSDictionary *userInfo = note.userInfo;
    // 获得键盘弹出后或隐藏后的frame
    CGRect keyboardFrame =[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获得键盘的y值
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获得屏幕的高度
    CGFloat screenH =[UIScreen mainScreen].bounds.size.height;
    //
    //    SMLog(@"note = %@",note);
    // 获得键盘执行动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    /*
     [UIView animateWithDuration:duration animations:^{
     self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
     }];
     */
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - screenH);
    } completion:nil];
}

- (void)addNotification{
    // 监听键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

- (void)setupUI{
    //键盘上面的输入栏
    SMKeyBoardHeader *keyboardHeaderView = [SMKeyBoardHeader keyBoardHeader];
    keyboardHeaderView.delegate = self;
    keyboardHeaderView.inputField.delegate = self;
    [self.view addSubview:keyboardHeaderView];
    self.keyBoardHeaderView = keyboardHeaderView;
    [keyboardHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    
    //背景
    self.backgroundImageViewH = 138;
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView = backgroundImageView;
    backgroundImageView.image = [UIImage imageNamed:@"微货架-beijing 5"];
    backgroundImageView.frame = CGRectMake(0, 0, KScreenWidth, self.backgroundImageViewH);
    [self.view addSubview:backgroundImageView];
    
    //上面的view
    UIView *topView = [[UIView alloc] initWithFrame:backgroundImageView.frame];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    
    //返回键
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(25);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    //客户详情
    UILabel *titleLabel =[[UILabel alloc] init];
    titleLabel.text = @"客户详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(25);
    }];
    
    //公司名字
    UILabel *companyNameLabel = [[UILabel alloc] init];
    [self.view addSubview:companyNameLabel];
    self.companyNameLabel = companyNameLabel;
    companyNameLabel.text = self.cus.fullname;
    companyNameLabel.font = [UIFont systemFontOfSize:18];
    companyNameLabel.textColor = [UIColor whiteColor];
    
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(topView.mas_bottom).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
    }];
    
#pragma 这个按钮得重新写

    //把tableview添加进去
    [self.view addSubview:self.tableView];
#pragma mark - 重写客户状态按钮
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"chubugoutongkuang"];
    imageView.tag = 10;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-10);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
    imageView.layer.cornerRadius = SMCornerRadios;
    imageView.layer.masksToBounds = YES;
    
    
    //加上label
    UILabel * lable = [UILabel new];
    lable.tag = 20;
    [imageView addSubview:lable];
    lable.font = KDefaultFontBig;
    lable.text = self.stateArray[self.cus.status];
    lable.textColor = [UIColor blueColor];
//    lable.text = self.stateArray[self.localCustomer.status.integerValue];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).with.offset(4);
        make.bottom.equalTo(imageView.mas_bottom).with.offset(-2);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    //给imageview加上手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStateBtnDidClick:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    
    //创建状态选择视图
    [self createselectstate];
    //数据
//    self.companyNameLabel.text = self.localCustomer.name;
    //[chooseStateBtn setTitle:self.stateArray[[self.localCustomer.status integerValue]] forState:UIControlStateNormal];
//    chooseStateBtn.titleLabel.font = KDefaultFontSmall;
    //chooseStateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [chooseStateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.stateTableView) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.stateTableView) {  //弹出来的状态栏笑tableview
        return self.stateArray.count;
    }
    if (section == 0) {
        if (self.isClickedMoreBtn) {//点了更多按钮之后
            return 6;
        }else{
            return 3 + 1;
        }
    }else{  //销售日志
        //评论
        SMLog(@"self.arrLogs.count   %zd",self.arrLogs.count);
        return self.arrLogs.count;
    }

}

//里面要分情况返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.stateTableView) {  //小tableview
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = self.stateArray[indexPath.row];
        cell.textLabel.font = KDefaultFontBig;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //没有点击更多按钮的情况
    if (indexPath.section == 0 && indexPath.row == 3 && !self.isClickedMoreBtn) {
        SMCustomerDetailTableViewCell *cell = [SMCustomerDetailTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 0){//点击“更多”之后的情况
        static NSString *ID = @"customer_DetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        //cell.textLabel.text = @"textLable";
        cell.textLabel.text = self.informationArray[indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = KDefaultFontBig;
        
        //cell.detailTextLabel.text = @"detailTextLabel";
        cell.detailTextLabel.text = self.infoArray[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = KDefaultFontBig;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){  //评论
        SMCustomerDetailTableViewCell2 *cell2 = [SMCustomerDetailTableViewCell2 cellWithTableView:tableView];
        cell2.log = self.arrLogs[indexPath.row];
        CGFloat width = KScreenWidth - 20;
//
////        NSArray* array = [LocalWorkLog MR_findByAttribute:@"id" withValue:self.localCustomer.id];
////        if (array.count>0) {
////           cell2.localworklog = array[array.count-1-indexPath.row];
////        }else
////        {
////            cell2.localworklog = nil;
////        }
//        
        self.commentSize = [cell2.comment textSizeWithFont:KDefaultFontBig maxSize:CGSizeMake(width, MAXFLOAT)];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
    
    SMCustomerDetailTableViewCell *cell = [SMCustomerDetailTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.stateTableView) {
        return 21;
    }
    if (indexPath.section == 0) {
        return 40;
    }else {  //评论内容
//        return 85;
        return 10 + 45 + 10 + self.commentSize.height + 10;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"销售日志";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.stateTableView) {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==self.stateTableView) {
        return 1;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"didSelectRowAtIndexPath    %zd--%zd",indexPath.section,indexPath.row);
    if (tableView == self.stateTableView) {
        self.stateView.hidden = !self.stateView.hidden;
        UIImageView * imageView = [self.view viewWithTag:10];
        UILabel * label = (UILabel *)[imageView viewWithTag:20];
        label.text = self.stateArray[indexPath.row];
        self.cus.status = indexPath.row;
        [[SKAPI shared] updateCustomer:self.cus block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result   %@",result);
            }else{
                SMLog(@"error  %@",error);
            }
        }];
        //保存下来
        //    查找到相应数据 更新
        //根据什么数据来找  唯一的标识
//        if (self.localCustomer.status.integerValue != indexPath.row) {
//            NSArray * array = [LocalCustomer MR_findByAttribute:@"fullname" withValue:self.localCustomer.fullname];
//            for (LocalCustomer * model in array) {
//                model.status = [NSNumber numberWithInteger:indexPath.row];
//                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//                
////                [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
////                    
////                } completion:^(BOOL contextDidSave, NSError *error) {
////                    
////                }];
//            }
//        }
        
        
    }else if (tableView == self.tableView && indexPath.section == 0 && indexPath.row == 2){
        SMChangeLevelController *vc = [SMChangeLevelController new];
        vc.cus = self.cus;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- SMChangeLevelControllerDelegate
- (void)refreshLevelWith:(Customer *)cus{
    self.cus = cus;
    [self loadSextion0Data];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.keyBoardHeaderView.inputField resignFirstResponder];
}

#pragma mark -- SMCustomerDetailTableViewCellDelegate
- (void)moreBtnDidClick:(UIButton *)btn{
    self.isClickedMoreBtn = YES;
    [self.tableView reloadData];
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self composeBtnDidClick];
        [self.keyBoardHeaderView.inputField resignFirstResponder];
        textField.text = nil;
        
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //在这里可以拿出 textField.text 加入到模型数组中去，然后下面刷新tableView 重新加载数据
}

#pragma mark --  SMKeyBoardHeaderDelegate 发表日志点击响应
- (void)composeBtnDidClick{
    SMLog(@"点击了 发表日志 按钮");
    
    if ([self.keyBoardHeaderView.inputField.text isEqualToString:@""]) {
        return;
    }
    //发表日志  自己发表  用自己的头像
    
    NSDateFormatter * fmr = [[NSDateFormatter alloc]init];
    fmr.dateFormat = [NSString stringWithFormat:@"yy年MM月dd日 HH:mm"];
    NSString * str = [fmr stringFromDate:[NSDate date]];
//
//    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        LocalWorkLog * localWorkLog = [LocalWorkLog MR_createEntityInContext:localContext];
//        localWorkLog.id = self.localCustomer.id;
//        //内容
//        localWorkLog.content = self.keyBoardHeaderView.inputField.text;
//        //时间
//        localWorkLog.createAt = str;
//        //还有的数据无法获得  。。。。改为服务器后 写上
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        
//    }];
    
    
//    [self.keyBoardHeaderView.inputField resignFirstResponder];
//    self.keyBoardHeaderView.inputField.text = nil;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
    SMLog(@"self.keyBoardHeaderView.inputField.text    %@",self.keyBoardHeaderView.inputField.text);
    [[SKAPI shared] writeCommentByCustomerId:self.cus.id andContent:self.keyBoardHeaderView.inputField.text block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  writeCommentByCustomerId   %@",result);
            [self.keyBoardHeaderView.inputField resignFirstResponder];
            self.keyBoardHeaderView.inputField.text = nil;
            [self loadSextion1Data];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
    
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void)createselectstate
{
    self.stateView = [[UIView alloc]init];
    self.stateView.layer.cornerRadius = SMCornerRadios;
    self.stateView.layer.masksToBounds = YES;
    self.stateView.hidden = YES;
    //self.stateView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.stateView];
    UIImageView * imageView = [self.view viewWithTag:10];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.width.equalTo(imageView.mas_width);
        make.height.equalTo(@200);
    }];
    
    //用到tableview
    self.stateTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.stateView addSubview:self.stateTableView];
    
    [self.stateTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stateView.mas_right).with.offset(0);
        make.top.equalTo(self.stateView.mas_top).with.offset(0);
        make.left.equalTo(self.stateView.mas_left).with.offset(-10);
        make.bottom.equalTo(self.stateView.mas_bottom).with.offset(0);
    }];
    self.stateTableView.delegate = self;
    self.stateTableView.dataSource =self;
    //注册cell
    [self.stateTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}

#pragma mark -- 响应事件

- (void)chooseStateBtnDidClick:(UITapGestureRecognizer *)tap{
    SMLog(@"点击了 选择客户状态 的按钮");
    //弹出选项
    self.stateView.hidden = !self.stateView.hidden;
   
}

- (void)backBtnClick{
    SMLog(@"点击了 返回 按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(NSArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = @[@"初步沟通",@"见面拜访",@"确定意向",@"正式报价",@"商务洽谈",@"签约成交",@"售后服务",@"停止客服",@"流失客户"];
    }
    return _stateArray;
}
-(NSMutableArray *)infoArray
{
    if(!_infoArray){
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
-(NSArray *)informationArray
{
    if (!_informationArray) {
        _informationArray = @[@"客户全称:",@"客户电话:",@"客户地址:",@"客户网址:",@"客户级别",@"客户介绍"];
    }
    return _informationArray;
}
-(void)loadSextion0Data
{
    [self.infoArray removeAllObjects];
    NSArray* array = @[@"个人客户",@"小型客户",@"中型客户",@"大型客户",@"VIP客户"];
//    [self.infoArray addObject:self.localCustomer.fullname];
//    [self.infoArray addObject:[NSString stringWithFormat:@"%@",self.localCustomer.phone]];
//    [self.infoArray addObject:[NSString stringWithFormat:@"%@",self.localCustomer.address]];
//    [self.infoArray addObject:[NSString stringWithFormat:@"%@",self.localCustomer.website]];
//    [self.infoArray addObject:array[[self.localCustomer.level integerValue]]];
//    [self.infoArray addObject:[NSString stringWithFormat:@"%@",self.localCustomer.intro]];
    
    [self.infoArray addObject:self.cus.fullname];
    [self.infoArray addObject:self.cus.phone];
    [self.infoArray addObject:array[self.cus.grade]];
    [self.infoArray addObject:self.cus.address];
    [self.infoArray addObject:self.cus.website];
    [self.infoArray addObject:self.cus.intro];
    [self.tableView reloadData];
    
}

- (void)loadSextion1Data{
    [[SKAPI shared] queryCustomerDetail:self.cus.id block:^(id result, NSError *error) {
        if (!error) {
            
            self.arrLogs = [WorkLog mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"workLogList" ]];
            [self.tableView reloadData];
            SMLog(@"result  queryCustomerDetail   %@",self.arrLogs);
        }else{
            SMLog(@"error  %@",error);
        }
    }];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete && tableView == self.tableView && indexPath.section == 1){
        WorkLog *log = self.arrLogs[indexPath.row];
        [[SKAPI shared] deleteCommentByCustomerId:self.cus.id andLogId:log.id block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  deleteCommentByCustomerId   %@",result);
                [self loadSextion1Data];
            }else{
                SMLog(@"error  %@",error);
            }
        }];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.editing) { // 插入操作
        return UITableViewCellEditingStyleInsert;
    }
    // 删除操作
    return UITableViewCellEditingStyleDelete;
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //这里设置。只有第二段才出现删除
    if (indexPath.section==1) {
        return YES;
    }
    return NO;
}


@end
