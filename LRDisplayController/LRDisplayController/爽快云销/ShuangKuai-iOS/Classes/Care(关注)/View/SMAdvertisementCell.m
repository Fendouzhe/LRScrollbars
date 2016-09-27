//
//  SMAdvertisementCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAdvertisementCell.h"
#import "SMAdvertisementScrollView.h"

@interface SMAdvertisementCell ()
//喇叭
@property (nonatomic ,strong)UIButton *hornBtn;

@property (nonatomic ,strong)SMAdvertisementScrollView *adView;

@property (nonatomic ,strong)NSArray *arrAds;

@end

@implementation SMAdvertisementCell

+ (instancetype)cellWithTableview:(UITableView *)tableView{
    
    static NSString *ID = @"advertisementCell";
    SMAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMAdvertisementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor greenColor];
        
        //喇叭  为了避免以后会添加点击事件，这里就用UIButton控件
        UIButton *hornBtn = [[UIButton alloc] init];
        self.hornBtn = hornBtn;
        [self.contentView addSubview:hornBtn];
        [hornBtn setBackgroundImage:[UIImage imageNamed:@"kuaibao"] forState:UIControlStateNormal];
 
        
//        self.adView = [[SMAdvertisementScrollView alloc] initWithArray:mutArray];
        
//        //轮播广告
//        SMAdvertisementScrollView *adView = [[SMAdvertisementScrollView alloc] initWithArray:@[@"恭喜清雯签约800万大单！！",@"本月销售冠军：海洛->8888万业绩。小伙伴们，加油！",@"电信推出1元购iphone7啦！赶紧来抢购吧！！电信推出1元购iphone7啦！赶紧来抢购吧！！"]];
//        self.adView = adView;
//        [self.contentView addSubview:adView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //喇叭
    [self.hornBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //广告
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.hornBtn.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
}

-(void)refreshUI:(NSArray *)array{
    NSMutableArray * mutArray = [NSMutableArray array];
    
    for (Msg * msg in array) {
        [mutArray addObject:msg.content];
    }
    
    //轮播广告
    [self.adView removeFromSuperview];
    self.adView = nil;
    SMAdvertisementScrollView *adView = [[SMAdvertisementScrollView alloc] initWithArray:mutArray];
    self.adView = adView;
    [self.contentView addSubview:adView];
    
    
    [self.hornBtn removeFromSuperview];
    self.hornBtn = nil;
    self.hornBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.hornBtn];
    [self.hornBtn setBackgroundImage:[UIImage imageNamed:@"kuaibao"] forState:UIControlStateNormal];
    
}
@end
