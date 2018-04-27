//
//  NSMutableAttributedString+XGTCCreateAttributedString.h
//  tuchao
//
//  Created by ZJ-Jie on 2017/6/30.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+XGTCAttributes.h"

@interface NSMutableAttributedString (XGTCCreateAttributedString)

+ (NSMutableAttributedString *)xg_makeAttributeString:(NSString *)string Attribute:(void(^)(NSMutableDictionary * attributes))block;

-(NSMutableAttributedString *)xg_makeAttributeStringAdd:(NSString *)string Attribute:(void(^)(NSMutableDictionary * attributes))block;

@end
