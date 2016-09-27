//
//  SMCounterTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCounterTableViewCell.h"
#import "SMShelfManagerScrollProduct.h"
#import "SMNewFav.h"
#import "SMNewProduct.h"
#import "SMCounterProductCollectCellNew.h"

#define IconWidth 90 *SMMatchWidth
#define Margin 10
#define MaxCount 5

@interface SMCounterTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *productNameBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong)SMShelfManagerScrollProduct *addView;

@property (nonatomic ,assign)CGFloat margin;

@property (nonatomic ,strong)NSMutableArray *arrProducts;

@property (nonatomic ,assign)CGFloat height;
@property (nonatomic ,assign)CGFloat width;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@property(nonatomic,strong)UICollectionViewFlowLayout *layout;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjIconHeight;

@end

@implementation SMCounterTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"SMCounterTableViewCell";
    SMCounterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //NSLog(@"cellWithTableView");
    }
    return cell;
}

static NSString  * const collectionReuserIdentifier = @"SMCounterProductCollectCellNew";
//比cellWithTableView:先执行
- (void)awakeFromNib {
    [super awakeFromNib];
    //NSLog(@"awakeFromNib");
    self.productNameBtn.userInteractionEnabled = NO;
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.backgroundColor = KControllerBackGroundColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SMCounterProductCollectCellNew class]) bundle:nil] forCellWithReuseIdentifier:collectionReuserIdentifier];

    //点击手势  单击背景图  提示是否切换到此柜台
    UITapGestureRecognizer *changeNowShelfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNowShelf)];
    self.bjIcon.userInteractionEnabled = YES;
    [self.bjIcon addGestureRecognizer:changeNowShelfTap];
    
    //给背景图添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.bjIcon addGestureRecognizer:longPress];
    
    self.bjIconHeight.constant = 170 *SMMatchHeight;//KScreenWidth*0.56
}

- (void)setFavNew:(SMNewFav *)favNew{
    _favNew = favNew;
    //SMLog(@"setFavNew");
    [self.productNameBtn setTitle:favNew.favName forState:UIControlStateNormal];
    NSString *imagePath = [favNew.bgImage stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=60",KScreenWidth *2.2,175 *2.2]];
//    [self.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"] options:SDWebImageRefreshCached];
    [self.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"]];
    self.arrProducts = [NSMutableArray arrayWithArray:favNew.items];
    
    [self.collectionView reloadData];
}

//柜台背景图长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    //SMLog(@"longPressAction");
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(bjIconDidLongPress:)]) {
            [self.delegate bjIconDidLongPress:self.tag];
        }
    }
}

- (void)changeNowShelf{
    
    if ([self.delegate respondsToSelector:@selector(changeShelfBtnDidClick:favID:)]) {
        [self.delegate changeShelfBtnDidClick:self.tag favID:self.favNew.favId];
    }
    
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //SMLog(@"%s----%lu",__func__,self.arrProducts.count);
    return self.arrProducts.count < MaxCount ? self.arrProducts.count + 1 : MaxCount;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCounterProductCollectCellNew *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuserIdentifier forIndexPath:indexPath];
    //SMLog(@"%lu---cell = %@",indexPath.item,cell);
    if (indexPath.row < self.arrProducts.count) {
        cell.cellType = SMCollectionViewTypeNormal;
        cell.product = self.arrProducts[indexPath.row];
    }else{
        cell.cellType = SMCollectionViewTypeAdd;
    }

    return cell;
}


#pragma mark --UICollectionViewDelegate

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCounterProductCollectCellNew *cell = (SMCounterProductCollectCellNew *)[collectionView cellForItemAtIndexPath:indexPath];
    //处于批量管理状态，禁止点击
    if (cell.gouBtn.hidden == NO) {
        return;
    }
    if (cell.cellType == SMCollectionViewTypeNormal) {
        
        //跳转到商品详情控制器
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[KScrollingProductNotiKey] = self.arrProducts[indexPath.item];//self.product;
        //SMLog(@"self.f   %@",self.arrProducts[indexPath.item]);
        [[NSNotificationCenter defaultCenter] postNotificationName:KScrollingProductNoti object:self userInfo:dict];
        
    }else if (cell.cellType == SMCollectionViewTypeAdd) {
        
        //添加商品
        if ([self.delegate respondsToSelector:@selector(addViewDidClick)]) {
            [self.delegate addViewDidClick];
        }
        
    }
    
}


#pragma mark -- 懒加载
- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
}

- (UICollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.minimumLineSpacing = Margin;//行间距
        _layout.minimumInteritemSpacing = Margin;//列间距
        _layout.itemSize = CGSizeMake(IconWidth, 130 *SMMatchHeight);
        _layout.sectionInset = UIEdgeInsetsMake(Margin, Margin, Margin, Margin);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

@end
