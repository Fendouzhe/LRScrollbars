//
//  SMSellLogTableViewCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSellLogTableViewCell.h"
#import "LocalCustomer+CoreDataProperties.h"

@interface SMSellLogTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageConstraints;

@end

@implementation SMSellLogTableViewCell

+ (instancetype)sellLogTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SMSellLogTableViewCell" owner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"sellLogTableViewCell";
    SMSellLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SMSellLogTableViewCell sellLogTableViewCell];
    }
    return cell;
}

-(void)setLocalworklog:(LocalWorkLog *)localworklog
{
    _localworklog = localworklog;
}

-(void)refreshUIWithLocalworklog:(LocalWorkLog*)localworklog andWithLocalCustomer:(LocalCustomer*)localCustomer
{
   // NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:KUserIcon];
    
    //self.iconImage.image = [UIImage imageWithData:data];
    
    self.iconImageConstraints.constant =0;
    self.iconImage.image = nil;
    
    self.nameLabel.text = localCustomer.fullname;
    self.contentLable.text = localworklog.content;
    self.timeLabel.text = localworklog.createAt;
    
    
}
@end
