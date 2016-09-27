//
//  SMShelfActionViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfActionViewController.h"
#import "SMAllActionTableViewCell.h"
#import "SMActionViewController.h"
#import "LocalFavoritesDetail.h"
#import "AppDelegate.h"

@interface SMShelfActionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

/**
 *   最下面的删除按钮
 */
@property (nonatomic ,strong)UIView *bottomViewDelete;
/**
 *  全选左边的 勾勾按钮
 */
@property (nonatomic ,strong)UIButton *gouBtn;
/**
 *  装已显示出来的cell
 */
@property (nonatomic ,strong)NSMutableArray *arrCell;

@property (nonatomic ,strong)NSMutableArray *arrDelete;

@end

@implementation SMShelfActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SMRandomColor;
    [self.view addSubview:self.tableView];
    
    [self loadSplite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDatas:) name:KRefreshDatasNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouBtnDidClick:) name:@"KDeleteNoteAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClickNote) name:@"KDeleteBtnClickNoteAction" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshupData) name:@"RefreshData" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
-(void)refreshupData
{
    [self loadDatas];
}
- (void)deleteBtnClickNote{
    [self loadDatas];
}

- (void)gouBtnDidClick:(NSNotification *)note{
    
    NSString *selectedStr = note.userInfo[@"KSelectedStrAction"];
    NSString *modleID = note.userInfo[@"KModleIDAction"];
    if (selectedStr.integerValue) { //如果勾勾是选中状态，就把当前选中的商品modle 加入到  arrDelete  这个数组中去
        NSInteger flag = 0;
        for (NSString *ID in self.arrDelete) {
            if ([modleID isEqualToString:ID]) {
                flag++;
            }
        }
        if (flag == 0) {
            [self.arrDelete addObject:modleID];
        }
        SMLog(@"self.arrDelete   1   %@",self.arrDelete);
    }else{  //如果勾勾是  未选中状态。  就把当前选中的modle 对应的id  从 arrDelete 这个数组中删除掉
        NSInteger index = [self.arrDelete indexOfObject:modleID];
        SMLog(@"self.arrDelete   %@",self.arrDelete);
        SMLog(@"modleID    %@",modleID);
        
        [self.arrDelete removeObjectAtIndex:index];
    }
    SMLog(@"self.arrDelete  %@",self.arrDelete);
}

- (void)loadDatas{
    [[SKAPI shared] queryMyStorageItems:self.fav.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arrM = [NSMutableArray array];
            for (FavoritesDetail *f in array) {
                if (f.type == 1) {
                    [arrM addObject:f];
                    [self.arrCurrentIDS addObject:f.itemId];
                }
            }
            self.arrDatas = arrM;
            
            [self.tableView reloadData];
            
            [self saveSqliteWithDatas:[arrM copy]];
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)refreshDatas:(NSNotification *)note{
    NSString *favID = note.userInfo[KFavID];
    [[SKAPI shared] queryMyStorageItems:favID block:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arrM = [NSMutableArray array];
            for (FavoritesDetail *f in array) {
                if (f.type == 1) {
                    [arrM addObject:f];
                    [self.arrCurrentIDS addObject:f.itemId];
                }
                self.arrDatas = arrM;
                [self.tableView reloadData];
            }
        }else{
            SMLog(@"%@",error);
        }
    }];
}

- (void)loadView{ //自定义设置控制器的View(可改变其类型)
    CGFloat height = KScreenHeight - KStateBarHeight - 40 - 10 - 65;
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
    self.view = bgview;
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMAllActionTableViewCell *cell = [SMAllActionTableViewCell cellWithTableView:tableView];
    cell.favDetail = self.arrDatas[indexPath.row];
    
//    if (cell.favDetail.isMoveRight) {
//        cell.gouBtn.hidden = NO;
//    }else{
//        cell.gouBtn.hidden = YES;
//    }
    [self.arrCell addObject:cell];
    
    SMLog(@"SMAllActionTableViewCell  %zd",indexPath.row);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"didSelectRowAtIndexPath");
    if ([self.delegate respondsToSelector:@selector(actionCellDidClick:)]) {
        [self.delegate actionCellDidClick:indexPath.row];
    }
}

#pragma mark -- 点击事件

- (void)managerAllClick{
    SMLog(@"vc2   managerAllClick");
    //加载出 下面的删除按钮
    [self.view addSubview:self.bottomViewDelete];
    [_bottomViewDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@50);
    }];
    
    SMLog(@"%@",self.arrCell);
    for (FavoritesDetail *f in self.arrDatas) {
        if (f.type == 1) {
            f.isMoveRight = !f.isMoveRight;
        }
    }
    [self.tableView reloadData];
}

- (void)managerAllClickAgain{
    SMLog(@"vc2  managerAllClickAgain");
    [self.bottomViewDelete removeFromSuperview];
    
    for (FavoritesDetail *f in self.arrDatas) {
        if (f.type == 1) {
            f.isMoveRight = !f.isMoveRight;
        }
    }
    [self.tableView reloadData];
}



#pragma mark -- 懒加载

- (NSMutableArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

- (NSMutableArray *)arrCell{
    if (_arrCell == nil) {
        _arrCell = [NSMutableArray array];
    }
    return _arrCell;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.frame = self.view.bounds;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)bottomViewDelete{
    if (_bottomViewDelete == nil) {
        _bottomViewDelete = [[UIView alloc] init];
        _bottomViewDelete.backgroundColor = [UIColor whiteColor];
        
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [_bottomViewDelete addSubview:deleteBtn];
        [deleteBtn setTitle:@"下架" forState:UIControlStateNormal];
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
        
        //给一条灰色横线
        UIView *grayLine = [[UIView alloc] init];
        [_bottomViewDelete addSubview:grayLine];
        grayLine.backgroundColor = KControllerBackGroundColor;
        
        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_bottomViewDelete.mas_left).with.offset(0);
            make.right.equalTo(_bottomViewDelete.mas_right).with.offset(0);
            make.top.equalTo(_bottomViewDelete.mas_top).with.offset(0);
            make.height.equalTo(@1);
        }];
    }
    return _bottomViewDelete;
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
        for (FavoritesDetail *f in self.arrDatas) {
            //            f.isAllSelected = YES;
            f.isSelected = YES;
            NSString *selectedStr = [NSString stringWithFormat:@"%zd",f.isSelected];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"KSelectedStrAction"] = selectedStr;
            dict[@"KModleIDAction"] = f.id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteAction" object:self userInfo:dict];
        }
    }else{
        for (FavoritesDetail *f in self.arrDatas) {
            //            f.isAllSelected = NO;
            f.isSelected = NO;
            NSString *selectedStr = [NSString stringWithFormat:@"%zd",f.isSelected];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"KSelectedStrAction"] = selectedStr;
            dict[@"KModleIDAction"] = f.id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteAction" object:self userInfo:dict];
        }
    }
    
    [self.tableView reloadData];
}
- (void)deleteBtnClick{
    SMLog(@"点击了 删除按钮");
    
//    for (NSString *ID in self.arrDelete) {
//        NSInteger index = [self.arrCurrentIDS indexOfObject:ID];
//        [self.arrCurrentIDS removeObjectAtIndex:index];
//    }
    //    [self.collectionView reloadData];
    
    
    [[SKAPI shared] deleteMyStorageItems:self.arrDelete andFavId:self.fav.id andType:1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteBtnClickNoteAction" object:self];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

- (NSMutableArray *)arrDelete{
    if (_arrDelete == nil) {
        _arrDelete = [NSMutableArray array];
    }
    return _arrDelete;
}

- (NSMutableArray *)arrCurrentIDS{
    if (_arrCurrentIDS == nil) {
        _arrCurrentIDS = [NSMutableArray array];
    }
    return _arrCurrentIDS;
}


-(void)saveSqliteWithDatas:(NSArray *)array
{
    //存之前需要删除 原来的数据
    
    NSArray * sandBoxArray = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.fav.id inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (LocalFavoritesDetail * localdetail in sandBoxArray) {
            if (localdetail.type.integerValue == 1) {
                [localdetail MR_deleteEntityInContext:localContext];
            }
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (FavoritesDetail * detail in array) {
            LocalFavoritesDetail * favoritesDetail = [LocalFavoritesDetail MR_createEntityInContext:localContext];
            favoritesDetail.id = detail.id;
            favoritesDetail.isMoveRight = [NSNumber numberWithInteger:detail.isMoveRight];
            favoritesDetail.isAllSelected =[NSNumber numberWithInteger:detail.isAllSelected];
            favoritesDetail.itemId = detail.itemId;
            favoritesDetail.itemName = detail.itemName;
            favoritesDetail.value1 = detail.value1;
            favoritesDetail.value2 = detail.value2;
            favoritesDetail.value3 = detail.value3;
            favoritesDetail.startTime = [NSNumber numberWithInteger:detail.startTime];
            favoritesDetail.endTime = [NSNumber numberWithInteger:detail.endTime];
            favoritesDetail.type = [NSNumber numberWithInteger:detail.type];
            favoritesDetail.imagePath = detail.imagePath;
            favoritesDetail.descr = detail.descr;
            favoritesDetail.favID = self.fav.id;
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
}

-(void)loadSplite
{
    //先清除数组
    [self.arrDatas removeAllObjects];
    //查找到相应的数据
    NSArray * array = [LocalFavoritesDetail MR_findByAttribute:@"favID" withValue:self.fav.id inContext:[NSManagedObjectContext MR_defaultContext]];
    //如果没有数据 直接请求
    if (array.count==0) {
        [self loadDatas];
    }else
    {
        for (LocalFavoritesDetail * localFavoritesDetail in array) {
            if (localFavoritesDetail.type.integerValue==1) {
                FavoritesDetail * favoritesDetail = [FavoritesDetail new];
                favoritesDetail.id = localFavoritesDetail.id;
                favoritesDetail.isMoveRight = localFavoritesDetail.isMoveRight.integerValue;
                favoritesDetail.isAllSelected =localFavoritesDetail.isAllSelected.integerValue;
                favoritesDetail.itemId = localFavoritesDetail.itemId;
                favoritesDetail.itemName = localFavoritesDetail.itemName;
                favoritesDetail.value1 = localFavoritesDetail.value1;
                favoritesDetail.value2 = localFavoritesDetail.value2;
                favoritesDetail.value3 = localFavoritesDetail.value3;
                favoritesDetail.startTime = localFavoritesDetail.startTime.integerValue;
                favoritesDetail.endTime = localFavoritesDetail.endTime.integerValue;
                favoritesDetail.type = localFavoritesDetail.type.integerValue;
                favoritesDetail.imagePath = localFavoritesDetail.imagePath;
                favoritesDetail.descr = localFavoritesDetail.descr;
                
                [self.arrDatas addObject:favoritesDetail];
            }
            
        }
    }
}
@end
