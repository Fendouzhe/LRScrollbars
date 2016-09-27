//
//  UITextView+Extention.m
//  
//
//  Created by iOS on 15/10/9.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "UITextView+Extention.h"

@implementation UITextView (Extention)

- (void)insertAttributeText:(NSAttributedString *)text{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    //拼接前面的文字
    [attributedText appendAttributedString:self.attributedText];
    
    //拼接图片
    NSUInteger loc = self.selectedRange.location;
    [attributedText insertAttributedString:text atIndex:loc];
    
    self.attributedText = attributedText;
    
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

@end
