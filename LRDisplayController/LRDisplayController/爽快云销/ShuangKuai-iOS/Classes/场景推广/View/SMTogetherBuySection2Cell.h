//
//  SMTogetherBuySection2Cell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/9/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMTogetherBuySection2Cell;
@class SMGroupbuyDetailList;

@protocol SMTogetherBuySection2CellDelegate <NSObject>
//热销单品点击
- (void)togetherBuyCollectionViewCellClickWithModel:(SMGroupbuyDetailList *)model;
//跟新高度
-(void)uodataTableViewCellHight:(SMTogetherBuySection2Cell *)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath;

@end

@interface SMTogetherBuySection2Cell : UITableViewCell

@property(nonatomic, strong)NSArray *dataArr;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic, weak)id<SMTogetherBuySection2CellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
