//
//  SMDetailProductSection3Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDetailProductSection3Cell.h"
#import "skuSelected.h"

@interface SMDetailProductSection3Cell ()

@property (nonatomic ,strong)UIView *topView;

@property (nonatomic ,strong)NSArray *arrSkus;

/**
 *  产品规格
 */
@property (nonatomic ,strong)UILabel *Specifications;

@property (nonatomic ,strong)UIView *bottomGrayView;
@end

@implementation SMDetailProductSection3Cell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"detailProductSection3Cell";
    SMDetailProductSection3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMDetailProductSection3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        //产品规格
        UILabel *Specifications = [[UILabel alloc] init];
        [self.contentView addSubview:Specifications];
        self.Specifications = Specifications;
        Specifications.textColor = [UIColor blackColor];
        Specifications.font = KDefaultFontBig;
        Specifications.text = @"选择规格";

        
        //右边的尖头
        UIButton *rightBtn = [[UIButton alloc] init];
        [self.contentView addSubview:rightBtn];
        self.rightBtn = rightBtn;
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"fanhuiqian"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"xiangxiajiantou"] forState:UIControlStateSelected];
        rightBtn.userInteractionEnabled = NO;
        
        //下面的灰色横线
        UIView *bottomGrayView = [[UIView alloc] init];
        self.bottomGrayView = bottomGrayView;
        bottomGrayView.backgroundColor = KGrayColorSeparatorLine;
        [self.contentView addSubview:bottomGrayView];

    }
    return self;
}

- (void)setSpecName:(NSString *)specName{
    _specName = specName;
    if (specName && ![specName isEqualToString:@""]) {
        self.Specifications.text = specName;
    }else{
        self.Specifications.text = @"选择规格";
    }
}

//- (void)setProduct:(Product *)product{
//    _product = product;
//    SMLog(@"product  setProduct   section3 %@ \n",product);
//    
//    NSArray *arrSkuS = [skuSelected mj_objectArrayWithKeyValuesArray:product.skuSelected];
//    self.arrSkus = arrSkuS;
//    SMLog(@"skuS   %@  --   %@",arrSkuS,product.skuSelected);
//    for (skuSelected *s in arrSkuS) {
//        self.sectionCount = self.arrSkus.count;
//        SMLog(@"s.propList    %zd",s.propList.count);
//    }
//    
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.Specifications mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    [self.bottomGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
}

- (NSArray *)arrSkus{
    if (_arrSkus == nil) {
        _arrSkus = [NSMutableArray array];
    }
    return _arrSkus;
}

@end
