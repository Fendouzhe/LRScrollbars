//
//  IntentionLevelViewController.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/27.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "IntentionLevelViewController.h"
#import "IntentionLevelCell.h"
#import "IntentionLevelModel.h"

@interface IntentionLevelViewController ()
@property (nonatomic,strong) NSArray *dataArray;/**<  */
@property (nonatomic,copy) NSString *selectText;/**< 选中选项 */
@end

@implementation IntentionLevelViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"意向购买等级";
    
    IntentionLevelModel *model01 = [[IntentionLevelModel alloc] init];
    model01.title = @"A";
    
    IntentionLevelModel *model02 = [[IntentionLevelModel alloc] init];
    model02.title = @"B";
    
    IntentionLevelModel *model03 = [[IntentionLevelModel alloc] init];
    model03.title = @"C";
    
    self.dataArray = @[model01,model02,model03];
    [self.tableView reloadData];
    

//    UIButton *rightBtn = [[UIButton alloc] init];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSFontAttributeName] = KDefaultFontBig;
//    dict[NSForegroundColorAttributeName] = KRedColorLight;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"确定" attributes:dict];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    rightBtn.width = 30;
//    rightBtn.height = 22;
//    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    self.view.backgroundColor = KControllerBackGroundColor;
}

-(void)rightItemClick{
    if (!self.selectText.length) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(chooseIntentionLevel:)]){
        [self.delegate chooseIntentionLevel:self.selectText];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntentionLevelCell *cell = [IntentionLevelCell cellWithTableView:tableView];
    cell.cellData = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectText = [self.dataArray[indexPath.row] title];
}

@end
