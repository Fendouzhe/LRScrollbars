//
//  SMHomePageCellSection1.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMHomePageCellSection1.h"
#import "SMHomePageCollectionCell3.h"
#import "SMHomePageCollectionCell4.h"
#import "SMHomePageCollectionCell5.h"
#import "UIView+Badge.h"

#define HomePageCollectionCellTagOff 1000

@interface SMHomePageCellSection1 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMHomePageCollectionCell5Delegate>

@property (nonatomic ,strong)UICollectionView *collectionView;/**< collectionView */

@property (nonatomic ,strong)NSArray *arrNames;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrImages;/**< <#注释#> */

@end

@implementation SMHomePageCellSection1

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"homePageCellSection1";
    SMHomePageCellSection1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMHomePageCellSection1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线"];
//        cell.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线"];
        cell.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线",@"客户管理",@"协同任务",@"客服连线"];
//        cell.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线",@"100-客户管理",@"renwurichegn",@"kehuNew"];
        
        cell.arrImages = @[@"收入",@"合伙人",@"订单",@"伙伴连线",@"客户管理-1",@"协同任务",@"客服连线"];
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collectionView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBageNotifi:) name:ShowBageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBageNotifi:) name:HiddenBageNotification object:nil];
    }
    return self;
}
#pragma mark --  显示掩藏红点
- (void)showBageNotifi:(NSNotification *)notice{
    NSInteger tag = [notice.userInfo[@"tag"] integerValue] + HomePageCollectionCellTagOff;
    SMHomePageCollectionCell4 *cell = [self.collectionView viewWithTag:tag];
    [cell showBadge];
}

- (void)hiddenBageNotifi:(NSNotification *)notice{
    NSInteger tag = [notice.userInfo[@"tag"] integerValue] + HomePageCollectionCellTagOff;
    SMHomePageCollectionCell4 *cell = [self.collectionView viewWithTag:tag];
    [cell removeBadge];
}

#pragma mark -- <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-  (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.arrNames.count;
    }
//    else if (section == 2){
//        return 1;
//    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//分销管理标题
        SMHomePageCollectionCell3 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier1 forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){//模块
        SMHomePageCollectionCell4 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier2 forIndexPath:indexPath];
        cell.name = self.arrNames[indexPath.row];
        cell.imageName = self.arrImages[indexPath.row];
        cell.tag = indexPath.item + HomePageCollectionCellTagOff;
        //[cell showBadgeWith:@"2"];
        //防止复用，移除红点
        [cell removeBadge];
        return cell;
    }
//    else if (indexPath.section == 2){//更多按钮
//        [collectionView registerClass:[SMHomePageCollectionCell5 class] forCellWithReuseIdentifier:@"homePageCollectionCell5"];
//        SMHomePageCollectionCell5 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homePageCollectionCell5" forIndexPath:indexPath];
//        cell.delegate = self;
//        return cell;
//    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"indexPath.section   %zd   indexPath.row   %zd", indexPath.section,indexPath.row);
    
    if ([self.delegate respondsToSelector:@selector(itemDidSelected:)]) {
        [self.delegate itemDidSelected:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(KScreenWidth, 25 *SMMatchHeight);
    }else if (indexPath.section == 1){
        return CGSizeMake(KScreenWidth / 4.0, (5 + 25 + 5 + 15 + 5) *SMMatchHeight);
    }
//    else if (indexPath.section == 2){
//        return CGSizeMake(KScreenWidth, 25 *SMMatchHeight);
//    }
    return CGSizeMake(0, 0);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//- (void)setIsOpen:(BOOL)isOpen{
//    _isOpen = isOpen;
//    if (isOpen) {
//        self.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线",@"客户管理",@"外勤签到",@"协同任务",@"客服连线"];
//        self.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线",@"100-客户管理",@"qiandao",@"renwurichegn",@"kehuNew"];
//    }else{
//        self.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线"];
//        self.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线"];
//    }
//}

//- (void)setIsOpen:(BOOL)isOpen{
//    _isOpen = isOpen;
//    if (isOpen) {
//        self.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线",@"客户管理",@"协同任务",@"客服连线"];
//        self.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线",@"100-客户管理",@"renwurichegn",@"kehuNew"];
//    }else{
//        self.arrNames = @[@"我的收入",@"合伙人",@"订单管理",@"伙伴连线"];
//        self.arrImages = @[@"我的收入",@"100-合伙人",@"100-订单管理",@"100-伙伴连线"];
//    }
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

#pragma mark -- 代理点击 更多按钮点击
//- (void)moreBtnDidClick:(UIButton *)btn{
//    
//    self.isOpen = btn.selected;
//    if ([self.delegate respondsToSelector:@selector(moreBtnDidClick2:)]) {
//        [self.delegate moreBtnDidClick2:btn];
//    }
//    [self.collectionView reloadData];
//}

static NSString *const reuserIdentifier1 = @"homePageCollectionCell3";
static NSString *const reuserIdentifier2 = @"homePageCollectionCell4";
#pragma mark -- 懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[SMHomePageCollectionCell3 class] forCellWithReuseIdentifier:reuserIdentifier1];
        [_collectionView registerClass:[SMHomePageCollectionCell4 class] forCellWithReuseIdentifier:reuserIdentifier2];
    }
    return _collectionView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
