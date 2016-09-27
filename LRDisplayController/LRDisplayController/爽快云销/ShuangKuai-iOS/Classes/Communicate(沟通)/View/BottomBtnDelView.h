//
//  BottomBtnDelView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomBtnDelViewDelegate <NSObject>

@optional
-(void)delBtnClick:(UIButton *)btn;
@end
@class SMGroupChatDetailData;
@interface BottomBtnDelView : UIView
@property (nonatomic,strong) SMGroupChatDetailData *roomDetail;/**< 房间详细信息 */
@property (nonatomic,weak) id<BottomBtnDelViewDelegate> delegate;/**< 代理 */
@end
