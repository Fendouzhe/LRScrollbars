//
//  SMActionViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMActionViewController.h"
#import "SMActionCollectionViewCell.h"
#import "SMActionCollectionViewCell2.h"
#import "SMCheatView.h"
#import "AppDelegate.h"
//#import "SMNumOfExtensionViewController.h"

@interface SMActionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic ,assign)CGFloat section2ItemH;
/**
 *  当前时间
 */
@property (nonatomic ,copy)NSString *currentTimeStr;
/**
 *  活动结束时间
 */
@property (nonatomic ,copy)NSString *actionEndTimeStr;

@property (nonatomic ,strong)SMActionCollectionViewCell *TopCell;
/**
 *  加入微推广按钮
 */
@property (nonatomic ,strong)UIButton *joinBtn;

@property (nonatomic ,strong)UIView *bottomView;

@property (nonatomic ,assign)NSInteger bottomViewH;

@property(nonatomic,strong)SMCheatView * cheatView;

@property(nonatomic,strong)UIAlertView * popAlertView;

@end

@implementation SMActionViewController

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
}

#pragma mark --  懒加载
//- (UICollectionView *)collectionView{
//    if (_collectionView == nil) {
//        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.topViewHeight+ self.topViewHeight, KScreenWidth, KScreenHeight - self.topViewHeight - self.topViewHeight - KStateBarHeight - KTabBarHeight) collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView. delegate = self ;
//        _collectionView. dataSource = self ;
//    }
//    return _collectionView;
//}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight - KStateBarHeight - KTabBarHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KStateBarHeight - KTabBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView. delegate = self;
        _collectionView. dataSource = self;
    }
    return _collectionView;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIPhone5) {
        self.bottomViewH = 49;
    }else if (isIPhone6){
        self.bottomViewH = 49 *KMatch6;
    }else if (isIPhone6p){
        self.bottomViewH = 49 *KMatch6p;
    }
    
    
    [self setupNav];
    
    [self.view addSubview:self.collectionView];
    [self addBottomView];
    
    
//    [[SKAPI shared] queryActivityById:self.activity.id block:^(Activity *activity, NSError *error) {
//        if (!error) {
//            SMLog(@"activity  %@",activity);
//        }else{
//            SMLog(@"error   %@",error);
//        }
//    }];
}

- (void)addBottomView{
    //最下面的按钮整体 view
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        NSNumber *height = [NSNumber numberWithInteger:self.bottomViewH];
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(height);
    }];
    //灰色横线
    UIView *grayLine = [[UIView alloc] init];
    [bottomView addSubview:grayLine];
    grayLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    
    UIButton * counterBtn = [[UIButton alloc]init];
    [bottomView addSubview:counterBtn];
    
    counterBtn.backgroundColor = SMColor(255, 66, 62);
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict2[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"进入柜台" attributes:dict2];
    [counterBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    
    //自定义button
    
    [counterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        CGFloat height;
        //        if (isIPhone5) {
        //            height = 40;
        //        }else if (isIPhone6){
        //            height = 40 *KMatch6;
        //        }else if (isIPhone6p){
        //            height = 40 *KMatch6p;
        //        }
        NSNumber *heightNum = [NSNumber numberWithFloat:self.bottomViewH];
        NSNumber * widthNum = [NSNumber numberWithFloat:KScreenWidth/5.0];
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        //make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.width.equalTo(widthNum);
        make.height.equalTo(heightNum);
    }];
    
    [counterBtn addTarget:self action:@selector(counterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //加入微推广按钮
    UIButton *joinBtn = [[UIButton alloc] init];
    [bottomView addSubview:joinBtn];
    self.joinBtn = joinBtn;
    joinBtn.backgroundColor = SMColor(255, 161, 45);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"上架微柜台" attributes:dict];
    [joinBtn setAttributedTitle:str forState:UIControlStateNormal];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        CGFloat height;
//        if (isIPhone5) {
//            height = 40;
//        }else if (isIPhone6){
//            height = 40 *KMatch6;
//        }else if (isIPhone6p){
//            height = 40 *KMatch6p;
//        }
        NSNumber *heightNum = [NSNumber numberWithFloat:self.bottomViewH];
        NSNumber * widthNum = [NSNumber numberWithFloat:KScreenWidth/5.0*2];
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(counterBtn.mas_right).with.offset(0);
        //make.right.equalTo(bottomView.mas_right).with.offset(-25);
        make.width.equalTo(widthNum);
        make.height.equalTo(heightNum);
    }];
    [joinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *subBtn = [[UIButton alloc] init];
    [bottomView addSubview:subBtn];
    //self.joinBtn = joinBtn;
    subBtn.backgroundColor = SMColor(255, 66, 62);
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    dict1[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"下架微柜台" attributes:dict1];
    [subBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        CGFloat height;
        //        if (isIPhone5) {
        //            height = 40;
        //        }else if (isIPhone6){
        //            height = 40 *KMatch6;
        //        }else if (isIPhone6p){
        //            height = 40 *KMatch6p;
        //        }
        NSNumber *heightNum = [NSNumber numberWithFloat:self.bottomViewH];
        NSNumber * widthNum = [NSNumber numberWithFloat:KScreenWidth/5.0*2];
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(joinBtn.mas_right).with.offset(0);
        //make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.width.equalTo(widthNum);
        make.height.equalTo(heightNum);
    }];
    [subBtn addTarget:self action:@selector(subBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

-(SMCheatView *)cheatView
{
    if (!_cheatView) {
        _cheatView = [SMCheatView initWithID:self.activity.id andType:1 andHeight:64];
        
        _cheatView.pushblock =^(UIViewController * Vc){
            [self.navigationController pushViewController:Vc animated:YES];
        };
        [self.view addSubview:_cheatView];
    }
    return _cheatView;
}
//加入微推广
- (void)joinBtnClick{
    SMLog(@"点击了 上架微柜台 按钮");
    self.cheatView.isCounter = NO;
    if (!self.isPushCounter) {
        //sender.enabled = YES;
        [self.cheatView requestshelfData];
    }else
    {
        if (self.isup) {
            [self addProduct];
        }
    }
    
    

    if (self.arrActionIDs.count >= 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的，一个货架最多只能添加5个活动哦～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KAddActionKey] = self.activity.id;
    [[NSNotificationCenter defaultCenter] postNotificationName:KAddActionNote object:self userInfo:dict];
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}

-(void)subBtnClick
{
    SMLog(@"点击了 下架微柜台按钮");
    self.cheatView.isCounter = NO;
    
    if (!self.isPushCounter) {
        [self.cheatView CounterCheck];
    }else
    {
        if (!self.isup) {
            [self cutoutProduct];
        }
    }
}

-(void)counterBtnClick:(UIButton *)btn
{
    SMLog(@"点击了 进入柜台的按钮");
    
    self.cheatView.isCounter = YES;
    [self.cheatView CounterCheck];
}

- (void)setupNav{
    //self.title = @"adidas活动专场";
    self.title = self.activity.name;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 22;
    rightBtn.height = 22;
    [rightBtn setImage:[UIImage imageNamed:@"zhuangfa"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBtnClick{
    SMLog(@"点击了 右边的转发/分享按钮");
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView{
    return 2 ;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath{
    
//    if (indexPath.section == 0) {
//        UINib *nib = [UINib nibWithNibName:@"SMActionCollectionViewCell" bundle:[NSBundle mainBundle]];
//        [collectionView registerNib:nib forCellWithReuseIdentifier:@"actionCollectionViewCell"];
//        SMActionCollectionViewCell *cell = [SMActionCollectionViewCell actionCollectionViewCell];
//        //模型赋值
//        cell.activity = self.activity;
//        SMLog(@"%@",self.activity.imagePaths);
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"actionCollectionViewCell" forIndexPath:indexPath];
//        self.TopCell = cell;
//        return cell;
//    }else{
//        UINib *nib = [UINib nibWithNibName:@"SMActionCollectionViewCell2" bundle:[NSBundle mainBundle]];
//        [collectionView registerNib:nib forCellWithReuseIdentifier:@"actionCollectionViewCell2"];
//        SMActionCollectionViewCell2 *cell = [SMActionCollectionViewCell2 actionCollectionViewCell2];
//        self.section2ItemH = cell.cellHeight;
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"actionCollectionViewCell2" forIndexPath:indexPath];
//        return cell;
//    }
    if (indexPath.section ==0) {
        //注册一次就够了
        UINib *nib = [UINib nibWithNibName:@"SMActionCollectionViewCell" bundle:[NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"actionCollectionViewCell"];
        
        SMActionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"actionCollectionViewCell" forIndexPath:indexPath];
        [cell refreshUI:self.activity];
        self.TopCell = cell;
        return cell;
    }else
    {
        UINib *nib = [UINib nibWithNibName:@"SMActionCollectionViewCell2" bundle:[NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"actionCollectionViewCell2"];
        
        SMActionCollectionViewCell2 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"actionCollectionViewCell2" forIndexPath:indexPath];
        //[cell refreshUI:self.activity];
        return cell;
    }
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    SMLog(@"点击了 collectionViewCell %zd组  %zd个",indexPath.section,indexPath.row);
//    SMDetailStoreHouseController *detailVc = [[SMDetailStoreHouseController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:detailVc animated:YES];
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    
    return YES;
}

//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CGFloat height;
        if (isIPhone5) {
            height = 200;
        }else if (isIPhone6){
            height = 200 *KMatch6;
        }else if (isIPhone6p){
            height = 200 *KMatch6p;
        }
        return CGSizeMake(KScreenWidth, height);
    }else{
        CGFloat w;
        CGFloat h = 230;
        if (isIPhone5) {
            w = 145;
        }else if (isIPhone6){
            w = 145 *KMatch6;
        }else if (isIPhone6p){
            w = 145 *KMatch6p;
        }
        return CGSizeMake (w , h);
    }
}

//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section{
    
    return UIEdgeInsetsMake (10 ,10 ,10 ,10);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.TopCell.timer invalidate];
    self.TopCell.timer = nil;
}


//删除商品
-(void)cutoutProduct
{
    NSArray * array = [[NSArray alloc]initWithObjects:self.favorites.id, nil];
    
    [[SKAPI shared] removeItem:self.activity.id fromMyStorage:array andType:1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result = %@",result);
            //通知刷新
            NSNotification * notice = [NSNotification notificationWithName:@"RefreshData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
            
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

//添加商品
-(void)addProduct
{
    
    //难道要请求一次   1.获取到有多少的产品  2.获取到已有产品  防止重复添加
    [[SKAPI shared] queryMyStorageItems:self.favorites.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"%@",array);
            NSInteger i = 0;
            for (FavoritesDetail * fav in array) {
                if (fav.type == 1) {
                    i++;
                }
            }
            if (i==5) {
                UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"一个专柜最多添加5个活动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerView show];
            }else
            {
                for (FavoritesDetail *  favDetail in array) {
                    if ([self.activity.id isEqualToString: favDetail.itemId]) {
                        UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该活动已在专柜中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alerView show];
                        return ;
                    }
                }
                [self add];
            }
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}
-(void)add
{
    NSArray * array = [[NSArray alloc]initWithObjects:self.favorites.id, nil];
    [[SKAPI shared] addItem:self.activity.id toMyStorage:array andType:1 block:^(id result, NSError *error) {
        
        if (!error) {
            SMLog(@"result = %@",result);
            NSNotification * notice = [NSNotification notificationWithName:@"RefreshData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            self.popAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上架成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.popAlertView show];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.popAlertView) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
