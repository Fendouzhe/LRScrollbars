//
//  SelectProductListViewController.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectProductListViewControllerDelegate <NSObject>

@optional
-(void)chooseProduct:(NSArray *)selectArray;
@end

@interface SelectProductListViewController : UIViewController
@property (nonatomic,strong) NSArray *oldSelectArray;/**< 旧的选中商品ID数组,NSString */
@property (nonatomic,weak) id<SelectProductListViewControllerDelegate> delegate;/**<  */
@end
