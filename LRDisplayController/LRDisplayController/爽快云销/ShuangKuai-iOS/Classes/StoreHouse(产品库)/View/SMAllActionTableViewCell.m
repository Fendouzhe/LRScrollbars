//
//  SMAllActionTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/24.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMAllActionTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface SMAllActionTableViewCell ()

@property (nonatomic ,assign)BOOL isAllSelected;

@end

@implementation SMAllActionTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"allActionTableViewCell";
    SMAllActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMAllActionTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    }
    return cell;
}

- (void)setAction:(Activity *)action{
    _action = action;
    
    NSArray *arrAction = [NSString mj_objectArrayWithKeyValuesArray:action.imagePaths];
    NSString *imageStr = arrAction[0];
    
    [self.iconView setShowActivityIndicatorView:YES];
    [self.iconView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.titleLabel.text = action.title;
    
}

- (IBAction)gouBtnClick:(UIButton *)sender {
    if (!self.isAllSelected) {
        sender.selected = !sender.selected;
        self.favDetail.isSelected = !self.favDetail.isSelected;
    }
    
    NSString *selectedStr = [NSString stringWithFormat:@"%zd",sender.selected];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"KSelectedStrAction"] = selectedStr;
    dict[@"KModleIDAction"] = self.favDetail.id;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KDeleteNoteAction" object:self userInfo:dict];
    
   
}

- (void)setFavDetail:(FavoritesDetail *)favDetail{
    _favDetail = favDetail;
    self.titleLabel.text = favDetail.itemName;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:favDetail.imagePath]];
    
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
    }else{
        self.gouBtn.selected = NO;
    }
    
}


- (void)awakeFromNib {
    self.gouBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
