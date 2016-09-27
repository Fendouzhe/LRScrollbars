//
//  SMCircelDetailViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/13.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^refreshBlock)(void);
@class tweetFrame;
@interface SMCircelDetailViewController : UIViewController

@property (nonatomic ,strong)tweetFrame *tweetFrame;

//@property (nonatomic ,strong)Tweet *tweet;

@property(nonatomic,copy)refreshBlock refreshBlock;

@end
