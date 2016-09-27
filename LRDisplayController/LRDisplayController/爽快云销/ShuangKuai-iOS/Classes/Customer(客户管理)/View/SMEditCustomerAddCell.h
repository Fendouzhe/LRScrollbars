//
//  SMEditCustomerAddCell.h
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/6/21.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMEditCustomerAddCellDelegate <NSObject>

- (void)labelDidTap:(UITapGestureRecognizer *)tap;

- (void)removeTagDidTap:(UITapGestureRecognizer *)tap;

- (void)addOldTagDidTap:(UITapGestureRecognizer *)tap;

- (void)longPressDeleteAction:(UILongPressGestureRecognizer *)longPress;

@end

@interface SMEditCustomerAddCell : UICollectionViewCell

@property (nonatomic ,strong)UILabel *addLabel;/**< 添加 */

@property (nonatomic ,strong)Tag *tagModel;/**< <#注释#> */

@property (nonatomic ,copy)NSString *titleText;/**< <#注释#> */

@property (nonatomic ,weak)id<SMEditCustomerAddCellDelegate> delegate;/**< delegate */
//添加新标签
- (void)addGestureAddNewTag;
//移除标签
- (void)addGestureRemoveTag;

//添加已有的标签
- (void)addGestureAddOldTag;

- (void)addLongPressDeleteAction;


- (void)beComeRedBorderAndRedTextColorLabel;
- (void)beComeRedBorderAndBlackTextColorLabel;
- (void)becomeBlackBorderAndBlackTextColorLabel;

@end
