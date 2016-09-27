//
//  SMStatusTrackingViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/2.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMStatusTrackingViewController.h"
#import "SMOrderDetailSection0Cell.h"
#import "SMStatusTrackingCell.h"
#import "AppDelegate.h"
#import "SMTrackInfo.h"



#define KBEditPen 32
@interface SMStatusTrackingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong)UITableView *tableView;
/**
 *  输入框
 */
@property (nonatomic ,strong)UITextField *inputField;
/**
 *  用来控制键盘弹位置起的margin
 */
@property (nonatomic ,assign)CGFloat margin;

/**
 *  下面的添加物流状态的数据
 */
@property (nonatomic , copy)NSMutableArray * dataArray;

@property (nonatomic ,strong)SalesOrder *order;


@end

@implementation SMStatusTrackingViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.bottomView];
    self.title = @"状态跟踪";
    
    [self addBottomView];
    
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
    
    [self LoadNewData];
    
    [[SKAPI shared] queryOrder:self.saleOrder.sn block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"%@",result);
            
            SalesOrder * order = (SalesOrder *)result;
            
            self.saleOrder = order;
            
            [self.tableView reloadData];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

- (void)addBottomView{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, KScreenHeight - 64 - 50, KScreenWidth, 50);
    //添加状态 按钮
    UIButton *addStatusBtn = [[UIButton alloc] init];
    [bottomView addSubview:addStatusBtn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"添加状态" attributes:dict];
    [addStatusBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    addStatusBtn.backgroundColor = KRedColorLight;
    addStatusBtn.layer.cornerRadius = SMCornerRadios;
    addStatusBtn.clipsToBounds = YES;
    [addStatusBtn addTarget:self action:@selector(addStatusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(bottomView.mas_right).with.offset(-10);
        make.width.equalTo(@58);
        make.height.equalTo(@27);
    }];
    
    //输入框
    UITextField *inputField = [[UITextField alloc] init];
    [bottomView addSubview:inputField];
    self.inputField = inputField;
    inputField.delegate = self;
    inputField.returnKeyType = UIReturnKeyDone;
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(addStatusBtn.mas_left).with.offset(-10);
        make.left.equalTo(bottomView.mas_left).with.offset(10);
    }];
    
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else{
        //要根据实际网络数据来写
        return self.dataArray.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//第0组
        SMOrderDetailSection0Cell *cell = [SMOrderDetailSection0Cell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"订单编号";
            cell.rightLabel.text = self.orderString;
            
        }else if (indexPath.row == 1){
            cell.leftLabel.text = @"发货时间";
            if (self.saleOrder.sendTime) {
                cell.rightLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",self.saleOrder.sendTime]];
            }else{
                cell.rightLabel.text = nil;
            }            
        }else if (indexPath.row == 2){
            cell.leftLabel.text = @"物流公司";
            cell.rightLabel.text = self.saleOrder.comCode;
            
        }else{
            cell.leftLabel.text = @"运单号";
            cell.rightLabel.text = self.saleOrder.shippingCode;
            
        }
        return cell;
    }else{//第1组
        if (indexPath.row == 0) {
            return [self cellWithTableView:tableView];
        }else{
            SMStatusTrackingCell *cell = [SMStatusTrackingCell cellWithTableView:tableView];
            if (indexPath.row != 1) {
//                cell.statusImageView.width = 10;
//                cell.statusImageView.height = 10;
                cell.statusImageView.image = [UIImage imageNamed:@"zhuangtaogzong02"];
                
                cell.timeLabel.textColor = [UIColor darkGrayColor];
                cell.addressLabel.textColor = [UIColor blackColor];
            }
            if (indexPath.row == 1) {
                cell.upGrayView.hidden = YES;
                
                cell.statusImageView.image = [UIImage imageNamed:@"zhaungtaigengzong"];
                
                cell.timeLabel.textColor = [UIColor redColor];
                cell.addressLabel.textColor = [UIColor redColor];
            }
            if (indexPath.row == self.dataArray.count) {
                cell.bottomGrayView.hidden = YES;
            }else{
                cell.bottomGrayView.hidden = NO;
            }
            
            if (self.dataArray.count>0) {
//                [cell refreshUI:self.dataArray[self.dataArray.count-(indexPath.row-1)-1]];
                cell.model = self.dataArray[indexPath.row - 1];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
}

- (UITableViewCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"statusTrackingSection1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"物流状态";
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) {
        CGFloat height;
        if (isIPhone5) {
            height = 38;
        }else if (isIPhone6){
            height = 38 *KMatch6;
        }else if (isIPhone6p){
            height = 38 *KMatch6p;
        }
        return height;
    }else{//物流状态
//        return 67;
        SMStatusTrackingCell * cell = (SMStatusTrackingCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];

            SMLog(@"cellheight =     %lf",cell.height);
            return cell.cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputField resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = [textField convertRect:textField.bounds toView:self.view];
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset + 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        
        SMLog(@"点击了键盘的搜索键  ，执行搜索代码");
        [self addStatusBtnClick];
    }
    return YES;
}


#pragma mark -- 点击事件
- (void)addStatusBtnClick{
    SMLog(@"点击了 添加状态 按钮");
    
    if ([self.inputField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可添加空状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[SKAPI shared] fillOrderTrackInfo:self.orderString andContent:self.inputField.text block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [self LoadNewData];
        }else{
            SMLog(@"%@",error);
        }
    }];
    
    [self.inputField resignFirstResponder];
    self.inputField.text = nil;
}


#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight -64-49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

//- (SMStatusTrackingBottomView *)bottomView{
//    if (_bottomView == nil) {
//        _bottomView = [SMStatusTrackingBottomView statusTrackingBottomView];
//        
//        _bottomView.frame = CGRectMake(0, KScreenHeight - 64 - 50, KScreenWidth, 50);
//    }
//    return _bottomView;
//}


-(void)LoadNewData{
    //快递状态
    SMLog(@"%@",self.orderString);
    [self.dataArray removeAllObjects];
    
    [[SKAPI shared] queryOrderTrackInfoById:self.orderString block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@   queryOrderTrackInfoById",result);
            
            
//            self.dataArray = [SMTrackInfo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"track_info"]];
            NSArray *arr = [SMTrackInfo mj_objectArrayWithKeyValuesArray:[result objectForKey:@"track_info"]];
            
            for (int i = (int)(arr.count - 1); i >= 0; i--) {
                [self.dataArray addObject:arr[i]];
            }
            
            [self.tableView reloadData];
            
        }else{
            SMLog(@"%@",error);
        }
    }];
}

@end
