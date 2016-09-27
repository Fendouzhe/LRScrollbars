//
//  SMCounterProductCollectCellNew.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/8/23.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMNewProduct;

typedef NS_ENUM(NSUInteger, SMCollectionViewType){
    SMCollectionViewTypeNormal,
    SMCollectionViewTypeAdd,
};

//@protocol SMCounterProductCollectCellNewDelegate <NSObject>
//
//
//
//@end

@interface SMCounterProductCollectCellNew : UICollectionViewCell

//@property (nonatomic ,weak)id<SMCounterProductCollectCellNewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *gouBtn;

@property (weak, nonatomic) IBOutlet UIImageView *productIcon;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic,assign)SMCollectionViewType cellType;/**< cell类型 */

@property (nonatomic ,strong)SMNewProduct *product;

@end
