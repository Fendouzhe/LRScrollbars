//
//  SMCircelDetailViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMCircelDetailViewController.h"
#import "tweetFrame.h"
#import "SMCircelCell.h"
#import "SMCircelMainTextCell.h"
#import "SMCircleHomeViewController.h"
#import "AppDelegate.h"
#import "MHPhotoBrowserController.h"
#import "MHPhotoModel.h"
#import "SYPhotoBrowser.h"


#define KBEditPen 32
@interface SMCircelDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UITableView *BigTableView;

@property (nonatomic ,strong)UITableView *smallTableView;
/**
 *  最下面的 评论一行View
 */
@property (nonatomic ,assign)CGFloat commentBottomViewH;
/**
 *  最下面的 评论按钮
 */
@property (nonatomic ,strong)UIView *commentBottomView;
/**
 *  发表按钮
 */
@property (nonatomic ,strong)UIButton *commentBtn;
/**
 *  中间一行灰色的 评论view
 */
@property (nonatomic ,assign)CGFloat midCommentViewH;
/**
 *  内部装的  TweetComment 对象
 */
@property (nonatomic ,strong)NSMutableArray *arrDatas;
/**
 *  输入框
 */
@property (nonatomic ,strong)UITextField *inputField;

@property (nonatomic ,assign)CGFloat margin;

@property (nonatomic ,strong)TweetComment *comment;

/**
 *  评论部分的高度
 */
@property (nonatomic ,assign)CGFloat cellHeight;

/**
 *  点击图片显示大图的图片侧滑显示   的最外层window
 */
@property (nonatomic ,strong)UIWindow *bgWindow;
/**
 *  点击图片显示大图的图片侧滑显示
 */
@property (nonatomic ,strong)UIScrollView *scrollViewPictures;
/**
 *  大图
 */
@property (nonatomic ,strong)UIImageView *imageView;
/**
 *  第几张
 */
@property(nonatomic,strong)UILabel * PicturesLabel;

@property (nonatomic ,strong)UIAlertView *deleteAlert;/**< 删除能量圈时的确认提示框 */

@end

@implementation SMCircelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    [self setup];
    
    [self setupBottomView];
    
    [self loadDatas];
    
    [self setupMJRefresh];
    
    //同步刷新上面的评论数和点赞数
    [self loadDatasForSmallTableView];
    
    self.BigTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageBtnDidClick:) name:KCircelImageClickNot object:nil];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.notesViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KCircelImageClickNot object:nil];
}

- (void)imageBtnDidClick:(NSNotification *)notification{
    
    
    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
    //    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
    
    NSArray *imageStrs = notification.userInfo[@"arr"];
    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:imageStrs delegate:self];
    photoBrowser.initialPageIndex = btn.tag;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
    
//    //没有拖动大图效果的代码
//    UIButton *btn = notification.userInfo[KCircelImageClickBtnKey];
//    //    UIImageView *cirCelImageView = notification.userInfo[KCircelImageClickBtnKey];
//    
//    NSArray *imageStrs = notification.userInfo[@"arr"];
//    SMLog(@"imageStrs  imageBtnDidClick  %@",imageStrs);
//    //    SMLog(@"imageBtnDidClick    notification    %@",btn);
//    //    UIImage *currentImage = btn.currentImage;
//    
//    
//    MHPhotoBrowserController *vc = [MHPhotoBrowserController new];
//    NSMutableArray * bigImgArray = [NSMutableArray new];
//    
//    for (NSString *imageStr in imageStrs) {
//        [bigImgArray addObject:[MHPhotoModel photoWithURL:[NSURL URLWithString:imageStr]]];
//    }
//    
//    vc.currentImgIndex = (int)btn.tag;
//    vc.displayTopPage = YES;
//    vc.displayDeleteBtn = YES;
//    vc.imgArray = bigImgArray;
//    
//    [self presentViewController:vc animated:NO completion:nil];

    
//    //最外层window
//    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
//    self.bgWindow = window;
//    
//    [window addSubview:self.scrollViewPictures];
//    self.scrollViewPictures.contentSize = CGSizeMake(KScreenWidth *imageStrs.count, KScreenHeight);
//    self.scrollViewPictures.pagingEnabled = YES;
//    self.scrollViewPictures.alpha = 1;
//    self.scrollViewPictures.delegate = self;
//    
//    //创建图片
//    for (NSInteger i = 0; i < imageStrs.count; i++) {
//        CGFloat w = KScreenWidth *2;
//        CGFloat h = KScreenHeight *2;
//        UIImageView *imageView = [[UIImageView alloc] init];
//        NSString *imageStr = [imageStrs[i] stringByAppendingString:[NSString stringWithFormat:@"?w=%.0f&h=%.0f&q=60",w,h]];
//        SMLog(@"imageStr   %@",imageStr);
//        NSURL *url = [NSURL URLWithString:imageStr];
//        
//        //[imageView sd_setImageWithURL:url];
//        [imageView setShowActivityIndicatorView:YES];
//        [imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"220"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//        [self.scrollViewPictures addSubview:imageView];
//        imageView.frame = CGRectMake(KScreenWidth *i, 0, KScreenWidth, KScreenHeight);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        // 单击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
//        [imageView addGestureRecognizer:tap];
//        
//        //捏合手势
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
//        [imageView addGestureRecognizer:pinch];
//        
//        self.imageView = imageView;
//        imageView.tag = i+1;
//        imageView.userInteractionEnabled = YES;
//    }
//    SMLog(@"self.scrollViewPictures.subviews  %@",self.scrollViewPictures.subviews);
//    self.scrollViewPictures.contentOffset = CGPointMake(KScreenWidth *btn.tag, 0);
//    
//    self.PicturesLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-25, 44, 50, 30)];
//    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%zd",btn.tag+1,imageStrs.count];
//    self.PicturesLabel.textColor = [UIColor whiteColor];
//    self.PicturesLabel.textAlignment = NSTextAlignmentCenter;
//    [window addSubview:self.PicturesLabel];
}

- (void)pinchScale:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}

- (void)imageViewTap{
    if (self.imageView.isAnimating) {
        return;
    }
    SMLog(@"imageViewTap");
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollViewPictures.alpha = 0;
        self.PicturesLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        for (UIImageView *imageView in self.scrollViewPictures.subviews) {
            if (imageView.tag > 0) {
                [imageView removeFromSuperview];
            }
        }
        [self.scrollViewPictures removeFromSuperview];
        self.scrollViewPictures = nil;
        [self.PicturesLabel removeFromSuperview];
        self.PicturesLabel = nil;
        self.bgWindow = nil;
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    
    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%.0f",page+1,scrollView.contentSize.width/KScreenWidth];
}

- (void)setup{
    self.commentBottomViewH = 50;
    self.midCommentViewH = 40;
    [self.view addSubview:self.BigTableView];
    self.BigTableView.tableHeaderView = self.smallTableView;
    
    self.margin = 3;
    if (isIPhone5) {
        self.margin = 4;
    }else if (isIPhone6){
        self.margin = 9;
    }else if (isIPhone6p){
        self.margin = 21;
    }
}

//
- (void)setupBottomView{
    //最下面整体的view
    UIView *commentBottomView = [[UIView alloc] init];
    [self.view addSubview:commentBottomView];
    
    CGFloat commentBottomViewY = CGRectGetMaxY(self.BigTableView.frame);
    commentBottomView.frame = CGRectMake(0, commentBottomViewY, KScreenWidth, self.commentBottomViewH);
    //    commentBottomView.backgroundColor = [UIColor greenColor];
    
    //发表评论
    UIButton *commentBtn = [[UIButton alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = KDefaultFont;
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"发表评论" attributes:dict];
    [commentBtn setAttributedTitle:str forState:UIControlStateNormal];
    [commentBtn setBackgroundColor:KRedColorLight];
//    [commentBtn sizeToFit];
    CGSize size = [@"发表评论" textSizeWithFont:KDefaultFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat margin = 10;
    CGFloat commentBtnW = size.width + 10;
    CGFloat commentBtnH = self.commentBottomViewH - margin *2;
    CGFloat commentBtnX = KScreenWidth - margin - commentBtnW;
    CGFloat commentBtnY = margin;
    commentBtn.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    self.commentBtn = commentBtn;
    [commentBottomView addSubview:commentBtn];
    commentBtn.layer.cornerRadius = SMCornerRadios;
    commentBtn.clipsToBounds = YES;
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //输入框
    UITextField *inputField = [[UITextField alloc] init];
    self.inputField = inputField;
    inputField.delegate = self;
    [commentBottomView addSubview:inputField];
    inputField.placeholder = @"我也说一句";
    inputField.frame = CGRectMake(margin, margin, KScreenWidth - margin * 3 - commentBtnW, commentBtnH);
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.returnKeyType = UIReturnKeySend;
}

#pragma mark -- 点击事件
- (void)commentBtnClick{
    [self sendComment];
    SMLog(@"点击了 发表评论按钮");
}


- (void)loadDatas{
    
    [[SKAPI shared] queryTweetComment:self.tweetFrame.tweet.id block:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.arrDatas removeAllObjects];
            
            for (TweetComment * comment in array) {
                [self.arrDatas addObject:comment];
            }
            
            SMLog(@"array    %@    self.arrDatas  %@",array,self.arrDatas);
            [self.BigTableView reloadData];
            
            [self.BigTableView.mj_header endRefreshing];
            
        }else{
            SMLog(@"error    %@",error);
        }
        
    }];
}

- (void)setupNav{
    self.title = @"爽快圈正文";
    
    //右边的 删除 按钮
    //只有是自己发布的才有该按钮
    //取出自己的id
    NSString * Id = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if ([Id isEqualToString:self.tweetFrame.tweet.userId]) {
//        UIButton *rightBtn = [[UIButton alloc] init];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//        dict[NSForegroundColorAttributeName] = KBlackColorLight;
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"删除" attributes:dict];
//        rightBtn.width = 40;
//        rightBtn.height = 16;
//        [rightBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    }
}

- (void)rightItemClick{
    SMLog(@"点击了 删除");
    
    self.deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除这条动态吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [self.deleteAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.deleteAlert) { //删除动态
        if (buttonIndex == 1) {  //确认删除
            [[SKAPI shared] deleteMyTweet:self.tweetFrame.tweet.id block:^(id result, NSError *error) {
                if (!error) {
                    SMLog(@"%@",result);
                    //刷新
                    //需要刷新爽快圈
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    SMLog(@"%@",error);
                    [MBProgressHUD showError:error.localizedDescription];
                }
            }];
        }
    }
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (tableView == self.BigTableView) {
        num = self.arrDatas.count;
    }else if (tableView == self.smallTableView){
        num = 1;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SMLog(@"tableView   %@",tableView);
    if (tableView == self.BigTableView) {
        //SMLog(@"self.BigTableView   ");
        TweetComment *comment = self.arrDatas[indexPath.row];
        //SMLog(@"indexPath.row   %zd",indexPath.row);
        SMCircelMainTextCell *cell = [SMCircelMainTextCell cellWithTableView:tableView];
        CGRect rect1 = cell.iconBtn.frame;
        CGRect rect2 = cell.commentLabel.frame;
        self.cellHeight = MAX(CGRectGetMaxY(rect1), CGRectGetMaxY(rect2));
        cell.comment = comment;
        return cell;
    }else if (tableView == self.smallTableView){
        SMCircelCell *cell = [SMCircelCell cellWithTableView:tableView];
        cell.tweetFrame = self.tweetFrame;

        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.smallTableView) {//小
        SMLog(@"self.tweetFrame.cellHeight  %f",self.tweetFrame.cellHeight);
        return self.tweetFrame.cellHeight;
    }else if (tableView == self.BigTableView){
        TweetComment *comment = self.arrDatas[indexPath.row];
        //        CGFloat commentX = 10 + 45 + 10;
        CGFloat maxW = KScreenWidth - 10 - 45 - 10 - 10;
        //        CGFloat commentY = 40;
        CGSize commentSize = [self sizeWithText:comment.content font:KDefaultFont maxW:maxW];
        return commentSize.height + 50;
    }
    return 80;
}

//传入参数：字符串、字体、限制的最大宽度，就返回这个字符串 所占的size 大小
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //设置内容最宽 只能到maxW ，但是高度不限制。
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || tableView == self.BigTableView) {
        return self.midCommentViewH;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.BigTableView ) {
        NSString *title = [NSString stringWithFormat:@"评论( %zd )",self.arrDatas.count];
        return title;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    TweetComment *comment = self.arrDatas[indexPath.row];
    //    self.comment = comment;
    
    
}

#pragma mark --
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        SMLog(@"点了 发送");
        [self sendComment];
    }
    return YES;
}

- (void)sendComment{
    if (self.inputField.text.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    
    SMLog(@"self.tweetFrame.tweet.id  %zd",self.tweetFrame.tweet.id);
    
    [[SKAPI shared] commentTweet:self.tweetFrame.tweet.id andContent:self.inputField.text andToCommentId:@"" andAtUserId:@"" block:^(id response, NSError *error) {
        if (!error) {
            
            SMLog(@"self.inputField.text   %@",self.inputField.text);
            TweetComment *comment = [TweetComment mj_objectWithKeyValues:response[@"result"]];
            
            SMLog(@"发表评论成功回调，返回  comment    %@--%@",comment.content,comment.userId);
            //            [self.arrDatas addObject:comment];
            
            [self.arrDatas insertObject:comment atIndex:0];
            
            [self.BigTableView reloadData];
            
            //同步刷新上面的评论数和点赞数
            [self loadDatasForSmallTableView];
            
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            
        }else{
            SMLog(@"error     %@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    self.inputField.text = nil;
}

- (void)loadDatasForSmallTableView{
    [[SKAPI shared] queryTweet:self.tweetFrame.tweet.id block:^(id result, NSError *error) {
        if (!error) {
            tweetFrame *tweetF = [[tweetFrame alloc] init];
            tweetF.tweet = (Tweet *)result;
            self.tweetFrame = tweetF;
            [self.smallTableView reloadData];
            SMLog(@"[result class]  %@",[result class]);
        }else{
            SMLog(@"%@",error);
        }
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = [textField convertRect:textField.bounds toView:self.view];
    int offset = frame.origin.y + KBEditPen - (self.view.frame.size.height - 216.0 - KBEditPen) + self.margin;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset + KStateBarHeight, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, KStateBarHeight, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark -- 懒加载

- (UIScrollView *)scrollViewPictures{
    if (_scrollViewPictures == nil) {
        _scrollViewPictures = [[UIScrollView alloc] initWithFrame:self.bgWindow.bounds];
        _scrollViewPictures.backgroundColor = [UIColor blackColor];
    }
    return _scrollViewPictures;
}

- (UITableView *)BigTableView{
    if (_BigTableView == nil) {
        CGFloat bigTableViewH = KScreenHeight - KStateBarHeight - self.commentBottomViewH;
        //        _BigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, bigTableViewH) style:UITableViewStyleGrouped];
        _BigTableView = [[UITableView alloc] init];
        _BigTableView.frame = CGRectMake(0, 0, KScreenWidth, bigTableViewH);
        _BigTableView.delegate = self;
        _BigTableView.dataSource = self;
    }
    return _BigTableView;
}

- (UITableView *)smallTableView{
    if (_smallTableView == nil) {
        CGFloat smallTableViewH = self.tweetFrame.cellHeight + self.midCommentViewH;
        _smallTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, smallTableViewH) style:UITableViewStylePlain];
        _smallTableView.delegate = self;
        _smallTableView.dataSource = self;
        _smallTableView.scrollEnabled = NO;
    }
    return _smallTableView;
}

- (NSMutableArray *)arrDatas{
    if (_arrDatas == nil) {
        _arrDatas = [NSMutableArray array];
    }
    return _arrDatas;
}

#pragma mark - 创建上下拉刷新
-(void)setupMJRefresh
{
    MJRefreshNormalHeader *BigTableViewheader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadDatas];
        
    }];
    
    self.BigTableView.mj_header = BigTableViewheader;
    
    //    MJRefreshAutoNormalFooter *BigTableViewfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //
    //
    //    }];
    // 
    //    self.BigTableView.mj_footer = BigTableViewfooter;
    
}

@end
