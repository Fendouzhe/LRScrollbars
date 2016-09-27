//
//  SMComposePhotosView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMComposePhotosView.h"

@interface SMComposePhotosView ()<UIAlertViewDelegate>

/**
 *  添加按钮
 */
@property (nonatomic ,strong)UIButton *addBtn;

/**
 *  定位的一整行view
 */
@property (nonatomic ,strong)UIView *locationView;

/**
 *  上面的灰色线
 */
@property (nonatomic ,strong)UIView *topGrayView;

/**
 *  下面的灰色线
 */
@property (nonatomic ,strong)UIView *bottomGrayView;

/**
 *  定位的标志图
 */
@property (nonatomic ,strong)UIButton *locationBtn;

/**
 *  右边的箭头
 */
@property (nonatomic ,strong)UIImageView *arrowView;

@property (nonatomic ,strong)UIAlertView *alert;
/**
 *  标记要删除的图片
 */
@property (nonatomic ,strong)UIButton *btnDelete;

@end

@implementation SMComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor greenColor];
        //装相片的数组
        _photos = [NSMutableArray array];
        
        //加号 添加按钮
        _addBtn = [[UIButton alloc] init];
        self.addBtn = _addBtn;
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"addBtnImage"] forState:UIControlStateNormal];
        [self addSubview:_addBtn];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];

        //**************
        //下面定位的整体view
        UIView *locationView = [[UIView alloc] init];
        self.locationView = locationView;
//        locationView.backgroundColor = [UIColor redColor];
        [self addSubview:locationView];
        
        //上面的灰色横线
        UIView *topGrayView = [[UIView alloc] init];
        self.topGrayView = topGrayView;
        topGrayView.backgroundColor = [UIColor lightGrayColor];
        [locationView addSubview:topGrayView];
        
        //下面的灰色view
        UIView *bottomGrayView = [[UIView alloc] init];
        self.bottomGrayView = bottomGrayView;
        [locationView addSubview:bottomGrayView];
        bottomGrayView.backgroundColor = [UIColor lightGrayColor];
        
        //定位图标
        UIButton *locationBtn = [[UIButton alloc] init];
        self.locationBtn = locationBtn;
        [locationBtn setBackgroundImage:[UIImage imageNamed:@"ditudingwei"] forState:UIControlStateNormal];
        [locationView addSubview:locationBtn];
        [locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        //“所在位置” 按钮
        UIButton *locationBtnText = [[UIButton alloc] init];
        self.locationBtnText = locationBtnText;
        [locationView addSubview:locationBtnText];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor blackColor];
        dict[NSFontAttributeName] = KDefaultFontBig;
        if (self.locationBtnTextStr == nil) {
            self.locationBtnTextStr = @"所在位置";
        }
        NSAttributedString *locationStr = [[NSAttributedString alloc] initWithString:self.locationBtnTextStr attributes:dict];
        [locationBtnText setAttributedTitle:locationStr forState:UIControlStateNormal];
        [locationBtnText addTarget:self action:@selector(locationBtnTextClick) forControlEvents:UIControlEventTouchUpInside];
        locationBtnText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //右边的箭头
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = [UIImage imageNamed:@"fanhuijiantou"];
        self.arrowView = arrowView;
        [locationView addSubview:arrowView];
//
    }
    return self;
}

#pragma mark -- 点击事件
- (void)locationBtnTextClick{
    SMLog(@"点击了 “所在位置” 按钮");
    if ([self.delegate respondsToSelector:@selector(locationBtnDidClick)]) {
        [self.delegate locationBtnDidClick];
    }
}

- (void)locationBtnClick{
    SMLog(@"点击了 定位按钮");
    if ([self.delegate respondsToSelector:@selector(locationBtnDidClick)]) {
        [self.delegate locationBtnDidClick];
    }
}

- (void)addBtnClick{
    SMLog(@"点击了添加按钮");
    if ([self.delegate respondsToSelector:@selector(addBtnDidClick)]) {
        [self.delegate addBtnDidClick];
    }
    SMLog(@"self.photos.count  %zd",self.photos.count);
}

- (void)addphoto:(UIImage *)photo{
    
//    UIImageView *photoView = [[UIImageView alloc] init];
//    photoView.image = photo;
    UIButton *photoView = [[UIButton alloc] init];
    [photoView setBackgroundImage:photo forState:UIControlStateNormal];
    [self addSubview:photoView];
    [self.photos addObject:photo];
    [photoView addTarget:self action:@selector(photoViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewLongPress:)];
    [photoView addGestureRecognizer:longPress];
    
}

#pragma mark -- 长按手势
- (void)photoViewLongPress:(UILongPressGestureRecognizer *)gesture{
    if (self.alert) {
        return;
    }
    self.btnDelete = (UIButton *)[gesture view];
    SMLog(@"photoViewLongPress   %@",self.btnDelete);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert = alert;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    SMLog(@"buttonIndex  %zd",buttonIndex);
    self.alert = nil;
    if (buttonIndex == 0) {
        SMLog(@"点击了取消   不做任何事情");
    }else if (buttonIndex == 1){
        SMLog(@"点击了 确定删除");
        [self.btnDelete removeFromSuperview];
        //同时刷新自己的photos数组，一面重新打开大图时不同步。
        [self.photos removeObject:self.btnDelete.currentBackgroundImage];
//        self.btnDelete.currentBackgroundImage
        SMLog(@"self.photos.count  alertView  %zd",self.photos.count);
        
        NSNumber *imageCount = [NSNumber numberWithInteger:self.photos.count];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"KImageCountNotiKey"] = imageCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KImageCountNoti" object:self userInfo:dict];
    }
}

#pragma mark -- 点击事件
- (void)photoViewClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(photoViewDidClick:andPhotos:)]) {
        [self.delegate photoViewDidClick:btn andPhotos:self.photos];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //让加号按钮一直处在最前面
    [self.addBtn removeFromSuperview];
    [self addSubview:self.addBtn];
    
    NSUInteger count = self.subviews.count ;
    SMLog(@"count   %zd",count);
    int maxCol = 4;
    CGFloat imageMargin = 10;
    CGFloat imageWH = (KScreenWidth - imageMargin *(maxCol + 1)) / maxCol;
    
//    if (count <= maxCol) {
//        self.viewHeight = imageWH;
//    }else if (count >4 && count <= 8 ){
//        self.viewHeight = imageWH + (imageWH + imageMargin);
//    }
    
    for (int i = 0; i < count; i++) {
        
//        UIImageView *photoView = self.subviews[i];
        UIButton *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.x = imageMargin + (imageWH + imageMargin) * col;
        int row = i / maxCol;
        photoView.y = imageMargin + row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
        
//        int colAdd = (i + 1) % maxCol;
//        int rowAdd = (i + 1) / maxCol;
//        self.addBtn.x = colAdd * (imageWH + imageMargin);
//        self.addBtn.y = rowAdd * (imageWH + imageMargin);
//        self.addBtn.width = imageWH;
//        self.addBtn.height = imageWH;
        
        self.addBtn.x = imageMargin;
        self.addBtn.y = imageMargin;
        self.addBtn.width = imageWH;
        self.addBtn.height = imageWH;
    }
    
    //定位整体view
    CGFloat locationH = 40;
    int i = ((int)self.subviews.count - 2) / maxCol;
    SMLog(@"定位view   %zd",i);
    CGFloat locationY = imageMargin + (imageMargin + imageWH) * (i + 1);
    self.locationView.frame = CGRectMake(0, locationY, KScreenWidth, locationH);
    
    //定位左边图标
    CGFloat locationBtnWH = 25;
    CGFloat locationBtnY = (locationH - locationBtnWH) / 2.0;
    CGFloat locationBtnX = locationBtnY;
    self.locationBtn.frame = CGRectMake(locationBtnX, locationBtnY, locationBtnWH, locationBtnWH);
    
    //定位文字    locationBtnText
    CGFloat locationTextX = locationBtnX + locationBtnWH;
    CGFloat locationTextY = 0;
    CGFloat locationTextH = locationH;
    CGFloat locationTextW = KScreenWidth - locationTextX;
    self.locationBtnText.frame = CGRectMake(locationTextX, locationTextY, locationTextW, locationTextH);
    
    //右边箭头  arrowView
    CGFloat arrowWH = 15;
    CGFloat arrowX = KScreenWidth - arrowWH - imageMargin;
    CGFloat arrowY = (locationH - arrowWH) / 2.0;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowWH, arrowWH);
    
    //topGrayView
    self.topGrayView.frame = CGRectMake(imageMargin, 0, KScreenWidth - imageMargin, 1);
    
    //bottomGrayView
    self.bottomGrayView.frame = CGRectMake(0, locationH, KScreenWidth, 1);
    
    self.viewHeight = CGRectGetMaxY(self.locationView.frame);
}

- (void)setBtnTitleAgain:(NSString *)str{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = KDefaultFont;
    
    NSAttributedString *locationStr = [[NSAttributedString alloc] initWithString:str attributes:dict];
    [self.locationBtnText setAttributedTitle:locationStr forState:UIControlStateNormal];
    
}

@end
