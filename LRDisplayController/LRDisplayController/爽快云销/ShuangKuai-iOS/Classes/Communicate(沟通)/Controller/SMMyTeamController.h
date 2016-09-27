//
//  SMMyTeamController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/4/6.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnIdArrayBlock)(NSArray * idArray);

@interface SMMyTeamController : UIViewController

// 1 是处于选择参与人员   2 处于日程详情点击参与人，来查看参与人员列表
@property(nonatomic,assign)NSInteger type;

//反传 id 的数组 的block
@property(nonatomic,strong)ReturnIdArrayBlock returnIdArrayBlock;

//初始化数组  ，如果是团队任务的修改状态  那么这个数组是有值的
@property(nonatomic,copy)NSArray * initialArray;
// 如果是从任务详情界面跳转过来 是可以看到所有参与人员的 其他人员就没有了 只显示参与人员
@property(nonatomic,copy)NSMutableArray * showArray;
@end
