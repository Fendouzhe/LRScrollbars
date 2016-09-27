//
//  SMProductClassesCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/2/1.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMProductClassesCell.h"
#import "skuSelected.h"

#define KOneRowNum 2
@interface SMProductClassesCell ()

/**
 *  一共有几个选项
 */
@property (nonatomic ,assign)NSInteger chooseCount;

@property (nonatomic ,strong)NSMutableArray *arrBtns;

@end

@implementation SMProductClassesCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andModel:(NSArray *)skuS{
    SMLog(@"cellWithTableView    SMProductClassesCell");
    static NSString *ID = @"productClassesCell";
    SMProductClassesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        //cell = [[SMProductClassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andModel:skuS];
        cell = [[SMProductClassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andModel:skuS];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.chooseCount = self.skuS.propList.count;
//        SMLog(@"self.skuS.propList.count  %zd",self.skuS.propList.count);
//        for (NSInteger i = 0; i < self.chooseCount; i++) {
//            UIButton *chooseBtn = [[UIButton alloc] init];
//            chooseBtn.tag = i;
//            
//            [chooseBtn setTitle:self.skuS.propList[i] forState:UIControlStateNormal];
//            chooseBtn.backgroundColor = [UIColor lightGrayColor];
//            [self.contentView addSubview:chooseBtn];
//            [self.arrBtns addObject:chooseBtn];
//        }
    }
    return self;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(skuSelected *)skuS{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.skuS = skuS;
//        self.chooseCount = self.skuS.propList.count;
//        SMLog(@"self.skuS.propList.count  %zd",self.skuS.propList.count);
//        for (NSInteger i = 0; i < self.chooseCount; i++) {
//            UIButton *chooseBtn = [[UIButton alloc] init];
//            chooseBtn.backgroundColor = SMColor(191, 191, 191);
//            
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[NSForegroundColorAttributeName] = [UIColor blackColor];
//            dict[NSFontAttributeName] = KDefaultFontSmall;
//            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.skuS.propList[i] attributes:dict];
//            [chooseBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//            chooseBtn.tag = i;
//            [self.contentView addSubview:chooseBtn];
//            [self.arrBtns addObject:chooseBtn];
//        }
//        
//        CGFloat margin = 5;
//        for (UIButton *btn in self.arrBtns) {
//            NSInteger atRow = btn.tag / KOneRowNum;
//            NSInteger atCol = btn.tag % KOneRowNum;
//            
//            CGFloat btnH = 30;
//            CGFloat btnW = (KScreenWidth - margin * (KOneRowNum - 1)) / KOneRowNum * 1.0;
//            CGFloat btnX = (btnW + margin) * atCol;
//            CGFloat btnY = (btnH + margin) * atRow;
//            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//            if (btn.tag == self.arrBtns.count - 1) {//最后一个
//                self.cellHeight =  CGRectGetMaxY(btn.frame);
//            }
//        }
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(NSArray *)skuS{
    
    for (UIView * view  in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self.arrBtns removeAllObjects];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.chooseCount = skuS.count;
        SMLog(@"self.skuS.propList.count  %zd",skuS.count);
        for (NSInteger i = 0; i < self.chooseCount; i++) {
            UIButton *chooseBtn = [[UIButton alloc] init];
            chooseBtn.backgroundColor = SMColor(191, 191, 191);

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSForegroundColorAttributeName] = [UIColor blackColor];
            dict[NSFontAttributeName] = KDefaultFontSmall;
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[skuS[i] name] attributes:dict];
            [chooseBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
            [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            chooseBtn.tag = i;
            [self.contentView addSubview:chooseBtn];
            [self.arrBtns addObject:chooseBtn];
        }

        CGFloat margin = 5;
        for (UIButton *btn in self.arrBtns) {
            NSInteger atRow = btn.tag / KOneRowNum;
            NSInteger atCol = btn.tag % KOneRowNum;

            CGFloat btnH = 30;
            CGFloat btnW = (KScreenWidth - margin * (KOneRowNum - 1)) / KOneRowNum * 1.0;
            CGFloat btnX = (btnW + margin) * atCol;
            CGFloat btnY = (btnH + margin) * atRow;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            if (btn.tag == self.arrBtns.count - 1) {//最后一个
                self.cellHeight =  CGRectGetMaxY(btn.frame);
            }
        }
    }
    return self;
}

-(void)chooseBtnClick:(UIButton *)btn{
    SMLog(@"点击了下面的子分类");
    //获取到tag  用来获取到数组的内容
    //获取到当前点击的模型
    Classify * classify = self.classifyArray[btn.tag];
    //获取到id 然后跳转 搜索出商品
    self.showblock(classify.id);
    
}
#pragma mark -- 懒加载
- (NSMutableArray *)arrBtns{
    if (_arrBtns == nil) {
        _arrBtns = [NSMutableArray array];
    }
    return _arrBtns;
}

@end
