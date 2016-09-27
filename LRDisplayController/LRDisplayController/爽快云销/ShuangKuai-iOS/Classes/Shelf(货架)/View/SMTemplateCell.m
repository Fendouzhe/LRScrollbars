//
//  SMTemplateCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/12/8.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import "SMTemplateCell.h"
#import "SMShelfTemplateViewController.h"
#import "Favorites.h"

@interface SMTemplateCell ()


@end

@implementation SMTemplateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    SMLog(@"cellWithTableView");
    
    static NSString *ID = @"templateCell";
    SMTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMTemplateCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

//+ (instancetype)cellWithTableView:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath{
//    
//    static NSString *ID = @"templateCell";
//    SMTemplateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMTemplateCell" owner:nil options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return cell;
//}





- (void)awakeFromNib {
    self.colorView.layer.cornerRadius = SMCornerRadios;
    self.colorView.clipsToBounds = YES;
    self.backgroundColor = KControllerBackGroundColor;
    
    self.leftLabel.textColor = SMColor(241, 246, 244);
    
    [self.rightBtn setTitleColor:SMColor(241, 246, 244) forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:SMColor(241, 246, 244) forState:UIControlStateSelected];
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    SMLog(@"点击了 cell 的右边按钮   sender");
    if ([self.delegate respondsToSelector:@selector(rightBtnDidClick:)]) {
        [self.delegate rightBtnDidClick:sender];
    }
}

//点了模版管理
- (void)managerBtnClick{
    SMLog(@"managerBtnClick");
    self.colorView.transform = CGAffineTransformMakeTranslation(34, 0);
    
//    [self.contentView addSubview:self.gouBtn];
    if (!self.gouBtn) {
        UIButton *gouBtn = [[UIButton alloc] init];
        self.gouBtn = gouBtn;
        [self.contentView addSubview:gouBtn];
        [gouBtn setImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [gouBtn setImage:[UIImage imageNamed:@"honggou"] forState:UIControlStateSelected];
        gouBtn.contentMode = UIViewContentModeCenter;
        
        [gouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(2);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        [gouBtn addTarget:self action:@selector(gouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.favorate.gouIsSelected) {
            gouBtn.selected = YES;
        }else{
            gouBtn.selected = NO;
        }
        
    }else{
        self.gouBtn.hidden = NO;
        //这个代码是用来解决在点击模版管理之后，出现的左边勾勾重用错误的bug
        if (self.favorate.gouIsSelected) {
            self.gouBtn.selected = YES;
        }else{
            self.gouBtn.selected = NO;
        }
    }    
}



- (void)managerBtnClickAgain{
    self.gouBtn.selected = NO;
    self.gouBtn.hidden = YES;
//    [self.gouBtn removeFromSuperview];
//    self.gouBtn = nil;
    
    self.colorView.transform = CGAffineTransformMakeTranslation(0, 0);
    
}

- (void)setFavorate:(Favorites *)favorate{
    _favorate = favorate;
    NSString *name = [NSString stringWithFormat:@"%zd号专柜：%@",self.numOfShelf + 1,favorate.name];
    self.leftLabel.text = name;
    if (favorate.isMoveRight) {
        [self managerBtnClick];
    }else{
        [self managerBtnClickAgain];
    }
}

/**
 * cell左边的勾勾
 */
- (void)gouBtnClick:(UIButton *)btn{
    SMLog(@"点击了 勾勾 按钮");
    btn.selected = !btn.selected;
    
    self.favorate.gouIsSelected = btn.selected;
    
}

@end
