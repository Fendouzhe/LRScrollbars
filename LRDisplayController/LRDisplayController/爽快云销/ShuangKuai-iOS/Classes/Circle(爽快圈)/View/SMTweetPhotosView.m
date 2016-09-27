//
//  SMTweetPhotosView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMTweetPhotosView.h"
#import <UIButton+WebCache.h>


#define SMTweetPhotoWH 70
#define SMTweetPhotoMargin 10
//如果是4张的话，就只显示两列。
#define SMTweetPhotoMaxCol(count) ((count==4)?2:3)

@implementation SMTweetPhotosView

CGFloat tweetPhotoWH;

- (void)setImageStrs:(NSArray *)imageStrs{
    _imageStrs = imageStrs;
    
    tweetPhotoWH = (KScreenWidth - SMTweetPhotoMargin * 4) / 3.0;
    int tag = 0;
    int photosCount = (int)imageStrs.count;
    //只要图片数量不够，就一直创建图片，直到图片足够使用
    while (self.subviews.count < photosCount) {
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImageView *imageView = [[UIImageView alloc] init];
        //填充模式
//        imageView.contentMode = UIViewContentModeScaleToFill;

//        imageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
//        [imageView addGestureRecognizer:tap];
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        imageBtn.tag = tag;
        tag++;
    }
    
    CGFloat imageWidth = tweetPhotoWH + tweetPhotoWH;
    NSMutableArray *imageStrArrM = [NSMutableArray array];
    for (int i = 0; i < self.imageStrs.count; i++) {
        NSString *strEnd = [NSString stringWithFormat:@"?w=%zd&h=%zd",imageWidth * 2,imageWidth * 2];
        NSString *str = self.imageStrs[i];
        NSString *imageStr = [str stringByAppendingString:strEnd];
        [imageStrArrM addObject:imageStr];
    }
    
    // 遍历所有的图片控件，设置图片
    for (UIButton *btn in self.subviews) {
        if (btn.tag < photosCount) {
            btn.hidden = NO;
            NSURL *url = [NSURL URLWithString:imageStrArrM[btn.tag]];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            imageView [UIImage imageWithData:data];
            
            
            SMLog(@"image = %@",url);
            
//            [btn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                
//            }];
            
            [btn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"220"] options:SDWebImageRetryFailed|SDWebImageHighPriority];
            
        }else{
            btn.hidden = YES;
        }
    }
}

- (void)imageBtnClick:(UIButton *)btn{
    SMLog(@"点击了  发布的图片");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCircelImageClickBtnKey] = btn;
    dict[@"arr"] = self.imageStrs;
    SMLog(@"self.imageStrs   - %@  ",self.imageStrs);
    SMLog(@"btn.currentImage   %@,btn.currentBackgroundImage  %@",btn.currentImage,btn.currentBackgroundImage);
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelImageClickNot object:self userInfo:dict];
}

//- (void)imageViewClick:(UITapGestureRecognizer *)tap{
//    UIImageView *imageView = (UIImageView *)[tap view];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[KCircelImageClickBtnKey] = imageView;
//    dict[@"arr"] = self.imageStrs;
//    SMLog(@"self.imageStrs   - %@  ",self.imageStrs);
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:KCircelImageClickNot object:self userInfo:dict];
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    int photosCount = (int)self.imageStrs.count;
    int maxCol = SMTweetPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        UIButton *btn = self.subviews[i];
        
        int col = i % maxCol;
        btn.x = col * (tweetPhotoWH + SMTweetPhotoMargin) - SMTweetPhotoMargin / 2.0;
        
        int row = i / maxCol;
        btn.y = row * (tweetPhotoWH + SMTweetPhotoMargin);
        btn.width = tweetPhotoWH;
        btn.height = tweetPhotoWH;
    }
}

//把图片的总数传进来，返回相册所占用的size 大小
+ (CGSize)sizeWithCount:(int)count{
    // 最大列数（一行最多有多少列）
    int maxCols = SMTweetPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/HWStatusPhotosView.m
    //列数
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * tweetPhotoWH + (cols - 1) * SMTweetPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * tweetPhotoWH + (rows - 1) * SMTweetPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}


@end
