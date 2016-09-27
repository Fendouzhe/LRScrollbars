//
//  ChatTopOfTableView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/16.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "ChatTopOfTableView.h"
#import "SMConnectPersonSection0.h"

@interface ChatTopOfTableView ()
@property (nonatomic,strong) NSArray *imageArray;/**< 图片数组 */
@property (nonatomic,strong) NSArray *strArray;/**< 文字数组 */
@end

@implementation ChatTopOfTableView
-(void)setWithImageArray:(NSArray *)imageArray withStrArray:(NSArray *)strArray{
    if (imageArray.count == strArray.count) {
        _imageArray = imageArray;
        _strArray = strArray;
        self.frame = CGRectMake(0, 0, KScreenWidth, imageArray.count*(41 *SMMatchHeight+10));
        
        MJWeakSelf
        for (int i = 0;i<imageArray.count;i++) {
            SMConnectPersonSection0 *view = [SMConnectPersonSection0 connectPersonSection0];
            [self addSubview:view];
            view.tag = i;
            [view setImage:imageArray[i] WithStr:strArray[i]];
//                [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(weakSelf).with.offset(i*(41 *SMMatchHeight+10));
//                    make.left.equalTo(weakSelf);
//                    make.right.equalTo(weakSelf);
//                    make.height.equalTo(@(41 *SMMatchHeight+10));
//                }];
//            view.frame = CGRectMake(0, 0, 100, 100);
            UIControl *control = [[UIControl alloc] init];
//            [control mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(view);
//            }];
            [self addSubview:control];
            [control addTarget:self action:@selector(chatTopOfTableViewClick:) forControlEvents:UIControlEventTouchUpInside];
            control.tag = i;
            
        }
        
    }
}

-(void)chatTopOfTableViewClick:(UIControl *)click{
//    SMLog(@"%@",NSStringFromClass(click));
    if ([self.delegate respondsToSelector:@selector(chatTopOfTableViewWithNumber:)]) {
        [self.delegate chatTopOfTableViewWithNumber:click.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    SMLog(@"%ld",self.subviews.count);
    for (int i = 0;i<self.subviews.count;i++) {
        
        if (i%2) {
            self.subviews[i].frame = CGRectMake(0, ((i-1)/2)*(41 *SMMatchHeight+10), KScreenWidth, 41 *SMMatchHeight+10);
        }else{
            
            self.subviews[i].frame = CGRectMake(0, (i/2)*(41 *SMMatchHeight+10), KScreenWidth, 41 *SMMatchHeight+10);
            
        }
        
    }
    
    SMLog(@"%@",self.subviews);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
