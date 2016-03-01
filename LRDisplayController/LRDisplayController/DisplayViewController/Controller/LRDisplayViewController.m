//
//  LRDisplayViewController.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRDisplayViewController.h"
#import "LRDisplayViewHeader.h"
#import "LRDisplayTitleLabel.h"
#import "UIView+Frame.h"
#import "LRFlowLayout.h"

@interface LRDisplayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 整体内容View 包含标题滚动视图和内容滚动视图 */
@property (nonatomic, weak) UIView *contentView;

/** 标题滚动视图 */
@property (nonatomic, weak) UIScrollView *titleScrollView;

/** 内容滚动视图 */
@property (nonatomic, weak) UICollectionView *contentCollectionView;

/** 所有标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

/** 所有标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;

/** 下标视图 */
@property (nonatomic, weak) UIView *underLine;

/** 标题遮盖视图 */
@property (nonatomic, weak) UIView *coverView;

/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;

/** 记录是否点击 */
@property (nonatomic, assign) BOOL isClickTitle;

/** 记录是否在动画 */
@property (nonatomic, assign) BOOL isAniming;

/** 是否初始化 */
@property (nonatomic, assign) BOOL isInitial;

/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;

/** 记录上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;

@end

@implementation LRDisplayViewController

#pragma mark - 初始化方法 -----------
- (instancetype)init{
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initial];
}

- (void)initial{
    //初始化标题高度44
    _titleHeight = LRTitleScrollViewH;
    //是否根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的 inset,
    //设置为no，让它不要自动调整,否则cell和titleScrollView距离不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/// 初始化
- (void)setup{
    //字体渐变，模式是RGB
    if (_isShowTitleGradient && _titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
        //初始化颜色渐变
        if (_endR == 0 && _endG == 0 && _endB == 0) {
            _endR = 1;//设置红色
        }
    }
}

#pragma mark - 懒加载 ---------------

- (UIFont *)titleFont{
    if (_titleFont == nil) {
        _titleFont = LRTitleFont;
    }
    return _titleFont;
}

- (NSMutableArray *)titleWidths{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (UIColor *)normalColor{
    if (_isShowTitleGradient && _titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
        _normalColor = [UIColor colorWithRed:_startR green:_startG blue:_startB alpha:1];
    }
    if (_normalColor == nil) {
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}

- (UIColor *)selectColor{
    if (_isShowTitleGradient && _titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
        _selectColor = [UIColor colorWithRed:_endR green:_endG blue:_endB alpha:1];
    }
    if (_selectColor == nil) {
        _selectColor = [UIColor redColor];
    }
    return _selectColor;
}

- (UIView *)coverView{
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = _coverColor ? _coverColor : [UIColor lightGrayColor];
        coverView.layer.cornerRadius = _coverCornerRadius;
        //放到滚动标题view最下面一层
        [self.titleScrollView insertSubview:coverView atIndex:0];
        _coverView = coverView;
    }
    return _isShowTitleCover?_coverView : nil;
}

- (UIView *)underLine{
    if (_underLine == nil) {
        UIView *underLineView = [[UIView alloc] init];
        underLineView.backgroundColor = _underLineColor ? _underLineColor : [UIColor redColor];
        [self.titleScrollView addSubview:underLineView];
        _underLine = underLineView;
    }
    return _isShowUnderLine ? _underLine : nil;
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

/// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView{
    if (_titleScrollView == nil) {
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.backgroundColor = _titleScrollViewColor ? _titleScrollViewColor : [UIColor colorWithWhite:1 alpha:0.7];
        [self.contentView addSubview:titleScrollView];
        _titleScrollView = titleScrollView;
    }
    return _titleScrollView;
}

/// 懒加载内容滚动视图
- (UICollectionView *)contentCollectionView{
    if (_contentCollectionView == nil) {
        //创建布局
        LRFlowLayout *flowLayout = [[LRFlowLayout alloc] init];
        UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentCollectionView = contentCollectionView;
        // 设置内容滚动视图
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        //设置在titleScrollView正下方
        [self.contentView insertSubview:contentCollectionView belowSubview:self.titleScrollView];
    }
    return _contentCollectionView;
}

/// 懒加载整个内容view
- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self.view addSubview:contentView];
    }
    return _contentView;
}


#pragma mark - 属性setter方法 ----------

- (void)setIsShowTitleScale:(BOOL)isShowTitleScale{
    if (_isShowUnderLine) {
        // 抛异常
        NSException *exception = [NSException exceptionWithName:@"LRDisplayViewControllerException" reason:@"字体放大效果和下划线view不能同时使用。" userInfo:nil];
        [exception raise];
    }
    _isShowUnderLine = isShowTitleScale;
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine{
    if (_isShowTitleScale) {
        // 抛异常
        NSException *exception = [NSException exceptionWithName:@"LRDisplayViewControllerException" reason:@"字体放大效果和下划线view不能同时使用。" userInfo:nil];
        [exception raise];
    }
    _isShowUnderLine = isShowUnderLine;
}

- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor{
    _titleScrollViewColor = titleScrollViewColor;
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}

- (void)setIsfullScreen:(BOOL)isfullScreen{
    _isfullScreen = isfullScreen;
    self.contentView.frame = CGRectMake(0, 0, LRScreenW, LRScreenH);
}

/// 设置整体内容的尺寸
- (void)setupContentViewFrame:(void (^)(UIView *))contentBlock{
    if (contentBlock) {
        contentBlock(self.contentView);
    }
}

/// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void (^)(BOOL *, LRTitleColorGradientStyle *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *))titleGradientBlock{
    if (titleGradientBlock) {
        titleGradientBlock(&_isShowTitleGradient,&_titleColorGradientStyle,&_startR,&_startG,&_startB,&_endR,&_endG,&_endB);
    }
}

/// 一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void (^)(BOOL *, UIColor *__autoreleasing *, CGFloat *))coverEffectBlock{
    UIColor *color;
    if (coverEffectBlock) {
        //经过这一步后color就有值了
        coverEffectBlock(&_isShowTitleCover,&color,&_coverCornerRadius);
        if (color) {
            _coverColor = color;
        }
    }
}

/// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void (^)(BOOL *isShowTitleScale,CGFloat *titleScale))titleScaleBlock{
    if (titleScaleBlock) {
        titleScaleBlock(&_isShowTitleScale,&_titleScale);
    }
}

/// 一次性设置所有下标（下划线view）view属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isShowUnderLine,BOOL *isDelayScroll,CGFloat *underLineH,UIColor **underLineColor))underLineBlock
{
    UIColor *underLineColor;
    
    if (underLineBlock) {
        underLineBlock(&_isShowUnderLine,&_isDelayScroll,&_underLineH,&underLineColor);
        
        _underLineColor = underLineColor;
    }
}

/// 一次性设置所有标题属性
- (void)setupTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **normalColor,UIColor **selectColor,UIFont **titleFont,CGFloat *titleHeight))titleEffectBlock{
    UIColor *titleScrollViewColor;
    UIColor *norColor;
    UIColor *selColor;
    UIFont *titleFont;
    if (titleEffectBlock) {
        //该方法过后前面的变量有值了
        titleEffectBlock(&titleScrollViewColor,&norColor,&selColor,&titleFont,&_titleHeight);
        _normalColor = norColor;
        _selectColor = selColor;
        _titleScrollViewColor = titleScrollViewColor;
        _titleFont = titleFont;
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (self.titleLabels.count) {
        UILabel *label = self.titleLabels[selectIndex];
        //最后添加的点击手势[label.gestureRecognizers lastObject]
        [self titleLabelClick:[label.gestureRecognizers lastObject]];
    }
}

#pragma mark - 控制器view生命周期方法 -------

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // 1 设置整个内容(包含标题滚动视图和内容滚动视图)的尺寸
    //有导航控制器Y就设置64，没有就设置状态栏高度20
    CGFloat contentY = self.navigationController ? LRNavBarH : [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat contentW = LRScreenW;
    CGFloat contentH = LRScreenH - contentY;
    if (self.contentView.height == 0) {
        // 没有设置内容尺寸，才需要设置内容尺寸
        self.contentView.frame = CGRectMake(0, contentY, contentW, contentH);
    }
    
    // 2 设置标题滚动视图frame
    CGFloat titleH = _titleHeight ? _titleHeight : LRTitleScrollViewH;
    CGFloat titleY = _isfullScreen ? contentY : 0;
    self.titleScrollView.frame = CGRectMake(0, titleY, contentW, titleH);
    
    // 3设置内容滚动视图frame
    CGFloat contentScrollY = CGRectGetMaxY(self.titleScrollView.frame);
    self.contentCollectionView.frame = _isfullScreen ? CGRectMake(0, 0, LRScreenW, LRScreenH) : CGRectMake(0, contentScrollY, contentW, LRScreenH - contentScrollY);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isInitial == NO) {
        _isInitial = YES;
        //注册cell
        [self.contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        self.contentCollectionView.backgroundColor = self.view.backgroundColor;
        //初始化
        [self setup];
        // 没有子控制器，不需要设置标题
        if (self.childViewControllers.count == 0) return;
        // 计算所有标题宽度
        [self setUpTitleWidth];
        // 设置所有标题
        [self setUpAllTitle];
    }
}

#pragma mark - 计算所有标题宽度 VS 添加标题方法------------
/// 计算所有标题宽度
- (void)setUpTitleWidth{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.childViewControllers.count;
    // 获取控制器标题
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    
    //计算标题总宽度
    CGFloat totalWidth = 0;
    // 计算所有标题的宽度
    for (NSString *title in titles) {
        //如果标题为空
        if ([title isKindOfClass:[NSNull class]]) {
            //抛异常
            NSException *exception = [NSException exceptionWithName:@"LRDisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [exception raise];
        }
        //计算标题大小
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil].size;
        CGFloat width = titleSize.width;
        //添加标题宽度进数组
        [self.titleWidths addObject:@(width)];
        totalWidth += width;
    }
    //如果标题总宽度超过屏幕宽度，就设置标题间距20
    if (totalWidth > LRScreenW) {
        _titleMargin = margin;
        //设置有间距
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        return;
    }
    //如果没有超过就计算标题间距
    CGFloat titleMargin = (LRScreenW - totalWidth) / (count + 1);
    //判断间距小于20就设置20
    _titleMargin = titleMargin < margin ? margin : titleMargin;
    //设置里面子控件间的间距
    self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
}

/// 设置所有标题
- (void)setUpAllTitle{
    // 遍历所有的子控制器
    NSUInteger count = self.childViewControllers.count;
    // 添加所有的标题
    CGFloat labelW = 0;
    CGFloat labelH = self.titleHeight;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        UILabel *label = [[LRDisplayTitleLabel alloc] init];
        label.tag = i;
        label.textColor = self.normalColor;
        label.font = self.titleFont;
        label.text = vc.title;
        //获取标题宽度
        labelW = [self.titleWidths[i] floatValue];
        //获取上一个标签
        UILabel *lastLabel = [self.titleLabels lastObject];
        //计算x坐标
        labelX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        //给标签添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        
        //将文本标签保存到数组
        [self.titleLabels addObject:label];
        
        [_titleScrollView addSubview:label];
        
        if (i == _selectIndex) {
            [self titleLabelClick:tap];
        }
    }
    //获取最后一个标题
    UILabel *lastLabel = self.titleLabels.lastObject;
    //设置标题滚动视图滚动范围
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    //设置内容滚动视图滚动范围,不设置也可以
    _contentCollectionView.contentSize = CGSizeMake(count * LRScreenW, 0);
}

#pragma mark - 标题效果渐变方法 --------------
/// 设置左右标题颜色渐变---腾讯 VS 今日头条使用 VS 网易新闻 --------
- (void)setupTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(LRDisplayTitleLabel *)rightLabel leftLabel:(LRDisplayTitleLabel *)leftLabel{
    
    if (_isShowTitleGradient == NO) return;
    //获取右边缩放<=1
    CGFloat rightScale = offsetX / LRScreenW - leftLabel.tag;
    //获取左边缩放<=1
    CGFloat leftScale = 1 - rightScale;
    
    NSLog(@"leftScale = %lf,rightScale = %lf",leftScale,rightScale);
    //RGB渐变---------网易新闻---------
    if (_titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
        //获取色差值
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        //设置右边颜色渐变
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightScale green:_startG + g * rightScale blue:_startB + b * rightScale alpha:1];
        //设置左边颜色渐变
        UIColor *leftColor = [UIColor colorWithRed:_startR + r * leftScale green:_startG + g * leftScale blue:_startB + b * leftScale alpha:1];
        //右边颜色
        rightLabel.textColor = rightColor;
        //左边颜色
        leftLabel.textColor = leftColor;
        
        return;
    }
    //实色渲染---------今日头条---------
    if (_titleColorGradientStyle == LRTitleColorGradientStyleFill) {
        // 获取移动距离 = 当前偏移值 - 上一次偏移值
        CGFloat offsetDelta = offsetX - _lastOffsetX;
        
        if (offsetDelta > 0) {//往右边
            
            rightLabel.fillColor = self.selectColor;
            rightLabel.progress = rightScale;
            
            leftLabel.fillColor = self.normalColor;
            leftLabel.progress = rightScale;
            
        }else if (offsetDelta < 0){//往左边
            //右边字体实际颜色是黑色，绘制红色
            rightLabel.textColor = self.normalColor;//黑色
            rightLabel.fillColor = self.selectColor;//红色
            rightLabel.progress = rightScale;
            //左边字体实际颜色是红色，绘制黑色
            leftLabel.textColor = self.selectColor;
            leftLabel.fillColor = self.normalColor;
            leftLabel.progress = rightScale;
        }
    }
}

/// 标题缩放 ---- 网易新闻 ---------
- (void)setupTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel{
    if (_isShowTitleScale == NO) return;
    //获取右边缩放
    CGFloat rightScale = offsetX / LRScreenW - leftLabel.tag;
    CGFloat leftScale = 1 - rightScale;
    
    CGFloat scaleTransform = _titleScale ? _titleScale : LRTitleTransformScale;
    
    scaleTransform -= 1;
    
    //缩放标签
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    // 1 ~ 1.3
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * scaleTransform + 1, rightScale * scaleTransform + 1);
}

/// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}
/// 设置下划线偏移 ---- 喜马拉雅 -----
- (void)setupUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel{
    //如果点击了标题就不再进行后面的计算
    if (_isClickTitle) return;
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    // 获取移动距离 当前偏移值 - 上一次偏移值
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / LRScreenW;
    // 宽度递增/减小量
    CGFloat underLineWidth = offsetDelta * widthDelta / LRScreenW;
    // 重新计算下划线宽度
    self.underLine.width += underLineWidth;
    // 移动下划线
    self.underLine.x += underLineTransformX;
}

/// 设置遮盖偏移 ------ 腾讯使用-------
- (void)setUpCoverOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel{
    //如果点击了标题就不再进行后面的计算
    if (_isClickTitle) return;
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    // 获取移动距离 当前偏移值 - 上一次偏移值
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    // 计算当前下划线偏移量
    CGFloat coverTransformX = offsetDelta * centerDelta / LRScreenW;
    // 宽度递增/减小量
    CGFloat coverOffWidth = offsetDelta * widthDelta / LRScreenW;
    // 重新计算宽度
    self.coverView.width += coverOffWidth;
    // 移动遮盖
    self.coverView.x += coverTransformX;
}

#pragma mark - 标题点击处理 -----------------

/// 标题文本点击手势事件回调方法
- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    //记录点击了标题
    _isClickTitle = YES;
    //获得点击的标题label
    UILabel *label = (UILabel *)tap.view;
    NSInteger i = label.tag;
    //选中label
    [self selectLabel:label];
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * LRScreenW;
    //动画,这样有滑动效果
    [UIView animateWithDuration:0.25 animations:^{
        //偏移collectionView
        self.contentCollectionView.contentOffset = CGPointMake(offsetX, 0);
    }];
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = offsetX;
    // 获取对应的控制器
    UIViewController *vc = self.childViewControllers[i];
    // 判断控制器的view有没有加载，没有就加载，加载完再发送通知
    if (vc.view) {
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LRDisplayViewClickOrScrollDidFinshNotice object:vc];
        // 发出重复点击标题通知
        if (_selIndex == i) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LRDisplayViewRepeatClickTitleNotice object:vc];
        }
    }
    //记录上一次选中角标
    _selIndex = i;
    // 点击事件处理完成
    _isClickTitle = NO;
}
/// 选中标签
- (void)selectLabel:(UILabel *)label{
    //遍历数组标签,未选中的状态还原
    for (LRDisplayTitleLabel *titleLabel in self.titleLabels) {
        //当前选中的标签跳过不设置
        if (label == titleLabel) continue;
        //不是选中标题的状态还原
        if (_isShowTitleGradient && _titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
            //状态还原 ---- 网易使用
            titleLabel.transform = CGAffineTransformIdentity;
        }
        titleLabel.textColor = self.normalColor;
        
        if (_isShowTitleGradient && _titleColorGradientStyle == LRTitleColorGradientStyleFill) {
            titleLabel.fillColor = self.normalColor;
            titleLabel.progress = 1;
        }
    }
    
    //标题缩放
    if (_isShowTitleScale && _titleColorGradientStyle == LRTitleColorGradientStyleRGB) {
        CGFloat scaleTransform = _titleScale ? _titleScale : LRTitleTransformScale;
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }
    // 修改标题选中颜色
    label.textColor = self.selectColor;
    
    // 设置标题居中
    [self setLabelTitleCenter:label];
    
    if (_isShowUnderLine) {
        // 设置下标(下划线view)的位置
        [self setUpUnderLine:label];
    }
    // 设置cover
    [self setUpCoverView:label];
}

/// 设置标题居中
- (void)setLabelTitleCenter:(UILabel *)label{
    // 设置标题滚动区域的偏移量（即标题中心x坐标与屏幕中心x坐标距离）
    CGFloat offsetX = label.center.x - LRScreenW * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - LRScreenW + _titleMargin;
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    // 滚动区域
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label{
    //获得文字尺寸
    CGSize titleSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil].size;
    //计算下划线
    CGFloat underLineH = _underLineH ? _underLineH : LRUnderLineH;
    self.underLine.y = label.height - underLineH;
    self.underLine.height = underLineH;
    // 最开始不需要动画
    if (self.underLine.x == 0) {
        self.underLine.width = titleSize.width;
        self.underLine.x = label.x;
        return;
    }
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.underLine.width = titleSize.width;
        self.underLine.x = label.x;
    }];
}

/// 设置cover
- (void)setUpCoverView:(UILabel *)label{
    //获得文字尺寸
    CGSize titleSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil].size;
    CGFloat border = 5;
    CGFloat coverH = titleSize.height+2*border;
    CGFloat coverW = titleSize.width+2*border;
    
    self.coverView.y = (label.height - coverH)*0.5;
    self.coverView.height = coverH;
    // 最开始不需要动画
    if (self.coverView.x == 0) {
        self.coverView.width = coverW;
        self.coverView.x = label.x - border;
        return;
    }
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = coverW;
        self.coverView.x = label.x - border;
    }];
}

#pragma mark - 刷新界面方法
/// 更新界面
- (void)refreshDisplay{
    // 清空之前所有标题
    [self.titleLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleLabels removeAllObjects];
    
    // 刷新表格
    [self.contentCollectionView reloadData];
    
    // 重新设置标题
    [self setUpTitleWidth];
    
    [self setUpAllTitle];
}

#pragma mark - UICollectionViewDataSource-----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.item];
    vc.view.frame = CGRectMake(0, 0, self.contentCollectionView.width, self.contentCollectionView.height);
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate------
/// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    //转换为NSInteger类型
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = LRScreenW;
    //手指在屏幕拖动的x方向偏移值 = scrollView偏移值磨以屏幕宽度，即求余
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > LRScreenW * 0.5) {//拖动超过到屏幕一半，就自动滚动完剩下的距离
        //往右移动
        offsetX = offsetX + (LRScreenW - extre);
        _isAniming = YES;
        [self.contentCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }else if (extre < LRScreenW*0.5 && extre > 0){//拖动没有超过到屏幕一半，就自动回滚复位
        _isAniming = YES;
        //往左移动
        offsetX = offsetX - extre;
        [self.contentCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    //获取标签下标
    NSInteger i = offsetX / LRScreenW;
    //选中对应标题
    [self selectLabel:self.titleLabels[i]];
    //取出对应控制器
    UIViewController *vc = self.childViewControllers[i];
    //发出通知加载对应控制器界面
    [[NSNotificationCenter defaultCenter] postNotificationName:LRDisplayViewClickOrScrollDidFinshNotice object:vc];
}

///滚动动画完成调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _isAniming = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 点击和动画的时候不需要设置
    if (_isAniming || self.titleLabels.count == 0) return;
    //获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取左边标签下标
    NSInteger leftIndex = offsetX / LRScreenW;
    //获取左边标签
    LRDisplayTitleLabel *leftLabel = self.titleLabels[leftIndex];
    //获取右边标签下标
    NSInteger rightIndex = leftIndex + 1;
    //获取右边标签
    LRDisplayTitleLabel *rightLabel = nil;
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    //字体放大
    [self setupTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    // 设置下标偏移
    if (_isDelayScroll == NO) {// 延迟滚动，不需要移动下标
        [self setupUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    // 设置遮盖偏移
    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    // 设置标题渐变
    [self setupTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    // 记录偏移量
    _lastOffsetX = offsetX;
}

@end





























