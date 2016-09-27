//
//  SMDetailLogViewController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/17.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalCustomer+CoreDataProperties.h"
#import "LocalWorkLog+CoreDataProperties.h"

@interface SMDetailLogViewController : UIViewController

@property(nonatomic,strong)LocalCustomer* localCustomer;
@property(nonatomic,strong)LocalWorkLog * localworklog;


-(void)refreshUIWithLocalworklog:(LocalWorkLog*)localworklog andWithLocalCustomer:(LocalCustomer*)localCustomer
;
@end
