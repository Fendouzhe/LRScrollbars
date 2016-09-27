//
//  BottomBtnDelView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/14.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "BottomBtnDelView.h"
#import "SMGroupChatDetailData.h"
#import "SMGroupChatListData.h"

@interface BottomBtnDelView ()
@property (nonatomic,weak) UIButton *delBtn;/**< 删除按钮 */
@end

@implementation BottomBtnDelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:delBtn];
        self.delBtn = delBtn;
        [delBtn setBackgroundColor:KRedColorLight];
        delBtn.layer.cornerRadius = 4;
        delBtn.layer.masksToBounds = YES;
//        [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [delBtn addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        MJWeakSelf
        [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(5);
            make.center.equalTo(weakSelf);
            make.width.equalTo(@(SMMatchWidth*280));
        }];
    }
    return self;
}

-(void)setRoomDetail:(SMGroupChatDetailData *)roomDetail{
    _roomDetail = roomDetail;
    NSString *userIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if([roomDetail.chatroom.createrId isEqualToString:userIDStr]){
        [self.delBtn setTitle:@"解散并退出" forState:UIControlStateNormal];
    }else{
        [self.delBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    }
    
}

-(void)delButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(delBtnClick:)]) {
        [self.delegate delBtnClick:btn];
    }
}

@end
