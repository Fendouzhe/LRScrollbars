//
//  SMCompanyHouseView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/11.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMCompanyHouseView.h"

@interface SMCompanyHouseView ()

///**
// *  添加关注按钮
// */
//@property (nonatomic ,strong)UIButton *addCareBtn;


/**
 *  水平横线
 */
@property (nonatomic ,strong)UILabel *horizontalLine;

//公司名与公司图标之间的距离
@property (nonatomic ,assign)CGFloat marginMid;

//整体view 下面的留白距离
@property (nonatomic ,assign)CGFloat marginUnder;

//公司名到view 顶部的距离
@property (nonatomic ,assign)CGFloat marginTop;

@property (nonatomic ,assign)CGFloat marginRight;

@property(nonatomic,strong)UIAlertView * alertView;

@end

@implementation SMCompanyHouseView

+ (instancetype)companyHouseView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.marginMid = 8;
        self.marginTop = 10;
        self.marginUnder = 5;
        self.marginRight = 10;
//        self.backgroundColor = KControllerBackGroundColor;
//        self.backgroundColor = SMRandomColor;
        //企业图标按钮
        UIButton *iconBtn = [[UIButton alloc] init];
        self.iconBtn = iconBtn;
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"qiye1"] forState:UIControlStateNormal];
        [self addSubview:iconBtn];
        [iconBtn addTarget:self action:@selector(iconBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        iconBtn.adjustsImageWhenHighlighted = NO;
        //目前点击公司图标是没有跳转的，以后有跳转需求的话，可以改这里
        iconBtn.userInteractionEnabled = NO;
        
        //公司名字Label
        UILabel *companyName = [[UILabel alloc] init];
        self.companyName = companyName;
        companyName.text = @"华为";
        companyName.font = [UIFont systemFontOfSize:12];
        [self addSubview:companyName];
        
        //加关注按钮
//        UIButton *addCareBtn = [[UIButton alloc] init];
//        self.addCareBtn = addCareBtn;
//        
//        
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"+ 关注" attributes:dict];
//        [addCareBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        
//        
////        [addCareBtn setTitle:@"+关注" forState:UIControlStateNormal];
////        [addCareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [addCareBtn setBackgroundColor:SMColor(178, 0, 30)];
//        addCareBtn.layer.cornerRadius = SMCornerRadios;
//        addCareBtn.clipsToBounds = YES;
//        [addCareBtn addTarget:self action:@selector(addCareBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:addCareBtn];
        
        //公司描述label
        UILabel *companyInfoLabel = [[UILabel alloc] init];
//        companyInfoLabel.backgroundColor = [UIColor greenColor];
        companyInfoLabel.font = [UIFont systemFontOfSize:9];
        companyInfoLabel.text = @"     作为全球领先的信息与通信解决方案供应商，我们为点心运营商，企业和消费者提供有竞争力的点到点ICT解决方案和服务，帮助客户在数字社会获得成功";
        companyInfoLabel.numberOfLines = 0;
        self.companyInfoLabel = companyInfoLabel;
        [self addSubview:companyInfoLabel];
        //添加手式
        companyInfoLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [companyInfoLabel addGestureRecognizer:tap];
        
        
        //下面的横线
        UILabel *horizontalLine = [[UILabel alloc] init];
        horizontalLine.backgroundColor = SMColor(183, 184, 186);
        [self addSubview:horizontalLine];
        self.horizontalLine = horizontalLine;
        horizontalLine.alpha = 0.6;
        
    }
    return self;
}

- (void)tapClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"companyHouseTapClick" object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-self.marginUnder);
        make.width.equalTo(@119);
    }];
    
    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(self.marginTop);
        make.left.equalTo(self.iconBtn.mas_right).with.offset(self.marginMid);
//        make.bottom.equalTo(self.mas_bottom).with.offset(10);
        make.height.equalTo(@21);
    }];
    
//    [self.addCareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(self.mas_right).with.offset(-self.marginRight);
//        make.top.equalTo(self.mas_top).with.offset(self.marginTop);
//        make.width.equalTo(@38);
//        make.height.equalTo(@16);
//    }];
    
    [self.companyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconBtn.mas_right).with.offset(self.marginMid);
        make.top.equalTo(self.companyName.mas_bottom).with.offset(self.marginTop);
        make.right.equalTo(self.mas_right).with.offset(-self.marginRight);
        make.bottom.equalTo(self.mas_bottom).with.offset(-(self.marginUnder + self.marginUnder));
    }];
    
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconBtn.mas_right).with.offset(self.marginMid);
        make.right.equalTo(self.mas_right).with.offset(-self.marginRight);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.height.equalTo(@1);
    }];
    
    
}

- (void)addCareBtnDidClick:(UIButton *)btn{
    SMLog(@"点击了 添加关注 按钮");
    //添加关注
    [self followCompany];
}

- (void)iconBtnDidClick:(UIButton *)btn{
    SMLog(@"点击了 企业图标 按钮");
}

-(void)followCompany
{
    SMLog(@"%@",[NSString stringWithFormat:@"%@",self.Id]);
    [[SKAPI shared] followCompany:[NSString stringWithFormat:@"%@",self.Id] andType:1 block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"%@",result);
            if ([result[@"message"] isEqualToString:@"success"]) {
                SMLog(@"%@",result);
                [self showAlertViewWithMessage:@"关注成功"];
                [self hideAlertView];
            }else
            {
                [self showAlertViewWithMessage:@"关注失败"];
                [self hideAlertView];
            }
        }else
        {
            SMLog(@"%@",error);
            [self showAlertViewWithMessage:@"关注失败"];
            [self hideAlertView];
        }

    }];
    
}

-(void)showAlertViewWithMessage:(NSString *)message{
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alertView show];
}
-(void)hideAlertView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    });
    
}
@end
