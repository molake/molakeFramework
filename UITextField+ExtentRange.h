//
//  UITextField+ExtentRange.h
//  HarlyKeyboard
//
//  Created by Harly on 15/5/12.
//  Copyright (c) 2015年 Harly. All rights reserved.
//
#import <UIKit/UIKit.h> 

@interface UITextField (ExtentRange)

- (NSRange) selectedRange;
- (NSInteger) selectedLocation;
- (void) setSelectedRange:(NSRange) range;

@end
