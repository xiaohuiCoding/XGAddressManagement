//
//  UIColor+HexString.h
//  Shark
//
//  Created by Connect King on 11-11-15.
//  Copyright 2011年 alpha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue;
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)yf_randomColor;


@end
