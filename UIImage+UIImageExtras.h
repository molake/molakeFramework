//
//  UIImage+UIImageExtras.h
//  MLK
//
//  Created by molake on 15/12/7.
//  Copyright © 2015年 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExtras)
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (UIImage *)clipFromView: (UIView *) theView;

+(UIImage *)clipFromView:(UIView *)theView andFrame:(CGRect)rect;

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
@end
