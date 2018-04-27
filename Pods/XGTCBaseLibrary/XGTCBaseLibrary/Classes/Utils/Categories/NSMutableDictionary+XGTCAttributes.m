//
//  NSMutableDictionary+XGTCAttributes.m
//  tuchao
//
//  Created by ZJ-Jie on 2017/6/30.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import "NSMutableDictionary+XGTCAttributes.h"

@implementation NSMutableDictionary (XGTCAttributes)

- (NSMutableDictionary *(^)(CGFloat))xg_fontSize {
    return ^id(CGFloat fontSize) {
        [self setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
        return self;
    };
}

- (NSMutableDictionary *(^)(UIFont *))xg_font {
    return ^id(UIFont *font) {
        [self setValue:font forKey:NSFontAttributeName];
        return self;
    };
}

- (NSMutableDictionary *(^)(UIColor *))xg_color {
    return ^id(UIColor * color) {
        [self setValue:color forKey:NSForegroundColorAttributeName];
        return self;
    };
}

@end
