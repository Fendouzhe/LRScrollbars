//
//  SMUploadTableViewCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/4/7.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMUploadTableViewCellDelegate <NSObject>

- (void)takePhotoBtnDidClick:(UIButton *)btn;

@end

@interface SMUploadTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;

@property (nonatomic ,weak)id<SMUploadTableViewCellDelegate> delegate;
@end
