//
//  SMSection3Row1Cell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/28.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMSection3Row1Cell.h"
#import "skuSelected.h"

@interface SMSection3Row1Cell ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  左上角的标签
 */
@property (nonatomic ,strong)UILabel *leftTopLabel;
/**
 *  选项内容
 */
@property (nonatomic ,strong)NSMutableArray *arrChoose;

@property (nonatomic ,strong)NSMutableArray *arrBtns;

@property (nonatomic ,assign)NSInteger chooseCount;

@property (nonatomic,copy)NSMutableArray * dataArray;

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,assign)CGFloat lastHeight;

@property (nonatomic,assign)NSInteger selectRow;

@property (nonatomic ,strong)UIView *bottomGrayLine;

@property (nonatomic ,copy)NSString *num;

@end

@implementation SMSection3Row1Cell

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
         _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
//        self.collectionView.frame = CGRectMake(0, label.origin.y+20, KScreenWidth, KScreenHeight-label.origin.y-20);
//        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView andModel:(skuSelected *)SkuS{
    static NSString *ID = @"section3Row1Cell";
    SMSection3Row1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell.skuS = SkuS;
//        cell = [[SMSection3Row1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell = [[SMSection3Row1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andModel:SkuS];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SMLog(@"cell.skuS   %@",SkuS);

    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        //左上角的标签
//        UILabel *leftTopLabel = [[UILabel alloc] init];
//        [self.contentView addSubview:leftTopLabel];
//        self.leftTopLabel = leftTopLabel;
//        
//        //循环创建 选项
//        self.chooseCount = self.skuS.propList.count;
//        SMLog(@"self.skuS  %@",self.skuS);
//        for (NSInteger i = 0; i < self.chooseCount; i++) {
//            UIButton *chooseBtn = [[UIButton alloc] init];
//            [chooseBtn setBackgroundImage:[UIImage imageNamed:@"heikuang-1"] forState:UIControlStateNormal];
//            [chooseBtn setTitle:self.skuS.propList[i] forState:UIControlStateNormal];
//            chooseBtn.tag = i;
//            [self.contentView addSubview:chooseBtn];
//            [self.arrBtns addObject:chooseBtn];
//        }
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(skuSelected *)skuS{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.skuS = skuS;
//        //左上角的标签
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseThePhoneNum:) name:@"KChooseThePhoneNum" object:nil];
       
//
//        //循环创建 选项
//        self.chooseCount = self.skuS.propList.count;
//        SMLog(@"self.skuS.propList.count   %zd",self.skuS.propList.count);
//        SMLog(@"self.skuS  %@",self.skuS);
//        for (NSInteger i = 0; i < self.chooseCount; i++) {
//            UIButton *chooseBtn = [[UIButton alloc] init];
//            [chooseBtn setBackgroundImage:[UIImage imageNamed:@"heikuang-1"] forState:UIControlStateNormal];
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
//        CGFloat marginLeftTop = 10;
//        CGFloat marginMid = 15;
//        NSInteger oneRowNum = 3;
//        CGFloat btnW = (KScreenWidth - marginMid * (oneRowNum + 1)) / oneRowNum *1.0;
//        
//        //左上角的标签
//        [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.mas_top).with.offset(marginLeftTop);
//            make.left.equalTo(self.mas_left).with.offset(marginLeftTop);
//        }];
//        
//        //下面的选项按钮
//        for (UIButton *btn in self.arrBtns) {
//            NSInteger atRow = btn.tag / oneRowNum;
//            NSInteger atCol = btn.tag % oneRowNum;
//            
//            CGFloat btnH = 22;
//            CGFloat btnX = marginMid + (btnW + marginMid) * atCol;
//            //  CGRectGetMaxY(self.leftTopLabel.frame)  leftTopLabel约束只有两个 ，拿不到它的 frame
////            CGFloat btnY = CGRectGetMaxY(self.leftTopLabel.frame) + marginLeftTop + (btnH + marginLeftTop) * atRow;
//            CGFloat btnY = marginLeftTop + 15 + marginLeftTop + (btnH + marginLeftTop) * atRow;
//            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//            
//            if (btn.tag == self.arrBtns.count - 1) {//最后一个
//                
//                self.cellHeight = CGRectGetMaxY(btn.frame) + marginLeftTop;
//            }
//            
//        }
        
        
        //self.collectionView.frame = self.contentView.bounds;
        
       
        
//        [self layoutSubviews];
//        [self layoutSubviews];
//        [self layoutSubviews];
        
        
//        NSUInteger sectionCount = [self.collectionView numberOfSections];
//        if (sectionCount) {
//            
//            NSUInteger rowCount = [self.collectionView numberOfItemsInSection:0];
//            
//            if (rowCount) {
//                
//                NSUInteger ii[2] = {0, rowCount - 1};
//                NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
//                
//                 [self.collectionView cellForItemAtIndexPath:indexPath];
//            }
//        }
        
        
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        UICollectionViewCell * lastCell = [self.dataArray lastObject];
//        
//        self.cellHeight = lastCell.frame.origin.y;
//        
//        self.collectionView.frame = self.contentView.bounds;
//    });
    
    
    return self;
}

- (void)chooseThePhoneNum:(NSNotification *)noti{
    self.num = noti.userInfo[@"KChooseThePhoneNumKey"];
}

-(UILabel *)leftTopLabel{
    if (!_leftTopLabel) {
        _leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth, 21)];
        _leftTopLabel.font = KDefaultFontBig;
        _leftTopLabel.textColor = [UIColor blackColor];
    }
    return _leftTopLabel;
}

- (UIView *)bottomGrayLine{
    if (!_bottomGrayLine) {
        _bottomGrayLine = [[UIView alloc] init];
        _bottomGrayLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomGrayLine;
}

-(void)setSkuS:(skuSelected *)skuS{
    _skuS = skuS;
    //第一次进来的时候  默认选择了第一个item规格
    

    
    self.selectedStr = skuS.propList.lastObject;
    SMLog(@"skuS.propList.firstObject   %@  skuS.propList.lastObject  %@  ",skuS.propList.firstObject,skuS.propList.lastObject);
    
    [self.contentView addSubview:self.leftTopLabel];
    
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:skuS.propList.count - 1 inSection:0];
    [self.collectionView selectItemAtIndexPath:index animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    self.leftTopLabel.text = skuS.text;
   
    
    
    [self.arrBtns removeAllObjects];
    
    self.cellHeight = 0.0;
    
    CGSize lastsize = [self CalculateStringSize:[self.skuS.propList lastObject]];
    
    CGFloat height = lastsize.height+10;
    CGFloat width = 0.0;
    
    [self.contentView addSubview:self.collectionView];
    //循环创建 选项
    self.chooseCount = self.skuS.propList.count;
    
    for (NSInteger i = 0; i < self.chooseCount; i++) {
        
        [self.arrBtns addObject:self.skuS.propList[i]];
        
        CGSize size = [self CalculateStringSize:self.skuS.propList[self.skuS.propList.count-1-i]];
        
        width = width+size.width+10;
        
        if (width>KScreenWidth) {
            height += lastsize.height+10;
            width = size.width;
        }
    }
    
    [self.collectionView reloadData];
    
    self.cellHeight = height+25;
    
    self.collectionView.frame = CGRectMake(0, 25, KScreenWidth, height);
    
    self.lastHeight = height+25;
    
    [self.contentView addSubview:self.bottomGrayLine];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(selecteFirstItem)]) {
            [self.delegate selecteFirstItem];
        }
    });
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
//    CGSize lastsize = [self CalculateStringSize:[self.skuS.propList lastObject]];
//
//    CGFloat height = lastsize.height+10;
//    CGFloat width = 0.0;
//
//    for (NSInteger i = 0; i<self.skuS.propList.count; i++) {
//        
//        CGSize size = [self CalculateStringSize:self.skuS.propList[self.skuS.propList.count-1-i]];
//        
//        width = width+size.width+10;
//        
//        if (width>KScreenWidth) {
//            height += size.height+10;
//            width = size.width;
//        }
//    }
    
    self.leftTopLabel.frame = CGRectMake(10, 0, KScreenWidth, 21);
    
    self.cellHeight = self.lastHeight;
    
    self.collectionView.frame = CGRectMake(0, 25, KScreenWidth, self.lastHeight-25);
    
    [self.bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    SMLog(@"%f",self.cellHeight);
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    
//    CGFloat marginLeftTop = 10;
//    CGFloat marginMid = 20;
//    NSInteger oneRowNum = 3;
//    CGFloat btnW = (KScreenWidth - marginMid * (oneRowNum + 1)) / oneRowNum *1.0;
//    
//    //左上角的标签
//    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.mas_top).with.offset(marginLeftTop);
//        make.left.equalTo(self.mas_left).with.offset(marginLeftTop);
//    }];
//    
//    //下面的选项按钮
//    for (UIButton *btn in self.arrBtns) {
//        NSInteger atRow = btn.tag / oneRowNum;
//        NSInteger atCol = btn.tag % oneRowNum;
//        
//        CGFloat btnH = 22;
//        CGFloat btnX = marginMid + (btnW + marginMid) * atCol;
//        CGFloat btnY = CGRectGetMaxY(self.leftTopLabel.frame) + marginLeftTop + (btnH + marginLeftTop) * atRow;
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//        
//        if (btn.tag == self.arrBtns.count - 1) {//最后一个
//            
//            self.cellHeight = CGRectGetMaxY(btn.frame) + marginLeftTop;
//        }
//        
//    }
//}

#pragma mark - collection相关
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrBtns.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    CGSize size = [self CalculateStringSize:self.arrBtns[self.arrBtns.count-1-indexPath.row]];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.font = KDefaultFont;
    label.text = self.arrBtns[self.arrBtns.count-1-indexPath.row];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.tag = 10+indexPath.row;
    
    if (self.selectRow == indexPath.row) {
//        label.textColor = SMColor(180, 0, 27);
//        label.layer.borderColor = SMColor(180, 0, 27).CGColor;
        label.textColor = KRedColorLight;
        label.layer.borderColor = KRedColorLight.CGColor;
    }
    
    cell.backgroundView = label;
    
    [self.dataArray addObject:cell];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度按照计算得到
    
    CGSize size = [self CalculateStringSize:self.arrBtns[self.arrBtns.count-1-indexPath.row]];
    
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(KScreenWidth, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击之后变红
    //获取到Lable
    //记录点击row
    self.selectRow = indexPath.row;
    SMLog(@"self.isBelongCounter   %zd",self.isBelongCounter);
    if (self.isBelongCounter) {
        for (NSInteger i=0; i<self.arrBtns.count; i++) {
            UILabel * lable = [self viewWithTag:10+i];
            if (i==indexPath.row) {
//                lable.textColor = SMColor(180, 0, 27);
//                lable.layer.borderColor = SMColor(180, 0, 27).CGColor;
                lable.textColor = KRedColorLight;
                lable.layer.borderColor = KRedColorLight.CGColor;
            }else{
                lable.textColor = [UIColor blackColor];
                lable.layer.borderColor = [UIColor blackColor].CGColor;
            }
        }
    }
    
//    SMLog(@"self.arrBtns[self.arrBtns.count-1-indexPath.row]    %@",self.arrBtns[self.arrBtns.count-1-indexPath.row]);
    //记录到选中产品的规格 需等接口
    self.selectedStr = self.arrBtns[self.arrBtns.count-1-indexPath.row];
    SMLog(@" cell   self.selectedStr  选中规格  %@",self.selectedStr);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.num) {
        dict[@"KChooseThePhoneNumKey"] = self.num;
    }else{
        dict[@"KChooseThePhoneNumKey"] = @"";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KChooseThePhoneNum" object:nil userInfo:dict];   
}

#pragma mark -- 懒加载
-(NSMutableArray *)arrBtns{
    if (_arrBtns == nil) {
        _arrBtns = [NSMutableArray array];
    }
    return _arrBtns;
}

-(CGSize)CalculateStringSize:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KDefaultFont} context:nil].size;
    CGSize fullsize = CGSizeMake(size.width+10, size.height+20);
    
    return fullsize;
}

- (NSMutableArray *)arrChoose{
    if (_arrChoose == nil) {
        _arrChoose = [NSMutableArray array];
    }
    return _arrChoose;
}
@end
