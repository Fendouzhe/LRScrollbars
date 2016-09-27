//
//  EditCustomerController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCustomerControllerDelegate <NSObject>

@optional
-(void)selectTagArray:(NSArray *)selectArray;
@end


@interface EditCustomerController : UIViewController
@property (nonatomic,weak) id<EditCustomerControllerDelegate> delegate;/**<  */
@property (nonatomic,strong) NSArray *oldTagArray;/**< 旧标签 */
@end
