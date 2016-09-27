//
//  SMNewShelfManagerCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/5/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMNewFav;
@protocol SMNewShelfManagerCellDelegate <NSObject>

- (void)addViewDidClick;

//- (void)changeShelfBtnDidClick:(NSInteger)tag;
- (void)changeShelfBtnDidClick:(NSInteger)tag favID:(NSString *)favID;

- (void)bjIconDidLongPress:(NSInteger)tag;

- (void)downProductBtnDidClick:(NSMutableArray *)arrIDs and:(NSString *)favID;

@end


@interface SMNewShelfManagerCell : UITableViewCell

@property (nonatomic ,weak)id<SMNewShelfManagerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bjIcon;

@property (nonatomic ,strong)SMNewFav *favNew;

//@property (nonatomic ,strong)Favorites *fav;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
