//
//  SMPintuanSingleCollectionCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMPintuanSingleCollectionCell.h"
#import "SMGroupbuyDetailList.h"

@interface SMPintuanSingleCollectionCell()

@property (strong, nonatomic)UIImageView *imageView;

@property (strong, nonatomic)UILabel *productNameLabel;
@property (strong, nonatomic)UILabel *currentPrice;
@property (strong, nonatomic)UILabel *originPrice;
@property (strong, nonatomic)UIView *buttonBgView;
@property (strong, nonatomic)UIButton *twoRenTuanButton;
@property (strong, nonatomic)UIButton *goKaiTuanButton;
@property (strong, nonatomic)UIView *bgView;

@end

@implementation SMPintuanSingleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //cell切圆角将失去阴影效果
        //self.layer.cornerRadius = 2;
        //self.layer.masksToBounds = YES;
        
        _bgView = [[UIView alloc] init];
        [self.contentView addSubview:_bgView];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _bgView.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bgView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        _bgView.layer.shadowRadius = 2;//阴影半径，默认3
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        //图片
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(145*KMatch));
        }];
        
        
        //商品名
        _productNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_productNameLabel];
        _productNameLabel.font = KDefaultFont13Match;
        _productNameLabel.textAlignment = NSTextAlignmentCenter;
        [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(6*KMatch);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(16*KMatch));
        }];
        
        //现价
        _currentPrice = [[UILabel alloc] init];
        [self.contentView addSubview:_currentPrice];
        _currentPrice.font = KDefaultFont13Match;
        _currentPrice.textAlignment = NSTextAlignmentCenter;
        _currentPrice.textColor = KRedColorLight;
        [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productNameLabel.mas_bottom).offset(6*KMatch);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@(16*KMatch));
        }];
        
        //原价
        _originPrice = [[UILabel alloc] init];
        [self.contentView addSubview:_originPrice];
        _originPrice.font = KDefaultFont13Match;
        _originPrice.textAlignment = NSTextAlignmentLeft;
        _originPrice.textColor = [UIColor lightGrayColor];
        [_originPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productNameLabel.mas_bottom).offset(6*KMatch);
            make.left.equalTo(self.contentView.mas_centerX);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(16*KMatch));
        }];
        
        
        //放置按钮的View
        _buttonBgView = [[UIView alloc] init];
        _buttonBgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_buttonBgView];
        _buttonBgView.layer.cornerRadius = 4;
        _buttonBgView.layer.masksToBounds = YES;
        //禁止按钮点击
        _buttonBgView.userInteractionEnabled = NO;
        [_buttonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.currentPrice.mas_bottom).offset(7*KMatch);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        
        //2人团按钮
        _twoRenTuanButton = [[UIButton alloc] init];
        [_buttonBgView addSubview:_twoRenTuanButton];
        [_twoRenTuanButton setTitle:@"2人团" forState:UIControlStateNormal];
        [_twoRenTuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _twoRenTuanButton.backgroundColor = KBlackColorLight;
        _twoRenTuanButton.titleLabel.font = KDefaultFontMiddleMatch;
        [_twoRenTuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonBgView.mas_top);
            make.left.equalTo(self.buttonBgView.mas_left);
            make.right.equalTo(self.buttonBgView.mas_centerX);
            make.bottom.equalTo(self.buttonBgView.mas_bottom);
        }];

        
        //去开团按钮
        _goKaiTuanButton = [[UIButton alloc] init];
        [_buttonBgView addSubview:_goKaiTuanButton];
        [_goKaiTuanButton setTitle:@"去开团" forState:UIControlStateNormal];
        [_goKaiTuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goKaiTuanButton.backgroundColor = KBlackColorLight;
        _goKaiTuanButton.backgroundColor = KRedColorLight;
        _goKaiTuanButton.titleLabel.font = KDefaultFontMiddleMatch;
        [_goKaiTuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonBgView.mas_top);
            make.left.equalTo(self.buttonBgView.mas_centerX);
            make.right.equalTo(self.buttonBgView.mas_right);
            make.bottom.equalTo(self.buttonBgView.mas_bottom);
        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}



- (void)setModel:(SMGroupbuyDetailList *)model{
    _model = model;
    
    [self.twoRenTuanButton setTitle:[NSString stringWithFormat:@"%lu人团",model.minLimitNum] forState:UIControlStateNormal];
    self.productNameLabel.text = model.productName;
    self.currentPrice.text = [NSString stringWithFormat:@"¥%.2f",model.finalPrice];
    //self.originPrice.text = [NSString stringWithFormat:@"¥%lu",model.price];
    [self.originPrice setAttributedText:[self lineWithString:[NSString stringWithFormat:@"%.2f",model.price]]];
    
    NSArray *imagePathArr = [NSString mj_objectArrayWithKeyValuesArray:model.imagePath];
    NSString *imageStr = imagePathArr[0];
    //加载指示器
    [self.imageView setShowActivityIndicatorView:YES];
    [self.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
}


-(NSAttributedString *)lineWithString:(NSString *)string
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:%@",string] attributes:dict];
    return attributeStr;
}

@end
