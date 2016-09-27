//
//  CustomerProductListCell.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@interface CustomerProductListCell : UICollectionViewCell
//@property (nonatomic,assign) CellSelectType selectType;/**< 选中属性 */
@property (nonatomic,strong) Product *cellData;/**< cellData */
-(void)cellSelect;
@end
