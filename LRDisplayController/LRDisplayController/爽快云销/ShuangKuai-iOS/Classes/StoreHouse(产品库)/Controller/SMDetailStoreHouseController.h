//
//  SMDetailStoreHouseController.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/25.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMDetailStoreHouseController : UITableViewController

@property (nonatomic ,strong)NSMutableArray *arrProductIDs;


/**
 *  添加到微货架时  货架的id
 */
@property (nonatomic ,copy)NSString *favID;

@property (nonatomic ,strong)Product *product;

@property (nonatomic ,copy)NSString *productID;

@end
