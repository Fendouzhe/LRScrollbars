//
//  SMNewShelfManagerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewShelfManagerCell.h"
#import "SMShelfManagerScrollProduct.h"
#import "SMNewFav.h"
#import "SMNewProduct.h"

#define IconWidth 90 *SMMatchWidth
#define Margin 10

@interface SMNewShelfManagerCell ()



@property (weak, nonatomic) IBOutlet UIButton *productNameBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic ,strong)SMShelfManagerScrollProduct *addView;

@property (weak, nonatomic) IBOutlet UIView *bottomVIew;

@property (nonatomic ,assign)CGFloat margin;

@property (nonatomic ,strong)NSMutableArray *arrProducts;

@property (nonatomic ,assign)CGFloat height;
@property (nonatomic ,assign)CGFloat width;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@property (nonatomic ,strong)NSMutableArray *arrDeleteIDs;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bjIconHeight;


@end

@implementation SMNewShelfManagerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"newShelfManagerCell";
    SMNewShelfManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //SMLog(@"awakeFromNib");
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.margin = 10;
    self.height = 130 *SMMatchHeight;
    self.width = IconWidth;
    self.productNameBtn.userInteractionEnabled = NO;
    self.bottomVIew.backgroundColor = KControllerBackGroundColor;
    
    self.scrollView.contentSize = CGSizeMake((IconWidth + Margin) * 5, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.backgroundColor = KControllerBackGroundColor;
    
    //添加按钮view
    SMShelfManagerScrollProduct *addView = [SMShelfManagerScrollProduct shelfManagerScrollProduct];
    addView.productIcon.image = [UIImage imageNamed:@"加-(2)"];
    [self.scrollView addSubview:addView];
    self.addView = addView;
    addView.frame = CGRectMake(self.margin, self.margin, IconWidth, 130);
    self.addView.productName.text = @"";
    self.addView.price.text = @"";
    [addView.gouBtn removeFromSuperview];
    //点击手势  添加新商品
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap)];
    [addView addGestureRecognizer:tap];
    
    
    //点击手势  单击背景图  提示是否切换到此柜台
    UITapGestureRecognizer *changeNowShelfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNowShelf)];
    self.bjIcon.userInteractionEnabled = YES;
    [self.bjIcon addGestureRecognizer:changeNowShelfTap];
    
    //给背景图添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.bjIcon addGestureRecognizer:longPress];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureDownProductNoti) name:KSureDownProductNoti object:nil];
    
    self.bjIconHeight.constant = 170 *SMMatchHeight;
}

- (void)setFavNew:(SMNewFav *)favNew{
    _favNew = favNew;
    //SMLog(@"setFavNew");
    [self.productNameBtn setTitle:favNew.favName forState:UIControlStateNormal];
    NSString *imagePath = [favNew.bgImage stringByAppendingString:[NSString stringWithFormat:@"?w=%zd&h=%zd&q=60",KScreenWidth *2.2,175 *2.2]];
//    [self.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"] options:SDWebImageRefreshCached];
    [self.bjIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"微货架-beijing 5"]];
    self.arrProducts = [NSMutableArray arrayWithArray:favNew.items];
    [self resetScrollView];
}

- (void)resetScrollView{

//    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj != self.addView) {
//            [obj removeFromSuperview];
//        }
//    }];
    for (NSInteger i = 0; i < self.arrProducts.count; i++) {
        //SMLog(@"self.arrProducts.count   %zd",self.arrProducts.count);
        SMShelfManagerScrollProduct *productView = [SMShelfManagerScrollProduct shelfManagerScrollProduct];
        [self.scrollView addSubview:productView];
        productView.product = self.arrProducts[i];
        CGFloat x = self.margin + (self.margin + self.width) *i;
        productView.frame = CGRectMake(x, self.margin, self.width, self.height);
    }
    
    if (self.arrProducts.count == 5) {
        self.addView.hidden = YES;
    }else{
        self.addView.hidden = NO;
        if (5 > self.arrProducts.count >= 1) { //少于5个商品的时候
            CGFloat x = self.margin + (self.margin + self.width) *self.arrProducts.count;
            self.addView.frame = CGRectMake(x, self.margin, self.width, self.height);
        }
    }
    
    
}



//- (void)sureDownProductNoti{
//    
//    for (UIView *view in self.scrollView.subviews) {
//        if ([view isKindOfClass:[SMShelfManagerScrollProduct class]]) {
//            if (![view isEqual:self.addView]) {
//                
//                SMShelfManagerScrollProduct *productDeleteView = (SMShelfManagerScrollProduct *)view;
//                if (productDeleteView.product.gouSelected) {
//                    [self.arrDeleteIDs addObject:productDeleteView.product.id];
//                }
//                
//            }
//        }
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(downProductBtnDidClick:and:)]) {
//        [self.delegate downProductBtnDidClick:self.arrDeleteIDs and:self.favNew.favId];
//        [self.arrDeleteIDs removeAllObjects];
//        SMLog(@"调用代理删除商品");
//    }
//    
//}


- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    SMLog(@"longPressAction");
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(bjIconDidLongPress:)]) {
            [self.delegate bjIconDidLongPress:self.tag];
        }
    }   
}

- (void)changeNowShelf{

        //发通知给展示产品的vc 刷新界面
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"KRefreshShelfProductKey"] = self.fav.id; //当前货架的id
    
//        [[NSUserDefaults standardUserDefaults] setInteger:row forKey:KCurrentSelectedShelf];
    if ([self.delegate respondsToSelector:@selector(changeShelfBtnDidClick:favID:)]) {
        [self.delegate changeShelfBtnDidClick:self.tag favID:self.favNew.favId];
    }
 
}
//“+”图片点击
- (void)addViewTap{
    if ([self.delegate respondsToSelector:@selector(addViewDidClick)]) {
        [self.delegate addViewDidClick];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //SMLog(@"self.addView.frame  %@",NSStringFromCGRect(self.addView.frame));
}

#pragma mark -- 懒加载
- (NSMutableArray *)arrProducts{
    if (_arrProducts == nil) {
        _arrProducts = [NSMutableArray array];
    }
    return _arrProducts;
}

- (NSMutableArray *)arrDeleteIDs{
    if (_arrDeleteIDs == nil) {
        _arrDeleteIDs = [NSMutableArray array];
    }
    return _arrDeleteIDs;
}

@end
