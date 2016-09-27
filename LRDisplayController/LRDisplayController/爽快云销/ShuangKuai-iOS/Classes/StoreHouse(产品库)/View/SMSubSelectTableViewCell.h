//
//  SMSubSelectTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/1/29.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddFavIDBlcok)(void);

typedef void(^SubFavIDBlcok)(void);

@interface SMSubSelectTableViewCell : UITableViewCell


-(void)setshowLabel:(NSString *)favName :(Favorites*)fav :(NSInteger)isCanAdd;

-(void)setsubshowLabel:(NSString *)favName :(Favorites*)fav :(NSInteger)isCanSub;

@property(nonatomic ,strong)AddFavIDBlcok addFavIDBlcok;

@property(nonatomic , strong)SubFavIDBlcok subFavIDBlcok;

@property(nonatomic , assign)NSInteger type;

@property(nonatomic , strong)Favorites * favorites;

@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)selectAction:(UIButton *)sender ;

@end
