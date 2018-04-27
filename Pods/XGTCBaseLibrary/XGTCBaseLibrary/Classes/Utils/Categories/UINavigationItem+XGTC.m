//
//  UINavigationItem+XGTC.h
//  retail
//
//  Created by wangdf on 17-09-25.
//  Copyright (c) 2017年 apple. All rights reserved.
//

#import "UINavigationItem+XGTC.h"

@implementation UINavigationItem (XGTC)

- (UIBarButtonItem *)fixedSpaceItem:(CGFloat)spaceWidth {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = spaceWidth;
    return item;
}

- (UIBarButtonItem *)iOS7FixedSpaceItem {
    return [self fixedSpaceItem:-12];
}

- (void)xgtc_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    if (leftBarButtonItem) {
        [self xgtc_setLeftBarButtonItems:@[leftBarButtonItem]];
    }else{
        self.leftBarButtonItem = leftBarButtonItem;
    }
}

- (void)xgtc_setLeftBarButtonItems:(NSArray *)leftBarButtonItems {
    if (leftBarButtonItems.count > 0) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
        CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
        if (version < 11.0) {
            [items insertObject:[self iOS7FixedSpaceItem] atIndex:0];
        }
        
        self.leftBarButtonItems = items;
    }else {
        self.leftBarButtonItems = leftBarButtonItems;
    }
}

- (void)xgtc_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    if (rightBarButtonItem) {
        [self xgtc_setRightBarButtonItems:@[rightBarButtonItem]];
    }else{
        self.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)xgtc_setRightBarButtonItems:(NSArray *)rightBarButtonItems {
    if (rightBarButtonItems.count > 0) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonItems];
        CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
        if (version < 11.0) {
            [items insertObject:[self iOS7FixedSpaceItem] atIndex:0];
        }
        
        self.rightBarButtonItems = items;
    }else{
        self.rightBarButtonItems = rightBarButtonItems;
    }
}

@end
