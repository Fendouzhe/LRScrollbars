//
//  SMCompanyCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCompanyCell.h"
#import "SMCompanyView.h"

@interface SMCompanyCell ()

@property (nonatomic ,strong)SMCompanyView *companyView;

@end

@implementation SMCompanyCell

+ (instancetype)companyCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"companyCell";
    SMCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[SMCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        SMCompanyView *companyView = [SMCompanyView companyView];
        self.companyView = companyView;
        [self.contentView addSubview:companyView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.companyView.frame = self.bounds;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
