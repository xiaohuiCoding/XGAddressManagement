//
//  NSMutableDictionary+XGTCAttributes.h
//  tuchao
//
//  Created by ZJ-Jie on 2017/6/30.
//  Copyright © 2017年 TuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableDictionary (XGTCAttributes)

- (NSMutableDictionary *(^)(CGFloat))xg_fontSize;
- (NSMutableDictionary *(^)(UIFont *))xg_font;
- (NSMutableDictionary *(^)(UIColor *))xg_color;

@end
