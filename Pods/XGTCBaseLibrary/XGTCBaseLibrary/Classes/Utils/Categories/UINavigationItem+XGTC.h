//
//  UINavigationItem+XGTC.h
//  retail
//
//  Created by wangdf on 17-09-25.
//  Copyright (c) 2017年 apple. All rights reserved.
//  ios7~ios10改变navBaritem往前面加个负的偏移item就能达到效果，但ios11改变了navBar的view层级，所以此方法无效，目前先通过重写navigationVC去改变ios11新加的view的autolayout属性

#import <UIKit/UIKit.h>

@interface UINavigationItem (XGTC)

- (void)xgtc_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)xgtc_setLeftBarButtonItems:(NSArray *)leftBarButtonItems;
- (void)xgtc_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)xgtc_setRightBarButtonItems:(NSArray *)rightBarButtonItems;



@end
