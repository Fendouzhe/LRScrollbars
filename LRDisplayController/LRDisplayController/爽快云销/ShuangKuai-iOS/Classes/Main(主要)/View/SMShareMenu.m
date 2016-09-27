//
//  SMShareMenu.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//  

#import "SMShareMenu.h"

@interface SMShareMenu ()

@property (weak, nonatomic) IBOutlet UIView *wechatFreindView;

@property (weak, nonatomic) IBOutlet UIView *wechatTimeLineView;

@property (weak, nonatomic) IBOutlet UIView *QQFreindView;

@property (weak, nonatomic) IBOutlet UIView *QQZoneView;

@property (weak, nonatomic) IBOutlet UIView *wechatFavView;

@property (weak, nonatomic) IBOutlet UIView *sinaVIew;

@property (weak, nonatomic) IBOutlet UIView *SMSView;

//图标 imageview
@property (weak, nonatomic) IBOutlet UIImageView *wechatIcon;

@property (weak, nonatomic) IBOutlet UIImageView *wechatTimeLineIcon;

@property (weak, nonatomic) IBOutlet UIImageView *QQIcon;

@property (weak, nonatomic) IBOutlet UIImageView *QQZoneIcon;

@property (weak, nonatomic) IBOutlet UIImageView *wechatFavIcon;

@property (weak, nonatomic) IBOutlet UIImageView *sinaIcon;

@property (weak, nonatomic) IBOutlet UIImageView *SMSIcon;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@end

@implementation SMShareMenu

+ (instancetype)shareMenu{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMShareMenu" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    self.wechatFreindView.tag = SSDKPlatformSubTypeWechatSession;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatFreindTap:)];
    [self.wechatFreindView addGestureRecognizer:tap1];
    
    self.wechatTimeLineView.tag = SSDKPlatformSubTypeWechatTimeline;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatTimeLineTap:)];
    [self.wechatTimeLineView addGestureRecognizer:tap2];
    
    self.QQFreindView.tag = SSDKPlatformSubTypeQQFriend;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQFreindTap:)];
    [self.QQFreindView addGestureRecognizer:tap3];
    
    self.QQZoneView.tag = SSDKPlatformSubTypeQZone;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQZoneTap:)];
    [self.QQZoneView addGestureRecognizer:tap4];
    
    self.wechatFavView.tag = SSDKPlatformSubTypeWechatFav;
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatFavTap:)];
    [self.wechatFavView addGestureRecognizer:tap5];
    
    self.sinaVIew.tag = SSDKPlatformTypeSinaWeibo;
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sinaTap:)];
    [self.sinaVIew addGestureRecognizer:tap6];
    
    self.SMSView.tag = SSDKPlatformTypeSMS;
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SMSTap:)];
    [self.SMSView addGestureRecognizer:tap7];
    
    
    self.wechatIcon.layer.cornerRadius = 20;
    self.wechatIcon.clipsToBounds = YES;
    self.wechatTimeLineIcon.layer.cornerRadius = 20;
    self.wechatTimeLineIcon.clipsToBounds = YES;
    self.wechatFavIcon.layer.cornerRadius = 20;
    self.wechatFavIcon.clipsToBounds = YES;
    self.QQIcon.layer.cornerRadius = 20;
    self.QQIcon.clipsToBounds = YES;
    self.QQZoneIcon.layer.cornerRadius = 20;
    self.QQZoneIcon.clipsToBounds = YES;
    self.sinaIcon.layer.cornerRadius = 20;
    self.sinaIcon.clipsToBounds = YES;
    self.SMSIcon.layer.cornerRadius = 20;
    self.SMSIcon.clipsToBounds = YES;
    
    
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
}

- (void)onlyShowWeiXinShare{
    self.QQFreindView.hidden = YES;
    self.QQZoneView.hidden = YES;
    self.wechatFavView.hidden = YES;
    self.sinaVIew.hidden = YES;
    self.SMSView.hidden = YES;
}
- (void)setIsCreatedByArticle:(BOOL)isCreatedByArticle{
    _isCreatedByArticle = isCreatedByArticle;
    
    if (isCreatedByArticle) { //如果是从文章分享页面创建的   就只显示分享到微信好友，微信朋友圈
        self.secondView.hidden = YES;
        self.QQFreindView.hidden = YES;
        self.QQZoneView.hidden = YES;
    }
}

- (IBAction)cancelBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelBtnDidClick)]) {
        [self.delegate cancelBtnDidClick];
    }
}

- (void)wechatFreindTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)wechatTimeLineTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)QQFreindTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)QQZoneTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)wechatFavTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)sinaTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

- (void)SMSTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(shareBtnDidClick:)]) {
        [self.delegate shareBtnDidClick:gesture.view.tag];
    }
}

@end
