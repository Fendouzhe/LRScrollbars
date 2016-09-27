//
//  fotterView.h
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshCollection)(void);
@interface fotterView : UICollectionReusableView


@property(nonatomic,strong)RefreshCollection refreshCollection;

@end
