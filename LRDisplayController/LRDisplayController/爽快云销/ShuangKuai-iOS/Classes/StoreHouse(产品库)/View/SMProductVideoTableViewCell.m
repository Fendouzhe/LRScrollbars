//
//  SMProductVideoTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/26.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductVideoTableViewCell.h"

@implementation SMProductVideoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"videoCell";
    SMProductVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMProductVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIWebView *webView = [[UIWebView alloc] init];
        self.webView = webView;
        self.webView.scrollView.scrollEnabled = NO;
        [self.contentView addSubview:webView];
    }
    return self;
}

//-(UIWebView *)webView{
//    if (!_webView) {
//        _webView =[[UIWebView alloc]initWithFrame:self.contentView.frame];
//        [self.contentView addSubview:_webView];
//    }
//    return _webView;
//}

-(void)loadVideo:(NSString *)iframe{
    
//    for (UIView * view in self.contentView.subviews) {
//        if ([view isKindOfClass:[UIWebView class]]) {
//            [view removeFromSuperview];
//        }
//    }
    CGFloat height = 0.0;
    if (isIPhone5) {
        height = 200;
    }else if (isIPhone6){
        height = 200 *KMatch6Height;
    }else if (isIPhone6p){
        height = 200 *KMatch6pHeight;
    }
    
    //拼接视屏HTMLString
    if (iframe && ![iframe isEqualToString:@""]) {
        
//        <iframe height=498 width=510 src="http://player.youku.com/embed/XMTUzMzQ0NDcwOA==" frameborder=0 allowfullscreen></iframe>
        
        NSMutableString * mutStr = [NSMutableString stringWithString:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>*{margin:0;padding:0;} img,div,table{max-width: 100%; width:auto; height:auto;}</style></head><body>"];
        
        NSMutableString * iframeStr = [NSMutableString stringWithString:iframe];
        
        [iframeStr replaceCharactersInRange:NSMakeRange([iframeStr rangeOfString:@"height"].location, [iframeStr rangeOfString:@"height"].length+4) withString:[NSString stringWithFormat:@"height=%lf",height]];
        
        [iframeStr replaceCharactersInRange:NSMakeRange([iframeStr rangeOfString:@"width"].location, [iframeStr rangeOfString:@"width"].length+4) withString:@"width=100%"];
        
        [mutStr appendString:iframeStr];
        
        SMLog(@"sss%@",iframeStr);
        
        [mutStr appendString:@"</body></html>"];
        
        [self.webView loadHTMLString:mutStr baseURL:nil];
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.webView.frame = self.contentView.bounds;
}
@end
