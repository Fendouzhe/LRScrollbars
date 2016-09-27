//
//  SMSection1TitleCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/3.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSection1TitleCell.h"

@interface SMSection1TitleCell ()

@property (weak, nonatomic) IBOutlet UIButton *moreProduct;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@end

@implementation SMSection1TitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"section1TitleCell";
    SMSection1TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMSection1TitleCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.moreProduct setTitleColor:KRedColorLight forState:UIControlStateNormal];
    self.grayView.backgroundColor = KControllerBackGroundColor;
    
    self.moreProduct.hidden = YES;  //隐藏“更多商品” 按钮
}

- (IBAction)moreProductClick {
    if ([self.delegate respondsToSelector:@selector(moreBtnDidCLick)]) {
        [self.delegate moreBtnDidCLick];
    }
}


@end
