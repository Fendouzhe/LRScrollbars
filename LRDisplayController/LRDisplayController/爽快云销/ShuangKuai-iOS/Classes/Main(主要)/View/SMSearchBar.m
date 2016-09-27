//
//  SMSearchBar.m
//  自定义搜索栏封装
//
//  Created by iOS on 15/11/7.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "SMSearchBar.h"

@implementation SMSearchBar

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索产品、企业";
        self.layer.cornerRadius = SMCornerRadios;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.background = [UIImage imageNamed:@"sousuokuang"];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:9];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"搜索产品、企业" attributes:dict];
//        self.attributedPlaceholder = attributeStr;
        UIColor *color = [UIColor whiteColor];
         self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索产品、企业" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.adjustsFontSizeToFitWidth = YES;
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"fangdajing"];
        
        searchIcon.width = 28;
        searchIcon.height = 28;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.keyboardType = UIKeyboardTypeWebSearch;
    }
    return self;
}

@end
