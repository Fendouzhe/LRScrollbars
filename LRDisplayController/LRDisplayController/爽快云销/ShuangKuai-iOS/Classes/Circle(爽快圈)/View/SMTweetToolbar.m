//
//  SMTweetToolbar.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTweetToolbar.h"


@interface SMTweetToolbar ()

/**
 *  转发按钮
 */
@property (nonatomic, weak) UIButton *repostBtn;
/**
 *  评论按钮
 */
@property (nonatomic, weak) UIButton *commentBtn;


/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic ,strong)UIView *grayView;

@end

@implementation SMTweetToolbar

+ (instancetype)toolbar{
    return [[self alloc] init];
}

//在这里面添加需要的子控件和一次性设置
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        // 添加按钮
        self.repostBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        
        [self.attitudeBtn setImage:[UIImage imageNamed:@"zanhong"] forState:UIControlStateSelected];
        self.attitudeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.attitudeBtn setTitle:@"赞" forState:UIControlStateNormal];
//        [self.attitudeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [self.attitudeBtn setImage:[UIImage imageNamed:@"zanhong"] forState:UIControlStateSelected];

        
        [self.repostBtn addTarget:self action:@selector(repostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        self.repostBtn.tag = 0;
        self.commentBtn.tag = 1;
        self.attitudeBtn.tag = 2;
        //分割线
        [self setupDivider];
        [self setupDivider];
        
        //下面灰色view
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = KControllerBackGroundColor;
        [self addSubview:grayView];
        self.grayView = grayView;
    }
    return self;
}

- (void)repostBtnClick:(UIButton *)btn{
    SMLog(@"点击了 转发  按钮");
    [self toolBtnClick:btn];
}

- (void)commentBtnClick:(UIButton *)btn{
    SMLog(@"点击了 评论  按钮");
    [self toolBtnClick:btn];
}

- (void)attitudeBtnClick:(UIButton *)btn{
    SMLog(@"点击了 点赞  按钮");
    [self toolBtnClick:btn];
}

- (void)toolBtnClick:(UIButton *)btn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCircelToolBtnKey] = btn;
    dict[KCircelTweetKey] = self.tweet;
    SMLog(@"KCircelTweetKey    self.tweet   %@",self.tweet);
    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelToolBtnClickNot object:self userInfo:dict];
    
}

//分割线
- (void)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
//    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:btn];
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int btnCount = (int)self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = 30;
    
    //btn frame
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
    
    int dividerCount = (int)self.dividers.count;
    
    //分割线frame
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
    
    self.grayView.frame = CGRectMake(0, 32, KScreenWidth, 10);
    
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    // 转发
    [self setupBtnCount:(int)tweet.reposts btn:self.repostBtn title:@"转发"];
    // 评论
    [self setupBtnCount:(int)tweet.comments btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:(int)tweet.upvotes btn:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title{
    
    if (self.tweet.isUpvote) {
        btn.selected = YES;
    }else
    {
        btn.selected = NO;
    }
    if (count) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
    
    
}
#pragma mark -- 懒加载
- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

@end
