//
//  CustomerProductListHeaderView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/6/24.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerProductListHeaderViewDelegate <NSObject>

@optional
-(void)sequenceButtonClick:(NSInteger)number;
@end
@class RightImageButton;
@interface CustomerProductListHeaderView : UIView
@property (nonatomic,strong) RightImageButton *priceBtn;/**< 价格按钮 */
@property (nonatomic,strong) UIButton *productNewBtn;/**< 新品 */
@property (nonatomic,strong) UIButton *saleBtn;/**< 销量 */
@property (nonatomic,strong) RightImageButton *brokerageBtn;/**< 佣金 */
@property (nonatomic,weak) id<CustomerProductListHeaderViewDelegate> delegate;/**< 代理 */
-(void)setButtonClick:(NSInteger)number;
@property (nonatomic,strong) NSArray *startArray;/**< 初始字符串 */
@end
