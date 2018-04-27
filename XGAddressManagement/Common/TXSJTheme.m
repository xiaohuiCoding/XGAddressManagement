//
//  ADJConfigModel.m
//  aidaojia
//
//  Created by yufan on 16/9/12.
//  Copyright © 2016年 Yi Dao. All rights reserved.
//

#import "TXSJTheme.h"

@implementation TXSJThemeColor

@end

@implementation TXSJThemeConfig

@end

@implementation TXSJTheme

+ (instancetype)sharedInstance {
    static TXSJTheme *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"json" ];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        instance = [TXSJTheme modelWithDictionary:dic];
    });
    return instance;
}

@end
