//
//  SMNewsDetailController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMNewsDetailController.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"

@interface SMNewsDetailController ()<UIWebViewDelegate>
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  公司名
 */
@property (weak, nonatomic) IBOutlet UILabel *companyName;
/**
 *  展示的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
/**
 *  详细说明
 */
@property (weak, nonatomic) IBOutlet UILabel *detailInfo;
@property (strong, nonatomic) IBOutlet UIWebView *loadWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webViewCOnstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SMNewsDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态详情";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;//行间距
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    SMLog(@"news.content   %@",self.news.content);
    self.detailInfo.attributedText = [[NSAttributedString alloc] initWithString:self.news.content attributes:ats];//设置行间距
    
    self.titleLabel.text = self.news.title;
    SMLog(@"news.title   %@",self.news.title);
    NSString *time = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",self.news.createAt]];
    NSString *timeStr = [[time componentsSeparatedByString:@" "] firstObject];
    self.timeLabel.text = timeStr;
    //[self.showImage sd_setImageWithURL:[NSURL URLWithString:self.news.imagePaths]];
    
    //显示菊花控件
    [self.showImage setShowActivityIndicatorView:YES];
    [self.showImage setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:self.news.imagePaths] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    
    
    [self.loadWebView loadHTMLString:self.news.content baseURL:nil];
    
    
    
    self.loadWebView.delegate = self;
    
    
    //NSString *   htmlHeight = [self.loadWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
   
    self.loadWebView.scrollView.scrollEnabled = NO;
    
    //self.webViewCOnstraint.constant = htmlHeight.floatValue;
    
    //self.loadWebView.scrollView.contentSize.height
    
}

//- (void)setNews:(News *)news{
//    _news = news;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;//行间距
//    NSDictionary *ats = @{
//                          NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
//                          NSParagraphStyleAttributeName : paragraphStyle,
//                          };
//    SMLog(@"news.content   %@",news.content);
//    self.detailInfo.attributedText = [[NSAttributedString alloc] initWithString:news.content attributes:ats];//设置行间距
//    
//    self.titleLabel.text = news.title;
//    SMLog(@"news.title   %@",news.title);
//    self.timeLabel.text = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",news.createAt]];
//    [self.showImage sd_setImageWithURL:[NSURL URLWithString:news.imagePaths]];
//    
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[self.loadWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
    
    self.webViewCOnstraint.constant = height;
}

@end
