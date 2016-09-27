//
//  SMCheatView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCheatView.h"
#import "SMSubSelectFooterView.h"
#import "SMSubSelectTableViewCell.h"
#import "SMSubSelectHeaderView.h"
#import "SMNumShelfViewController.h"

@interface SMCheatView ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  蒙版上的View
 */
@property (nonatomic ,strong)UIView * selectView;
/**
 *  selectView 上的Tableview
 */
@property (nonatomic ,strong)UITableView * subTableView;
/**
 *  获取模板的数组
 */
@property (nonatomic ,copy)NSMutableArray * favArray;
/**
 *  获取每个模板里的东东的数组
 */
@property (nonatomic ,copy)NSMutableArray * productsArray;
/**
 *  存所有模板里东东的字典
 */
@property(nonatomic,copy)NSMutableDictionary * datasDictionary;
/**
 *  存选中货架的id
 */
@property(nonatomic,copy)NSMutableArray * favIDArray;
/**
 *  底部带有确定安按钮的视图
 */
@property(nonatomic,strong)SMSubSelectFooterView * footerView;

/**
 *  是否为下架
 */
@property(nonatomic,assign)BOOL isdown;

@property(nonatomic,assign)BOOL isCanClick;

@end

@implementation SMCheatView

+(instancetype)initWithID:(NSString *)ID andType:(NSInteger)type andHeight:(CGFloat)height
{
    SMCheatView * cheatView = [SMCheatView new];
    //创建蒙版 在下面
    cheatView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);

    //cheatView.backgroundColor = [UIColor clearColor];
    cheatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //cheatView.alpha = 0.4;
    //蒙版的手势
    //[cheatView createTap];
    
    cheatView.ID = ID;
    cheatView.type = type;
    cheatView.isdown = NO;
    cheatView.height = height;
    
    [cheatView addSubview:cheatView.selectView];
    
    //[cheatView.selectView addSubview:cheatView.subTableView];
    
    [cheatView bringSubviewToFront:cheatView.selectView];
    
    [[NSNotificationCenter defaultCenter] addObserver:cheatView selector:@selector(disappearClick) name:@"KCheatViewDisappear" object:nil];
    
    //[NSNotificationCenter defaultCenter] addObserver:cheatView selector:@selector() name:<#(nullable NSString *)#> object:<#(nullable id)#>
    
    return cheatView;
}

//懒加载

-(NSMutableArray *)favArray
{
    if (!_favArray) {
        _favArray = [NSMutableArray array];
    }
    return _favArray;
}
-(NSMutableArray *)productsArray
{
    if (!_productsArray) {
        _productsArray = [NSMutableArray array];
    }
    return _productsArray;
}
-(NSMutableArray *)favIDArray
{
    if (!_favIDArray) {
        _favIDArray  = [NSMutableArray array];
    }
    return _favIDArray;
}

-(UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.alpha = 1;
        //[self addSubview:_selectView];
    }
    return _selectView;
}

-(SMSubSelectFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"SMSubSelectFooterView" owner:nil options:nil] lastObject];
        _footerView.productID = self.ID;
        _footerView.type = self.type;
    }
    return _footerView;
}

-(UITableView *)subTableView
{
    if (!_subTableView) {
        _subTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.bounces = NO;
        //_subTableView.scrollEnabled = NO;
        [_subTableView registerNib:[UINib nibWithNibName:@"SMSubSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubSelectCell"];
    }
    return _subTableView;
}

-(void)createSubcheatView
{
    //self.selectView.height = height;
    //self.selectView.width = KScreenWidth;
    
    [self bringSubviewToFront:self.selectView];
    
    
    //选择的tableview
    
    
    [self.selectView addSubview:self.subTableView];
    
}

-(void)createViewWith:(CGFloat)count
{
    if (self.type == 1 ||self.type == 2) {
        if (self.isCounter) {
            self.height = 0;
        }else{
            self.height = 64;
        }
        
    }else{
        if (self.isCounter) {
            self.height = -64;
        }else{
            self.height = 0;
        }
    }
    
    SMLog(@"%f",count);
    
    //确定选择界面的高度
    self.selectView.height = count*44+21+44+self.height;
    
    self.selectView.frame = CGRectMake(0,2*KScreenHeight-self.selectView.height, KScreenWidth,self.selectView.height);
    
    
    self.subTableView.frame  = CGRectMake(0, 0, KScreenWidth, self.selectView.height);
    
    if (count>5) {
        self.selectView.height = 5*44+21+44+self.height;
        if (self.type == 2) {
            self.subTableView.frame  = CGRectMake(0, 0, KScreenWidth, self.selectView.height-64);
        }else{
            self.subTableView.frame  = CGRectMake(0, 0, KScreenWidth, self.selectView.height);
        }
    }
    
    
    SMLog(@"%lf",self.selectView.height);
    //创建选择界面 以及上面的tableview
    [self createSubcheatView];
    // 点击动画  移上来
    [self createShelfcheatView];
    
    [self.subTableView reloadData];
}

//蒙版上的手势
-(void)createTap
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearClick)];
    
    [self addGestureRecognizer:tap];
}

//消失动画
-(void)disappearClick
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(0, KScreenHeight);
        
        self.selectView.frame = CGRectMake(0, 2*KScreenHeight-self.selectView.height, KScreenWidth, self.selectView.height);
    }];
    //将多有的勾去掉
    
    for (Favorites * fav in self.favArray) {
        fav.gouIsSelected = NO;
    }
}
//弹出动画
-(void)createShelfcheatView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(0, 0);
        self.selectView.origin = CGPointMake(0, KScreenHeight-self.selectView.height);
    }];
}

#pragma mark - tableview 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isCounter) {
        return self.productsArray.count;
    }
    if (!self.isdown) {
        return self.favArray.count;
    }else
    {
        return self.productsArray.count;
    };
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSubSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubSelectCell"];
    cell.type = self.type;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.isdown) {
        Favorites * favorites = self.favArray[indexPath.row];
        
        NSInteger add = 1;
        if (!favorites.isCanClick) {
            add = 1;
        }else
        {
            add = 0;
        }
        //分情况
        if (self.type==0) {
           [cell setshowLabel:favorites.name : favorites :add];
        }else if(self.type==1)
        {
            [cell setshowLabel:favorites.name : favorites :add];
        }else
        {
            [cell setshowLabel:favorites.name : favorites :add];
        }
        cell.addFavIDBlcok = ^{
            favorites.gouIsSelected = YES;
            [self.footerView.favIDArray addObject:favorites.id];
        };
        cell.subFavIDBlcok = ^{
            favorites.gouIsSelected = NO;
            [self.footerView.favIDArray removeObject:favorites.id];
        };
        
        cell.favorites  = favorites;
    }else
    {
        if (self.productsArray.count>0) {
            Favorites * favorites = self.productsArray[indexPath.row];
            NSInteger sub = 1;
            if (self.type==0) {
                [cell setsubshowLabel:favorites.name : favorites :sub];
            }else if(self.type==1)
            {
                [cell setsubshowLabel:favorites.name : favorites :sub];
            }else
            {
                [cell setsubshowLabel:favorites.name : favorites :sub];
            }
            cell.addFavIDBlcok = ^{
                [self.footerView.favIDArray addObject:favorites.id];
            };
            cell.subFavIDBlcok = ^{
                [self.footerView.favIDArray removeObject:favorites.id];
            };
            cell.addFavIDBlcok = ^{
                [self.footerView.favIDArray addObject:favorites.id];
            };
            cell.subFavIDBlcok = ^{
                [self.footerView.favIDArray removeObject:favorites.id];
            };
            
            if (!self.isCounter) {
                favorites.isCanClick = NO;
            }else{
                favorites.isCanClick = YES;
            }
            
            cell.favorites  = favorites;
        }
  
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SMSubSelectHeaderView * headerView = [[SMSubSelectHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 21)];
    if (self.isCounter) {
        return nil;
    }
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isCounter) {
        return nil;
    }
    return self.footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isCounter) {
        return 1;
    }
    return 21;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isCounter) {
        return 1;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMLog(@"点击cell");
    if (self.isCounter) {
        //进入柜台
        Favorites * favorites = self.productsArray[indexPath.row];
        
        SMNumShelfViewController *vc = [[SMNumShelfViewController alloc] init];
        vc.favorite = favorites;
        vc.currentShelfNum = indexPath.row + 1;
        Favorites *favorate = favorites;
        vc.shelfName = favorate.name;
        SMLog(@"self.shelfName  navigationController   %@", vc.shelfName);
        //[self.navigationController pushViewController:vc animated:NO];
        self.pushblock(vc);
    }else{
        SMSubSelectTableViewCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell selectAction:cell.selectBtn];
//        cell.selectBtn.selected = !cell.selectBtn.selected;
    }
}

#pragma mark - 如果本地没有数据  需要第一次请求 获取模板的数据
//上架调用
-(void)requestshelfData
{
    //获取个人的货架列表
    self.isdown = NO;
    self.footerView.isdown = self.isdown;
    [self.footerView.favIDArray removeAllObjects];
    
    [self.favArray removeAllObjects];
    [[SKAPI shared] queryStorage:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array = queryStorage    %@",array);
            for (Favorites * fav in array) {
                [self.favArray addObject:fav];
            }
            
            if (array.count>0) {
               [self CounterCheckUP];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有货架模板,请先添加货架模板" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }];
}
//反查该商品在哪些模板上
-(void)CounterCheckUP
{
    [[SKAPI shared] queryStorageByItem:self.ID block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array = %@",array);
            for (Favorites * fav in array) {
                
                for (NSInteger i=0; i<self.favArray.count; i++) {
                    Favorites * addfav = self.favArray[i];
                    if ([fav.id isEqualToString:[addfav id]]) {
                        [self.favArray removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            
            //如果满了  就不能点击  不显示。。。。
            for (NSInteger i=0; i<self.favArray.count; i++) {
                Favorites * fullShelf = self.favArray[i];
                //在这里 要区分产品/活动/优惠券
                if(self.type==0)
                {
                    if (fullShelf.products.integerValue==5 ) {
                        fullShelf.isCanClick = YES;
                    }
                }else if(self.type == 1)
                {
                    if (fullShelf.activitys == 5) {
                        fullShelf.isCanClick = YES;
                    }
                }else
                {
                    if (fullShelf.coupons == 5) {
                        fullShelf.isCanClick = YES;
                    }
                }
                
            }
            
            SMLog(@"%ld",self.favArray.count);
            [self createViewWith:self.favArray.count];
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}


//反查该商品在哪些模板上   下架调用
-(void)CounterCheck
{
    [self.productsArray removeAllObjects];
    self.isdown = YES;
    self.footerView.isdown = self.isdown;
    SMLog(@"%@",self.ID);
    //[self.footerView.favIDArray removeAllObjects];
    
    [[SKAPI shared] queryStorageByItem:self.ID block:^(NSArray *array, NSError *error) {
        if (!error) {
            SMLog(@"array = %@",array);
            for (Favorites * fav in array) {
                [self.productsArray addObject:fav];
            }
            if (self.productsArray.count>0) {
                [self createViewWith:self.productsArray.count];
            }else{
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有货架有此商品,请先上架商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
        }else
        {
            SMLog(@"%@",error);
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self disappearClick];
}
@end
