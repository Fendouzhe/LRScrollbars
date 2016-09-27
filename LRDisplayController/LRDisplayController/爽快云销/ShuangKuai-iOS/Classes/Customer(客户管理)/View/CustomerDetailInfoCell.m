//
//  CustomerDetailInfoCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomerDetailInfoCell.h"
#import "CustomerDetailBaseModel.h"
#import "CustomerDetailArrowModel.h"
#import "CustomerDetailOneFooterImage.h"
#import "CustomerDetailTwoFooterImage.h"
#import "CustomerDetailBigFrameModel.h"
#import "CustomerDetailJustHeightModel.h"
#import "NSString+Extension.h"
#define fontSize 15
@interface CustomerDetailInfoCell ()
@property (nonatomic,strong) UIImageView *iconView;/**< 头像 */
@property (nonatomic,strong) UILabel *mainLabel;/**< 标题 */
@property (nonatomic,strong) UILabel *detailLabel;/**< 尾部标题 */
@property (nonatomic,strong) UIButton *detailButton;/**< 尾部Image */
@property (nonatomic,strong) UIButton *detailMoreButton;/**< 尾部Image */
@end

@implementation CustomerDetailInfoCell

-(UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.font = KDefaultFontBig;
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = KDefaultFontBig;
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 0;
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

-(UIButton *)detailButton{
    if (_detailButton == nil) {
        _detailButton = [[UIButton alloc] init];
        [self.contentView addSubview:_detailButton];
        [_detailButton addTarget:self action:@selector(lastButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

-(void)lastButtonClick{
    if ([self.delegate respondsToSelector:@selector(cellButtonClickWithIndex:withButtonNumber:)]) {
        [self.delegate cellButtonClickWithIndex:self.cellIndex withButtonNumber:0];
    }
}

-(UIButton *)detailMoreButton{
    if (_detailMoreButton == nil) {
        _detailMoreButton = [[UIButton alloc] init];
        [self.contentView addSubview:_detailMoreButton];
        [_detailMoreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailMoreButton;
}

-(void)moreButtonClick{
    if ([self.delegate respondsToSelector:@selector(cellButtonClickWithIndex:withButtonNumber:)]) {
        [self.delegate cellButtonClickWithIndex:self.cellIndex withButtonNumber:1];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    
    static NSString *ID = @"CustomerDetailInfoCell";
    CustomerDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CustomerDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)setCellData:(CustomerDetailBaseModel *)cellData{
    _cellData = cellData;
    self.iconView.image = [UIImage imageNamed:cellData.iconImage];
    self.mainLabel.text = cellData.title;
    self.detailLabel.text = cellData.detailText;
    if ([cellData isMemberOfClass:[CustomerDetailArrowModel class]]) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (cellData.textAlignment) {
        case DetailTextAlignmentLeft:
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case DetailTextAlignmentCenter:
            self.detailLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case DetailTextAlignmentRight:
            self.detailLabel.textAlignment = NSTextAlignmentRight;
        default:
            break;
    }
    if ([cellData isMemberOfClass:[CustomerDetailBaseModel class]]) {
        /**
         *  暂时只有标签
         */
        return;
    }
    if ([cellData isMemberOfClass:[CustomerDetailTwoFooterImage class]]) {
        CustomerDetailTwoFooterImage* twoFooterImage = (CustomerDetailTwoFooterImage *)cellData;
        if (twoFooterImage.imageArray.count>1) {
//            self.detailImage.image = [UIImage imageNamed:twoFooterImage.imageArray[0]];
            [self.detailButton setImage:[UIImage imageNamed:twoFooterImage.imageArray[0]] forState:UIControlStateNormal];
//            self.detailMoreImage.image = [UIImage imageNamed:twoFooterImage.imageArray[1]];
            [self.detailMoreButton setImage:[UIImage imageNamed:twoFooterImage.imageArray[1]] forState:UIControlStateNormal];
        }
        
    }
    if ([cellData isMemberOfClass:[CustomerDetailOneFooterImage class]]) {
        CustomerDetailOneFooterImage* oneFooterImage = (CustomerDetailOneFooterImage *)cellData;
//        self.detailImage.image = [UIImage imageNamed:oneFooterImage.detailImage];
        [self.detailButton setImage:[UIImage imageNamed:oneFooterImage.detailImage] forState:UIControlStateNormal];
    }
}

-(void)setFrameCellData:(CustomerDetailBigFrameModel *)frameCellData{
    _frameCellData = frameCellData;
    self.iconView.image = [UIImage imageNamed:frameCellData.cellModel.iconImage];
    self.mainLabel.text = frameCellData.cellModel.title;
    self.detailLabel.text = frameCellData.cellModel.detailText;
    self.accessoryType=UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat size = 22;
    if (self.cellData) {
        CGFloat imageW = size;
        CGFloat imageH = imageW;
        CGFloat iconViewY = (self.frame.size.height - imageW)*0.5;
        self.iconView.frame = CGRectMake(10, iconViewY, imageW, imageH);
        [self.mainLabel sizeToFit];
        CGFloat mainLabelY = (self.frame.size.height - self.mainLabel.frame.size.height)*0.5;
        
        self.mainLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+5,mainLabelY , self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
        
        CGFloat detailLabelX = CGRectGetMaxX(self.mainLabel.frame)+5;
        CGFloat detailLabelW;
        CGFloat detailLabelH;
        CGFloat detailLabelY;
        if ([self.cellData isKindOfClass:[CustomerDetailOneFooterImage class]]) {
            CGFloat detailImageW = 25;
            CGFloat detailImageH = detailImageW;
            CGFloat detailImageX = KScreenWidth - 10 - detailImageW;
            CGFloat detailImageY = iconViewY;
            self.detailButton.frame = CGRectMake(detailImageX, detailImageY, detailImageW, detailImageH);
            self.detailButton.hidden = NO;
            if (_detailMoreButton) {
                _detailMoreButton.hidden = YES;
            }
            detailLabelY = mainLabelY;
            detailLabelW = detailImageX - detailLabelX - 15;
            detailLabelH = self.mainLabel.frame.size.height;
            self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
            return;
        }
        if ([self.cellData isKindOfClass:[CustomerDetailTwoFooterImage class]]){
            CGFloat detailImageW = size;
            CGFloat detailImageH = detailImageW;
            CGFloat detailImageX = KScreenWidth - 10 - detailImageW;
            CGFloat detailImageY = iconViewY;
            self.detailButton.frame = CGRectMake(detailImageX, detailImageY, detailImageW, detailImageH);
            self.detailButton.hidden = NO;
            CGFloat detailMoreImageW = detailImageW;
            CGFloat detailMoreImageH = detailImageH;
            CGFloat detailMoreImageX = detailImageX - 10 - detailImageW;
            CGFloat detailMoreImageY = iconViewY;
            self.detailMoreButton.frame = CGRectMake(detailMoreImageX, detailMoreImageY, detailMoreImageW, detailMoreImageH);
            self.detailMoreButton.hidden = NO;
            detailLabelY = mainLabelY;
            detailLabelW = detailMoreImageX - detailLabelX - 15;
            detailLabelH = self.mainLabel.frame.size.height;
            self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
            SMLog(@" self.detailLabel = %@,self.mainLabel = %@",self.detailLabel,self.mainLabel);
            return;
        }
//        detailLabelX = CGRectGetMaxX(self.mainLabel.frame)+5;
        detailLabelW = KScreenWidth - detailLabelX - size-5;
        detailLabelH = self.mainLabel.frame.size.height;
        detailLabelY = mainLabelY;
        self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY,detailLabelW , detailLabelH);
        _detailButton.hidden = YES;
        _detailMoreButton.hidden = YES;
    }else if(self.frameCellData){
        CGFloat imageW = size;
        CGFloat imageH = imageW;
        CGFloat iconViewY = (self.frame.size.height - imageW)*0.5;
        self.iconView.frame = CGRectMake(10, iconViewY, imageW, imageH);
        [self.mainLabel sizeToFit];
        CGFloat mainLabelY = (self.frame.size.height - self.mainLabel.frame.size.height)*0.5;
        self.mainLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+5,mainLabelY , self.mainLabel.frame.size.width, self.mainLabel.frame.size.height);
        CGFloat w = KScreenWidth - CGRectGetMaxX(self.mainLabel.frame) - 15;
        CGSize textSize = [self.frameCellData.cellModel.detailText textSizeWithFont:[UIFont systemFontOfSize:fontSize] maxSize:CGSizeMake(w, MAXFLOAT)];
        CGFloat detailLabelX = CGRectGetMaxX(self.mainLabel.frame)+5;
//        CGFloat detailLabelW = w;
        CGFloat detailLabelH = detailLabelH = self.mainLabel.frame.size.height;
        CGFloat detailLabelY = (self.frame.size.height - textSize.height)*0.5;
        self.detailLabel.frame = CGRectMake(detailLabelX, detailLabelY, w, textSize.height);
    }
}

@end
