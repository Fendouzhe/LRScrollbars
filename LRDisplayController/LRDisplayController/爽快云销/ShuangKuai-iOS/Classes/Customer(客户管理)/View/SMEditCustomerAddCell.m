//
//  SMEditCustomerAddCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMEditCustomerAddCell.h"

@interface SMEditCustomerAddCell ()



@end

@implementation SMEditCustomerAddCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.addLabel = [[UILabel alloc] init];
        self.addLabel.text = @"➕标签";
        self.addLabel.font = KDefaultFont;
        self.addLabel.layer.borderWidth = 1;
        self.addLabel.layer.borderColor = SMColor(189, 189, 189).CGColor;
        self.addLabel.textAlignment = NSTextAlignmentCenter;
        self.addLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.addLabel];
        self.addLabel.layer.cornerRadius = SMCornerRadios / 2.0;
        self.addLabel.clipsToBounds = YES;
        
        
    }
    return self;
}

- (void)setTagModel:(Tag *)tagModel{
    _tagModel = tagModel;
    self.addLabel.text = tagModel.name;
    SMLog(@"tagModel.name  %@",tagModel.name);
}

- (void)beComeRedBorderAndRedTextColorLabel{
    self.addLabel.layer.borderColor = KRedColorLight.CGColor;
//    self.addLabel.layer.borderWidth = 0.5;
    self.addLabel.textColor = KRedColorLight;
}

- (void)beComeRedBorderAndBlackTextColorLabel{
    self.addLabel.layer.borderColor = KRedColorLight.CGColor;
//    self.addLabel.layer.borderWidth = 0.5;
    self.addLabel.textColor = [UIColor blackColor];
}

- (void)becomeBlackBorderAndBlackTextColorLabel{
    self.addLabel.layer.borderColor = KGrayColorSeparatorLine.CGColor;
//    self.addLabel.layer.borderWidth = 0.5;
    self.addLabel.textColor = [UIColor blackColor];
}

#pragma mark -- 添加手势
//长按删除手势
- (void)addLongPressDeleteAction{
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 1.0;
    [self.addLabel addGestureRecognizer:longPress];
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ //手势只在开始时触发下面代码，防止调用两次
        if ([self.delegate respondsToSelector:@selector(longPressDeleteAction:)]) {
            [self.delegate longPressDeleteAction:longPress];
        }
    }
    
}

//添加新标签
- (void)addGestureAddNewTag{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLabelClick:)];
    [self.addLabel addGestureRecognizer:tap];
}
//移除标签
- (void)addGestureRemoveTag{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTag:)];
    [self.addLabel addGestureRecognizer:tap];
}

//添加已有的标签
- (void)addGestureAddOldTag{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addOldTag:)];
    [self.addLabel addGestureRecognizer:tap];
}

#pragma mark -- 代理
- (void)addOldTag:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(addOldTagDidTap:)]) {
        [self.delegate addOldTagDidTap:tap];
    }
}

- (void)removeTag:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(removeTagDidTap:)]) {
        [self.delegate removeTagDidTap:tap];
    }
}

- (void)addLabelClick:(UITapGestureRecognizer *)tap{
    SMLog(@"点击了 添加标签");
    if ([self.delegate respondsToSelector:@selector(labelDidTap:)]) {
        [self.delegate labelDidTap:tap];
    }
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    
    self.addLabel.text = titleText;
}



- (void)layoutSubviews{
    [super layoutSubviews];
//    self.addLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds) - 5, CGRectGetHeight(self.contentView.bounds) - 5);
    self.addLabel.frame = self.contentView.bounds;
}

@end
