//
//  UIColor+HexString.m
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    return [self colorWithHexString:stringToConvert alpha:1.0f];
} /* colorWithHexString */

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSString * cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    return [self colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue
{
    return [self colorWithHexValue:hexValue alpha:1.0];
}

+ (UIColor *)yf_randomColor
{
    static NSArray *colors;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        colors = @[
                   [UIColor colorWithHexValue:0x666666],
                   [UIColor redColor],
                   [UIColor greenColor],
                   [UIColor yellowColor],
                   [UIColor colorWithHexValue:0x59c75b],
                   [UIColor colorWithHexValue:0x9361ce],
                   [UIColor colorWithHexValue:0x67c7d9]
                   ];
    });
    return colors[arc4random_uniform((uint32_t)[colors count])];
}

@end
