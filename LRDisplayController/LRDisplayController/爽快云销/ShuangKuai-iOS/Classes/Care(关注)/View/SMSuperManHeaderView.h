//
//  SMSuperManHeaderView.h
//  ShuangKuai-iOS
//
//  Created by 雷路荣 on 16/8/10.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol SMSuperManHeaderViewDelegate <NSObject>

- (void)superManHeaderViewIconViewClick:(User *)user;

@end

@interface SMSuperManHeaderView : UIView

+ (instancetype)superManHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstIconImage;

@property (weak, nonatomic) IBOutlet UIImageView *secondIconImage;

@property (weak, nonatomic) IBOutlet UIImageView *threeIconImage;

@property(nonatomic,strong)NSMutableArray *userArr;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstIconToTop;


@property(nonatomic,weak)id<SMSuperManHeaderViewDelegate>delegate;

@end
