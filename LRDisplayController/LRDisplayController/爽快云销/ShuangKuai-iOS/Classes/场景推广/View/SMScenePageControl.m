//
//  SMScenePageControl.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMScenePageControl.h"

#define AnimationKey @"AnimationGroup"

//static SMScenePageControl *instance = nil;

@implementation SMScenePageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
//     self.activeImage = [UIImage imageNamed:@"产品jiantou.png"];
//     self.inactiveImage = [UIImage imageNamed:@"产品jiantou.png"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageAnimationNotifi:) name:PageControlStartAnimationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnimationNotifi:) name:PageControlRemoveAnimationNotification object:nil];
    }
     return self;
}

//+ (instancetype)sharedPageControl{
//    if (instance == nil) {
//        instance = [[self alloc] init];
//    }
//    return instance;
//}
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    });
//    return instance;
//}

- (void)pageAnimationNotifi:(NSNotification *)notice{

    NSInteger index = [notice.userInfo[@"index"] integerValue];
    UIView *view = self.subviews[index];
    
//    //放大动画
//    CABasicAnimation *scaleAnimate = [CABasicAnimation animation];
//    scaleAnimate.keyPath = @"transform.scale";
//    scaleAnimate.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(view.layer.transform, 0.8, 0.8, 0)];
//    scaleAnimate.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(view.layer.transform, 2, 2, 0)];
//    
//    //透明动画
//    CABasicAnimation *opacAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
//    opacAnimation.toValue = [NSNumber numberWithFloat:0.0f];
//    
//    //组动画
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = @[scaleAnimate,opacAnimation];
//    group.duration = 2;
//    //group.autoreverses = YES;
//    group.removedOnCompletion = NO;
//    group.fillMode = kCAFillModeForwards;
//    group.repeatCount = MAXFLOAT;
//    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    [view.layer addAnimation:group forKey:AnimationKey];
//    
//    SMLog(@"view.layer.animationKeys = %@",view.layer.animationKeys);
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    //去掉背景色
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 4; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = view.layer.bounds;
        if (index == self.currentPage) {
            circle.backgroundColor = self.currentPageIndicatorTintColor.CGColor;
        }else{
            circle.backgroundColor = self.pageIndicatorTintColor.CGColor;
        }
        
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 0.98f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.8f, 2.8f, 0.0f)];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(0.98f);
        opacityAnimation.toValue = @(0.0f);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.removedOnCompletion = NO;
        animationGroup.beginTime = beginTime + i * 0.8f;
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = 3.2f;
        animationGroup.animations = @[transformAnimation, opacityAnimation];
        
        [view.layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:AnimationKey];
    }

}

- (void)removeAnimationNotifi:(NSNotification *)notice{
    NSInteger index = [notice.userInfo[@"index"] integerValue];
    UIView *view = self.subviews[index];
    [view.layer removeAllAnimations];
    
//    NSMutableArray *arr = [NSMutableArray array];
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.layer.animationKeys.count) {
//            [arr addObject:obj.layer.animationKeys];
//        }
//    }];
//    ///没有还在动画的page
//    if (arr.count == 0) {
//        //移除场景推广 Tabbar消息红点
//        [[NSNotificationCenter defaultCenter] postNotificationName:RemoveSceneTabbarBageNotification object:nil userInfo:nil];
//    }
    
    [view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeAllAnimations];
    }];
    if (index == self.currentPage) {
        view.backgroundColor = self.currentPageIndicatorTintColor;
    }else{
        view.backgroundColor = self.pageIndicatorTintColor;
    }
    NSMutableArray *arr = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
            if (layer.animationKeys.count) {
                [arr addObject:layer.animationKeys];
            }
        }];
    }];
    ///没有还在动画的page
    if (arr.count == 0) {
        //移除场景推广 Tabbar消息红点
        [[NSNotificationCenter defaultCenter] postNotificationName:RemoveTabbarBageNotification object:nil userInfo:@{@"index":@"1"}];
    }
}


-(void)setCurrentPage:(NSInteger)page
{
     [super setCurrentPage:page];
    
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger viewIndex, BOOL * _Nonnull stop) {
        [view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger layerIndex, BOOL * _Nonnull stop) {
            //有动画
            if (layer.animationKeys.count) {
                view.backgroundColor = [UIColor clearColor];
                if (viewIndex == self.currentPage) {
                    layer.backgroundColor = self.currentPageIndicatorTintColor.CGColor;
                }else{
                    layer.backgroundColor = self.pageIndicatorTintColor.CGColor;
                }
            }else{
                if (viewIndex == self.currentPage) {
                    view.backgroundColor = self.currentPageIndicatorTintColor;
                }else{
                    view.backgroundColor = self.pageIndicatorTintColor;
                }
            }
        }];
    }];
 
}



@end
