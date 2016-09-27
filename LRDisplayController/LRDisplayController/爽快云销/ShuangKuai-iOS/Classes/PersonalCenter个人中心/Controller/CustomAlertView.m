//
//  CustomAlertView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/3/22.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()<UITextViewDelegate>

@property (nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UIView * View;

@end
@implementation CustomAlertView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    //灰色的蒙版
    self.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.4];
    //整体view的高度
    CGFloat height = 0.0;
    //textView 的高度
    CGFloat textHeight = 0.0;
    //按钮的高度
    CGFloat BtnHeight  =0.0;
    
    if (isIPhone5) {
        height = 180;
        textHeight = 80;
        BtnHeight = 44;
    }else if(isIPhone6){
        height = 180*KMatch6Height;
        textHeight = 80 * KMatch6Height;
        BtnHeight = 44 * KMatch6Height;
    }else{
        height = 180*KMatch6pHeight;
        textHeight = 80*KMatch6pHeight;
        BtnHeight = 44*KMatch6pHeight;
    }
    
    UIView * view = [[UIView alloc]init];
    self.View = view;
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
    //view.center = self.center;
    
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
        make.width.with.offset(KScreenWidth-50);
        make.height.with.offset(height);
    }];
    
    //上面添加控件
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"意见反馈";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(0);
        make.top.equalTo(view.mas_top).with.offset(5);
        make.width.with.offset(KScreenWidth-50);
    }];
    
    UILabel * messageLable = [[UILabel alloc]init];
    messageLable.text = @"请输入您的意见,我们将尽快解决!";
    messageLable.textColor = [UIColor blackColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.font = KDefaultFontSmall;
    [view addSubview:messageLable];
    
    [messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(0);
        make.top.equalTo(label.mas_bottom).with.offset(5);
        make.width.with.offset(KScreenWidth-50);
    }];
    
    UITextView * textView = [[UITextView alloc]init];
    self.textView = textView;
    self.textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    textView.selectedRange = NSMakeRange(0, 4);
    textView.text = @"请输入您的意见...";
    textView.textColor = SMColor(107, 107, 107);

    [self addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(10);
        make.right.equalTo(view.mas_right).with.offset(-10);
        make.top.equalTo(messageLable.mas_bottom).with.offset(5);
        make.height.with.offset(textHeight);
    }];
    
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.alpha = 0.5;
    [self addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(0);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.bottom.equalTo(view.mas_bottom).with.offset(-BtnHeight);
        make.height.equalTo(@0.5);
    }];
    
    UILabel * midlineLabel = [[UILabel alloc]init];
    midlineLabel.backgroundColor = [UIColor grayColor];
    midlineLabel.alpha = 0.5;
    [self addSubview:midlineLabel];
    
    [midlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.bottom.equalTo(view.mas_bottom).with.offset(0);
        make.width.equalTo(@0.5);
        make.height.with.offset(BtnHeight);
    }];
    //按钮
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:SMColor(0, 80, 255) forState:UIControlStateNormal];
//    cancelBtn.layer.borderWidth = 0.5;
//    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.clipsToBounds = YES;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(0);
        make.bottom.equalTo(view.mas_bottom).with.offset(0);
        make.width.with.offset((KScreenWidth-50)/2);
        make.height.with.offset(BtnHeight);
    }];
    
    UIButton * retainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [retainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [retainBtn setTitleColor:SMColor(0, 80, 255) forState:UIControlStateNormal];
    retainBtn.layer.masksToBounds = YES;
//    retainBtn.layer.borderWidth = 0.5;
//    retainBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    retainBtn.clipsToBounds = YES;
    [retainBtn addTarget:self action:@selector(retainBtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:retainBtn];
    
    [retainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(0);
        make.bottom.equalTo(view.mas_bottom).with.offset(0);
        make.width.with.offset((KScreenWidth-50)/2);
        make.height.with.offset(BtnHeight);
    }];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow ;

    [window addSubview:self];
    
    return self;
}

-(void)cancelBtnClick:(UIButton *)btn{
    [self removeFromSuperview];
    
    //self.canelblock();
}

-(void)retainBtnClick:(UIButton *)btn{
    [self removeFromSuperview];
    
    self.retainblock(self.textView.text);
    //执行上传代码
}

#pragma mark -  textViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //键盘弹起  改变frame
    
    [self.View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(-100);
        make.width.with.offset(KScreenWidth-50);
        make.height.equalTo(@180);
    }];
    
    if ([textView.text isEqualToString:@"请输入您的意见..."]) {
        textView.text = nil;
        textView.textColor = SMColor(107, 107, 107);
    }else{
        //不清空
        
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    //输入完成
    if ([textView.text isEqualToString:@""]) {
        //等于空
        //设置成提示的内容
        textView.text = @"请输入您的意见...";
        textView.textColor = SMColor(107, 107, 107);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        self.retainblock(textView.text);
        [self.textView resignFirstResponder];
        [self removeFromSuperview];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
@end
