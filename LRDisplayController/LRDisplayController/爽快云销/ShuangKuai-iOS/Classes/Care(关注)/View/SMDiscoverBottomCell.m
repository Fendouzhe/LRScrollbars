//
//  SMDiscoverBottomCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscoverBottomCell.h"
#import "SMHotProductController.h"
#import "SMHotActionController.h"
#import "SMNewsController.h"

@implementation SMDiscoverBottomCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"discoverBottomCell";
    SMDiscoverBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMDiscoverBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        SMHotProductController *vc1 = [[SMHotProductController alloc] init];
        self.vc1 = vc1;
        [self.contentView addSubview:vc1.view];
        
        SMHotActionController *vc2 = [[SMHotActionController alloc] init];
        self.vc2 = vc2;
        [self.contentView addSubview:vc2.view];
        vc2.view.hidden = YES;
        
        SMNewsController *vc3 = [[SMNewsController alloc] init];
        self.vc3 = vc3;
        [self.contentView addSubview:vc3.view];
        vc3.view.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
