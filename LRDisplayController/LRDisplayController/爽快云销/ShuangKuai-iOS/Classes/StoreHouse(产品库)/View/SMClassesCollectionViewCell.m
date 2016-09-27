//
//  SMClassesCollectionViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMClassesCollectionViewCell.h"

@interface SMClassesCollectionViewCell ()

@property (nonatomic ,strong)UILabel *classLabel;/**< <#注释#> */

@end

@implementation SMClassesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.classLabel = [[UILabel alloc] init];
        self.classLabel.text = @"分类名";
        self.classLabel.font = KDefaultFont;
        self.classLabel.textAlignment = NSTextAlignmentCenter;
        self.classLabel.backgroundColor = SMColor(208, 208, 208);
        
        [self.contentView addSubview:self.classLabel];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return self;
}

- (void)setModel2:(SMClassesLevel2 *)model2{
    _model2 = model2;
    self.classLabel.text = model2.name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.classLabel.frame = self.contentView.bounds;
}

@end
