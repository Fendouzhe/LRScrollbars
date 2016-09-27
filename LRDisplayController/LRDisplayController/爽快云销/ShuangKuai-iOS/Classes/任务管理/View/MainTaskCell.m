//
//  MainTaskCell.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/7/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "MainTaskCell.h"
#import "TaskUserCell.h"
#import "TaskDetailMainViewFrame.h"
#import "SMFatherTask.h"
#import "MLLinkLabel.h"
#import "SMParticipant.h"

@interface MainTaskCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIImageView *iconImageView;/**< 头像 */
@property (nonatomic,strong) UILabel *nameLabel;/**< 标题 */
@property (nonatomic,strong) UILabel *timeLabel;/**< 时间 */
@property (nonatomic,strong) UILabel *mainLabel;/**< <#属性#> */
@property (nonatomic,strong) UILabel *introLabel;/**< 详情 */
@property (nonatomic,strong) UIImageView *deadlineImageView;/**< <#属性#> */
@property (nonatomic,strong) UILabel *deadlineLabel;/**< 截止时间 */
@property (nonatomic,strong) UIButton *participantButton;/**< 不能点击的按钮，参与人与前面的按钮 */
@property (nonatomic,strong) UICollectionView *collectionView;/**< 头像部分 */
@property (nonatomic,strong) TaskDetailMainViewFrame *cellData;/**< cellData */
@property (nonatomic,strong) NSArray *participantArray;/**<  */
@property (nonatomic,strong) UIButton *statusButton;/**< 状态按钮 */
@property (nonatomic,strong) UIImageView *personsImageView;/**< 人物列表 */
@property (nonatomic,strong) MLLinkLabel *linkLabel;/**< 人物 */
@end

@implementation MainTaskCell
//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
////        SMLog(@"%f,%f",self.alpha,self.contentView.alpha);
////        self.alpha = 0;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

-(void)setCellData:(TaskDetailMainViewFrame *)cellData WithParticipantArray:(NSArray *)participantArray{
    _cellData = cellData;
    _participantArray = participantArray;
    [self setCellValue];
    [self setCellFrame];
//    [self.collectionView reloadData];
}

-(void)setCellValue{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.cellData.cellData.uPortrait] placeholderImage:[UIImage imageNamed:@"220"]];
    self.nameLabel.text = self.cellData.cellData.uName;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[self.cellData.cellData.createAt integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:date1];
    self.mainLabel.text = self.cellData.cellData.title;
    self.introLabel.text = [NSString stringWithFormat:@"任务内容:%@",self.cellData.cellData.remark];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[self.cellData.cellData.schTime integerValue]];
    self.deadlineLabel.text = [NSString stringWithFormat:@"截止时间:%@",[formatter stringFromDate:date2]];
//    self.timeLabel.text = [self.cellData.cellData.createAt stringValue];
//    self.introLabel.text = self.cellData.cellData.remark;
//    self.deadlineLabel.text = [self.cellData.cellData.schTime stringValue];
    
    /************   linkLabel赋值  ************/
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
//    [self addHeaderStr];
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
        if ([weakSelf.delegate respondsToSelector:@selector(mainTaskCellclickNameWithUserID:)]) {
            [weakSelf.delegate mainTaskCellclickNameWithUserID:link.linkValue];
        }
    }];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    self.statusButton.hidden = NO;
    self.statusButton.enabled = YES;
    self.statusButton.backgroundColor = [UIColor whiteColor];
    [self.statusButton setTitleColor:KRedColorLight forState:UIControlStateNormal];
    
    if ([userID isEqualToString:self.cellData.cellData.userId]) {
        
        switch (self.cellData.cellData.status) {
            case 0:
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[NSFontAttributeName] = KDefaultFontBig;
                dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"发布任务" attributes:dict];
                [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateNormal];
//                [self.statusButton setTitle:@"发布任务" forState:UIControlStateNormal];
                [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.statusButton setBackgroundColor:KRedColorLight];
                self.statusButton.tag = 0;
                
            }
                break;
            case 1:
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[NSFontAttributeName] = KDefaultFontBig;
                dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"完成任务" attributes:dict];
                [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateNormal];
                
//                [self.statusButton setTitle:@"完成任务" forState:UIControlStateNormal];
//                [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.statusButton setBackgroundColor:KRedColorLight];
                self.statusButton.tag = 1;
            }
                break;
            case 2:
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[NSFontAttributeName] = KDefaultFontBig;
                dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
                NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"已完成" attributes:dict];
                [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateDisabled];
                
//                self.statusButton.userInteractionEnabled = NO;
                self.statusButton.enabled = NO;
//                [self.statusButton setTitle:@"已完成" forState:UIControlStateDisabled];
//                [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                self.statusButton.tag = 1;
            }
                break;
            default:
                break;
        }
    }else{
        if (self.cellData.cellData.sonTaskNumber) {
//            self.statusButton.hidden = YES;
            switch (self.cellData.cellData.status) {
                case 0:
                {
//                    [self.statusButton setTitle:@"发布" forState:UIControlStateNormal];
//                    [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                    self.statusButton.tag = 0;
                }
                    break;
                case 1:
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[NSFontAttributeName] = KDefaultFontBig;
                    dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
                    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict];
                    [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateNormal];
                    
//                    self.statusButton.userInteractionEnabled = NO;
                    [self.statusButton setTitle:@"未完成" forState:UIControlStateDisabled];
//                    [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                    self.statusButton.tag = 1;
                    self.statusButton.enabled = NO;
                }
                    break;
                case 2:
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[NSFontAttributeName] = KDefaultFontBig;
                    dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
                    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"已完成" attributes:dict];
                    [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateDisabled];
                    
//                    self.statusButton.userInteractionEnabled = NO;
//                    [self.statusButton setTitle:@"已完成" forState:UIControlStateDisabled];
//                    [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                    self.statusButton.tag = 1;
                    self.statusButton.enabled = NO;
                }
                    break;
                default:
                    break;
            }
        }else{
//            self.statusButton.hidden = NO;
            switch (self.cellData.cellData.status) {
                case 0:
                {
//                    [self.statusButton setTitle:@"发布" forState:UIControlStateNormal];
//                    [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//                    self.statusButton.tag = 0;
                }
                    break;
                case 1:
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[NSFontAttributeName] = KDefaultFontBig;
                    dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
                    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict];
                    [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateDisabled];
                    
//                    self.statusButton.userInteractionEnabled = NO;
//                    [self.statusButton setTitle:@"未完成" forState:UIControlStateDisabled];
//                    [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                    self.statusButton.tag = 1;
                    self.statusButton.enabled = NO;
                }
                    break;
                case 2:
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[NSFontAttributeName] = KDefaultFontBig;
                    dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
                    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"未完成" attributes:dict];
                    [self.statusButton setAttributedTitle:btnTitle forState:UIControlStateDisabled];
                    
                    
//                    self.statusButton.userInteractionEnabled = NO;
//                    [self.statusButton setTitle:@"已完成" forState:UIControlStateDisabled];
//                    [self.statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                    self.statusButton.tag = 1;
                    self.statusButton.enabled = NO;
                }
                    break;
                default:
                    break;
            }
        }
    }
    
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
    self.iconImageView.frame = self.cellData.iconImageViewFrame;
    self.nameLabel.frame = self.cellData.nameLabelFrame;
    self.timeLabel.frame = self.cellData.timeLabelFrame;
    self.mainLabel.frame = self.cellData.mainLabelFrame;
    self.introLabel.frame = self.cellData.introLabelFrame;
//    self.participantButton.frame = self.cellData.participantButtonFrame;
//    self.collectionView.frame = self.cellData.collectionViewFrame;
    self.deadlineImageView.frame = self.cellData.deadlineImageFrame;
    self.deadlineLabel.frame = self.cellData.deadlineLabelFrame;
    self.statusButton.frame = self.cellData.statusButtonFrame;
    self.personsImageView.frame = self.cellData.personsImageViewFrame;
    self.linkLabel.frame = self.cellData.linkLabelFrame;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.participantArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMLog(@"test");
    TaskUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskUserCell" forIndexPath:indexPath];
    cell.user = self.participantArray[indexPath.row];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30,30);
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        UIFont *font = KDefaultFontBig;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:16];
        }
        _nameLabel.font = KDefaultFontBig;
//        _nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = KDefaultFontSmall;
        _timeLabel.textColor = KGrayColor;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)mainLabel{
    if (_mainLabel == nil) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.font = KDefaultFontBig;
        [self.contentView addSubview:_mainLabel];
    }
    return _mainLabel;
}

-(UILabel *)introLabel{
    if (_introLabel == nil) {
        _introLabel = [[UILabel alloc] init];
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _introLabel.font = font;
        _introLabel.numberOfLines = 0;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}

-(UIImageView *)deadlineImageView{
    if (_deadlineImageView == nil) {
        _deadlineImageView = [[UIImageView alloc] init];
        _deadlineImageView.image = [UIImage imageNamed:@"shijian"];
        [self.contentView addSubview:_deadlineImageView];
    }
    return _deadlineImageView;
}

-(UILabel *)deadlineLabel{
    if (_deadlineLabel == nil) {
        _deadlineLabel = [[UILabel alloc] init];
        _deadlineLabel.textColor = KGrayColor;
        UIFont *font = KDefaultFont;
        if (isIPhone6p) {
            font = [UIFont systemFontOfSize:13];
        }
        _deadlineLabel.font = font;
        [self.contentView addSubview:_deadlineLabel];
    }
    return _deadlineLabel;
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

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[TaskUserCell class] forCellWithReuseIdentifier:@"TaskUserCell"];
        [self.contentView addSubview:_collectionView];
//        MJWeakSelf
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(weakSelf.contentView);
//        }];
    }
    return _collectionView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"MainTaskCell";
    MainTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MainTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(UIButton *)statusButton{
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.layer.cornerRadius = SMCornerRadios;
        _statusButton.layer.masksToBounds = YES;
        [_statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_statusButton];
    }
    return _statusButton;
}

-(void)statusButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(statusButtonClickWithStatus:)]) {
        [self.delegate statusButtonClickWithStatus:(int)btn.tag];
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

@end
