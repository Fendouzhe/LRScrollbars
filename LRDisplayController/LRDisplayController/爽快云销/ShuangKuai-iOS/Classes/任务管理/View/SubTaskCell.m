//
//  SubTaskCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SubTaskCell.h"
#import "TaskUserCell.h"
#import "SubTaskViewModel.h"
#import "SMSonTask.h"
#import "SMParticipant.h"
#import "MLLinkLabel.h"

@interface SubTaskCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel *mainLabel;/**<  */
@property (nonatomic,strong) UILabel *introLabel;/**< 详情 */
@property (nonatomic,strong) UIButton *participantButton;/**< 不能点击的按钮，参与人与前面的按钮 */
//@property (nonatomic,strong) UICollectionView *collectionView;/**< 头像部分 */
@property (nonatomic,strong) SubTaskViewModel *cellData;/**<  */
@property (nonatomic,strong) NSArray *participantArray;/**<  */
@property (nonatomic,strong) UIView *backGroundColorView;/**< 背景 */
@property (nonatomic,strong) UIButton *statusButton;/**< 状态按钮 */
@property (nonatomic,strong) UIImageView *personsImageView;/**< 人物列表 */
@property (nonatomic,strong) MLLinkLabel *linkLabel;/**< 人物 */
@property (nonatomic,strong) UIImageView *deathLineImageView;/**< <#属性#> */
@property (nonatomic,strong) UILabel *deathLineLabel;/**< 截止时间 */
@property (nonatomic,strong) UIView *lineView;/**<  */
@end

@implementation SubTaskCell
//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setCellFrame];
}

-(void)setCellData:(SubTaskViewModel *)cellData WithParticipantArray:(NSArray *)participantArray{
    _cellData = cellData;
    SMLog(@"cellData.cellData.users = %@  cellData.cellData.complateStatus = %@",cellData.cellData.users,cellData.cellData.complateStatus);
    _participantArray = participantArray;
    [self setCellFrame];
    [self setCellValue];
//    [self.collectionView reloadData];
}

-(void)setCellValue{
//    self.mainLabel.text = self.cellData.cellData.title;
    self.mainLabel.text = [NSString stringWithFormat:@"子任务%ld",self.index.row + 1];
    self.introLabel.text = [NSString stringWithFormat:@"任务内容:%@",self.cellData.cellData.remark];
    /************   linkLabel赋值  ************/
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    //    [self addHeaderStr];
    //参与人
    [attributedText appendAttributedString:[self addHeaderStr]];
    
    for (int i = 0; i<self.participantArray.count; i++) {
        if (i>0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
        }
        SMParticipant *data = self.participantArray[i];
        [attributedText appendAttributedString:[self addNameAttributedStringWithModel:data]];
    }
    self.linkLabel.attributedText = attributedText;
    MJWeakSelf
    [self.linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        //        SMLog(@"%@",link.linkValue);
        if ([weakSelf.delegate respondsToSelector:@selector(clickNameWithUserID:)]) {
            [weakSelf.delegate clickNameWithUserID:link.linkValue];
        }
    }];
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[self.cellData.cellData.schTime integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    self.deathLineLabel.text = [NSString stringWithFormat:@"截止时间:%@",[formatter stringFromDate:date1]];
}

-(NSMutableAttributedString *)addHeaderStr{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"参与人:" attributes:@{NSForegroundColorAttributeName : KGrayColor}];
    return attString;
}

-(NSMutableAttributedString *)addNameAttributedStringWithModel:(SMParticipant *)task{
    
    NSString *text = task.name;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : task.id} range:[task.name  rangeOfString:task.name]];
    return attString;
}

-(void)setCellFrame{
    self.backGroundColorView.frame = self.cellData.backgroundFrame;
    [self lineView];
    self.mainLabel.frame = self.cellData.titleFrame;
    self.introLabel.frame = self.cellData.introFrame;
    self.personsImageView.frame = self.cellData.personsImageViewFrame;
    self.linkLabel.frame = self.cellData.linkLabelFrame;
    self.deathLineImageView.frame = self.cellData.deathLineImageViewFrame;
    self.deathLineLabel.frame = self.cellData.deathLineLabelFrame;
    self.statusButton.frame = self.cellData.statusButtonFrame;
//    self.participantButton.frame = self.cellData.participantButtonFrame;
//    self.collectionView.frame = self.cellData.collectionViewFrame;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    self.statusButton.hidden = YES;
    for (NSString *tempID in self.cellData.cellData.users ) {
        SMLog(@"userID = %@  tempID = %@",userID,tempID);
        if ([tempID isEqualToString:userID]) {
            self.statusButton.hidden = NO;
            break;
        }
    }
    SMLog(@"self.statusButton.hidden = %d self.cellData.cellData.complateStatus = %@ self.statusButton.frame = %@",self.statusButton.hidden,self.cellData.cellData.complateStatus,NSStringFromCGRect(self.statusButton.frame));
//    switch (self.cellData.cellData.status) {
//        case 0:
//        {
////            [self.statusButton setTitle:@"发布" forState:UIControlStateNormal];
////            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
////            self.statusButton.tag = 0;
//        }
//            break;
//        case 1:
//        {
//            self.statusButton.enabled = YES;
//            [self.statusButton setTitle:@"完成任务" forState:UIControlStateNormal];
//            [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.statusButton.backgroundColor = KRedColorLight;
//            self.statusButton.tag = 1;
//        }
//            break;
//        case 2:
//        {
//            self.statusButton.enabled = NO;
//            [self.statusButton setTitle:@"已完成" forState:UIControlStateNormal];
//            [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            self.statusButton.backgroundColor = SMColor(241, 241, 240);
//            self.statusButton.tag = 1;
//        }
//            break;
//        default:
//            break;
//    }
    
    [self.cellData.cellData.complateStatus enumerateObjectsUsingBlock:^(NSString *uerid, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([uerid isEqualToString:userID]) {
            self.statusButton.enabled = NO;
            [self.statusButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.statusButton.backgroundColor = SMColor(241, 241, 240);
            self.statusButton.tag = 1;
            *stop = YES;
        }else{
            if (idx == [self.cellData.cellData.complateStatus count]-1) {
            self.statusButton.enabled = YES;
            [self.statusButton setTitle:@"完成任务" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.statusButton.backgroundColor = KRedColorLight;
            self.statusButton.tag = 1;
            }
        }
    }];
    
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.participantArray.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    TaskUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskUserCell" forIndexPath:indexPath];
//    cell.user = self.participantArray[indexPath.row];
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(30,30);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

-(UIView *)backGroundColorView{
    if (_backGroundColorView == nil) {
        _backGroundColorView = [[UIView alloc] init];
        _backGroundColorView.backgroundColor = SMColor(241, 241, 240);
        [self.contentView addSubview:_backGroundColorView];
    }
    return _backGroundColorView;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.textColor = KRedColorLight;
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:11];
        }
        _mainLabel.font = font;
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)introLabel{
    if (_introLabel == nil) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.numberOfLines = 0;
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _introLabel.font = font;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}

-(UIButton *)participantButton{
    if (_participantButton == nil) {
        _participantButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_participantButton];
        [_participantButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_participantButton setTitle:@"参与人" forState:UIControlStateNormal];
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _participantButton.titleLabel.font = font;
        [_participantButton setImage:[UIImage imageNamed:@"canyuren"] forState:UIControlStateNormal];
    }
    return _participantButton;
}

//-(UICollectionView *)collectionView{
//    if (_collectionView == nil) {
//        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 5;
//        layout.minimumInteritemSpacing = 5;
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.scrollEnabled = NO;
////        _collectionView.backgroundColor = KGrayColorSeparatorLine;
//        [_collectionView registerClass:[TaskUserCell class] forCellWithReuseIdentifier:@"TaskUserCell"];
//        [self.contentView addSubview:_collectionView];
////        MJWeakSelf
////        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.edges.equalTo(weakSelf.contentView);
////        }];
//    }
//    return _collectionView;
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"SubTaskCell";
    SubTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SubTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(UIButton *)statusButton{
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _statusButton.layer.cornerRadius = SMCornerRadios;
        _statusButton.titleLabel.font = KDefaultFontMiddleMatch;
        [self.contentView addSubview:_statusButton];
    }
    return _statusButton;
}

-(void)statusButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(statusButtonClickWithStatus:withSonTaskID:)]) {
        [self.delegate statusButtonClickWithStatus:(int)btn.tag withSonTaskID:self.cellData.cellData.id];
    }
}

-(MLLinkLabel *)linkLabel{
    if (_linkLabel == nil) {
        _linkLabel = [[MLLinkLabel alloc] init];
        _linkLabel.numberOfLines = 0;
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _linkLabel.font = font;
        [self.contentView addSubview:_linkLabel];
    }
    return _linkLabel;
}

-(UIImageView *)personsImageView{
    if ( _personsImageView == nil) {
        _personsImageView = [[UIImageView alloc] init];
        _personsImageView.image = [UIImage imageNamed:@"canyuren"];
        [self.contentView addSubview:_personsImageView];
    }
    return _personsImageView;
}

-(UILabel *)deathLineLabel{
    if (_deathLineLabel == nil) {
        _deathLineLabel = [[UILabel alloc] init];
        _deathLineLabel.textColor = KGrayColor;
        _deathLineLabel.font = KDefaultFont;
        [self.contentView addSubview:_deathLineLabel];
    }
    return _deathLineLabel;
}

-(UIImageView *)deathLineImageView{
    if(_deathLineImageView == nil){
        _deathLineImageView = [[UIImageView alloc] init];
        _deathLineImageView.image = [UIImage imageNamed:@"shijian"];
        [self.contentView addSubview:_deathLineImageView];
    }
    return _deathLineImageView;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        [self.contentView addSubview:_lineView];
        _lineView.backgroundColor = KGrayColor;
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backGroundColorView);
            make.right.equalTo(self.backGroundColorView);
            make.bottom.equalTo(self.contentView).with.offset(-2);
            make.height.equalTo(@0.5);
        }];
    }
    return _lineView;
}

@end
