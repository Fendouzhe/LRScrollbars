//
//  CustomerDetailInfoViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/20.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailInfoViewController.h"
#import "CustomerDetailInfoHeaderView.h"
#import "CustomerDetailInfoFooterView.h"
#import "CustomerDetailInfoCell.h"
#import "CustomerDetailBaseModel.h"
#import "CustomerDetailArrowModel.h"
#import "CustomerDetailTwoFooterImage.h"
#import "CustomerDetailOneFooterImage.h"
#import "CustomerDetailJustHeightModel.h"
#import "CustomerDetailBigFrameModel.h"
#import "CustomerDetailNoteCell.h"
#import "CustomerDetailNoteFrameModel.h"
#import "IntentionProductViewController.h"
#import "CreatNewCustomerViewController.h"
#import <MessageUI/MessageUI.h>
#import "CompleteOrderViewController.h"

@interface CustomerDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CustomerDetailInfoFooterViewDelegate,CustomerDetailInfoCellDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SWTableViewCellDelegate,CreatNewCustomerViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;/**< 表格 */
@property (nonatomic,strong) NSArray *dataSource;/**< 数据 */
@property (nonatomic,strong) CustomerDetailInfoHeaderView *topView;/**< 顶部的view */
@property (nonatomic,strong) CustomerDetailInfoFooterView *footerView;/**< 底部输入框 */
@property (nonatomic,strong) NSMutableArray *workLogList;/**< 备注列表,worklog */
@property (nonatomic,strong) NSArray *customerArray;/**< 用户信息数组 */
@end

@implementation CustomerDetailInfoViewController

-(UITableView *)tableView{
    if (_tableView ==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CustomerDetailInfoHeaderView *topView = [[CustomerDetailInfoHeaderView alloc] init];
        topView.frame = CGRectMake(0, 0, KScreenWidth, 100*SMMatchWidth);
        self.topView = topView;
        _tableView.tableHeaderView = topView;
        
        [self.view addSubview:_tableView];
        MJWeakSelf
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view).with.offset(-40*SMMatchWidth);
        }];
    }
    return _tableView;
}

- (CustomerDetailInfoFooterView *)footerView{
    if (_footerView == nil) {
        MJWeakSelf
        _footerView = [[CustomerDetailInfoFooterView alloc] init];
        _footerView.delegate = self;
        [self.view addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
            make.height.equalTo(@(40*SMMatchWidth));
        }];
//        CGFloat h = 40*SMMatchWidth;
//        CGFloat w = self.view.frame.size.width;
//        CGFloat y = self.view.frame.size.height - h-64;
//        _footerView.frame = CGRectMake(0, y, w, h);
//        SMLog(@"_footerView.frame = %@",NSStringFromCGRect(_footerView.frame));
    }
    return _footerView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"客户详情";
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
//    [self tableView];
    MJWeakSelf
    CustomerDetailArrowModel *model1 = [[CustomerDetailArrowModel alloc] init];
    model1.title = @"已成交订单数";
    model1.iconImage = @"customer01";
    model1.detailText = @"";
    model1.textAlignment = DetailTextAlignmentCenter;
    
    CustomerDetailTwoFooterImage *model2 = [[CustomerDetailTwoFooterImage alloc] init];
    model2.title = @"客户电话";
    model2.iconImage = @"customer02";
    model2.detailText = @"";
    model2.textAlignment = DetailTextAlignmentRight;
    model2.imageArray = @[@"customer10",@"customer09"];
    
    CustomerDetailJustHeightModel *model3 = [[CustomerDetailJustHeightModel alloc] init];
    model3.title = @"客户地址";
    model3.iconImage = @"customer03";
    model3.detailText = @"";
    
    CustomerDetailBigFrameModel *bigModel = [[CustomerDetailBigFrameModel alloc] init];
    bigModel.cellModel = model3;
    
    
    CustomerDetailOneFooterImage *model4 = [[CustomerDetailOneFooterImage alloc] init];
    model4.title = @"客户邮箱";
    model4.iconImage = @"customer04";
    model4.detailText = @"";
    model4.detailImage = @"customer09";
    model4.textAlignment = DetailTextAlignmentRight;
    
    
    CustomerDetailBaseModel *model5 = [[CustomerDetailBaseModel alloc] init];
    model5.title = @"客户标签";
    model5.iconImage = @"customer05";
    model5.detailText = @"";
    model5.textAlignment = DetailTextAlignmentRight;
    

    CustomerDetailArrowModel *model6 = [[CustomerDetailArrowModel alloc] init];
    model6.title = @"意向商品";
    model6.iconImage = @"customer06";
    model6.detailText = @"";
    model6.textAlignment = DetailTextAlignmentRight;
//    model6.option = ^(){
//        IntentionProductViewController *vc = [[IntentionProductViewController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    };
    
    CustomerDetailBaseModel *model7 = [[CustomerDetailBaseModel alloc] init];
    model7.title = @"购买等级";
    model7.iconImage = @"customer07";
    model7.detailText = @"";
    model7.textAlignment = DetailTextAlignmentRight;
    
    CustomerDetailBaseModel *model8 = [[CustomerDetailBaseModel alloc] init];
    model8.title = @"客户级别";
    model8.iconImage = @"customer08";
    model8.detailText = @"";
    model8.textAlignment = DetailTextAlignmentRight;
    
//    CustomerDetailBaseModel *model9 = [[CustomerDetailBaseModel alloc] init];
//    model9.title = @"1466732512";
//    model9.detailText = @"faflajflajfljalfjafeqweqeqwelkjafkjalfjdsjafkljasdflkjasfl";
//    
//    CustomerDetailNoteFrameModel *frameModel1= [[CustomerDetailNoteFrameModel alloc] init];
//    frameModel1.cellData = model9;
//    
//    CustomerDetailBaseModel *model10 = [[CustomerDetailBaseModel alloc] init];
//    model10.title = @"1466730000";
//    //    model5.iconImage = @"";
//    model10.detailText = @"faflajflajfljalfewqeqeqweqweweqeqjaflkjafkjalfjdsjafkljasdflkjasfl";
//    
//    CustomerDetailNoteFrameModel *frameModel2 = [[CustomerDetailNoteFrameModel alloc] init];
//    frameModel2.cellData = model10;
    
    self.dataSource = @[@[model1,model2,bigModel],@[model4,model5,model6,model7,model8]];
    [self.tableView reloadData];
    
    [self footerView];
    self.topView.customer = self.customer;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tianjialianxirrenRed"] forState:UIControlStateNormal];
    //    rightBtn.width = 22;
    //    rightBtn.height = 22;
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"bianji_red"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:KRedColorLight forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyBoardChange:(NSNotification *)noti{
    SMLog(@"%@,\n%f",noti.userInfo,KScreenHeight);
    MJWeakSelf
    CGRect keyboardEndFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat h = 40*SMMatchWidth;
//    CGFloat w = self.view.frame.size.width;
//    CGFloat y = keyboardEndFrame.origin.y-h-64;
//    self.footerView.frame = CGRectMake(0, y, w, h);
    
    
    
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(@(keyboardEndFrame.origin.y-h-64));
        make.height.equalTo(@(h));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.footerView.mas_top);
    }];
    
    NSInteger section = self.dataSource.count - 1;
    NSInteger row = [self.dataSource[section] count]-1;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
    });
    
//    SMLog(@"self.footerView.frame = %@,\ny = %f",NSStringFromCGRect(self.footerView.frame),y);
}

-(void)rightItemClick{
    CreatNewCustomerViewController *vc = [[CreatNewCustomerViewController alloc] init];
    vc.customer = self.customer;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self requestData];
}

-(void)requestData{
    MJWeakSelf
    [[SKAPI shared] queryCustomerDetail:self.customer.id block:^(id result, NSError *error) {
        if (!error) {
            weakSelf.workLogList = [WorkLog mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"workLogList"]];
            //            weakSelf.customer = [Customer mj_objectWithKeyValues:[[result valueForKey:@"result"] valueForKey:@"customer"]];
            CustomerDetailArrowModel *model1 = [[CustomerDetailArrowModel alloc] init];
            model1.title = @"已成交订单数";
            model1.iconImage = @"customer01";
            model1.detailText = [NSString stringWithFormat:@"%ld",(long)weakSelf.customer.sumOrder];
            model1.textAlignment = DetailTextAlignmentCenter;
            model1.option = ^(){
                CompleteOrderViewController *vc = [[CompleteOrderViewController alloc] init];
                vc.phone = weakSelf.customer.phone;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            CustomerDetailTwoFooterImage *model2 = [[CustomerDetailTwoFooterImage alloc] init];
            model2.title = @"客户电话";
            model2.iconImage = @"customer02";
            model2.detailText = weakSelf.customer.phone;
            model2.textAlignment = DetailTextAlignmentRight;
            model2.imageArray = @[@"联系掌柜00",@"customer10"];
            
            CustomerDetailJustHeightModel *model3 = [[CustomerDetailJustHeightModel alloc] init];
            model3.title = @"客户地址";
            model3.iconImage = @"customer03";
            model3.detailText = weakSelf.customer.address;
            
            CustomerDetailBigFrameModel *bigModel = [[CustomerDetailBigFrameModel alloc] init];
            bigModel.cellModel = model3;
            
            
            CustomerDetailOneFooterImage *model4 = [[CustomerDetailOneFooterImage alloc] init];
            model4.title = @"客户邮箱";
            model4.iconImage = @"customer04";
            model4.detailText = weakSelf.customer.email;
            model4.detailImage = @"customer09";
            model4.textAlignment = DetailTextAlignmentRight;
            
            
            CustomerDetailBaseModel *model5 = [[CustomerDetailBaseModel alloc] init];
            model5.title = @"客户标签";
            model5.iconImage = @"customer05";
            model5.detailText = weakSelf.customer.target;
            model5.textAlignment = DetailTextAlignmentRight;
            
            
            
            
            //NSLog(@"self.customer.purpose    requestData   %@",self.customer.purpose);
            NSArray *productArray = [weakSelf.customer.purpose componentsSeparatedByString:@","];
            
            CustomerDetailArrowModel *model6 = [[CustomerDetailArrowModel alloc] init];
            model6.title = @"意向商品";
            model6.iconImage = @"customer06";
            if ([self.customer.purpose isEqualToString:@""]) {
                model6.detailText = @"0";
            }else{
                model6.detailText = [NSString stringWithFormat:@"%lu",(unsigned long)productArray.count];
            }
            model6.textAlignment = DetailTextAlignmentRight;
            model6.option = ^(){
                IntentionProductViewController *vc = [[IntentionProductViewController alloc] init];
                vc.productArray = productArray;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            NSString *IntentionLevel;
            switch (weakSelf.customer.buyRating) {
                case 0:
                {
                    IntentionLevel = @"A";
                }
                    break;
                case 1:
                {
                    IntentionLevel = @"B";
                }
                    break;
                case 2:
                {
                    IntentionLevel = @"C";
                }
                    break;
                default:
                    IntentionLevel = @"";
                    break;
            }
            
            CustomerDetailBaseModel *model7 = [[CustomerDetailBaseModel alloc] init];
            model7.title = @"购买等级";
            model7.iconImage = @"customer07";
            model7.detailText = IntentionLevel;
            model7.textAlignment = DetailTextAlignmentRight;
            
            NSString *customerLevel;
            switch (weakSelf.customer.level) {
                case 0:
                {
                    customerLevel = @"Vip";
                }
                    break;
                case 1:
                {
                    customerLevel = @"大型客户";
                }
                    break;
                case 2:
                {
                    customerLevel = @"中型客户";
                }
                    break;
                case 3:
                {
                    customerLevel = @"小型客户";
                }
                    break;
                default:
                    customerLevel = @"";
                    break;
            }
            
            CustomerDetailBaseModel *model8 = [[CustomerDetailBaseModel alloc] init];
            model8.title = @"客户级别";
            model8.iconImage = @"customer08";
            model8.detailText = customerLevel;
            model8.textAlignment = DetailTextAlignmentRight;
            
            weakSelf.customerArray = @[@[model1,model2,bigModel],@[model4,model5,model6,model7,model8]];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.customerArray];
            
            if (weakSelf.workLogList.count) {
                //                [tempArray addObject:weakSelf.workLogList];
                NSMutableArray *tempFrameArray = [NSMutableArray array];
                for (WorkLog *object in weakSelf.workLogList) {
                    CustomerDetailNoteFrameModel *frameModel = [[CustomerDetailNoteFrameModel alloc] init];
                    frameModel.cellData = object;
                    [tempFrameArray addObject:frameModel];
                }
                [tempArray addObject:tempFrameArray];
            }
            //            self.dataSource = ;
            weakSelf.dataSource = [tempArray copy];
            [self.tableView reloadData];
        }else{
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CustomerDetailInfoCell *cell = [CustomerDetailInfoCell cellWithTableView:tableView];
//    cell.cellData = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section<2) {
        CustomerDetailInfoCell *cell = [CustomerDetailInfoCell cellWithTableView:tableView];
//        cell.cellData = self.dataSource[indexPath.section][indexPath.row];
        id data = self.dataSource[indexPath.section][indexPath.row];
        if ([data isKindOfClass:[CustomerDetailBigFrameModel class]]) {
            cell.frameCellData = data;
        }else{
            cell.cellData = data;
        }
        cell.cellIndex = indexPath;
        cell.delegate = self;
        return cell;
    }else{
        CustomerDetailNoteCell *cell = [CustomerDetailNoteCell cellWithTableView:tableView];
        cell.cellData = self.dataSource[indexPath.section][indexPath.row];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        return cell;
    }
//    return cell;
}

-(NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:KRedColorLight title:@"删除"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.section<2) {
            id data = self.dataSource[indexPath.section][indexPath.row];
            if ([data isKindOfClass:[CustomerDetailBigFrameModel class]]) {
                CustomerDetailBigFrameModel *model = (CustomerDetailBigFrameModel *)data;
                return model.cellHeight;
            }else{
                return 50*SMMatchWidth;
            }
        }else{
            CustomerDetailNoteFrameModel *model = self.dataSource[indexPath.section][indexPath.row];
            return model.cellHeight;
        }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return @"客户备注";
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 30;
            break;
        default:
            return 0.1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerDetailBaseModel *model = self.dataSource[indexPath.section][indexPath.row];
    if ([model isKindOfClass:[CustomerDetailBigFrameModel class]]) {
        
    }
    if ([model isKindOfClass:[CustomerDetailBaseModel class]]) {
        if (model.option) {
            model.option();
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - CustomerDetailInfoFooterViewDelegate
-(void)addNewNoteButtonClickWithStr:(NSString *)text{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[SKAPI shared] writeCommentByCustomerId:self.customer.id andContent:text block:^(id result, NSError *error) {
        if (!error) {
            [self requestData];
        }else{
            
        }
    }];
}
#pragma mark - CustomerDetailInfoCellDelegate
-(void)cellButtonClickWithIndex:(NSIndexPath *)index withButtonNumber:(int)number{
    if (index.section == 0 && index.row == 1) {
        switch (number) {
            case 0:
            {
                if(self.customer.phone.length<=0){
                    return;
                }
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc]init];
                //设置短信内容
                vc.body = @"";
                //设置收件人列表
                NSArray *messageArray = [NSArray arrayWithObject:self.customer.phone];
                vc.recipients = messageArray;
                //设置代理
                vc.messageComposeDelegate = self;
                //显示控制器
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 1:
            {
                if(self.customer.phone.length<=0){
                    return;
                }
                UIWebView *webView = [[UIWebView alloc]init];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.customer.phone]];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];
            }
                break;
            default:
                break;
        }
    }
    if (index.section == 1 && index.row == 0 ) {
        if (number == 0) {
            if (self.customer.email.length) {
                if(![MFMailComposeViewController canSendMail]) return;
                MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
                //设置邮件主题
                [vc setSubject:@""];
                //设置邮件内容
                [vc setMessageBody:@"" isHTML:NO];
                //设置收件人列表
                NSArray *messageArray = [NSArray arrayWithObject:self.customer.email];
                [vc setToRecipients:messageArray];
                //设置代理
                vc.mailComposeDelegate = self;
                //显示控制器
                [self presentViewController:vc animated:YES completion:nil];
            }
            
        }
        
    }
}

/**
 *  点击取消按钮会自动调用
 *
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            MJWeakSelf
            WorkLog *workLog = self.workLogList[cellIndexPath.row];
            [[SKAPI shared] deleteCommentByCustomerId:self.customer.id andLogId:workLog.id block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"删除成功");
//                    NSIndexPath *index = [NSIndexPath indexPathForRow:cellIndexPath.row inSection:0];
                    [weakSelf.workLogList removeObjectAtIndex:cellIndexPath.row];
                    if (weakSelf.workLogList.count) {
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.customerArray];
                        NSMutableArray *tempFrameArray = [NSMutableArray array];
                        for (WorkLog *object in weakSelf.workLogList) {
                            CustomerDetailNoteFrameModel *frameModel = [[CustomerDetailNoteFrameModel alloc] init];
                            frameModel.cellData = object;
                            [tempFrameArray addObject:frameModel];
                        }
                        [tempArray addObject:tempFrameArray];
                        weakSelf.dataSource = [tempArray copy];
                    }else{
                        weakSelf.dataSource = weakSelf.customerArray;
                    }
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    SMLog(@"删除失败");
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - CreatNewCustomerViewControllerDelegate
-(void)saveNewCustomerSuccessWithCustomer:(Customer *)customer{
    _customer = customer;
    [self setCustomerArrayWith:customer];
    if (self.workLogList.count) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.customerArray];
        NSMutableArray *tempFrameArray = [NSMutableArray array];
        for (WorkLog *object in self.workLogList) {
            CustomerDetailNoteFrameModel *frameModel = [[CustomerDetailNoteFrameModel alloc] init];
            frameModel.cellData = object;
            [tempFrameArray addObject:frameModel];
        }
        [tempArray addObject:tempFrameArray];
        self.dataSource = [tempArray copy];
    }else{
        self.dataSource = self.customerArray;
    }
    [self.tableView reloadData];
}

-(void)setCustomerArrayWith:(Customer *)customer{
    
    CustomerDetailArrowModel *model1 = [[CustomerDetailArrowModel alloc] init];
    model1.title = @"已成交订单数";
    model1.iconImage = @"customer01";
    model1.detailText = [NSString stringWithFormat:@"%ld",(long)self.customer.sumOrder];
    model1.textAlignment = DetailTextAlignmentCenter;
    model1.option = ^(){
        CompleteOrderViewController *vc = [[CompleteOrderViewController alloc] init];
        vc.phone = self.customer.phone;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    CustomerDetailTwoFooterImage *model2 = [[CustomerDetailTwoFooterImage alloc] init];
    model2.title = @"客户电话";
    model2.iconImage = @"customer02";
    model2.detailText = self.customer.phone;
    model2.textAlignment = DetailTextAlignmentRight;
    model2.imageArray = @[@"联系掌柜00",@"customer10"];
    
    CustomerDetailJustHeightModel *model3 = [[CustomerDetailJustHeightModel alloc] init];
    model3.title = @"客户地址";
    model3.iconImage = @"customer03";
    model3.detailText = self.customer.address;
    
    CustomerDetailBigFrameModel *bigModel = [[CustomerDetailBigFrameModel alloc] init];
    bigModel.cellModel = model3;
    
    
    CustomerDetailOneFooterImage *model4 = [[CustomerDetailOneFooterImage alloc] init];
    model4.title = @"客户邮箱";
    model4.iconImage = @"customer04";
    model4.detailText = self.customer.email;
    model4.detailImage = @"customer09";
    model4.textAlignment = DetailTextAlignmentRight;
    
    
    CustomerDetailBaseModel *model5 = [[CustomerDetailBaseModel alloc] init];
    model5.title = @"客户标签";
    model5.iconImage = @"customer05";
    model5.detailText = self.customer.target;
    model5.textAlignment = DetailTextAlignmentRight;
    
    
    SMLog(@"self.customer.purpose  setCustomerArrayWith   %@",self.customer.purpose);
    NSArray *productArray = [self.customer.purpose componentsSeparatedByString:@","];
    MJWeakSelf
    CustomerDetailArrowModel *model6 = [[CustomerDetailArrowModel alloc] init];
    model6.title = @"意向商品";
    model6.iconImage = @"customer06";
    if ([self.customer.purpose isEqualToString:@""] || [self.customer.purpose isEqualToString:@"请选择意向商品"]) {
        model6.detailText = @"0";
    }else{
        model6.detailText = [NSString stringWithFormat:@"%lu",(unsigned long)productArray.count];
    }
    
    model6.textAlignment = DetailTextAlignmentRight;
    model6.option = ^(){
        IntentionProductViewController *vc = [[IntentionProductViewController alloc] init];
        vc.productArray = productArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    NSString *IntentionLevel;
    switch (self.customer.buyRating) {
        case 0:
        {
            IntentionLevel = @"A";
        }
            break;
        case 1:
        {
            IntentionLevel = @"B";
        }
            break;
        case 2:
        {
            IntentionLevel = @"C";
        }
            break;
        default:
            IntentionLevel = @"";
            break;
    }
    
    CustomerDetailBaseModel *model7 = [[CustomerDetailBaseModel alloc] init];
    model7.title = @"购买等级";
    model7.iconImage = @"customer07";
    model7.detailText = IntentionLevel;
    model7.textAlignment = DetailTextAlignmentRight;
    
    NSString *customerLevel;
    switch (self.customer.level) {
        case 0:
        {
            customerLevel = @"Vip";
        }
            break;
        case 1:
        {
            customerLevel = @"大型客户";
        }
            break;
        case 2:
        {
            customerLevel = @"中型客户";
        }
            break;
        case 3:
        {
            customerLevel = @"小型客户";
        }
            break;
        default:
            customerLevel = @"";
            break;
    }
    
    CustomerDetailBaseModel *model8 = [[CustomerDetailBaseModel alloc] init];
    model8.title = @"客户级别";
    model8.iconImage = @"customer08";
    model8.detailText = customerLevel;
    model8.textAlignment = DetailTextAlignmentRight;
    
    self.customerArray = @[@[model1,model2,bigModel],@[model4,model5,model6,model7,model8]];
    
}

@end
