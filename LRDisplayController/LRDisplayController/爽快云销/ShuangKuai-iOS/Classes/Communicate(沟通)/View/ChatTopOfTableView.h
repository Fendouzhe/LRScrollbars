//
//  ChatTopOfTableView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatTopOfTableViewDelegate <NSObject>

@optional
-(void)chatTopOfTableViewWithNumber:(NSUInteger)tag;
@end

@interface ChatTopOfTableView : UIView
-(void)setWithImageArray:(NSArray *)imageArray withStrArray:(NSArray *)strArray;
@property (nonatomic,weak) id<ChatTopOfTableViewDelegate> delegate;/**< 代理 */
@end
