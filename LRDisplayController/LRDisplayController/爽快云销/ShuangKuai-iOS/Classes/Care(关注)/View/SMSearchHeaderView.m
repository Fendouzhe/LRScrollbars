//
//  SMSearchHeaderView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMSearchHeaderView.h"

@interface SMSearchHeaderView ()<UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray * companyArray;

@end

@implementation SMSearchHeaderView

-(NSMutableArray *)companyArray
{
    if (!_companyArray) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

+ (instancetype)searchHeaderView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KControllerBackGroundColor;
        
        //搜索栏
        UITextField *searchField = [[UITextField alloc] init];
        self.searchField = searchField;
        searchField.returnKeyType = UIReturnKeySearch;
        searchField.delegate = self;
        searchField.layer.cornerRadius = SMCornerRadios;
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        
        searchField.placeholder = @"搜索企业";
        [self addSubview:searchField];
        
        
        
        //放大镜
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"fangdajing2"];
        searchIcon.width = 28;
        searchIcon.height = 28;
        searchIcon.contentMode = UIViewContentModeCenter;
        
        searchField.leftView =searchIcon;
        searchField.leftViewMode = UITextFieldViewModeAlways;
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        //添加监听
        [self addobserverTextfieldchange];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(7);
        make.width.equalTo(@230);
        make.height.equalTo(@24);
    }];
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.searchField resignFirstResponder];
        SMLog(@"点击了搜索");
        //要执行搜索
        //[self searchCompanyWithName:textField.text];
    }
    return YES;
}

-(void)addobserverTextfieldchange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCompanyWithName) name:UITextFieldTextDidChangeNotification object:self.searchField];
}

-(void)searchCompanyWithName
{
    [self.companyArray removeAllObjects];
    
    [[SKAPI shared] queryCompanyByName:self.searchField.text isRecommend:YES andPage:0 andSize:10 block:^(NSArray *array, NSError *error) {
        if (!error) {
            for (Company * company in array) {
                [self.companyArray addObject:company];
            }
            //回调刷新主tableview
            self.refreshblock(self.companyArray);
        }
    }];
}
@end
