//
//  SMLeftItemBtn.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMLeftItemBtn.h"

static SMLeftItemBtn *instance = nil;

@implementation SMLeftItemBtn

+ (instancetype)leftItemBtn{
//    if (instance == nil) {
//        instance = [[self alloc] init];
//    }
//    return instance;
    return [[self alloc] init];
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    });
//    return instance;
//}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 22)];
////        label.backgroundColor = SMColor(197, 12, 37);
//        [self addSubview:label];
        
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 22, 22)];
        
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
        UIImage* image = [UIImage imageWithData:imageData];
//        if (image) {
//            [btn setBackgroundImage:image forState:UIControlStateNormal];
//        }else{
//            [btn setBackgroundImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
//        }
//        [self addSubview:btn];
//        btn.layer.cornerRadius =11;
//        btn.clipsToBounds = YES;
//        btn.layer.masksToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iconImageChangeNoti:) name:UserIconImageChangeNotification object:nil];
        
        CGFloat wh;
        if (isIPhone5) {
            wh = KIconWH;
        }else if (isIPhone6){
            wh = KIconWH *KMatch6;
        }else if (isIPhone6p){
            wh = KIconWH * KMatch6p;
        }else if (KScreenHeight == 480){
            wh = KIconWH;
        }
        
        UIImageView * imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, wh, wh)];
        imageView.layer.cornerRadius = wh / 2.0;
        imageView.layer.masksToBounds = YES;
        //imageView.userInteractionEnabled = YES;
        imageView.image = image;
        self.customImageView = imageView;

        [self addSubview:imageView];
        
    }
    return self;
}

- (void)iconImageChangeNoti:(NSNotification *)notice{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:KUserIcon];
        UIImage *image = [UIImage imageWithData:imageData];
        self.customImageView.image = image;
        //[self setNeedsDisplay];
    });
}

@end
