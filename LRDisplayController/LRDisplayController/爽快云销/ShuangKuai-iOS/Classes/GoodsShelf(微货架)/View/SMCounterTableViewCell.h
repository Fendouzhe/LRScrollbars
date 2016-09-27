//
//  SMCounterTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMNewFav;
@protocol SMCounterTableViewCellDelegate <NSObject>

- (void)addViewDidClick;
//- (void)changeShelfBtnDidClick:(NSInteger)tag;
- (void)changeShelfBtnDidClick:(NSInteger)tag favID:(NSString *)favID;

- (void)bjIconDidLongPress:(NSInteger)tag;

- (void)downProductBtnDidClick:(NSMutableArray *)arrIDs and:(NSString *)favID;

@end

@interface SMCounterTableViewCell : UITableViewCell

@property (nonatomic ,weak)id<SMCounterTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bjIcon;

@property (nonatomic ,strong)SMNewFav *favNew;

//@property (nonatomic ,strong)Favorites *fav;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
