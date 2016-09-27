//
//  SMTogetherBuy2Controller.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTogetherBuy2Controller.h"
#import "SMGroupbuyDetailList.h"
#import "SMPintuanSingleCollectionCell.h"
#import "SMPingtuanHeaderView.h"
#import "SMPintuanSpecialCollectionCell.h"
#import "SMTogetherBuyWebVc.h"

@interface SMTogetherBuy2Controller ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic ,strong)NSTimer *timer;

//特价拼团放送专场数据
@property (nonatomic ,strong)NSArray *arrData;/**< GroupBuyMaster */

//特价拼团单品专场数据
@property (nonatomic ,strong)NSMutableArray *groupbuyDetailArr;/*groupbuyDetailList*/

@end

@implementation SMTogetherBuy2Controller

- (NSMutableArray *)groupbuyDetailArr{
    if (_groupbuyDetailArr == nil) {
        _groupbuyDetailArr = [NSMutableArray array];
    }
    return _groupbuyDetailArr;
}

static NSString *const reuserIdentifier1 = @"SMPintuanSpecialCollectionCell";
static NSString *const reuserIdentifier8 = @"SMPintuanSingleCollectionCell";
static NSString *const headViewIdentifier = @"SMPingtuanHeaderView";

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - LRTitleScrollViewHeight - 49 + 10 ) collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = KTuiGuangVcBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SMPintuanSpecialCollectionCell class] forCellWithReuseIdentifier:reuserIdentifier1];
        [_collectionView registerClass:[SMPintuanSingleCollectionCell class] forCellWithReuseIdentifier:reuserIdentifier8];
        [_collectionView registerClass:[SMPingtuanHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewIdentifier];
    }
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLastTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self setupMJRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupMJRefresh{
    MJRefreshNormalHeader *TableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    self.collectionView.mj_header = TableViewheader;
}

- (void)getData{
    [[SKAPI shared] queryPromotionGroupBuyingList:10000 andLastTimestamp:0 block:^(id result, NSError *error) {
        if (!error) {
            
            SMLog(@"result  queryPromotionGroupBuyingList  %@",result);
            self.arrData = [GroupBuyMaster mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"groupbuyMasterList"]];
            NSArray * grouDetaiarr = [SMGroupbuyDetailList mj_objectArrayWithKeyValuesArray:[[result valueForKey:@"result"] valueForKey:@"groupbuyDetailList"]];
            //groupbuyStatus 为1的才显示
            [grouDetaiarr enumerateObjectsUsingBlock:^(SMGroupbuyDetailList *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (model.groupbuyStatus == 1) {
                    [self.groupbuyDetailArr addObject:model];
                }
            }];
            [self.collectionView reloadData];
            
        }else{
            SMLog(@"error   %@",error);
            [MBProgressHUD showError:@"网络不给力,请重试!"];
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)refreshLastTime{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshLastTimNotification object:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLastTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.arrData.count;
    }else{
        return self.groupbuyDetailArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SMPintuanSpecialCollectionCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier1 forIndexPath:indexPath];
        cell1.master = self.arrData[indexPath.item];
        return cell1;
    }else{
        
        SMPintuanSingleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier8 forIndexPath:indexPath];
        SMGroupbuyDetailList *model = self.groupbuyDetailArr[indexPath.item];
        cell.model = model;
        return cell;
    }
    return nil;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(KScreenWidth, 220 * KMatch);
    }else{
        return CGSizeMake((KScreenWidth - 3*10)/2, KTuiguangCollectionCellHeight * KMatch);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SMPingtuanHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.title = @"特价拼团放送专场";
    }else {
        headerView.title = @"特价拼团热销单品";
    }
    return headerView;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        SMPintuanSpecialCollectionCell *cell = (SMPintuanSpecialCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.master.clickState == 1) {//活动尚未开始
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动尚未开始" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //        [alert show];
            
            SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
            GroupBuyMaster *master = self.arrData[indexPath.row];
            vc.pId = master.id;
            vc.titleName = master.name;
            vc.imageUrl = [cell.master.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (cell.master.clickState == 2){//活动正在进行
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动正在进行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //        [alert show];
            
            SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
            GroupBuyMaster *master = self.arrData[indexPath.row];
            vc.pId = master.id;
            vc.titleName = master.name;
            vc.imageUrl = [cell.master.imagePath stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (cell.master.clickState == 3){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动已结束" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"其他情况" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
        
        SMGroupbuyDetailList *model = self.groupbuyDetailArr[indexPath.item];
        SMTogetherBuyWebVc *vc = [SMTogetherBuyWebVc new];
        vc.isSingle = YES;
        vc.pId = model.id;
        vc.titleName = model.productName;
        NSArray *imagePathArr = [NSString mj_objectArrayWithKeyValuesArray:model.imagePath];
        NSString *imageStr = imagePathArr[0];
        vc.imageUrl = [imageStr stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",KScreenWidth *2,170.0 *2 *2]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
//返回头部view宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.arrData.count == 0) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0);
        }else{
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
        }
    }else {
        if (self.groupbuyDetailArr.count == 0) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.0);
        }else{
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
        }
    }

    //return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 10;
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end
