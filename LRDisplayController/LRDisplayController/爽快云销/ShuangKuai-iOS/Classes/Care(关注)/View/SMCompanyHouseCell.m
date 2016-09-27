//
//  SMCompanyHouseCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCompanyHouseCell.h"
#import "SMCompanyHouseView.h"
#import <UIButton+WebCache.h>


@interface SMCompanyHouseCell ()



@end

@implementation SMCompanyHouseCell

+ (instancetype)cellWithTableVIew:(UITableView *)tableView{
    
    static NSString *ID = @"companyHouseCell";
    SMCompanyHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMCompanyHouseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        SMCompanyHouseView *companyHouseView = [SMCompanyHouseView companyHouseView];
//        companyHouseView.height = 100;
        self.companyHouseView = companyHouseView;
        
        [self.contentView addSubview:companyHouseView];
        
    }
    return self;
}

- (void)setNews:(News *)news{
    _news = news;
    
    //[self.companyHouseView.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:news.imagePaths] forState:UIControlStateNormal];
    
    [self.companyHouseView.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:news.imagePaths] forState:UIControlStateNormal placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.companyHouseView.companyName.text = news.title;
    self.companyHouseView.companyInfoLabel.text = [self removeHTML2:news.content];
    
}

//获取html 里面的字符串
- (NSString *)removeHTML2:(NSString *)html{
    
    
    SMLog(@"html =    %@" ,html);
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    SMLog(@"htmlArray   =   %@",components);
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    
    
    
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    return plainText; 
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.companyHouseView.frame = self.bounds;
}
@end
