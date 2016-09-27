//
//  SMProductCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductCell.h"
#import "SMProductView.h"

@interface SMProductCell ()

//@property (nonatomic ,strong)SMProductView *productView;

@end

@implementation SMProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"productCell";
    SMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        SMProductView *productView = [SMProductView productView];
        self.productView = productView;
        [self.contentView addSubview:productView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.productView.frame = self.bounds;
}


@end
