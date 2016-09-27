//
//  SMShelfTemplateViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/7.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfTemplateViewController.h"
#import "SMTemplateCell.h"
#import "SMNumShelfViewController.h"
#import "LocalFavorites.h"
#import "AppDelegate.h"


#define KShelfMaxCount 10
@interface SMShelfTemplateViewController ()<UITableViewDataSource,UITableViewDelegate,SMTemplateCellDelegate>

/**
 *  装微货架模版的数组
 */
@property (nonatomic ,strong)NSMutableArray *shelfTemplates;

/**
 *  当前使用的是几号微货架
 */
@property (nonatomic ,assign)NSInteger currentShelfNum;

/**
 *  每个cell的颜色显示
 */
@property (nonatomic ,strong)NSArray *arrColor;
/**
 *  添加模版按钮
 */
@property (nonatomic ,strong)UIView *bottomView;
/**
 *  删除按钮
 */
@property (nonatomic ,strong)UIView *bottomViewDelete;

@property (nonatomic ,strong)UITableView *tableView;
/**
 *  已经显示出来cell 都装进这个数组
 */
@property (nonatomic ,strong)NSMutableArray *arrCell;

/**
 *  处于右移状态
 */
@property (nonatomic ,assign)BOOL atRight;
/**
 *  全选按钮左边的勾勾按钮
 */
@property (nonatomic ,strong)UIButton *gouBtn;

@property (nonatomic ,strong)NSMutableArray *arrShelfs;

/**
 *  需要删除的微货架ID 数组
 */
@property (nonatomic ,strong)NSMutableArray *arrDeleteIDs;

@property (nonatomic ,copy)NSString *shelfName;
/**
 *  当前选中cell
 */
@property (nonatomic ,assign)NSInteger index;

@end

@implementation SMShelfTemplateViewController


#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
    [self setupNav];
    
    //最下面的 添加模版 按钮
    //[self setupBottomView];
    
    //添加tableView
    [self.view addSubview:self.tableView];
    
    [self requestShelfData];
    
    //[self loadSqlite];
    //这里是自己写的用1号微货架,接入网络后要改
    self.currentShelfNum = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrenUseSehlfNum];
    
    //[self requestShelfData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshData) name:@"NameRefreshData" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
-(void)RefreshData
{
    [self requestShelfData];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[NSUserDefaults standardUserDefaults] setInteger:self.arrShelfs.count forKey:KCurrentShelfCount];
//}

//最下面的 添加模版 按钮
- (void)setupBottomView{
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@49);
    }];
}

#pragma mark -- 点击事件
- (void)addBtnClick{
    SMLog(@"点击了 添加模版");
    if (self.arrShelfs.count >= 10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的，专柜最多只能有10个喔" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[SKAPI shared] createStorage:@"VIP客户专柜" block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result   %@",result);
            [self requestShelfData];
            //将当前货架模版总数存到沙盒   前面的微货架模块会用到这个
//            SMLog(@"self.arrShelfs.count  %zd",self.arrShelfs.count);
//            [[NSUserDefaults standardUserDefaults] setInteger:self.arrShelfs.count forKey:KCurrentShelfCount];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)setupNav{
    self.title = @"柜台管理";
    
    //右边的 新建 按钮
//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = KDefaultFontBig;
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"模版管理" attributes:dict];
//    rightBtn.width = 60;
//    rightBtn.height = 20;
//    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

//点了 模版管理
- (void)rightItemClick{
    SMLog(@"点击了 模版管理 按钮");
    self.atRight = !self.atRight;
    if (self.atRight) {//如果还不处于右移状态，就执行右移代码
        [self moveRight];
        
    }else{ //如果已经处于右移状态，就 回到原始的状态
        [self moveBack];
//        ********原来，没有刷新***
//        [self.tableView reloadData];
        
    }
}

//备份
//- (void)moveRight{
//    SMLog(@"执行 右移代码");
//    for (SMTemplateCell *cell in self.arrCell) {
//        //每个cell 依次执行右移
//        [cell managerBtnClick];
//    }
//    //显示删除按钮
////    [self addBottomDeleteBtn];
//    [self.view addSubview:self.bottomViewDelete];
//    [_bottomViewDelete mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //        make.centerX.equalTo(self.mas_centerX);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
//        make.height.equalTo(@50);
//    }];
//    [self.bottomView removeFromSuperview];
//}

- (void)moveRight{
    SMLog(@"执行 右移代码");
    for (Favorites *f in self.arrShelfs) {
        //每个cell 依次执行右移
//        [cell managerBtnClick];
        f.isMoveRight = !f.isMoveRight;
    }
    [self.tableView reloadData];
    //显示删除按钮
    //    [self addBottomDeleteBtn];
    [self.view addSubview:self.bottomViewDelete];
    [_bottomViewDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@50);
    }];
    [self.bottomView removeFromSuperview];
}

//- (void)moveBack{
//    SMLog(@"回到原始状态");
//    for (SMTemplateCell *cell in self.arrCell) {
//        //每个cell 依次执行右移
//        [cell managerBtnClickAgain];
//    }
//    //移除添加模版
//    [self.bottomViewDelete removeFromSuperview];
//    //加上删除按钮
//    [self setupBottomView];
//}

- (void)moveBack{
    SMLog(@"回到原始状态");
    //[self requestShelfData];
    for (Favorites *f in self.arrShelfs) {
        //每个cell 依次执行右移
        f.isMoveRight = NO;
    }
    /******   原来没有这个   *******/
    self.atRight = NO;
    /******   原来这里有刷新   *******/
    [self.tableView reloadData];
    
    //移除删除按钮
    [self.bottomViewDelete removeFromSuperview];
    //加上 添加模版view
    [self setupBottomView];
}

//点了全选
- (void)allSelectedBtnClick:(UIButton *)btn{
    SMLog(@"点了全选按钮");
    [self gouBtnClick:self.gouBtn];
}
//点了全选 左边的勾勾
- (void)gouBtnClick:(UIButton *)btn{
    SMLog(@"点击了 全选勾勾");
    btn.selected = !btn.selected;
    //如果全选左边的勾勾 按钮为选中状态。则把每一个cell 内的勾勾都变为选中状态
    if (self.gouBtn.selected) {
        for (SMTemplateCell *cell in self.arrCell) {
            cell.gouBtn.selected = YES;
        }
        for (Favorites * fav in self.arrShelfs) {
            fav.gouIsSelected = YES;
        }
    }else{
        for (SMTemplateCell *cell in self.arrCell) {
            cell.gouBtn.selected = NO;
        }
        for (Favorites * fav in self.arrShelfs) {
            fav.gouIsSelected = NO;
        }
    }
    
}

- (void)deleteBtnClick{
    SMLog(@"点击了 删除按钮 ");
    [self.arrDeleteIDs removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:KCurrentSelectedShelf];
    //通过判断cell左边的勾勾是否处于选中状态   来删除选中状态的cell  刷新tableView数据
    for (SMTemplateCell *cell in _arrCell) {
        if (cell.gouBtn.selected) {
            NSString *ID = cell.favorate.id;
            [self.arrDeleteIDs addObject:ID];
        }
    }
    SMLog(@"self.arrDeleteIDs   %@",self.arrDeleteIDs);
    [[SKAPI shared] deleteStorage:self.arrDeleteIDs block:^(id result, NSError *error) {
        if (!error) {
            
            [self moveBack];
            [self requestShelfData];
            if (self.gouBtn.selected) { //如果左下角全选的勾是选中状态，在删除全部成功之后，把它恢复成normal 状态
                self.gouBtn.selected = NO;
                //并把当前使用的货架号存到沙盒.
                
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:KCurrenUseSehlfNum];
            }
//            SMLog(@"self.arrShelfs.count  %zd",self.arrShelfs.count);
//            [[NSUserDefaults standardUserDefaults] setInteger:self.arrShelfs.count forKey:KCurrentShelfCount];
        }else{
            SMLog(@"%@",error);
        }
    }];
    
}
#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrShelfs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMTemplateCell *cell = [SMTemplateCell cellWithTableView:tableView];
//    SMTemplateCell *cell = [SMTemplateCell cellWithTableView:tableView andIndex:indexPath];
    cell.numOfShelf = indexPath.row;
    //选择状态变化
    [self.arrCell addObject:cell];
    cell.delegate = self;
    cell.rightBtn.tag = indexPath.row;
    SMLog(@"self.arrShelfs   %@    indexPath.row  %zd",self.arrShelfs,indexPath.row);
    Favorites *favorate = self.arrShelfs[indexPath.row];
    cell.favorate = favorate;
    
    NSString *leftStr = [NSString stringWithFormat:@"%zd号专柜：%@",indexPath.row + 1,favorate.name];
    cell.leftLabel.text = leftStr;
    
    if (indexPath.row == self.currentShelfNum) {
        //当前正在使用的，显示成灰色
        cell.colorView.backgroundColor = self.arrColor.lastObject;
        cell.rightBtn.selected = YES;

    }else{
        if (indexPath.row <= 10) {
            cell.colorView.backgroundColor = self.arrColor[indexPath.row];
            cell.rightBtn.selected = NO;
        }else{
            SMLog(@"模版数量超出了10个  颜色数组 越界");
        }
    }    
    //给数据
    if (favorate.name) {
        self.index = indexPath.row;
    }
    
    SMLog(@"self.shelfName  favorate.name  %@",self.shelfName);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"选中了cell 第 %zd行",indexPath.row);
    
    SMNumShelfViewController *vc = [[SMNumShelfViewController alloc] init];
    vc.favorite = self.arrShelfs[indexPath.row];
    vc.currentShelfNum = indexPath.row + 1;
    Favorites *favorate = self.arrShelfs[indexPath.row];
    vc.shelfName = favorate.name;
    SMLog(@"self.shelfName  navigationController   %@", vc.shelfName);
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark -- SMTemplateCellDelegate
- (void)rightBtnDidClick:(UIButton *)rightBtn{
    SMLog(@"点击了 cell 右边的按钮");
    
    if (rightBtn.selected == YES)  return;
    SMLog(@"--");
    //感觉这里面面还是拿到真实数据再写 比较好一点。    

    self.currentShelfNum = rightBtn.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:rightBtn.tag forKey:KCurrenUseSehlfNum];
    Favorites *f = self.arrShelfs[self.currentShelfNum];
    [[NSUserDefaults standardUserDefaults] setObject:f.id forKey:KCurrentShelfID];
    SMLog(@"currentShelfNum    %zd",self.currentShelfNum);
    [self.arrCell removeAllObjects];
    [self.tableView reloadData];

}

//微货架的数据
-(void)requestShelfData{
//    [self.arrShelfs removeAllObjects];
    
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        
        if (!error) {
            SMLog(@"array  %@",array);
            //self.arrShelfs = [array mutableCopy];
//            for (Favorites * fav in array) {
//                [self.arrShelfs addObject:fav];
//            }
            self.arrShelfs = (NSMutableArray *)array;
            [[NSUserDefaults standardUserDefaults] setInteger:self.arrShelfs.count forKey:KCurrentShelfCount];

            SMLog(@"self.arrCell    %@",self.arrCell);
            SMLog(@"self.arrShelfs    %@",self.arrShelfs);
            //保存下来
            [self saveSqliteWith:self.arrShelfs];
            
            [self.arrCell removeAllObjects];
            [self.tableView reloadData];
        }else{
            SMLog(@"%@",error);
            //请求失败  加载本地
            [self loadSqlite];
        }
    }];
}


#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        //50 是太添加模版按钮的高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 -10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = KControllerBackGroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}


//装cell 颜色的数组，最后一个元素是选中时的灰色
- (NSArray *)arrColor{
    if (_arrColor == nil) {
        _arrColor = [NSArray array];
        _arrColor = @[SMColor(31, 120, 127),SMColor(241, 0, 90),SMColor(240, 102, 34),SMColor(230, 80, 53),SMColor(10, 82, 168),SMColor(76, 0, 116),SMColor(18, 139, 55),SMColor(117, 65, 143),SMColor(12, 96, 89),SMColor(228, 73, 5),SMColor(110, 111, 112)];
    }
    return _arrColor;
}

- (NSMutableArray *)arrCell{
    if (_arrCell == nil) {
        _arrCell = [NSMutableArray array];
    }
    return _arrCell;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        
        //添加模版 按钮
        UIButton *addBtn = [[UIButton alloc] init];
        [_bottomView addSubview:addBtn];
        [addBtn setTitle:@"添加模版" forState:UIControlStateNormal];
        addBtn.layer.cornerRadius = SMCornerRadios;
        [addBtn setBackgroundColor:KRedColor];
        addBtn.clipsToBounds = YES;
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_bottomView.mas_top).with.offset(2);
            make.bottom.equalTo(_bottomView.mas_bottom).with.offset(-2);
            make.right.equalTo(_bottomView.mas_right).with.offset(-24);
            make.left.equalTo(_bottomView.mas_left).with.offset(24);
        }];
        
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (UIView *)bottomViewDelete{
    if (_bottomViewDelete == nil) {
        _bottomViewDelete = [[UIView alloc] init];
        
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [_bottomViewDelete addSubview:deleteBtn];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setBackgroundColor:KRedColor];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.centerX.equalTo(self.mas_centerX);
            make.right.equalTo(_bottomViewDelete.mas_right).with.offset(0);
            make.top.equalTo(_bottomViewDelete.mas_top).with.offset(0);
            make.bottom.equalTo(_bottomViewDelete.mas_bottom).with.offset(0);
            make.width.equalTo(@85);
        }];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        //圆圈
        UIButton *gouBtn = [[UIButton alloc] init];
        [_bottomViewDelete addSubview:gouBtn];
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [gouBtn setBackgroundImage:[UIImage imageNamed:@"honggou"] forState:UIControlStateSelected];
        
        [gouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomViewDelete.mas_centerY);
            make.left.equalTo(_bottomViewDelete.mas_left).with.offset(5);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        [gouBtn addTarget:self action:@selector(gouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.gouBtn = gouBtn;
        
        //全选
        UIButton *allSelectedBtn = [[UIButton alloc]  init];
        [_bottomViewDelete addSubview:allSelectedBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"全选" attributes:dict];
        [allSelectedBtn setAttributedTitle:str forState:UIControlStateNormal];
        allSelectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [allSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_bottomViewDelete.mas_centerY);
            make.left.equalTo(gouBtn.mas_right).with.offset(5);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [allSelectedBtn addTarget:self action:@selector(allSelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomViewDelete;
}

#pragma mark -- 懒加载

- (NSMutableArray *)arrDeleteIDs{
    if (_arrDeleteIDs == nil) {
        _arrDeleteIDs = [NSMutableArray array];
    }
    return _arrDeleteIDs;
}

- (NSMutableArray *)arrShelfs{
    if (_arrShelfs == nil) {
        _arrShelfs = [NSMutableArray array];
    }
    return _arrShelfs;
}

-(void)saveSqliteWith:(NSArray *)array
{
    //保存前需要删除
    NSArray * localArray = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            for (LocalFavorites * fav in localArray) {
                [fav MR_deleteEntityInContext:localContext];
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
        }];
   
//    存起来
#warning 存储数据  乱序   换到主线程存就没有问题了
    //这里数组  存储时候  乱序了
    for (Favorites * favorites in array) {
            SMLog(@"name = %@",favorites.name);
            LocalFavorites * localFavorites = [LocalFavorites MR_createEntity];
            localFavorites.id = favorites.id;
            localFavorites.createAt = [NSNumber numberWithInteger:favorites.createAt];
            localFavorites.name = favorites.name;
            localFavorites.type = [NSNumber numberWithInteger:favorites.type];
            localFavorites.products = favorites.products;
            localFavorites.activitys = [NSNumber numberWithInteger:favorites.activitys];
            localFavorites.coupons = [NSNumber numberWithInteger:favorites.coupons];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

-(void)loadSqlite
{
    //清空数组
//    [self.arrShelfs removeAllObjects];
    NSArray * localArray = [LocalFavorites MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    if (localArray.count>0) {
        for (LocalFavorites * localFavorites in localArray) {
            Favorites * favorites = [Favorites new];
            favorites.id = localFavorites.id;
            favorites.createAt = localFavorites.createAt.integerValue;
            favorites.name = localFavorites.name;
            favorites.type = localFavorites.type.integerValue;
            favorites.products = localFavorites.products;
            favorites.activitys = localFavorites.activitys.integerValue;
            favorites.coupons = localFavorites.coupons.integerValue;
            [self.arrShelfs addObject:favorites];
        }
        [self.tableView reloadData];
//        [self requestShelfData];
    }else
    {
        //[self requestShelfData];
    }
}
@end
