//
//  SMPictureTextHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/26.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMPictureTextHeaderView.h"
#import "NSString+Extension.h"

@interface SMPictureTextHeaderView ()

@property (nonatomic ,strong)UILabel *itemsLabel;

@property (nonatomic ,strong)UILabel *detailLabel;

@property (nonatomic ,copy)NSString *detailStr;

@end

@implementation SMPictureTextHeaderView

+ (instancetype)pictureTextHeaderView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //小事项label
        UILabel *itemsLabel = [[UILabel alloc] init];
        itemsLabel.text = @"[小事项]";
        itemsLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:itemsLabel];
        self.itemsLabel = itemsLabel;
        
        //详细说明
        self.detailStr = @"新毛衣出厂会有些味道，建议先晾晒通风两天。毛衣类衣物会有不同程度的起球和掉毛现象，望知悉。针织毛衣类衣物不能机洗，机洗与甩干会引起变形，请务必用晒衣篮平铺晾晒，以免拉长";
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = self.detailStr;
//        detailLabel.width = KScreenWidth - 20;
        detailLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:detailLabel];
        detailLabel.numberOfLines = 0;
        self.detailLabel = detailLabel;
        
        
        CGFloat height1 = [itemsLabel.text textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
        CGFloat height2 = [self.detailStr textSizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)].height;
        
        self.headerHeight = 10 + height1 + height2 + 7;
         
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = KScreenWidth - 20;
    NSNumber *wNum = [NSNumber numberWithFloat:w];
    [self.itemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(wNum);
//        make.height.equalTo(@14);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-7);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(wNum);
        //        make.height.equalTo(@14);
    }];
    
}

@end
