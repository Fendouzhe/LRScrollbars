//
//  SMNewShelfManagerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewShelfManagerController.h"
#import "SMNewShelfManagerCell.h"
#import "SMStroreHouseForShelfController.h"
#import "SMProductDetailController.h"
#import "SMChangeShelfNameController.h"
#import <UIImageView+WebCache.h>
#import "SMNewProduct.h"
#import "SMNewFav.h"
#import "SMNewShelfManager.h"
#import "SMNewProductDetailController.h"
#import "SMCounterTableViewCell.h"


@interface SMNewShelfManagerController ()<UITableViewDelegate,UITableViewDataSource,SMNewShelfManagerCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SMChangeShelfNameControllerDelegate,SMStroreHouseForShelfControllerDelegate,SMCounterTableViewCellDelegate>

@property (nonatomic ,strong)UITableView *tableView;

////
//@property (nonatomic ,strong)NSMutableArray *arrShelfs;

@property (nonatomic ,strong)SCLAlertView *pressAlert;

@property (nonatomic ,assign)NSInteger sourceType;

@property (nonatomic ,assign)NSInteger tag;

@property (nonatomic ,copy)NSString *imageToken;

@property (nonatomic ,strong)NSMutableArray *arrImages;
//SMNewFav  模型数组
@property (nonatomic ,strong)NSArray *arrDatas;

@property (nonatomic ,strong)UIButton *rightBtn;

@property (nonatomic ,strong)UIView *bottomView;

@property (nonatomic ,strong)UIButton *gouBtn;

@property (nonatomic ,strong)UILabel *allChooseLabel;

@property (nonatomic ,strong)UIButton *downBtn;

//确定要下架的商品IDs
@property (nonatomic ,strong)NSMutableArray *arrIDs;

@property (nonatomic ,assign)NSInteger flag;



@end

@implementation SMNewShelfManagerController

- (void)refreshDataNoti:(NSNotification *)notice{
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self SetupMJRefresh];
    
    [self setupNav];
    
    [self setupBottomView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollingProductDidClick:) name:KScrollingProductNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNoti:) name:RefreshCounterDataNotification object:nil];
    
    //[self.tableView.mj_header beginRefreshing];
    [self getData];
}

- (void)SetupMJRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getData];
    }];
    self.tableView.mj_header = header;
}

- (void)setupBottomView{
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.equalTo(@49);
    }];
//    self.bottomView.frame = CGRectMake(0, 200, KScreenWidth, 49);
    SMLog(@"NSStringFromCGRect(self.bottomView.frame)   %@",NSStringFromCGRect(self.bottomView.frame));
    
    //对勾按钮
    UIButton *gouBtn = [[UIButton alloc] init];
    self.gouBtn = gouBtn;
    [bottomView addSubview:gouBtn];
    [gouBtn setImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
    [gouBtn setImage:[UIImage imageNamed:@"honggou"] forState:UIControlStateSelected];
    [gouBtn addTarget:self action:@selector(gouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(0);
        make.width.equalTo(@49);
    }];
    
    //全选
    UILabel *allChooseLabel = [[UILabel alloc] init];
    [bottomView addSubview:allChooseLabel];
    self.allChooseLabel = allChooseLabel;
    allChooseLabel.text = @"全选";
    allChooseLabel.font = KDefaultFontBig;
    [allChooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(gouBtn.mas_right).with.offset(0);
    }];
    
    //下架
    UIButton *downBtn = [[UIButton alloc] init];
    self.downBtn = downBtn;
    [bottomView addSubview:downBtn];
    downBtn.backgroundColor = KRedColorLight;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"下架" attributes:dict];
    [downBtn setAttributedTitle:str forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(0);
        make.width.equalTo(@80);
    }];
    
    //灰色线
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    bottomView.hidden = YES;
}

- (void)downBtnClick{
    SMLog(@"点击了下架");
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KSureDownProductNoti object:nil];
    
    for (SMNewFav *fav in self.arrDatas) {
        NSMutableArray *arr = [NSMutableArray array];
        for (SMNewProduct *product in fav.items) {
            if (product.gouSelected) {//如果勾选了删除的对勾
                [arr addObject:product.id];
            }
        }
        
        [[SKAPI shared] deleteMyStorageItems:arr andFavId:fav.favId andType:0 block:^(id result, NSError *error) {
            if (!error) {
                SMLog(@"result  deleteMyStorageItems  %@",result);
                self.flag++;
                if (self.flag == 5) {  //5个删除请求都成功执行完成
                    [self getData];
                    //进入rightItemClick点击方法selected会取反
                    self.rightBtn.selected = YES;
                    [self rightItemClick:self.rightBtn];

                }
                [self getData];
                //进入rightItemClick点击方法selected会取反
                self.rightBtn.selected = YES;
                [self rightItemClick:self.rightBtn];
            }else{
                SMLog(@"error   %@",error);
            }
        }];
        
    }
    
}

- (void)gouBtnClick:(UIButton *)btn{
    SMLog(@"点击了 柜台管理下方的勾勾");
    btn.selected = !btn.selected;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KNewAllProductSelectedDeleteKey] = [NSString stringWithFormat:@"%zd",btn.selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNewAllProductSelectedDelete object:self userInfo:dict];
    
    for (SMNewFav *fav in self.arrDatas) {
        for (SMNewProduct *p in fav.items) {
            p.gouSelected = self.gouBtn.selected;
        }
    }
}

- (void)setupNav{
    self.title = @"柜台管理";
    self.view.backgroundColor = KControllerBackGroundColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFontBig;
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"批量管理" attributes:dict];
    UIButton *rightbtn = [[UIButton alloc] init];
    [rightbtn setAttributedTitle:str forState:UIControlStateNormal];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = KDefaultFontBig;
    dict2[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"批量管理" attributes:dict2];
    [rightbtn setAttributedTitle:str2 forState:UIControlStateSelected];
    [rightbtn sizeToFit];
//    rightbtn.height = 30;
//    rightbtn.width = 70;
    self.rightBtn = rightbtn;
//    rightbtn.backgroundColor = [UIColor greenColor];
    [rightbtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick:(UIButton *)rightBtn{
    SMLog(@"点击了 批量管理");
    rightBtn.selected = !rightBtn.selected;
    
    for (SMNewFav *fav in self.arrDatas) {
        for (SMNewProduct *p in fav.items) {
            p.rightItemSelected = self.rightBtn.selected;
        }
    }
    
    if (rightBtn.selected) {   //右上角按钮处于选中状态  展示对勾
        self.bottomView.hidden = NO;
    }else{
        self.gouBtn.selected = NO;
        self.bottomView.hidden = YES;
    }
    
//    NSNumber *num = [NSNumber numberWithInteger:self.rightBtn.selected];
    NSString *num = [NSString stringWithFormat:@"%d",self.rightBtn.selected];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KNewShelfManagerDeleteNotiKey] = num;
    SMLog(@"num  %@-----%@",num,dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNewShelfManagerDeleteNoti object:self userInfo:dict];
    
}


- (void)scrollingProductDidClick:(NSNotification *)noti{
    
    SMNewProduct *product = noti.userInfo[KScrollingProductNotiKey];
    SMLog(@"product   KScrollingProductNotiKey  %@",product);
//    [[SKAPI shared] queryProductById:product.itemId block:^(Product *product, NSError *error) {
//        if (!error) {
//            SMProductDetailController *vc = [SMProductDetailController new];
//            vc.product = product;
//            SMLog(@"product   %@   ,product.name   %@",product, product.name);
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            SMLog(@"error    %@",error);
//        }
//        
//    }];
    
    SMNewProductDetailController *vc = [SMNewProductDetailController new];
    vc.productId = product.itemId;
    vc.mode = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData{
    SMShowPrompt(@"玩命加载中...");
    [[SKAPI shared] queryStorageList:^(id result, NSError *error) {
        if (!error) {
            [HUD hide:YES];
//            SMNewShelfManager *m = [SMNewShelfManager mj_objectWithKeyValues:[result valueForKey:@"favorites"]];
            self.arrDatas = [SMNewFav mj_objectArrayWithKeyValuesArray:[result valueForKey:@"favorites"]];
            SMLog(@"[result valueForKey:@favorites]    %@",[result valueForKey:@"favorites"]);
            for (SMNewFav *m in self.arrDatas) {
//                SMLog(@"queryStorageList  m   %@",m.bgImage);
                for (SMNewProduct *x in m.items) {
                    SMLog(@"queryStorageList  x   %@",x.itemName);
                }
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            [HUD hide:YES];
            [MBProgressHUD showError:@"数据加载失败！请重试!"];
            [self.tableView.mj_header endRefreshing];
            SMLog(@"error  queryStorageList  %@ ",error);
        }
    }];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SMNewShelfManagerCell *cell = [SMNewShelfManagerCell cellWithTableView:tableView];
    //优化后
    SMCounterTableViewCell *cell = [SMCounterTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    
    cell.tag = indexPath.row;
    if(self.arrDatas.count){
        cell.favNew = self.arrDatas[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320 *SMMatchHeight;
}

#pragma mark -- SMCounterTableViewCellDelegate
- (void)addViewDidClick{
    SMLog(@"点击了 添加按钮，做相应的界面跳转");
    
    SMStroreHouseForShelfController *vc = [[SMStroreHouseForShelfController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- SMStroreHouseForShelfControllerDelegate
- (void)refreshUI{
    SMLog(@"refreshUI");
    [self getData];
}

- (void)changeShelfBtnDidClick:(NSInteger)tag favID:(NSString *)favID{
    SMLog(@"点击了 是否选择当前柜台    %zd   favID   %@" , tag   ,favID);
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SlideInFromTop;
    alert.hideAnimationType = SlideOutToBottom;
    
    [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"是否切换到此柜台？" closeButtonTitle:nil duration:0];
    
    SCLButton *sureBtn = [alert addButton:@"确定" actionBlock:^{
        SMLog(@"  actionBlock  %zd",tag);
        
        //先把当前选中的柜台存到本地，再通知前面的界面刷新界面
//        [[NSUserDefaults standardUserDefaults] setInteger:tag forKey:KCurrentSelectedShelf];  //最好不要用这个数据来取货架的信息，因为这只是个数字，而后台返回的数组顺序 不一定是固定的。 最好用下面的favID 来取
        
        [[NSUserDefaults standardUserDefaults] setObject:favID forKey:KCurrentShelfID];
      
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[KRefreshCounterProductNotiKey] = self.arrShelfs[tag];
        dict[@"KRefreshCounterProductNotiKey"] = favID;
        SMNewFav *fav = self.arrDatas[tag];
        dict[@"KRefreshCounterProductNotiKeyNewFav"] = fav;
        [[NSNotificationCenter defaultCenter] postNotificationName:KRefreshCounterProductNoti object:self userInfo:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    sureBtn.backgroundColor = KRedColorLight;
    
    SCLButton *cancelBtn = [alert addButton:@"取消" actionBlock:^{
        SMLog(@"点击了 取消");
    }];
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
}

- (void)bjIconDidLongPress:(NSInteger)tag{
    SMLog(@"长按 选择设置背景图和柜台名字");

    self.tag = tag;
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    self.pressAlert = alert;
    alert.showAnimationType = SlideInFromBottom;
    alert.hideAnimationType = SlideOutToTop;
    
    [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"亲，您要自定义编辑吗？" closeButtonTitle:nil duration:0];
    
    SCLButton *nameBtn = [alert addButton:@"给柜台取个新名字" actionBlock:^{
        
        self.pressAlert = nil;
        SMChangeShelfNameController *vc = [[SMChangeShelfNameController alloc] init];
        SMNewFav *f = self.arrDatas[self.tag];
        vc.shelfID = f.favId;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    nameBtn.backgroundColor = KRedColorLight;
    
    //换背景
    SCLButton *iconBtn = [alert addButton:@"给柜台换个美美的背景图😄" actionBlock:^{
        
        self.pressAlert = nil;
        UIActionSheet *sheet;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
        }
        else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
        }
        [sheet showInView:self.view];
        
    }];
    iconBtn.backgroundColor = [UIColor greenColor];
    
    SCLButton *cancelBtn = [alert addButton:@"不了，下次再说。" actionBlock:^{
//        self.pressAlert removeFromParentViewController
        self.pressAlert = nil;
    }];
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
}

//- (void)downProductBtnDidClick:(NSMutableArray *)arrIDs and:(NSString *)favID{
//    SMLog(@"点击下架 执行的方法");
//
//    for (SMNewFav *fav in self.arrDatas) {
//        NSMutableArray *arr = [NSMutableArray array];
//        for (SMNewProduct *product in fav.items) {
//            if (product.gouSelected) {//如果勾选了删除的对勾
//                [arr addObject:product.id];
//            }
//        }
//        
//        [[SKAPI shared] deleteMyStorageItems:arr andFavId:fav.favId andType:0 block:^(id result, NSError *error) {
//            if (!error) {
//                SMLog(@"result   %@",result);
//                self.flag++;
//                if (self.flag == 5) {  //5个删除请求都成功执行完成
//                    [self getData];
//                    [self rightItemClick:self.rightBtn];
//                }
//            }else{
//                SMLog(@"error   %@",error);
//            }
//        }];
//        
//    }
//}

#pragma mark -- SMChangeShelfNameControllerDelegate
- (void)saveSuccessName:(NSString *)name{
    
    [self getData];
//    [self.tableView reloadData];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                return;
            case 1: //相机
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2: //相册
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            return;
        } else {
            self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = self.sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tag inSection:0];
        SMCounterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIImage *originImage = cell.bjIcon.image;
        cell.bjIcon.image = image;
        
        [[SKAPI shared] uploadPic:image block:^(id result, NSError *error) { //先拿到 要上传图片的imageToken
            
            if (!error) {
//                self.imageToken = result;
//                Favorites *f = self.arrShelfs[self.tag];
                SMNewFav *f =  self.arrDatas[self.tag];
                NSString *token = [[result valueForKey:@"result"] valueForKey:@"token"];
                SMLog(@"result   uploadPic  %@   token  %@",result,token);
                [[SKAPI shared] updateStorage:@"" andFavId:f.favId andImageToken:token block:^(id result, NSError *error) {
                    if (!error) {
                        SMLog(@"result  updateStorage  %@",result);
                        
#warning 这里上传完图片立即刷新不出来图片，有点问题 服务器还没有马上保存 需要延时2秒
////                            [self.tableView reloadData];
//                        SCLAlertView *alert = [[SCLAlertView alloc] init];
//                        alert.showAnimationType = SlideInFromCenter;
//                        alert.hideAnimationType = SlideOutToCenter;
//                        
//                        [alert showCustom:self image:[UIImage imageNamed:@"ShuangKuaiCircle"] color:nil title:@"提示" subTitle:@"正玩命在上传中...稍后重新进入页面就能看到你美美的背景图啦～" closeButtonTitle:nil duration:0];
//                        
//                        SCLButton *nameBtn = [alert addButton:@"确定" actionBlock:^{
//
//                        }];
//                        nameBtn.backgroundColor = KRedColorLight;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //[self getData];
                            [[SKAPI shared] queryStorageList:^(id result, NSError *error) {
                                if (!error) {
                                    self.arrDatas = [SMNewFav mj_objectArrayWithKeyValuesArray:[result valueForKey:@"favorites"]];
                                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }else{
                                    //[MBProgressHUD showError:@"数据加载失败！请重试!"];
                                    SMLog(@"error  queryStorageList  %@ ",error);
                                }
                            }];
                            
                        });
                        
                    }else{
                        cell.bjIcon.image = originImage;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        SMLog(@"error updateStorage  %@",error);
                    }
                }];
            }else{
                cell.bjIcon.image = originImage;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                SMLog(@"error  uploadPic  %@",error);
            }
        }];
    }];
    
}


#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//- (NSMutableArray *)arrShelfs{
//    if (_arrShelfs == nil) {
//        _arrShelfs = [NSMutableArray array];
//    }
//    return _arrShelfs;
//}

- (NSMutableArray *)arrIDs{
    if (_arrIDs == nil) {
        _arrIDs = [NSMutableArray array];
    }
    return _arrIDs;
}

- (NSMutableArray *)arrImages{
    if (_arrImages == nil) {
        _arrImages = [NSMutableArray array];
    }
    return _arrImages;
}

@end
