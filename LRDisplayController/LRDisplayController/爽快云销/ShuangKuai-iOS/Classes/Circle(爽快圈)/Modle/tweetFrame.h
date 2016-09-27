//
//  tweetFrame.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/11.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface tweetFrame : NSObject

@property (nonatomic ,strong)Tweet *tweet;

//@property (nonatomic ,strong)User *user;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;

/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;

/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;

/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;

/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;

/** 地址 */
@property (nonatomic, assign) CGRect addressLabelF;

/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;



/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;

/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;

/** 转发整体view 里面的左边图片 */
@property (nonatomic ,assign)CGRect leftIconF;

/** 转发整体view 中右边的文字 */
@property (nonatomic ,assign)CGRect rightContentLabelF;
///**
// *  “转发爽快圈”
// */
//@property (nonatomic ,assign)CGRect retweetSignF;


/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;



@end
