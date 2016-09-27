//
//  SMJumpUpView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/3/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMJumpUpView.h"
#import "skuSelected.h"
#import "SMSection3Row1Cell.h"
#import "SMProductTopView.h"
#import "SMBuyCountCell.h"
#import "SMChooseNumCell.h"
#import "sku.h"
#import "ProductSpec.h"

@interface SMJumpUpView ()<UITableViewDelegate,UITableViewDataSource,SMSection3Row1CellDelegate>

@property (nonatomic ,assign)CGFloat cellHeight;

@property (nonatomic ,strong)UIView *bottomSureView;

@property (nonatomic ,strong)UIButton *sureBtn;

@property (nonatomic ,assign)CGFloat tableViewHeight;



@property (nonatomic ,strong)SMBuyCountCell *buyCountCell;

@property (nonatomic ,assign)BOOL isDianXin;

@property (nonatomic ,strong)SMChooseNumCell *phoneNumCell;

//预计最多出四个规格选项
@property (nonatomic ,strong)SMSection3Row1Cell *cell0;
@property (nonatomic ,strong)SMSection3Row1Cell *cell1;
@property (nonatomic ,strong)SMSection3Row1Cell *cell2;
@property (nonatomic ,strong)SMSection3Row1Cell *cell3;

@property (nonatomic ,copy)NSString *productSpecID;/**< 选择完规格之后的productId */

@end

@implementation SMJumpUpView

//+ (instancetype)jumpUpViewWithModle:(skuSelected *)skus{
//    return [[self alloc]  init];
//}

- (instancetype)init{
    if (self = [super init]) {
        
        //创建下面的确定按钮
        UIView *bottomSureView = [[UIView alloc]  init];
        self.bottomSureView = bottomSureView;
        [self addSubview:bottomSureView];
        bottomSureView.backgroundColor = [UIColor whiteColor];
        
        //红色确定按钮
        UIButton *sureBtn = [[UIButton alloc] init];
        self.sureBtn = sureBtn;
        [bottomSureView addSubview:sureBtn];
        sureBtn.backgroundColor = KRedColorLight;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        NSAttributedString *sureTitle = [[NSAttributedString alloc] initWithString:@"确  定" attributes:dict];
        [sureBtn setAttributedTitle:sureTitle forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius = SMCornerRadios;
        sureBtn.clipsToBounds = YES;
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //顶部view
        SMProductTopView *topView = [SMProductTopView productTopView];
        self.topView = topView;
        [self addSubview:topView];
        
        
        
        //创建tableView
        UITableView *tableView = [[UITableView alloc] init];
        self.tableView = tableView;
        [self addSubview:tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        self.skus = skus;
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userHasChoosedNum:) name:@"KChooseThePhoneNum" object:nil];
        
    }
    return self;
}

- (void)userHasChoosedNum:(NSNotification *)noti{
    
    SMLog(@"self.isDianxin   %zd",self.isDianxin);
    
    
    if (self.isDianxin) {  //如果是电信产品，才需要进行下面的拼接规格的操作。普通产品不需要拼接参数
        NSString *choosedNum;
        if (self.product.stock < 1) {
            choosedNum = nil;
        }else{
            choosedNum = noti.userInfo[@"KChooseThePhoneNumKey"];
//            choosedNum = @"";
        }
        
        SMLog(@"用户选择了号码   可以刷新一下 价格，库存等信息");
        
    }else{
        SMLog(@"普通商品");
        SMLog(@"self.cell0.selectedStr  %@",self.cell0.selectedStr);
    }
    
    [self sendSpecName];
}

- (void)selecteFirstItem{
    [self sendSpecName];
    SMLog(@"selecteFirstItem");
}

- (void)sendSpecName{
    NSString *SpecName = @"";
    if (self.cell0.selectedStr) {
        SpecName = [SpecName stringByAppendingString:[NSString stringWithFormat:@"%@",self.cell0.selectedStr]];
    }
    if (self.cell1.selectedStr){
        SpecName = [SpecName stringByAppendingString:[NSString stringWithFormat:@"/%@",self.cell1.selectedStr]];
    }
    if (self.cell2.selectedStr){
        SpecName = [SpecName stringByAppendingString:[NSString stringWithFormat:@"/%@",self.cell2.selectedStr]];
    }
    if (self.cell3.selectedStr){
        SpecName = [SpecName stringByAppendingString:[NSString stringWithFormat:@"/%@",self.cell3.selectedStr]];
    }
    
    SMLog(@"self.product.id  %@  SpecName  %@   self.cell1.selectedStr  %@",self.product.id,SpecName,self.cell1.selectedStr);
    
    [[SKAPI shared] queryProductSpec:self.product.id andSpecName:SpecName block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  queryProductSpec 普通商品  %@",result);
            
            if ([SpecName isEqualToString:@""]) {
                self.topView.chooseLabel.text = @"请选择规格";
            }else{
                self.topView.chooseLabel.text = SpecName;
            }
            
            
            ProductSpec *spec = [ProductSpec mj_objectWithKeyValues:result];
            //发通知刷新upview界面数据
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"KSpecificationsKey"] = spec;
            dict[@"KSpecificationsSpecName"] = SpecName;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSpecifications" object:nil userInfo:dict];
            
            //代理把 ProductSpec 这个模型传出去
            if ([self.deledate respondsToSelector:@selector(specificationsDidClick:)]) {
                [self.deledate specificationsDidClick:spec];
            }
            
        }else{
            SMLog(@"error  queryProductSpec   %@",error);
        }
    }];

}

- (void)setProduct:(Product *)product{
    _product = product;
    self.topView.product = product;
    if ([product.classModel isEqualToString:@"dianxin"]) {
        self.isDianXin = YES;
    }
    SMLog(@"product.classModel   %@",product.classModel);
}

- (void)setArrSkus:(NSArray *)arrSkus{
    _arrSkus = arrSkus;
    self.topView.arrSkus = arrSkus;
}

- (void)sureBtnClick{
    
    NSString *str1 = [self.topView.stockLabel.text substringFromIndex:2]; //截掉前面的“库存两个字”
    NSString *str2 = [str1 substringToIndex:str1.length - 1];  //截掉后面的“字” 一个字
    SMLog(@"str1  %@ str1.length %zd   str2  %@" ,str1,str1.length,str2);
//    SMLog(@"self.buyCountCell.numLabel.text.integerValue  %zd  self.topView.product.stock  %zd",self.buyCountCell.numLabel.text.integerValue,self.topView.product.stock);
    if (self.buyCountCell.numLabel.text.integerValue > str2.integerValue) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，暂时没有这么多的库存哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [self sendSpecName];
    
    if ([self.deledate respondsToSelector:@selector(sureBtnDidClick:andPhoneNum:)]) {
        [self.deledate sureBtnDidClick:self.buyCountCell.buyNum andPhoneNum:self.phoneNumCell.phoneNumLable.text];
    }
    
    SMLog(@"sureBtnClick  %zd",self.buyCountCell.buyNum);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.isDianXin) { //如果是电信的商品，需要多一行选号的选项
//        return self.arrSkus.count + 1 + 1;
//    }else{
//        return self.arrSkus.count + 1;
//    }
    if (!self.isBelongCounter && !self.isDianxin) { //如果不是微柜台的，且不属于电信类商品的。不显示购买数量。
        return self.arrSkus.count;
    }
    
    return self.arrSkus.count + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isDianXin) { //如果是电信商品
        if (indexPath.row == self.arrSkus.count) { //选择号码
            SMChooseNumCell *cell = [SMChooseNumCell cellWithTableView:tableView];
            self.phoneNumCell = cell;
            return cell;
        }else{  //基本的商品规格
            SMSection3Row1Cell *cell = [SMSection3Row1Cell cellWithTableView:tableView andModel:self.arrSkus[indexPath.row]];
            cell.isDianxin = self.isDianxin;
            cell.isBelongCounter = self.isBelongCounter;
            if (indexPath.row == 0) {
                self.cell0 = cell;
            }else if (indexPath.row == 1){
                self.cell1 = cell;
            }else if (indexPath.row == 2){
                self.cell2 = cell;
            }else if (indexPath.row == 3){
                self.cell3 = cell;
            }
            
            
            SMLog(@"self.arrSkus   %@",self.arrSkus);
            for (sku *m in self.arrSkus) {
                SMLog(@"m.text   %@      m.id  %zd   m.propList   %@",m.text,m.id,m.propList);
            }
            self.cellHeight = cell.cellHeight;
            return cell;
        }
    }else{ //如果是普通商品
        if (indexPath.row == self.arrSkus.count) {
            SMBuyCountCell *cell = [SMBuyCountCell cellWithTableView:tableView];
            self.buyCountCell = cell;
            return cell;
        }else{
            SMSection3Row1Cell *cell = [SMSection3Row1Cell cellWithTableView:tableView andModel:self.arrSkus[indexPath.row]];
            cell.delegate = self;
            self.cellHeight = cell.cellHeight;
            cell.isBelongCounter = self.isBelongCounter;
            if (indexPath.row == 0) {
                self.cell0 = cell;
            }else if (indexPath.row == 1){
                self.cell1 = cell;
            }else if (indexPath.row == 2){
                self.cell2 = cell;
            }else if (indexPath.row == 3){
                self.cell3 = cell;
            }
            return cell;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDianXin) {
        if (indexPath.row == self.arrSkus.count + 1) {
            return 44;
        }else{
            if (self.cellHeight <= 85) {
                return 85;
            }else{
                return self.cellHeight;
            }
        }
    }else{
        if (indexPath.row == self.arrSkus.count) {
            return 44;
        }else{
            if (self.cellHeight <= 85) {
                return 85;
            }else{
                return self.cellHeight;
            }
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDianXin && indexPath.row == self.arrSkus.count) { //如果是电信商品，并且选择的是选择号码.跳到选择号码界面
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.isBelongCounter) {
            dict[@"chooseNumNotiKey"] = @"1";
        }else{
            dict[@"chooseNumNotiKey"] = @"0";
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseNumNoti" object:nil userInfo:dict];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SMLog(@"%zd",indexPath.row);
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //最下面确定view
    [self.bottomSureView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@49);
    }];
    
    //确定按钮
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.bottomSureView.mas_right).with.offset(-20);
        make.left.equalTo(self.bottomSureView.mas_left).with.offset(20);
        make.bottom.equalTo(self.bottomSureView.mas_bottom).with.offset(-2);
        make.top.equalTo(self.bottomSureView.mas_top).with.offset(2);
    }];
    
    //顶部view
    CGFloat topViewHeight;
    if (isIPhone5) {
        topViewHeight = 79;
    }else if (isIPhone6){
        topViewHeight = 79 *KMatch6Height;
    }else if (isIPhone6p){
        topViewHeight = 79 *KMatch6pHeight;
    }
    NSNumber *topViewHeightNum = [NSNumber numberWithFloat:topViewHeight];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.equalTo(topViewHeightNum);
    }];
    
    
    //tableView
    CGFloat upViewHeight;
    if (isIPhone5) {
        upViewHeight = 398;
    }else if (isIPhone6){
        upViewHeight = 398 *KMatch6Height;
    }else if (isIPhone6p){
        upViewHeight = 398 *KMatch6pHeight;
    }
    SMLog(@" self.topView.height  %f", self.topView.height);
    SMLog(@" self.bounds.size.height - self.topView.height - self.bottomSureView.height  %f", self.bounds.size.height - self.topView.height - self.bottomSureView.height);
    self.tableView.frame = CGRectMake(0, topViewHeight, KScreenWidth, upViewHeight - 49 - topViewHeight);
}

@end
