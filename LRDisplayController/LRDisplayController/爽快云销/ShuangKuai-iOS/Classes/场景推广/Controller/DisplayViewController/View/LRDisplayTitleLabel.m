//
//  LRDisplayTitleLabel.m
//  LRDisplayController
//
//  Created by 雷路荣 on 16/1/22.
//  Copyright © 2016年 leilurong. All rights reserved.
//

#import "LRDisplayTitleLabel.h"

#define BageTag 888

@interface LRDisplayTitleLabel()

//@property(nonatomic ,strong)UIImageView *imageView;
//
//@property(nonatomic ,strong)UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LRDisplayTitleLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
//        self.textAlignment = NSTextAlignmentCenter;
        
//        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-30)*0.5, 8, 30, 30)];
//        imageview.backgroundColor = [UIColor blueColor];
//        imageview.image = [UIImage imageNamed:@"tuiguang1"];
//        [self addSubview:imageview];
//        self.imageView = imageview;
//        
//        UILabel *label = [[UILabel alloc] init];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor blueColor];
//        [self addSubview:label];
//        self.titleLabel = label;
        
    }
    return self;
}

+ (instancetype)displayTitleLabel{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = KDefaultFont12Match;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_fillColor set];
    //绘制到当前label的宽度
    rect.size.width = rect.size.width * _progress;
    //向当前绘图环境所创建的内存中的label图片上填充一个矩形，绘制使用指定的混合模式。
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);//用于今日头条
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    //通知重绘,会自动调用(void)drawRect:(CGRect)rect方法
    [self setNeedsDisplay];
}

-(void)showBadge{
    
    [[self viewWithTag:BageTag] removeFromSuperview];
    //显示
    UILabel * badgeLable = [[UILabel alloc]init];
    badgeLable.backgroundColor = [UIColor whiteColor];
    badgeLable.tag = BageTag;
    CGFloat width = 8*KMatch;
    badgeLable.width = width;
    badgeLable.height = width;
    badgeLable.x = self.width - width-8*KMatch;
    badgeLable.y = 0 + 8*KMatch;

    badgeLable.layer.cornerRadius = width * 0.5;
    badgeLable.layer.masksToBounds = YES;
    badgeLable.layer.shouldRasterize = YES;
    [self addSubview:badgeLable];
}

-(void)removeBadge{
    UILabel * label = [self viewWithTag:BageTag];
    [label removeFromSuperview];
}

@end
