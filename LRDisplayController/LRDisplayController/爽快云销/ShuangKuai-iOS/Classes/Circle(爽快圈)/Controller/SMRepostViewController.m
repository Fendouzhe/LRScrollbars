//
//  SMRepostViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMRepostViewController.h"
#import "SMEmotionTextView.h"
#import "SMRepostView.h"
#import "AppDelegate.h"

@interface SMRepostViewController ()

@property (nonatomic ,assign)CGFloat textViewH;

@property (nonatomic ,strong)SMEmotionTextView *textView;

@property (nonatomic ,strong)SMRepostView *repostView;

@end

@implementation SMRepostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    //添加输入控件
    [self setupTextView];
    
    //设置转发灰色部分
    [self setupRepostView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}

- (void)setupRepostView{
    SMRepostView *repostView = [SMRepostView repostView];
    [repostView setImageAndLabel:self.tweet];
    SMLog(@"self.tweet  --%@",self.tweet);
    [self.view addSubview:repostView];
    repostView.frame = CGRectMake(0, self.textViewH, KScreenWidth, 55);
    self.repostView = repostView;
}

- (void)setupNav{
    self.title = @"爽快圈";
    
    //右边的 发布 按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14*SMMatchWidth];
    dict[NSForegroundColorAttributeName] = KBlackColorLight;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"发布" attributes:dict];
//    rightBtn.width = 25;
//    rightBtn.height = 15;
    [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick{
    SMLog(@"点击了 转发爽快圈   的发布按钮");
    [[SKAPI shared] repostTweet:self.tweet.id andContent:self.textView.text block:^(id result, NSError *error) {
        if (!error) {
//            hud.mode = MBProgressHUDModeText;
            if ([self.delegate respondsToSelector:@selector(recomposeBtnDidClick)]) {
                [self.delegate recomposeBtnDidClick];
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

//添加输入控件
- (void)setupTextView{
    self.textViewH = 120;
    SMEmotionTextView *textView = [[SMEmotionTextView alloc] init];
    textView.frame = CGRectMake(0, 0, KScreenWidth, self.textViewH);
    //    textView.backgroundColor = [UIColor yellowColor];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"发表爽快圈...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    [self.textView becomeFirstResponder];
}

#pragma mark -- 通知响应事件
/**
 * 监听文字改变
 */
- (void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
}
@end
