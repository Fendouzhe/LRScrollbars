//
//  SMCompanyView.m
//  ShuangKuai-iOS
//
//  Created by yuzhongkeji on 15/11/10.
//  Copyright © 2015年 com.shuangkuaimai. All rights reserved.
//
//推荐企业的view
#import "SMCompanyView.h"
#import <UIButton+WebCache.h>
#import <MagicalRecord/MagicalRecord.h>
#import "LocalCompany+CoreDataProperties.h"
#import "Reachability.h"


//#define OnePageImageNum 3
#define TotalImageNum 6

@interface SMCompanyView ()<UIScrollViewDelegate>

//图片之间的距离
@property (nonatomic ,assign)CGFloat margin;
/**
 *  当前scrollView 显示的第几页
 */
@property (nonatomic ,assign)NSInteger currentPage;

@property (nonatomic ,strong)NSMutableArray *arrImageStrs;

/**
 *  用于检查网络
 */
@property (nonatomic ,strong)Reachability *reach;

@property(nonatomic,assign)NSInteger isOnLine;


@end

@implementation SMCompanyView


-(NSMutableArray *)arrImageStrs
{
    if (!_arrImageStrs) {
        _arrImageStrs = [NSMutableArray array];
    }
    return _arrImageStrs;
}
//- (NSMutableArray *)arrImageStrs{
//    SMLog(@"arrImageStrs 懒加载");
//    
//    if (_arrImageStrs == nil) {
//        _arrImageStrs = [NSMutableArray array];
//         SMLog(@"进来了");
////        [[SKAPI shared] queryCompanyByName:@"" isRecommend:NULL andPage:1 andSize:6 block:^(NSArray *array, NSError *error) {
////            SMLog(@"----------  %@",array);
////            if (!error) {
////                SMLog(@"array  %@",array);
////                for (Company *c in array) {
////                    SMLog(@"%@", c.name);
////                    SMLog(@"%@", c.logoPath);
////                }
//////                for (int i = 0; i < TotalImageNum; i++) {
//////                    NSString *imageStr = [array[i] logoPath];
//////                    [_arrImageStrs addObject:@""];
//////                }
////                SMLog(@"self.arrImageStrs    %@",self.arrImageStrs);
////            }else{
////                //SMLog(@"%@",error);
////            }
////        }];
//        
//        
//        
//       
//    }
//    return _arrImageStrs;
//}

+ (instancetype)companyView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KControllerBackGroundColor;
        self.margin = 10;

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 设置滚动范围
        scrollView.contentSize = CGSizeMake(KScreenWidth * 2, 0);
        // 隐藏水平滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        
        self.scrollView = scrollView;
        
        [self addSubview:scrollView];
    }
    [self requestData];
    //[self loadSandbox];
    return self;
}

-(void)setupBtn
{
    
    CGFloat btnWith = (KScreenWidth - (self.margin * (OneRowImageViewNum + 1))) / OneRowImageViewNum;
    CGFloat btnheight = btnWith;
    
    //self.arrImageStrs = [NSMutableArray array];
    
    /**
     *  检查网络
     */
    //        self.reach = [Reachability reachabilityWithHostName:@"baidu.com"];
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    //        [self.reach startNotifier];
    
    //延迟创建按钮，这个方法不好
   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < TotalImageNum; i++) {
            
            UIButton *companyBtn = [[UIButton alloc] init];
            
            if (self.arrImageStrs.count>0) {
                
            //[companyBtn sd_setBackgroundImageWithURL:self.arrImageStrs[i] forState:UIControlStateNormal];
    
                [companyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.arrImageStrs[i]] forState:UIControlStateNormal placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }else{
                SMLog(@"self.arrImageStrs 还没加载完成");
            }
            
            //                SMLog(@"%@",self.arrImageStrs);
            
            //            NSString *imageName = [NSString stringWithFormat:@"qiye%zd",i+1];
            //            [companyBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            CGFloat btnX = self.margin + (self.margin + btnWith) * i;
            companyBtn.frame = CGRectMake(btnX, 0, btnWith, btnheight);
            companyBtn.adjustsImageWhenHighlighted = NO;
            
            companyBtn.tag = i;
            [self.scrollView addSubview:companyBtn];
            [companyBtn addTarget:self action:@selector(companyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    //});
}
-(void)loadSandbox
{
    NSArray * array = [LocalCompany MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    for (LocalCompany * company in array) {
        [self.arrImageStrs addObject:company.logoPath];
    }
    
    [self setupBtn];
}

- (void)companyBtnDidClick:(UIButton *)btn{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[KCompanyClickButtonKey] = btn;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KCompanyClickNotificationName object:self userInfo:dict];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint offset = self.scrollView.contentOffset;
//    CGFloat scrollViewW = CGRectGetWidth(self.scrollView.frame);
//    if (offset.x > scrollViewW) {
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"careCompanyAdd" object:self];
//        self.currentPage = 2;
//        
//    }
//}

-(void)requestData
{
    [[SKAPI shared] queryCompanyByName:nil isRecommend:NULL andPage:1 andSize:TotalImageNum block:^(NSArray *array, NSError *error) {
        
        SMLog(@"queryCompanyByName");
        
        if (!error) {//获取成功
            if (self.arrImageStrs.count>0) {
                [self.arrImageStrs removeAllObjects];
            }
            for (LocalCompany * localModel in [LocalCompany MR_findAll]) {
                    [localModel MR_deleteEntity];
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            for (Company *company in array) {
                NSString *str = company.logoPath;
                if (str != nil) {
                    [self.arrImageStrs addObject:str];
                }
                
            }
            [self setupBtn];
            //保存下来
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
                for (Company * company in array) {
                    LocalCompany * localModel = [LocalCompany MR_createEntityInContext:localContext];
                    localModel.logoPath = company.logoPath;
                }
                
            } completion:^(BOOL contextDidSave, NSError *error) {
                
            }];
        }else{//获取失败
            NSArray * array = [LocalCompany MR_findAll];
            [self.arrImageStrs removeAllObjects];
            for (LocalCompany* model in array) {
                [self.arrImageStrs addObject:model.logoPath];
            }
            SMLog(@"%@",error);
        }
    }];
    //SMLog(@"count = %zd",[LocalCompany MR_findAll].count);
    //SMLog(@"imagearr%@",self.arrImageStrs);
}
#pragma mark - 判断网络状态
- (void)reachabilityChanged{
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
        {
            SMLog(@"没有联网");
            self.isOnLine = 0;
        }
            break;
        case ReachableViaWiFi:
        {
            SMLog(@"wifi上网");
            self.isOnLine = 1;

        }
            break;
        case ReachableViaWWAN:
            //手机上模拟才写的这段代码，后面可以删掉这句代码
        {
            SMLog(@"手机流量上网");
            self.isOnLine = 2;

        }
            break;
        default:
            break;
    }
    //[self requestData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
