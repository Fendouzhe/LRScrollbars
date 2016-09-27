//
//  SMComposeViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/14.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMComposeViewController.h"
#import "SMEmotionTextView.h"
#import "SMComposeToolbar.h"
#import "SMComposePhotosView.h"
#import "SMEmotionKeyboard.h"
//#import <AFNetworking.h>
//#import <AFNetworking/AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import "SMLocationViewController.h"
#import "SGImagePickerController.h"
#import "AppDelegate.h"

@interface SMComposeViewController ()<UITextViewDelegate,SMComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SMComposePhotosViewDelegate,SMLocationViewControllerDelegate,UIActionSheetDelegate>

//输入发表文字的控件
@property (nonatomic ,strong)SMEmotionTextView *textView;

//工具条
@property (nonatomic ,strong)SMComposeToolbar *toolbar;

//相册
@property (nonatomic ,strong)SMComposePhotosView *photosView;

@property (nonatomic ,strong)SMEmotionKeyboard *emotionKeyboard;

@property (nonatomic ,assign)BOOL switchingKeybaord;

@property (nonatomic ,assign)CGFloat textViewH;
/**
 *  地址
 */
@property (nonatomic ,copy)NSString *address;

@property (nonatomic ,strong)UIWindow *bgWindow;

@property (nonatomic ,strong)UIScrollView *scrollViewPictures;

/**
 *  大图
 */
@property (nonatomic ,strong)UIImageView *imageView;

/**
 *  第几张
 */
@property(nonatomic,strong)UILabel * PicturesLabel;

@property (nonatomic ,assign)NSInteger sourceType; /**< 照相机选项 */

@end

@implementation SMComposeViewController

#pragma mark -- 懒加载
- (SMEmotionKeyboard *)emotionKeyboard{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[SMEmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (UIScrollView *)scrollViewPictures{
    if (_scrollViewPictures == nil) {
        _scrollViewPictures = [[UIScrollView alloc] initWithFrame:self.bgWindow.bounds];
        _scrollViewPictures.backgroundColor = [UIColor blackColor];
    }
    return _scrollViewPictures;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCountNotiDidChange:) name:@"KImageCountNoti" object:nil];
    [self.textView becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏内容
    [self setupNav];
    
    //添加输入控件
    [self setupTextView];
    
    // 添加工具条
//    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];
}

- (void)imageCountNotiDidChange:(NSNotification *)noti{
    NSNumber *imageCount = noti.userInfo[@"KImageCountNotiKey"];
    if (imageCount.integerValue == 0 && [self.textView.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
//- (void)setupToolbar{
//    SMComposeToolbar *toolbar = [[SMComposeToolbar alloc] init];
//    toolbar.width = self.view.width;
//    toolbar.height = 44;
//    
//    toolbar.delegate = self;
//    //toolbar 的初始y
//    toolbar.y = self.view.height - toolbar.height;
//    [self.view addSubview:toolbar];
//    self.toolbar = toolbar;
//}

- (void)setupPhotosView{
    SMComposePhotosView *photosView = [[SMComposePhotosView alloc] init];
    self.photosView = photosView;
    photosView.delegate = self;
    photosView.x = 0;
    photosView.y = self.textViewH;
    photosView.width = KScreenWidth;
    photosView.height = KScreenHeight;
    [self.view addSubview:photosView];
//    photosView.height = photosView.viewHeight;
    SMLog(@"setupPhotosView   %zd",photosView.viewHeight);

}

#pragma mark -- SMComposePhotosViewDelegate  加号按钮点击代理事件
- (void)addBtnDidClick{
    SMLog(@"点击了 加号按钮");
    
    [self.view endEditing:YES];
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
    }
    [sheet showInView:self.view];
    
    
    
//    [self.photosView.photos removeAllObjects];
    
//    [self openAlbum];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                return;
            case 1: //相机
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self gotoAlbum];
                break;
            case 2: //相册
//                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self gotoCustomBlbum];
                
                break;
        }
    }else {
        if (buttonIndex == 0) {
            return;
        } else {
            self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
    }
}

- (void)gotoCustomBlbum{
    SGImagePickerController *picker = [[SGImagePickerController alloc] initWithRootViewController:nil];
    //返回选择的缩略图
    [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
        SMLog(@"缩略图%@",thumbnails);
    }];
    
    //返回选中的原图
    [picker setDidFinishSelectImages:^(NSArray *images) {
        SMLog(@"原图%@",images);
        for (UIImage *image in images) {
            [self.photosView addphoto:image];
        }
        
        if (self.textView.hasText || self.photosView.photos.count > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        SMLog(@"self.photosView.photos.count   %zd",self.photosView.photos.count);
    }];
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)gotoAlbum{
    // 跳转到相机或相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = self.sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//#pragma mark - image picker delegte
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    //    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        SMLog(@"imagePickerController  image %@",image);
//        self.bjImageView.image = image;
//        
//        //        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:KUserInfoBjImage];
//        [self cheatViewTap];
//    }];
//    
//}

- (void)locationBtnDidClick{
    SMLog(@"跳转  发爽快圈  定位界面 ");
    SMLocationViewController *vc = [[SMLocationViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photoViewDidClick:(UIButton *)btn andPhotos:(NSMutableArray *)photos{
    SMLog(@"点击了 图片小图");
    
    
    //最外层window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.bgWindow = window;
    
    [window addSubview:self.scrollViewPictures];
    self.scrollViewPictures.contentSize = CGSizeMake(KScreenWidth *photos.count, KScreenHeight);
    self.scrollViewPictures.pagingEnabled = YES;
    self.scrollViewPictures.alpha = 1;
    self.scrollViewPictures.delegate = self;
    
    //创建图片
    for (NSInteger i = 0; i < photos.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        NSURL *url = [NSURL URLWithString:imageStrs[i]];
        //[imageView sd_setImageWithURL:url];
        
        //添加菊花
//        [imageView setShowActivityIndicatorView:YES];
        //改变菊花颜色
//        [imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
        imageView.image = photos[i];
        [self.scrollViewPictures addSubview:imageView];
        imageView.frame = CGRectMake(KScreenWidth *i, 0, KScreenWidth, KScreenHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
        [imageView addGestureRecognizer:tap];
        self.imageView = imageView;
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
    }
    
    //添加显示哪一张的数字
    self.PicturesLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2-25, 44, 50, 30)];
    
    UIImage *btnBGImage = btn.currentBackgroundImage;
    NSInteger index = (NSInteger)[photos indexOfObject:btnBGImage];
    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%zd",index + 1,photos.count];
    self.PicturesLabel.textColor = [UIColor whiteColor];
    self.PicturesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.scrollViewPictures.contentOffset = CGPointMake(KScreenWidth *index, 0);
    [window addSubview:self.PicturesLabel];

    
}

//scrollView 滚动结束时，更新上面的数字显示
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/KScreenWidth;
    
    self.PicturesLabel.text = [NSString stringWithFormat:@"%zd/%.0f",page+1,scrollView.contentSize.width/KScreenWidth];
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
    [self.textView resignFirstResponder];
}

#pragma mark -- 生命周期
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}



////设置导航栏内容
- (void)setupNav{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];

    self.title = @"写爽快圈";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(send)];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    NSString *prefix = @"写爽快圈";
//    NSString *name = [HWAccountTool account].name;
//    if (name) {
//        UILabel *titleView = [[UILabel alloc] init];
//        titleView.width = 200;
//        titleView.height = 100;
//        titleView.textAlignment = NSTextAlignmentCenter;
//        titleView.numberOfLines = 0;
//        titleView.y = 50;
//        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
//        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//        
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
//        titleView.attributedText = attrStr;
//        self.navigationItem.titleView = titleView;
//    }else{
//        self.title = prefix;
//    }
    
    
}

//添加输入控件
- (void)setupTextView{
    self.textViewH = 92;
    SMEmotionTextView *textView = [[SMEmotionTextView alloc] init];
    textView.frame = CGRectMake(0, 0, KScreenWidth, self.textViewH);
//    textView.backgroundColor = [UIColor yellowColor];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"发表爽快圈...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionBtnDidClick:) name:SMEmotionNotificationName object:nil];
}



- (void)emotionBtnDidClick:(NSNotification *)notification{
    
    SMEmotion *emotion = notification.userInfo[SMEmotionDictKey];
    [self.textView insertEmotion:emotion];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    //如果正在切换键盘，就不执行下面的代码（保证toolbar 位置不变）
    //    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    //动画持续时间跟键盘弹出来所耗用的时间相等
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出来后的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{        
        //设置toolbar 的位置
        if (keyboardF.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            //这样设置y ，就可以让 toolbar 一直和键盘挨在一起
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

/**
 * 监听文字改变
 */
- (void)textDidChange{
    if (self.textView.hasText || self.photosView.photos.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
///发布
- (void)send{
    
    [self.textView resignFirstResponder];
    if (self.photosView.photos.count > 9) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多可以发送9张图片，请选择删除后重新发送,么么哒。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //判断用户的发送内容是否带有图片，从而发送不同的请求给服务器
    //SMLog(@"self.photosView.photos %@",self.photosView.photos);

    SMShowPrompt(@"正在发布...");
    [[SKAPI shared] publishTweet:self.textView.text andLocation:self.address andDatas:self.photosView.photos block:^(id result, NSError *error) {
        if (!error) {
            //SMLog(@"发布result = %@",result);
            [HUD hide:YES];
            
            //发布之后  返回 刷新
            self.refreshBlock();
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            SMLog(@"发布error = %@",error);
            [HUD hide:YES];
            [MBProgressHUD showError:@"网络不给力,请重试!"];
        }
    }];
}

//#pragma mark - UITextViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

#pragma mark - HWComposeToolbarDelegate
//- (void)composeToolbar:(SMComposeToolbar *)toolbar didClickButton:(SMComposeToolbarButtonType)buttonType{
//    
//    switch (buttonType) {
//        case SMComposeToolbarButtonTypeCamera: // 拍照
//            [self openCamera];
//            break;
//            
//        case SMComposeToolbarButtonTypePicture: // 相册
//            [self openAlbum];
//            break;
//            
//        case SMComposeToolbarButtonTypeMention: // @
//            SMLog(@"--- @");
//            break;
//            
//        case SMComposeToolbarButtonTypeTrend: // #
//            SMLog(@"--- #");
//            break;
//            
//        case SMComposeToolbarButtonTypeEmotion: // 表情\键盘
//            [self switchKeyboard];
//            break;
//    }
//}

- (void)switchKeyboard{
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emotionKeyboard;
        self.toolbar.showKeyboardButton = YES;
    }else{
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    //退出键盘
    self.switchingKeybaord = YES;
    [self.textView endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //重新打开键盘
        [self.textView becomeFirstResponder];
        self.switchingKeybaord = NO;
    });
}

#pragma mark -- SMLocationViewControllerDelegate
- (void)locationCellDidSelected:(NSString *)address{
    SMLog(@"locationCellDidSelected    %@",address);
    self.address = address;
    [self.photosView setBtnTitleAgain:address];
}


#pragma mark - 其他方法
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

/**
 *  打开相册
 */
- (void)openAlbum{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    //    self.picking = YES;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addphoto:image];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.picking = NO;
    //    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
