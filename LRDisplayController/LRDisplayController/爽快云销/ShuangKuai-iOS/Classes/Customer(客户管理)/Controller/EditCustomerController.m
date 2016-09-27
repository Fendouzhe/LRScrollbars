//
//  EditCustomerController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "EditCustomerController.h"
#import "SMEditCustomerAddCell.h"
#import "SMCollectionViewFlowLayout.h"
#import "SMAddLabelView.h"



#define KCollectionTopY 10
@interface EditCustomerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMEditCustomerAddCellDelegate,SMAddLabelViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UICollectionView *collectionViewTop;/**< 上面的collectionView */

@property (nonatomic ,strong)UIView *topView;/**< 上面的view  collectionViewTop 的父控件 */

@property (nonatomic ,strong)UICollectionView *collectionViewBottom;/**< 下面的collectionView */

@property (nonatomic ,strong)UIView *bottomView;/**< 下面的view  collectionViewBottom 的父控件 */

@property (nonatomic ,strong)UIView *cheatView;/**< <#注释#> */

@property (nonatomic ,strong)UIWindow *window;/**< <#注释#> */

@property (nonatomic ,strong)SMAddLabelView *labelView;/**< <#注释#> */

@property (nonatomic ,strong)NSArray *arrAllTag;/**< 所有标签数据源 */

@property (nonatomic ,strong)NSMutableArray *arrCurrentTags;/**< 当前选中的标签 */

@property (nonatomic ,strong)UIAlertView *longPressAlert;/**<  提示是否确认删除标签*/

@property (nonatomic ,strong)UILongPressGestureRecognizer *longPressGes;/**< <#注释#> */

@end

@implementation EditCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.arrCurrentTags = [NSMutableArray arrayWithArray:self.oldTagArray];
    
    [self setupNav];
    
    [self.view addSubview:self.collectionViewTop];
//    [self.view addSubview:self.collectionViewBottom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCollectionViewBottom) name:@"addCollectionViewBottom" object:nil];
    
    [self getAllTags];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(selectTagArray:)]) {
        [self.delegate selectTagArray:[self.arrCurrentTags copy]];
    }
}

- (void)getAllTags{
    [[SKAPI shared] queryCustomerTagByName:@"" block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  queryCustomerTagByName %@ ",result);
            self.arrAllTag = [Tag mj_objectArrayWithKeyValuesArray:[result objectForKey:@"result"]];
            [self.collectionViewBottom reloadData];
        }else{
            SMLog(@"error  queryCustomerTagByName  %@",error);
        }
    }];
}

- (void)addCollectionViewBottom{
    [self.view addSubview:self.collectionViewBottom];
    CGFloat y = CGRectGetMaxY(self.collectionViewTop.frame) + 10;
    self.collectionViewBottom.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight - 64 - y);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.collectionViewTop) {
        return 2;
    }else if (collectionView == self.collectionViewBottom){
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionViewTop) {
        if (section == 0) {
            return 1;
        }else{
            return self.arrCurrentTags.count;
        }
    }else if (collectionView == self.collectionViewBottom){
        if (section == 0) {
            return 1;
        }else{
            return self.arrAllTag.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMEditCustomerAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"editCustomerAddCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    if (collectionView == self.collectionViewTop) {  //上面collectionView
        if (indexPath.section == 0) {
            cell.titleText = @"➕标签";
            [cell addGestureAddNewTag];
            [cell becomeBlackBorderAndBlackTextColorLabel];
        }else{
            cell.titleText = self.arrCurrentTags[indexPath.row];
            [cell addGestureRemoveTag];
            [cell beComeRedBorderAndRedTextColorLabel];
        }
    }else{    //下面collectionView
        if (indexPath.section == 0) {
            cell.titleText = @"常用标签";
//            cell.addLabel.userInteractionEnabled = NO;
            [cell becomeBlackBorderAndBlackTextColorLabel];
            
            for (UITapGestureRecognizer *tap in [cell.addLabel gestureRecognizers]) {
                [cell.addLabel removeGestureRecognizer:tap];
            }
            for (UILongPressGestureRecognizer *longPress in [cell.addLabel gestureRecognizers]) {
                [cell.addLabel removeGestureRecognizer:longPress];
            }
            //
        }else{
            Tag *tagModel = self.arrAllTag[indexPath.row];
            cell.tagModel = tagModel;
            
            BOOL flag = NO;
            for (NSString *tagName in self.arrCurrentTags) {
                if ([tagModel.name isEqualToString:tagName]) {
                    flag = YES;
                }
            }
            
            if (flag == YES) {
                [cell beComeRedBorderAndBlackTextColorLabel];
            }else{
                [cell becomeBlackBorderAndBlackTextColorLabel];
            }
            [cell addGestureAddOldTag];
            [cell addLongPressDeleteAction];
        }
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size;
    if (collectionView == self.collectionViewTop) { //上面的collectionView
        if (indexPath.section == 0) {
            size = [self sizeWithText:@"➕标签" font:KDefaultFont maxW:KScreenWidth - 20];
        }else{
            size = [self sizeWithText:self.arrCurrentTags[indexPath.row] font:KDefaultFont maxW:KScreenWidth - 20];
        }
    }else{  //下面的
        if (indexPath.section == 0) {
            size = [self sizeWithText:@"常用标签" font:KDefaultFont maxW:KScreenWidth - 20];
        }else{
            Tag *tag = self.arrAllTag[indexPath.row];
            size = [self sizeWithText:tag.name font:KDefaultFont maxW:KScreenWidth - 20];
        }
    }
    
    return CGSizeMake((size.width + 20) *SMMatchWidth, (size.height + 8) *SMMatchHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



#pragma mark -- 代理点击事件
- (void)longPressDeleteAction:(UILongPressGestureRecognizer *)longPress{
    self.longPressGes = longPress;
    self.longPressAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除此标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.longPressAlert show];
}

- (void)deleteTag{
    UILabel *label = (UILabel *)self.longPressGes.view;
    SMLog(@" 长按删除   label.text  %@",label.text);
    [self.arrCurrentTags removeObject:label.text];
    [self.collectionViewTop reloadData];
    
    NSString *deleteID;
    for (Tag *tag in self.arrAllTag) {
        if ([tag.name isEqualToString:label.text]) {
            deleteID = tag.id;
        }
    }
    
    SMLog(@"deleteID   longPressDeleteAction  %@",deleteID);
    
    [[SKAPI shared] deleteTag:deleteID block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result  deleteTag   %@",result );
            [self getAllTags];
        }else{
            SMLog(@"error   %@",error);
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == self.longPressAlert && buttonIndex == 1) {
        
        [self deleteTag];
        return;
    }
    
    [self cheatViewClick];
    
}

#pragma mark - SMEditCustomerAddCellDelegate

- (void)labelDidTap:(UITapGestureRecognizer *)tap{
    SMLog(@"点击了 上面的添加标签  labelDidTap   %@   %@",self.cheatView,self.labelView);
    if (self.cheatView || self.labelView) {
        return;
    }
    
    if (self.arrCurrentTags.count >= 5) {
        [self promptAlreadyHave5Tags];
        return;
    }
    
    self.cheatView = [[UIView alloc] init];
    self.window  = [UIApplication sharedApplication].keyWindow;//[UIApplication sharedApplication].windows lastObject];
    [self.window addSubview:self.cheatView];
    self.cheatView.frame = self.window.bounds;
    self.cheatView.backgroundColor = [UIColor blackColor];
    self.cheatView.alpha = 0;
    UITapGestureRecognizer *tapCheatView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheatViewClick)];
    [self.cheatView addGestureRecognizer:tapCheatView];
    
    
    SMAddLabelView *labelView = [SMAddLabelView addLabelView];
    self.labelView = labelView;
    [self.window addSubview:labelView];
    labelView.delegate = self;
    NSNumber *width = [NSNumber numberWithFloat:230 *SMMatchWidth];
    NSNumber *heigth = [NSNumber numberWithFloat:150 *SMMatchHeight];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.window.mas_centerX);
        make.top.equalTo(self.window.mas_top).with.offset(120 *SMMatchHeight);
        make.width.equalTo(width);
        make.height.equalTo(heigth);
    }];
    self.labelView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cheatView.alpha = 0.4;
        self.labelView.alpha = 1;
    }];
    
    [self.labelView.inputField becomeFirstResponder];
}

- (void)promptAlreadyHave5Tags{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱哒，最多可以添加5个标签哦～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)removeTagDidTap:(UITapGestureRecognizer *)tap{
    SMLog(@"点击了  上面的collectionViewCell 移除标签");
    
    UILabel *label = (UILabel *)tap.view;
    [self.arrCurrentTags removeObject:label.text];
    [self.collectionViewTop reloadData];
    [self.collectionViewBottom reloadData];
}

- (void)addOldTagDidTap:(UITapGestureRecognizer *)tap{
    SMLog(@"点击了  下面的collectionViewCell   将老的标签添加到上面");
    
    
    
    UILabel *label = (UILabel *)tap.view;
//    [self addTagWithTagname:label.text];
    
    if (self.arrCurrentTags.count >= 5 && CGColorEqualToColor(label.layer.borderColor, KGrayColorSeparatorLine.CGColor) ) {
        [self promptAlreadyHave5Tags];
        return;
    }
    
    
    BOOL flag = NO;
    for (NSString *tagName in self.arrCurrentTags) {
        if ([label.text isEqualToString:tagName]) { //如果上面collectionView中已有这个标签，先移除上面的标签，再把下面的标签border变黑色
            flag = YES;
            
        }
    }
    
    if (flag == YES) {
        [self.arrCurrentTags removeObject:label.text];
        [self.collectionViewTop reloadData];
        [self.collectionViewBottom reloadData];  //这个方法内部 已经有自动判断下面的cell是不是要显示红边或者黑边
    }else{
        [self.arrCurrentTags addObject:label.text];
        [self.collectionViewTop reloadData];
        [self.collectionViewBottom reloadData];  //这个方法内部 已经有自动判断下面的cell是不是要显示红边或者黑边
    }
    
}

- (void)cheatViewClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cheatView.alpha = 0;
        self.labelView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cheatView removeFromSuperview];
        self.cheatView = nil;
        [self.labelView removeFromSuperview];
        self.labelView = nil;
    }];
}

#pragma mark -- SMAddLabelViewDelegate
- (void)sureBtnDidClick{
    SMLog(@"点击了 确认");
    
//    [[SKAPI shared] addTag:self.labelView.inputField.text block:^(id result, NSError *error) {
//        if (!error) {
//            SMLog(@"result addTag  %@",result);
//            [self.arrCurrentTags addObject:self.labelView.inputField.text];
//            [self cheatViewClick];
//            //刷新上面collectionView
//            [self.collectionViewTop reloadData];
//            //同时刷新下面collectionView
//            [self getAllTags];
//        }else{
//            SMLog(@"error addTag %@",error);
//            if ([error.userInfo[@"该标签已存在"] isEqualToString:@"该标签已存在"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该标签已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//    }];
    [self addTagWithTagname:self.labelView.inputField.text];
    [self cheatViewClick];
}

- (void)addTagWithTagname:(NSString *)tagName{
    //忽略首尾空格及换行
    NSString *tipName = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!tipName.length) {
        [MBProgressHUD showError:@"空格不能作为标签!"];
        return;
    }
    [[SKAPI shared] addTag:tipName block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"result addTag  %@",result);
            [self.arrCurrentTags addObject:tagName];
            
            //刷新上面collectionView
            [self.collectionViewTop reloadData];
            //同时刷新下面collectionView
            [self getAllTags];
        }else{
            SMLog(@"error addTag %@",error);
//            if ([error.userInfo[@"该标签已存在"] isEqualToString:@"该标签已存在"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该标签已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
        }
    }];
}



- (void)cancelBtnDidClick{
    SMLog(@"点击了 取消");
    [self cheatViewClick];
}

- (void)setupNav{
    self.title = @"编辑客户标签";
//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    dict[NSFontAttributeName] = KDefaultFontBig;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"保存" attributes:dict];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];//rightItem;
    
    self.view.backgroundColor = KControllerBackGroundColor;
    
}

- (void)rightItemClick{
    SMLog(@"点击了 保存");
    
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //设置内容最宽 只能到maxW ，但是高度不限制。
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

// 这个是对于单行的字符串内容
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionViewTop{
    if (_collectionViewTop == nil) {
        SMCollectionViewFlowLayout *layout = [[SMCollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        _collectionViewTop = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KCollectionTopY, KScreenWidth, 40 *SMMatchHeight) collectionViewLayout:layout];
        _collectionViewTop.delegate = self;
        _collectionViewTop.dataSource = self;
        _collectionViewTop.backgroundColor = [UIColor whiteColor];
        [_collectionViewTop registerClass:[SMEditCustomerAddCell class] forCellWithReuseIdentifier:@"editCustomerAddCell"];
        
//        _collectionViewTop.layer.shadowOffset = CGSizeMake(5, 5);
//        _collectionViewTop.layer.shadowColor = [UIColor redColor].CGColor;
//        _collectionViewTop.layer.shadowOpacity = 0.8;//阴影透明度，默认0
//        _collectionViewTop.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return _collectionViewTop;
}

- (UICollectionView *)collectionViewBottom{
    if (_collectionViewBottom == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        CGFloat y = CGRectGetMaxY(self.collectionViewTop.frame) + 10;
        _collectionViewBottom = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, KScreenWidth, KScreenHeight - 64 - y) collectionViewLayout:layout];
        _collectionViewBottom.delegate = self;
        _collectionViewBottom.dataSource = self;
        _collectionViewBottom.backgroundColor = KControllerBackGroundColor;
        [_collectionViewBottom registerClass:[SMEditCustomerAddCell class] forCellWithReuseIdentifier:@"editCustomerAddCell"];
    }
    return _collectionViewBottom;
}

- (NSMutableArray *)arrCurrentTags{
    if (_arrCurrentTags == nil) {
        _arrCurrentTags = [NSMutableArray array];
    }
    return _arrCurrentTags;
}

@end
