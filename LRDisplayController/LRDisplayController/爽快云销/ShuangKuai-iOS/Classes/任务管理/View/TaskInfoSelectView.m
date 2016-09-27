//
//  TaskInfoSelectView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "TaskInfoSelectView.h"

@interface TaskInfoSelectView ()
@property (nonatomic,strong) UIButton *receiveButton;/**< 接收 */
@property (nonatomic,strong) UIButton *commentButton;/**< 评论按钮 */
@property (nonatomic,strong) UIView *backGroundView;/**< <#属性#> */
//@property (nonatomic,assign) int selectTag;/**< <#属性#> */
@property (nonatomic,strong) UIButton *selectButton;
@end

@implementation TaskInfoSelectView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backGroundView = [[UIView alloc] init];
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self receiveButton];
        [self commentButton];
    }
    return self;
}

-(UIButton *)receiveButton{
    if (_receiveButton == nil) {
        _receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveButton.tag = 0;
        _receiveButton.titleLabel.font = KDefaultFont;
        [_receiveButton setImage:[UIImage imageNamed:@"jieshou"] forState:UIControlStateNormal];
        [_receiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[_receiveButton setTitleColor:KRedColorLight forState:UIControlStateSelected];
        [_receiveButton setTitle:@"接收" forState:UIControlStateNormal];
        //[_receiveButton setTitle:@"接收" forState:UIControlStateSelected];
        [_receiveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        _receiveButton.selected = YES;
        self.selectButton = _receiveButton;
        [self addSubview:_receiveButton];
        MJWeakSelf
        [_receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(5);
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.width.equalTo(@80);
        }];
    }
    return _receiveButton;
}

-(UIButton *)commentButton{
    if (_commentButton == nil) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.tag = 1;
        //        UIFont *font = KDefaultFont;
        //        if (isIPhone6p) {
        //            font = [UIFont systemFontOfSize:13];
        //        }
        _commentButton.titleLabel.font = KDefaultFont;
        [_commentButton setImage:[UIImage imageNamed:@"pinglun_1"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_commentButton setTitleColor:KRedColorLight forState:UIControlStateSelected];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        //[_commentButton setTitle:@"评论" forState:UIControlStateSelected];
        [_commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        MJWeakSelf
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.receiveButton.mas_right).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(5);
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.width.equalTo(@80);
        }];
    }
    return _commentButton;
}


-(void)setSelectNumber:(int)number{
    switch (number) {
        case 0:
        {
            self.receiveButton.selected = YES;
            self.commentButton.selected = NO;
            self.selectTag = self.receiveButton.tag;
        }
            break;
        case 1:
        {
            self.receiveButton.selected = NO;
            self.commentButton.selected = YES;
            self.selectTag = self.commentButton.tag;
        }
        default:
            break;
    }
}

-(void)setSelectTag:(NSInteger)selectTag{
    switch (selectTag) {
        case 0:
        {
            self.receiveButton.selected = YES;
            self.commentButton.selected = NO;
            _selectTag = selectTag;
        }
            break;
        case 1:
        {
            self.receiveButton.selected = NO;
            self.commentButton.selected = YES;
            _selectTag = selectTag;
        }
        default:
            break;
    }
}

-(void)setType:(NSInteger)type{
    switch (type) {
        case 0:
        {
            self.commentButton.hidden = YES;
        }
            break;
        case 1:
        {
            self.commentButton.hidden = NO;
        }
            break;
        case 2:
        {
            self.commentButton.hidden = NO;
        }
            break;
        default:
            break;
    }
}

-(void)buttonClick:(UIButton *)btn{
    
    self.selectButton.selected = NO;
    btn.selected = YES;
    self.selectButton = btn;
//    if (btn.tag == self.selectTag) {
//        return;
//    }
    if ([self.delegate respondsToSelector:@selector(taskInfoMessageSelectWithNumber:)]) {
        switch (btn.tag) {
            case 0:
            {
//                self.receiveButton.selected = YES;
//                self.commentButton.selected = NO;
//                self.selectButton = self.receiveButton;
                [self.delegate taskInfoMessageSelectWithNumber:0];
                
            }
                break;
            case 1:
            {
//                self.receiveButton.selected = NO;
//                self.commentButton.selected = YES;
//                self.selectButton = self.commentButton;
                [self.delegate taskInfoMessageSelectWithNumber:1];
                
            }
                break;
            default:
                break;
        }
    }
}


- (void)setRecevieNumber:(NSInteger)recevieNumber{
    _recevieNumber = recevieNumber;
    if (_recevieNumber) {
        [_receiveButton setTitle:[NSString stringWithFormat:@"接收 %lu",recevieNumber] forState:UIControlStateNormal];
    }else{
        [_receiveButton setTitle:@"接收 0" forState:UIControlStateNormal];
    }
    
}
- (void)setCommentNumber:(NSInteger)commentNumber{
    _commentNumber = commentNumber;
    if (commentNumber) {
        [_commentButton setTitle:[NSString stringWithFormat:@"评论 %lu",commentNumber] forState:UIControlStateNormal];
    }else{
        [_commentButton setTitle:@"评论 0" forState:UIControlStateNormal];
    }
    
}
@end
