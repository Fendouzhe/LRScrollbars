//
//  SMDiscoverViewController.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 16/1/25.
//  Copyright © 2016年 com.shuangkuaimai. All rights reserved.
//

#import "SMDiscoverViewController.h"
#import "AppDelegate.h"
@interface SMDiscoverViewController ()

@end

@implementation SMDiscoverViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate * application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    application.notesViewController = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KControllerBackGroundColor;
}



@end
