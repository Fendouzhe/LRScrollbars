//
//  SMDetailProductSection4Cell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SMDetailProductSection4CellDelegate <NSObject>

@optional
-(void)backToTableView;
-(void)setWebViewCellHeight:(CGFloat)height;
@end

@interface SMDetailProductSection4Cell : UITableViewCell

@property (nonatomic ,strong)Product *product;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,weak) id<SMDetailProductSection4CellDelegate> delegate;/**< 代理 */

@property(nonatomic ,assign)CGFloat cellHeight;

@end
