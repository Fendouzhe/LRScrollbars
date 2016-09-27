//
//  fotterView.m
//  ShuangKuai-iOS
//
//  Created by 宇中 on 16/2/17.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "fotterView.h"
#import "LocalSearchHistory.h"
@interface fotterView ()
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;

@end
@implementation fotterView

- (void)awakeFromNib {
    // Initialization code
    
    self.clearBtn.layer.cornerRadius = 5;
    self.clearBtn.layer.masksToBounds = YES;
    
    self.clearBtn.layer.borderWidth = 0.5;
    self.clearBtn.layer.borderColor = [UIColor blackColor].CGColor;
}
- (IBAction)clearAction:(UIButton *)sender {
    SMLog(@"清除");
    //删除本地
    NSArray * array = [LocalSearchHistory MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    for (LocalSearchHistory * localHistory in array) {
        [localHistory MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    //刷新collectionView
    
    self.refreshCollection();
}

@end
