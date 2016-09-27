//
//  SMSuperSalerCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSuperSalerCell.h"
#import "SMSuperManShowView.h"

@interface SMSuperSalerCell ()

@property (nonatomic ,strong)UIView *topView;
/**
 *  销售达人
 */
@property (nonatomic ,strong)UILabel *superSaler;
/**
 *  达人榜
 */
@property (nonatomic ,strong)UIButton *superMans;
/**
 *  下面放置照片的整体View
 */
@property (nonatomic ,strong)UIView *bottomView;
/**
 *  第1张照片
 */
@property (nonatomic ,strong)SMSuperManShowView *firstPic;
/**
 *  第2张照片
 */
@property (nonatomic ,strong)SMSuperManShowView *secondPic;
/**
 *  第3张照片
 */
@property (nonatomic ,strong)SMSuperManShowView *thirdPic;


@property (nonatomic ,strong)UIView *grayViewBottom;



@end

@implementation SMSuperSalerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"superSalerCell";
    SMSuperSalerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SMSuperSalerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        cell.layer.shadowOffset = CGSizeMake(0,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        cell.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        cell.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor blueColor];
        
        //1,上半部分view 里面放“销售达人” 和 “达人榜”
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        self.topView = topView;
        
        //销售达人
        UILabel *superSaler = [[UILabel alloc] init];
        superSaler.text = @"销售达人";
        superSaler.font = [UIFont systemFontOfSize:15];
        self.superSaler = superSaler;
        [topView addSubview:superSaler];
        
        //达人榜按钮
        UIButton *superMans = [[UIButton alloc] init];
        [topView addSubview:superMans];
        self.superMans = superMans;
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSFontAttributeName] = KDefaultFont;
//        dict[NSForegroundColorAttributeName] = KRedColor;
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"达人榜" attributes:dict];
//        [superMans setAttributedTitle:str forState:UIControlStateNormal];
        [superMans setImage:[UIImage imageNamed:@"paihangbang"] forState:UIControlStateNormal];
        [superMans addTarget:self action:@selector(superMansClick) forControlEvents:UIControlEventTouchUpInside];
        
        //2,下部分 装3张图片的view
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        self.bottomView = bottomView;
//        bottomView.backgroundColor = [UIColor yellowColor];
        
        //第一张照片
        SMSuperManShowView *firstPic = [SMSuperManShowView superManShowView];
        [bottomView addSubview:firstPic];
        self.firstPic = firstPic;
        firstPic.bgImage = [UIImage imageNamed:@"发现（新）今日"];
        firstPic.flag = 0;
        
        //第二张
        SMSuperManShowView *secondPic = [SMSuperManShowView superManShowView];
        [bottomView addSubview:secondPic];
        self.secondPic = secondPic;
        secondPic.bgImage = [UIImage imageNamed:@"发现（新）本周"];
        secondPic.flag = 1;
        
        //第三张
        SMSuperManShowView *thirdPic = [SMSuperManShowView superManShowView];
        [bottomView addSubview:thirdPic];
        self.thirdPic = thirdPic;
        thirdPic.bgImage = [UIImage imageNamed:@"发现（新）本月"];
        thirdPic.flag = 2;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat marginLeft = 15;
    
    //上半部分整体
    CGFloat topViewH;
    if (isIPhone5 ||isIPhone4) {
        topViewH = 30;
    }else if (isIPhone6){
        topViewH = 30 * isIPhone6;
    }else if (isIPhone6p){
        topViewH = 30 * isIPhone6p;
    }
    self.topView.frame = CGRectMake(0, 0, KScreenWidth, topViewH);
    
    //销售达人
    [self.superSaler mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).with.offset(margin);
    }];
    
    //达人榜
    [self.superMans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).with.offset(-margin);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
    
    //下半部分整体
    CGFloat bottomViewH;
    if (isIPhone5 || isIPhone4) {
        bottomViewH = 120;
    }else if (isIPhone6){
        bottomViewH = 145 *isIPhone6;
    }else if (isIPhone6p){
        bottomViewH = 175 *isIPhone6p;
    }
    self.bottomView.frame = CGRectMake(0, topViewH + 10 * SMMatchHeight, KScreenWidth, bottomViewH);
    
    //第一张
    CGFloat picW = (KScreenWidth - margin * 2 - marginLeft *2) / 3.0;
    self.firstPic.frame = CGRectMake(marginLeft, 0, picW, bottomViewH);
    
    //第二张
    self.secondPic.frame = CGRectMake(marginLeft + picW + margin, 0, picW, bottomViewH);
    
    //第三张
    CGFloat thirdX = marginLeft + margin *2 + picW *2;
    self.thirdPic.frame = CGRectMake(thirdX, 0, picW, bottomViewH);
    

}


-(void)setDatasArray:(NSMutableArray *)datasArray
{
    _datasArray = datasArray;
    //SMLog(@"%@",datasArray);
    if (datasArray.count>0) {
        self.firstPic.user = self.datasArray[0];
        self.secondPic.user = self.datasArray[1];
        self.thirdPic.user = self.datasArray[2];
    }

}

#pragma mark -- 点击事件
- (void)superMansClick{
    if ([self.delegate respondsToSelector:@selector(superMansDidClick)]) {
        [self.delegate superMansDidClick];
    }
}

@end
