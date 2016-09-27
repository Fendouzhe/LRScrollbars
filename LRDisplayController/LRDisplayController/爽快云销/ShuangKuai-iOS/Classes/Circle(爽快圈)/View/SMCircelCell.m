//
//  SMCircelCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircelCell.h"
#import "SMTweetPhotosView.h"
#import "SMTweetToolbar.h"
#import "tweetFrame.h"
#import <UIButton+WebCache.h>

@interface SMCircelCell ()<SMTweetToolbarDelegate>

/** 原创微博整体 */
@property (nonatomic ,strong)UIView *originalView;
/**
 *  头像
 */
@property (nonatomic ,strong)UIButton *iconBtn;
/**
 *  名字
 */
@property (nonatomic ,strong)UILabel *nameLabel;
/**
 *  地址
 */
@property (nonatomic ,strong)UILabel *addressLabel;
/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;
/**
 *  内容
 */
@property (nonatomic ,strong)UILabel *contentLabel;
/**
 *  图片
 */
@property (nonatomic ,strong)SMTweetPhotosView *photosView;


/**
 *  工具栏
 */
@property (nonatomic ,strong)SMTweetToolbar *toolbar;
/**
 *  “转发爽快圈”
 */
@property (nonatomic ,strong)UILabel *retweetSignLabel;

@property (nonatomic ,strong)UIImageView *bgGrayView;


@end

@implementation SMCircelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"tweet";
//    SMCircelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[SMCircelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//
#pragma mark 这里有cell 重用问题     ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    SMCircelCell *cell =  [[SMCircelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    cell.tweetFrame = nil;
    
    SMLog(@"cellWithTableView");
 
    
    
//    [tableView registerClass:[SMCircelCell class] forCellReuseIdentifier:ID];
//    
//    SMCircelCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    //先创建出需要的控件
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        for (UIView * view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        // 初始化原创爽快圈
        [self setupOriginal];
        
        // 初始化转发爽快圈
        [self setupRetweet];
        
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化工具条
        [self setupToolbar];
    }
    return self;
}

- (void)setupToolbar{
    SMTweetToolbar *toolbar = [SMTweetToolbar toolbar];
    toolbar.delegate = self;
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)setupOriginal{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    //注意： 往cell 里面添加内容的时候，是添加到 contentView 中去的.
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    originalView.backgroundColor = [UIColor clearColor];
    
    
    //头像
    UIButton *iconBtn = [[UIButton alloc] init];
    self.iconBtn = iconBtn;
    [iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [originalView addSubview:iconBtn];
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = KDefaultFont;
    self.nameLabel = nameLabel;
    [originalView addSubview:nameLabel];
    
    //地址label
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = KDefaultFontSmall;
    addressLabel.textColor = [UIColor darkGrayColor];
    [originalView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    addressLabel.text = @"来自爽快圈";   //默认就是这句话
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.font = KDefaultFontSmall;
    timeLabel.textColor = [UIColor grayColor];
    [originalView addSubview:timeLabel];
    
    //正文内容
    UILabel *contentLabel = [[UILabel alloc] init];
    [originalView addSubview:contentLabel];
    contentLabel.text = @"转发爽快圈";
    self.contentLabel = contentLabel;
    self.contentLabel.numberOfLines = 0;
    contentLabel.font = KDefaultFont;
    
    //配图
    SMTweetPhotosView *photosVIew = [[SMTweetPhotosView alloc] init];
    self.photosView = photosVIew;
    [originalView addSubview:photosVIew];
   
}

- (void)setupRetweet{
//    //"转发爽快圈"
//    UILabel *retweetSignLabel = [[UILabel alloc] init];
//    retweetSignLabel.text = @"转发爽快圈";
//    retweetSignLabel.font = KDefaultFont;
//    [self.contentView addSubview:retweetSignLabel];
//    self.retweetSignLabel = retweetSignLabel;
    
    //转发爽快圈的整体
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = SMColor(247, 247, 247);
//    retweetView.backgroundColor = SMRandomColor;
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    //被转发的整体灰色背景上面给一个点击事件
    UIImageView *bgGrayView = [[UIImageView alloc] init];
    self.bgGrayView = bgGrayView;
    [retweetView addSubview:bgGrayView];
    bgGrayView.image = [UIImage imageNamed:@"bgGrayView"];
    bgGrayView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgGrayViewTap)];
    [bgGrayView addGestureRecognizer:tap];    
    
    //被转发爽快圈的 标题图片   
    UIButton *retweetTitleImage = [[UIButton alloc] init];
    [retweetView addSubview:retweetTitleImage];
    self.retweetTitleImage = retweetTitleImage;
    [retweetTitleImage addTarget:self action:@selector(retweetTitleImageClick) forControlEvents:UIControlEventTouchUpInside];
    
    //被转发爽快圈的标题
    UILabel *retweetTitle = [[UILabel alloc] init];
    retweetTitle.font = KDefaultFontBig;
    self.retweetTitle = retweetTitle;
    [retweetView addSubview:retweetTitle];
    
}

- (void)bgGrayViewTap{
    SMLog(@"bgGrayViewTap");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCircelToolRepostBtnClickNotKey] = self.tweetFrame;
    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelToolRepostBtnClickNot object:nil userInfo:dict];
    SMLog(@"self.tweetFrame.tweet.userName  %@",self.tweetFrame.tweet.userName);
}

- (void)retweetTitleImageClick{
    SMLog(@"retweetTitleImageClick");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCircelToolRepostBtnClickNotKey] = self.tweetFrame;
    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelToolRepostBtnClickNot object:nil userInfo:dict];
    SMLog(@"self.tweetFrame.tweet.userName  %@",self.tweetFrame.tweet.userName);
}

- (void)setTweetFrame:(tweetFrame *)tweetFrame{
    _tweetFrame = tweetFrame;
    
    
    /** 原创微博整体 */
    self.originalView.frame = tweetFrame.originalViewF;
    
    //头像
    self.iconBtn.frame = tweetFrame.iconViewF;
    NSURL *url = [NSURL URLWithString:tweetFrame.tweet.portrait];
    //[self.iconBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    [self.iconBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"huisemorentouxiang"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.iconBtn.layer.cornerRadius = tweetFrame.iconViewF.size.width / 2.0;
    self.iconBtn.clipsToBounds = YES;
    
    
    //名字
    self.nameLabel.frame = tweetFrame.nameLabelF;
    self.nameLabel.text = tweetFrame.tweet.userName;
    SMLog(@"tweetFrame.user.name     %@",tweetFrame.tweet.userName);
    
    //地址
    self.addressLabel.frame = tweetFrame.addressLabelF;
    self.addressLabel.text = tweetFrame.tweet.address;
    SMLog(@"tweetFrame.tweet.address   %@",tweetFrame.tweet.address);
    
    //时间
    self.timeLabel.frame = tweetFrame.timeLabelF;
    NSString *timeStr = [NSString stringWithFormat:@"%zd",tweetFrame.tweet.createAt];
    //SMLog(@"timeStr = %@",timeStr);
    self.timeLabel.text = [Utils getTimeFromTimestamp:timeStr];
    
    //内容
    self.contentLabel.frame = tweetFrame.contentLabelF;
    self.contentLabel.text = tweetFrame.tweet.content;
//    self.contentLabel.backgroundColor = SMRandomColor;
    SMLog(@"tweetFrame.tweet.content   %@",tweetFrame.tweet.content);
//    if (tweetFrame.tweet.content == nil) {
//        self.contentLabel.text = @"转发爽快圈";
//    }else{
//        self.contentLabel.text = tweetFrame.tweet.content;
//    }
    
    
    SMLog(@"tweetFrame.tweet.type    %zd",tweetFrame.tweet.type);
    SMLog(@"tweetFrame.tweet.datas.count--- %zd",tweetFrame.tweet.datas.count);
    
    //如果原创
    if (tweetFrame.tweet.type == 0) { //原创
        self.retweetView.hidden = YES;  //转发部分隐藏
        if (tweetFrame.tweet.datas.count) { //有配图
            self.photosView.hidden = NO;
            self.photosView.frame = tweetFrame.photosViewF;
            self.photosView.imageStrs = tweetFrame.tweet.datas;
        }else{  //没有配图
            self.photosView.hidden = YES;
//            self.retweetView.hidden = NO;
        }
    }

    //被转发的 爽快圈
    if (tweetFrame.tweet.type == 1 ) {
        self.retweetView.hidden = NO;  //显示转发部分的view
        self.photosView.hidden = YES;   //隐藏图片
        self.retweetView.frame = tweetFrame.retweetViewF;
        SMLog(@"tweetFrame.tweet.datas   %@",tweetFrame.tweet.datas);
        if (tweetFrame.tweet.datas.count) {  //如果转发的原微博内有图片
            NSString *firstImageStr = tweetFrame.tweet.datas[0];  //把原微博的第一张图片，作为转发view 的左边推按
            //[self.retweetTitleImage sd_setBackgroundImageWithURL:[NSURL URLWithString:firstImageStr] forState:UIControlStateNormal];
            
            [self.retweetTitleImage sd_setBackgroundImageWithURL:[NSURL URLWithString:firstImageStr] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        
        
        self.retweetTitleImage.frame = tweetFrame.leftIconF;
        self.retweetTitle.text = tweetFrame.tweet.repostFrom;
        self.retweetTitle.frame = tweetFrame.rightContentLabelF;
        
        self.bgGrayView.frame = self.retweetView.bounds;
    }
//    else{
//        self.retweetView.hidden = YES;
//        self.photosView.hidden = NO;
//    }
    

    /** 工具条 */
    self.toolbar.frame = tweetFrame.toolbarF;
    self.toolbar.tweet = tweetFrame.tweet;
    
    
    
//    if (self.tweetFrame.tweet.isUpvote) {
//        s.selected = YES;
//    }else
//    {
//        btn.selected = NO;
//    }
    
}

#pragma mark -- SMTweetToolbarDelegate
- (void)tweetToolBarDidClick:(UIButton *)btn{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCircelToolBtnKey] = btn;
    dict[KCircelToolCellKey] = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelToolBtnClickNot object:self userInfo:dict]; 
}


-(void)iconBtnClick{
    SMLog(@"点击了  头像按钮");
    if(self.iconblock){
        self.iconblock();
    }
    
}

@end
