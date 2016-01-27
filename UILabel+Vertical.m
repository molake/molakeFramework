//
//  UILabel+Vertical.m
//  MLK
//
//  Created by RenChao on 12/22/15.
//  Copyright © 2015 Accenture. All rights reserved.
//

#import "UILabel+Vertical.h"

@implementation UILabel(Vertical)

- (void)setTextVertical:(NSString*)text maxHeight:(NSUInteger)maxHeight
{
    self.text = text;
    self.numberOfLines = 0;
    NSInteger length = [text length];
    CGFloat fontSize = self.font.pointSize;
    CGFloat height = fontSize *(CGFloat)length;
    if (height > maxHeight && maxHeight >0)
    {
        height = maxHeight;
    }
    
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}

@end
