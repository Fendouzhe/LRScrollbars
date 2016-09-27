//
//  SMEmotionPageView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMEmotionPageView.h"
#import "SMEmotion.h"
#import "SMEmotionPopView.h"
#import "SMEmotionButton.h"

@interface SMEmotionPageView()
/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) SMEmotionPopView *popView;
@end

@implementation SMEmotionPageView

- (SMEmotionPopView *)popView{
    if (!_popView) {
        self.popView = [SMEmotionPopView popView];
    }
    return _popView;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        SMEmotionButton *btn = [[SMEmotionButton alloc] init];
        [self addSubview:btn];
        
        btn.emotion = emotions[i];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnClick:(SMEmotionButton *)btn{
    self.popView.emotion = btn.emotion;
    
    //拿到最外层的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 把放大镜添加到最外层window 上
    [window addSubview:self.popView];
    
    //放大镜的位置
    CGRect btnFrame = [btn.superview convertRect:btn.frame toView:nil];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height;
    self.popView.centerX = CGRectGetMidX(btnFrame);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[SMEmotionDictKey] = btn.emotion;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SMEmotionNotificationName object:nil userInfo:dict];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.popView removeFromSuperview];
    });
    
}

@end
