//
//  UIColor+HexExtension.m
//  MLK
//
//  Created by Harly on 15/6/19.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import "UIColor+HexExtension.h"

@implementation UIColor(HexExtension)

+(UIColor *) colorWithHex:( NSString *)hexColor
{
    unsigned int red=0, green=0, blue=0;
    
    NSRange range;
    
    range. length = 2 ;
    
    range. location = 0 ;
    
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    
    range. location = 2 ;
    
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    
    range. location = 4 ;
    
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
    
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}

@end
