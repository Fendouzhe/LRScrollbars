//
//  SMShelfDiscountCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/8.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMShelfDiscountCell.h"

@interface SMShelfDiscountCell ()

/**
 *  全部选中状态
 */
@property (nonatomic ,assign)BOOL isAllSelected;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bgColorView;

@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;

@end

@implementation SMShelfDiscountCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"shelfDiscountCell";
    SMShelfDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMShelfDiscountCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }    
    return cell;
}

- (IBAction)gouBtnClick:(UIButton *)sender {
    if (!self.isAllSelected) {
        sender.selected = !sender.selected;
        self.favDetail.isSelected = YES;
    }
    
    NSString *selectedStr = [NSString stringWithFormat:@"%zd",sender.selected];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"KSelectedStrDiscount"] = selectedStr;
    dict[@"KModleIDDiscount"] = self.favDetail.id;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteDisCount" object:self userInfo:dict];
}

- (void)awakeFromNib {
    // Initialization code
    self.gouBtn.hidden = YES;
    self.backgroundColor = KControllerBackGroundColor;
    self.bottomGrayView.backgroundColor = KControllerBackGroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCoupon:(Coupon *)coupon
{
    if (isIPhone6) {
        self.widthConstraint.constant = 80 * KMatch6;
    }else if(isIPhone6p)
    {
        self.widthConstraint.constant = 80* KMatch6p;
    }
    _coupon = coupon;
    
    self.iconImageView.layer.cornerRadius = 22;
    self.iconImageView.layer.masksToBounds = YES;
    
    //[self.iconImageView sd_setImageWithURL:[NSURL URLWithString:coupon.companyImage]];
    
    [self.iconImageView setShowActivityIndicatorView:YES];
    [self.iconImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:coupon.companyImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.actionNameLabel.text = coupon.name;
    
    self.companyLabel.text = [NSString stringWithFormat:@"%@",coupon.companyName];
    
    self.periodLabel.text = [NSString stringWithFormat:@"有效期:%@-%@",[self getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",coupon.startTime]],[self getTimeFromTimestamp:[NSString stringWithFormat:@"%ld",coupon.endTime ]]];
    
    self.topLabel.text = [NSString stringWithFormat:@"￥%.0lf",coupon.money ];
    self.midLabel.text = [NSString stringWithFormat:@"%.0lf折",coupon.depositRate];
    self.bottomLabel.text = coupon.type ? @"优惠劵":@"兑换券";
    
    //按照优惠劵的类型显示
    if (coupon.type==0) {
        self.midLabel.hidden = YES;
        self.topLabel.hidden = NO;
        self.bottomLabel.hidden = NO;
        self.bottomLabel.text = @"代金券";
        self.topLabel.text = [NSString stringWithFormat:@"￥%.0lf",coupon.money ];
        self.bgColorView.image = [UIImage imageNamed:@"youhuiquanjuse"];
    }else if(coupon.type == 1)
    {
        self.midLabel.hidden = YES;
        self.topLabel.hidden = NO;
        self.bottomLabel.hidden = NO;
        self.bottomLabel.text = @"折扣券";
        self.topLabel.text = [NSString stringWithFormat:@"%.0lf折",coupon.depositRate];
        self.bgColorView.image = [UIImage imageNamed:@"lansezhekouquan"];
    }else
    {
        self.midLabel.hidden = NO;
        self.topLabel.hidden = YES;
        self.bottomLabel.hidden = YES;
        self.midLabel.text = @"兑换券";
        self.bgColorView.image = [UIImage imageNamed:@"ziseduihuanquan"];
    }
}

//将服务器返回的时间戳转化成时间
- (NSString *)getTimeFromTimestamp:(NSString *)timestamp
{
    NSTimeInterval _interval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}

- (void)setFavDetail:(FavoritesDetail *)favDetail{
    _favDetail = favDetail;
    
    if (favDetail.type == 0) {
        self.bgColorView.image = [UIImage imageNamed:@"youhuiquanjuse"];
    }else if (favDetail.type == 1){
        self.bgColorView.image = [UIImage imageNamed:@"lansezhekouquan"];
    }else if (favDetail.type == 2){
        self.bgColorView.image = [UIImage imageNamed:@"ziseduihuanquan"];
    }
    
    if (isIPhone6) {
        self.widthConstraint.constant = 80 * KMatch6;
    }else if(isIPhone6p)
    {
        self.widthConstraint.constant = 80* KMatch6p;
    }
    
    self.actionNameLabel.text = favDetail.itemName;
    
    self.companyLabel.text = [NSString stringWithFormat:@"%@",favDetail.companyName];
    
    [self.iconImageView setShowActivityIndicatorView:YES];
    [self.iconImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:favDetail.imagePath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    NSString *timeStart = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",favDetail.startTime]];
    NSString *start = [timeStart componentsSeparatedByString:@" "].firstObject;
    NSString *timeEnd = [Utils getTimeFromTimestamp:[NSString stringWithFormat:@"%zd",favDetail.endTime]];
    NSString *end = [timeEnd componentsSeparatedByString:@" "].firstObject;
    self.periodLabel.text = [NSString stringWithFormat:@"有效期:%@ -- %@",start,end];
    
    SMLog(@"descr = %@",favDetail.descr);
#warning 兑换券的判断

        if (favDetail.value2.integerValue!= 0 && favDetail.value1.integerValue == 0) {
            self.midLabel.hidden = YES;
            self.topLabel.hidden = NO;
            self.bottomLabel.hidden = NO;
            self.topLabel.text = [NSString stringWithFormat:@"%@折",favDetail.value2];
            self.bottomLabel.text = @"折扣券";
            self.bgColorView.image = [UIImage imageNamed:@"lansezhekouquan"];
        }else
        {
            self.midLabel.hidden = YES;
            self.topLabel.hidden = NO;
            self.bottomLabel.hidden = NO;
            self.topLabel.text = [NSString stringWithFormat:@"￥%@",favDetail.value1];
            self.bottomLabel.text = @"代金券";
            self.bgColorView.image = [UIImage imageNamed:@"youhuiquanjuse"];
        }
    
    if (favDetail.value1.integerValue == 0 && favDetail.value2.integerValue == 0) {
        self.midLabel.hidden = NO;
        self.topLabel.hidden = YES;
        self.bottomLabel.hidden = YES;
        self.midLabel.text = @"兑换券";
        self.bgColorView.image = [UIImage imageNamed:@"ziseduihuanquan"];
    }
    

    
//    if (favDetail.type==0) {
//        self.midLabel.hidden = YES;
//        self.topLabel.hidden = NO;
//        self.bottomLabel.hidden = NO;
//        self.topLabel.text = [NSString stringWithFormat:@"￥%@",favDetail.value1];
//        self.bottomLabel.text = @"代金券";
//    }else if (favDetail.type==1){
//        self.midLabel.hidden = YES;
//        self.topLabel.hidden = NO;
//        self.bottomLabel.hidden = NO;
//        self.topLabel.text = [NSString stringWithFormat:@"%@折",favDetail.value2];
//        self.bottomLabel.text = @"折扣券";
//    }else if (favDetail.type==2){
//        self.midLabel.hidden = NO;
//        self.topLabel.hidden = YES;
//        self.bottomLabel.hidden = YES;
//        self.midLabel.text = @"兑换券";
//    }
    
    if (favDetail.isMoveRight) {
        self.gouBtn.hidden = NO;
    }else{
        self.gouBtn.hidden = YES;
    }
    
    if (favDetail.isAllSelected) {//如果属于全选状态，就把勾勾  勾上
        self.gouBtn.selected = YES;
        self.isAllSelected = YES;
    }else{
        self.gouBtn.selected = NO;
        self.isAllSelected = NO;
    }
    
    if (self.gouBtn.selected) {
        [self gouBtnClick:self.gouBtn];
    }
    
    if (favDetail.isSelected) {
        self.gouBtn.selected = YES;
    }else
    {
        self.gouBtn.selected = NO;
    }
}



@end
