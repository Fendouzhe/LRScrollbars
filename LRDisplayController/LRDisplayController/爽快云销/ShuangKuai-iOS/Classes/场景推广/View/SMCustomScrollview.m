//
//  SMCustomScrollview.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCustomScrollview.h"
#import "SMScenePromotionBottomView.h"
@interface SMCustomScrollview () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic ,strong)NSArray *arrColor;/**< 底部颜色 */
@end

@implementation SMCustomScrollview


- (id)initWithFrame:(CGRect)frame target:(id<UIScrollViewDelegate>)target{
    self = [super initWithFrame:frame];
    if (self){
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(KScreenWidth / 6, 0, KScreenWidth * 2 / 3, KScreenHeight)];
        _scrollview.pagingEnabled = YES;
        _scrollview.clipsToBounds = NO;
        [self addSubview:_scrollview];
        self.clipsToBounds = YES;
        // 添加代理
        _scrollview.delegate = target;
        
        self.arrColor = @[SMColor(42, 68, 89),SMColor(210, 52, 158),SMColor(157, 106, 79),SMColor(230, 97, 3),SMColor(55, 110, 149),SMColor(224, 154, 4),SMColor(42, 68, 89),SMColor(210, 52, 158)];
    }
    return self;
}



//// 加载网络图片
//- (void)loadImagesWithUrl:(NSArray *)array{
//    _picArray = array;
//    int index = 0;
//    [_scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    for(NSString * name in array){
//        //        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(sWIDTH * 2 / 3 * index, sHEIGHT / 6, sWIDTH * 2 / 3, sHEIGHT * 2 / 3)];
//        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * 2 / 3 * index, KScreenHeight / 6, KScreenWidth * 2 / 3, KScreenHeight * 2 / 3)];
//        if (index != 1) {
//            CGRect image = iv.bounds;
//            image.size.width =  KScreenWidth * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * 1) )/ KScreenWidth * 2 / 3 + 0.8 *KScreenWidth * 2 / 3;
//            image.size.height =  KScreenHeight * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * 1) )/ KScreenWidth * 2 / 3 + 0.8 *KScreenHeight * 2 / 3;
//            iv.bounds = image;
//        }
//        
//        [iv sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"0"]];
//        iv.contentMode = UIViewContentModeScaleToFill;
//        [_scrollview addSubview:iv];
//        [self.imageViewArray addObject:iv];
//        iv.tag = index;
//        
//        index++;
//    }
//    _scrollview.contentSize = CGSizeMake((_scrollview.frame.size.width) * index, 0);
//}

- (void)loadImages:(NSArray *)array{
    _picArray = array;
    int index = 0;
    [_scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(NSString * name in array){
        
        UIView *fatherView = [[UIView alloc] init];
        
        
        fatherView.frame = CGRectMake(KScreenWidth * 2 / 3 * index, 47 *SMMatchHeight, KScreenWidth * 2 / 3, KScreenHeight * 2 / 3);
        if (index != 1) {
            CGRect image = fatherView.bounds;
            image.size.width =  KScreenWidth * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * 1) )/ KScreenWidth * 2 / 3 + 0.8 *KScreenWidth * 2 / 3;
            image.size.height =  KScreenHeight * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * 1) )/ KScreenWidth * 2 / 3 + 0.8 *KScreenHeight * 2 / 3;
            fatherView.bounds = image;
        }
        
//        fatherView.backgroundColor = [UIColor yellowColor];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        
        iv.contentMode = UIViewContentModeScaleToFill;
        [fatherView addSubview:iv];
        iv.frame = fatherView.bounds;
        fatherView.layer.cornerRadius = SMCornerRadios;
        fatherView.clipsToBounds = YES;
        
        SMScenePromotionBottomView *bottomView = [SMScenePromotionBottomView scenePromotionBottomView];
        [fatherView addSubview:bottomView];
        UIColor *color = self.arrColor[index];
        bottomView.backgroundColor = color;
        CGFloat bottomHeight = 75;
        bottomView.frame = CGRectMake(0, fatherView.height - bottomHeight, fatherView.width, bottomHeight);
        bottomView.alpha = 0.5;
        
//        fatherView.layer.shadowColor = [UIColor grayColor].CGColor;
//        fatherView.layer.shadowOffset = CGSizeMake(10, 10);
//        
//        fatherView.layer.shadowRadius = 5;
//        fatherView.layer.shadowOpacity = 0.8;
        fatherView.layer.borderWidth = 0.5;
        fatherView.layer.borderColor = [UIColor grayColor].CGColor;
        
        [_scrollview addSubview:fatherView];
        [self.imageViewArray addObject:fatherView];
        fatherView.tag = index;
        index++;
    }
    
    _scrollview.contentSize = CGSizeMake((_scrollview.frame.size.width) * index, 0);
}

// 滚动时改变大小
#pragma

- (void)scroll{
    int index = _scrollview.contentOffset.x / (KScreenWidth * 2 / 3);
    
    if (index == 0) {
        for (int i = 0; i < 2; i++) {
//            UIImageView *im = _imageViewArray[i];
            UIView *im = _imageViewArray[i];
            CGRect image = im.bounds;
            image.size.width =  KScreenWidth * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenWidth * 2 / 3;
            image.size.height =  KScreenHeight * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenHeight * 2 / 3;
            im.bounds = image;
            
            for (UIView *subV in im.subviews) {
                if ([[subV class] isSubclassOfClass:[UIImageView class]]) { //图像
                    subV.width = im.width;
                    subV.height = im.height;
                }else if ([[subV class] isSubclassOfClass:[SMScenePromotionBottomView class]]){
                    subV.width = im.width;
                    subV.height = im.height / 4.44;
                    subV.y = im.height - subV.height;
                }
            }
        }
    }else if(index == _picArray.count - 1){
        for (int i = index - 1; i < index + 1; i++) {
//            UIImageView *im = _imageViewArray[i];
            UIView *im = _imageViewArray[i];
            CGRect image = im.bounds;
            image.size.width =  KScreenWidth * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenWidth * 2 / 3;
            image.size.height =  KScreenHeight * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenHeight * 2 / 3;
            im.bounds = image;
            for (UIView *subV in im.subviews) {
                if ([[subV class] isSubclassOfClass:[UIImageView class]]) {
                    subV.width = im.width;
                    subV.height = im.height;
                }else if ([[subV class] isSubclassOfClass:[SMScenePromotionBottomView class]]){
                    subV.width = im.width;
                    subV.height = im.height / 4.44;
                    subV.y = im.height - subV.height;
                }
            }
        }
    }else{
        for (int i = index - 1; i < index + 2; i++) {
//            UIImageView *im = _imageViewArray[i];
            UIView *im = _imageViewArray[i];
            CGRect image = im.bounds;
            image.size.width =  KScreenWidth * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenWidth * 2 / 3;
            image.size.height =  KScreenHeight * 2 / 3 * 0.2 * (KScreenWidth * 2 / 3 -  fabs(_scrollview.contentOffset.x - KScreenWidth * 2 / 3 * i) )/ (KScreenWidth * 2 / 3) + 0.8 * KScreenHeight * 2 / 3;
            im.bounds = image;
            for (UIView *subV in im.subviews) {
                if ([[subV class] isSubclassOfClass:[UIImageView class]]) {
                    subV.width = im.width;
                    subV.height = im.height;
                }else if ([[subV class] isSubclassOfClass:[SMScenePromotionBottomView class]]){
                    subV.width = im.width;
                    subV.height = im.height / 4.44;
                    subV.y = im.height - subV.height;
                }
            }
        }
    }
}




#pragma mark -- 懒加载

- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        self.imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}
@end
