//
//  SMDetailProductSection4Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductSection4Cell.h"

#define Margin 10

@interface SMDetailProductSection4Cell ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic ,strong)UILabel *topLabel;

@property (nonatomic ,strong)UIWebView *webView;

@property (nonatomic,assign) CGFloat startY;/**< 开始 */

@property (nonatomic,assign) CGFloat endY;/**< 结束 */

@property (nonatomic,assign) BOOL isLoad;/**< 标记 */
@property (nonatomic,assign) BOOL setCellHeightOnce;/**< 设置一次高度 */


@end

@implementation SMDetailProductSection4Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"detailProductSection4Cell";
    SMDetailProductSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMDetailProductSection4Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //图文详情
        UILabel *topLabel = [[UILabel alloc] init];
        [self.contentView addSubview:topLabel];
        self.topLabel = topLabel;
        topLabel.text = @"图文详情";
        topLabel.font = KDefaultFontBig;

        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).with.offset(Margin);
            make.left.equalTo(self.contentView.mas_left).with.offset(Margin);
            
        }];
        
        // 高度必须提前赋一个值 >0
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLabel.frame) + Margin, [[UIScreen mainScreen] bounds].size.width, 1)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
        self.webView.userInteractionEnabled = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.delegate = self;
        self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.scrollEnabled = NO;
        [self.contentView addSubview:self.webView];
        
    }
    return self;
}

- (void)setProduct:(Product *)product{
    _product = product;
    
    NSString *header = @"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>*{margin:0;padding:0;} img,div,table{max-width: 100%; width:auto; height:auto;}</style></head><body>";
    NSString *footer = @"</body></html>";
    
    if (product.descr) {
        NSString *html1 = [header stringByAppendingString:product.descr];
        NSString *html2 = [html1 stringByAppendingString:footer];
        [self.webView loadHTMLString:html2 baseURL:nil];
        SMLog(@"html2  setProduct   %@",html2);
        SMLog(@"product.descr   ----   %@",product.descr);
    }else{
        [self.webView loadHTMLString:product.descr baseURL:nil];
        SMLog(@"product.descr  %@",product.descr);
    }
    
    
//    [self.webView loadHTMLString:html2 baseURL:nil];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:product.descr]];
//    [self.webView loadRequest:request];
//    NSURL *url = [NSURL URLWithString:@"http://www.iqiyi.com/w_19rsz0k00l.html"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    [self.contentView addSubview:self.webView];
    
}

//-(UIWebView *)webView{
//    if (!_webView) {
//        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, 1)];
//        _webView.delegate = self;
//        _webView.scalesPageToFit = YES;
//        _webView.scrollView.delegate = self;
//        _webView.multipleTouchEnabled = YES;
//    }
//    return _webView;
//}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y < 5) {
//        self.startY = scrollView.contentOffset.y;
//        self.isLoad = YES;
//    }else{
//        self.isLoad = NO;
//    }
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    self.endY = scrollView.contentOffset.y;
//    if (self.isLoad && (self.endY <0)) {
//        if ([self.delegate respondsToSelector:@selector(backToTableView)]) {
//            [self.delegate backToTableView];
//        }
//    }
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.endY = scrollView.contentOffset.y;
//}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    SMLog(@"shouldStartLoadWithRequest: = %lf",webViewHeight);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:@{@"rowHeight":@(webViewHeight)}];
//    return YES;
//}

//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    SMLog(@"webViewDidStartLoad: = %lf",webViewHeight);
//    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), KScreenWidth, webViewHeight);
//    self.cellHeight = webViewHeight + CGRectGetMaxY(self.topLabel.frame);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:@{@"rowHeight":@(_cellHeight)}];
//}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
 
    //使用这两种方法获取高度有时候无法获取实际高度
    //CGSize fittingSize = webView.scrollView.contentSize;//[self.webView sizeThatFits:CGSizeZero];
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    SMLog(@"webViewHeight = %lf",webViewHeight);

    self.cellHeight = webViewHeight + CGRectGetMaxY(self.topLabel.frame) + Margin;//fittingSize.height+30;
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.topLabel.frame) + Margin, KScreenWidth, webViewHeight);
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:@{@"rowHeight":@(_cellHeight)}];
    
    //[self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.contentView.mas_top).with.offset(10);
//        make.left.equalTo(self.contentView.mas_left).with.offset(10);
//        
//    }];
    
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.contentView.mas_top).with.offset(30);
//        make.left.equalTo(self.contentView.mas_left).with.offset(0);
//        make.right.equalTo(self.contentView.mas_right).with.offset(0);
//        //make.height.equalTo(@400);
//        make.height.equalTo(@(_cellHeight));
//    }];    
}

@end
