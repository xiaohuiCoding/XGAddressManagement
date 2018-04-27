//
//  NSMutableAttributedString+XGTCCreateAttributedString.m
//  tuchao
//
//  Created by ZJ-Jie on 2017/6/30.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import "NSMutableAttributedString+XGTCCreateAttributedString.h"

@implementation NSMutableAttributedString (XGTCCreateAttributedString)

+(NSMutableAttributedString *)xg_makeAttributeString:(NSString *)string Attribute:(void(^)(NSMutableDictionary * attributes))block{
    if (!string) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    block(attributes);
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return as;
}

-(NSMutableAttributedString *)xg_makeAttributeStringAdd:(NSString *)string Attribute:(void(^)(NSMutableDictionary * attributes))block{
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    block(attributes);
    if (string.length > 0) {
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
        [self appendAttributedString:as];
    }
    return self;
}

@end
