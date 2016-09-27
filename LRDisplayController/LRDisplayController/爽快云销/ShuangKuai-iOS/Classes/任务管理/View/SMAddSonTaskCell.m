//
//  SMAddSonTaskCell.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/7/4.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMAddSonTaskCell.h"
#import "SMSonTaskCell.h"
#import "SMSonTaskList.h"
#import "SMSonTaskListFrame.h"

@interface SMAddSonTaskCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UIView *grayView;/**<  */

@property (nonatomic ,strong)UIButton *bottomBtn;/**< 下面的小按钮  添加小任务 */

@property (nonatomic ,strong)UIView *mainView;/**< 装tableView的view */

@property (nonatomic ,strong)UITableView *tableView;/**<  */

@property (nonatomic ,strong)NSArray *arrListFames;/**< 装着模型frame    SMSonTaskListFrame  */

@end

@implementation SMAddSonTaskCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *Id = @"addSonTaskCell";
    SMAddSonTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[SMAddSonTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.grayView = [[UIView alloc] init];
        self.grayView.backgroundColor = KControllerBackGroundColor;
        [self.contentView addSubview:self.grayView];
        
        
        self.bottomBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.bottomBtn];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = KDefaultFontSmall;
        dict[NSForegroundColorAttributeName] = KRedColorLight;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"添加子任务" attributes:dict];
        [self.bottomBtn setAttributedTitle:str forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:@"smallRedAdd"] forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(addSonTaskAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        //装有tableview的view
        self.mainView = [[UIView alloc] init];
        [self.contentView addSubview:self.mainView];
        
        [self.mainView addSubview:self.tableView];
        
//        self.mainView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)addSonTaskAction{
    if ([self.delegate respondsToSelector:@selector(addSonTaskAction)]) {
        [self.delegate addSonTaskAction];
    }
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrListFames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMSonTaskCell *cell = [SMSonTaskCell cellWithTableView:tableView];
    cell.listF = self.arrListFames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSonTaskListFrame *frame = self.arrListFames[indexPath.row];
    SMLog(@"frame.cellHeight   heightForRowAtIndexPath  %f",frame.cellHeight);
    return frame.cellHeight;
    
//    return 80 *SMMatchHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fatherStatus != 0) { //父任务只有在草稿状态才可以修改子任务
        //要不要发个通知给
        SMLog(@"要不要发个通知弹个提示框出来？");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cannotUpdateSonTask1" object:self];
        
        return;
    }
    
    SMSonTaskList *sonList = self.arrSonLists[indexPath.row];
    SMLog(@"sonList.childSchedule.status   %zd",sonList.childSchedule.status);
    if (sonList.childSchedule.status != 0 && sonList.childSchedule.status != 1) {  // 子任务只有在草稿状态下，才允许编辑
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cannotUpdateSonTask2" object:self];
        return;
    }
    
    SMSonTaskListFrame *frame = self.arrListFames[indexPath.row];
    SMSonTaskList *list = frame.list;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KGotoSonTaskVcKey] = list;
    [[NSNotificationCenter defaultCenter] postNotificationName:KGotoSonTaskVc object:self userInfo:dict];
    
}

/**
 *  当提交一个编辑操作的时候调用
 *  只要实现了这个方法，那么向左滑动就会出现删除按钮，
 *  只有点击了删除按钮才会调用该方法
 *  @param editingStyle 编辑操作
 UITableViewCellEditingStyleDelete, 删除
 UITableViewCellEditingStyleInsert  插入
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        
        SMSonTaskList *list = self.arrSonLists[indexPath.row];
        
        if (self.fatherStatus == 2) { //如果主任务是已完成状态，不让删除
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cannotDeleteSonTask1" object:self];
            return;
        }else if (list.childSchedule.status == 2){  //如果子任务是已完成状态， 也不让删除
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cannotDeleteSonTask2" object:self];
            return;
        }
        
        
        [[SKAPI shared] deleteMission:list.childSchedule.id block:^(id result, NSError *error) {
            if (!error) {
                
                SMLog(@"result  %@",result);
                //移除这个模型，并重新赋值给数据源数组
//                NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.arrSonLists];
//                [arrM removeObject:list];
//                self.arrSonLists = (NSArray *)arrM;
//                
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
////                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishDeleteRefreshTableView" object:self];
            }else{
                SMLog(@"error  %@",error);
            }
        }];
        
        
//        [self.contacts removeObjectAtIndex:indexPath.row];
        
        
        // 刷新表格
        // 全局刷新，性能不好，要使用局部刷新
        //    [self.tableView reloadData];
        
        // reloadRowsAtIndexPaths:刷新前后，数组中元素个数和界面显示的行数不能变
        //    self.tableView reloadRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
        
        // 删除指定的行
        // 注意点：数组中删除的元素个数必须和界面上删除的行数一致
        
    }
}

/**
 *  告诉tableView第indexPath行要执行怎么操作
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 删除操作
    return UITableViewCellEditingStyleDelete;
}
/**
 *  返回删除按钮对应的标题文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(@5);
    }];
    
    NSNumber *btnHeight = [NSNumber numberWithFloat:30 *SMMatchHeight];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.equalTo(btnHeight);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.grayView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.bottomBtn.mas_top).with.offset(0);
    }];
    
    self.tableView.frame = self.mainView.bounds;
}

- (void)setArrSonLists:(NSArray *)arrSonLists{
    _arrSonLists = arrSonLists;
    
    self.arrListFames = [self getFrameModelFromeModel:arrSonLists];
    
//    CGFloat tableViewHeight = 0;
//    for (SMSonTaskListFrame *frame in self.arrListFames) {
//        
//        tableViewHeight += frame.cellHeight;
//    }
    
    
    [self.tableView reloadData];
    
}

- (NSArray *)getFrameModelFromeModel:(NSArray *)arrModel{
    
    NSMutableArray *frames = [NSMutableArray array];
    for (SMSonTaskList *list in arrModel) {
        SMSonTaskListFrame *listF = [[SMSonTaskListFrame alloc] init];
        listF.list = list;
        [frames addObject:listF];
    }
    return (NSArray *)frames;
}

#pragma mark -- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [UIColor yellowColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
