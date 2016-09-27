//
//  SMDataStationCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDataStationCell.h"
#import "SMDataStation.h"

@interface SMDataStationCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UISwitch *swichBtn;

@property (weak, nonatomic) IBOutlet UIView *topLine;//最上面的灰色横线

@end

@implementation SMDataStationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"dataStationCell";
    SMDataStationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMDataStationCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)setDataModel:(SMDataStation *)dataModel{
    _dataModel = dataModel;
    self.name.text = dataModel.name;
    [self.swichBtn setOn:dataModel.status.integerValue];
}

- (void)hideTopLine{
    self.topLine.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.swichBtn.onTintColor = KHomePageRed;
    
    [self.swichBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction{
    SMLog(@"switchAction");
    self.dataModel.status = [NSNumber numberWithInteger:self.swichBtn.isOn];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"KSwichBtnClickModelKey"] = self.dataModel;
    dict[@"KSwichBtnClickAtRowKey"] = [NSNumber numberWithInteger:self.atRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwichBtnClick" object:self userInfo:dict];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{

    SMLog(@"observeValueForKeyPath");
}



@end
