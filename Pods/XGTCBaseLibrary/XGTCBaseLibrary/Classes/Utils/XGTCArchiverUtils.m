//
//  XGTCArchiverUtils.m
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "XGTCArchiverUtils.h"
#import "XGTCLocalPathUtils.h"

@implementation XGTCArchiverUtils

/**
 加载某路径下的Archiver对象
 */
+ (id)loadUnArchiverObject:(NSString *)savePath {
    if (!savePath) {
        return nil;
    }

    NSData *serializedData  = [NSData dataWithContentsOfFile:savePath];
    if (!serializedData) {
        return nil;
    }

    return [NSKeyedUnarchiver unarchiveObjectWithData:serializedData];
}

/**
 用保存Archiver方式保存数据
 */
+ (BOOL)saveArchiverObject:(id) object savePath:(NSString *)savePath {
    if (!savePath) {
        return NO;
    }

    if (!object) {
        ///删除保存的文件, savePath为空
        [XGTCLocalPathUtils removeFileAtPath:savePath error:nil];
        return NO;
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    return [self saveData:data savePath:savePath];
}

/**
 写NSData对像到指定路径
 */
+ (BOOL)saveData:(NSData *)data savePath:(NSString *)savePath {
    if (!data) {
        ///删除保存的文件
        [XGTCLocalPathUtils removeFileAtPath:savePath error:nil];
        return NO;
    }

    BOOL result = [data writeToFile:savePath atomically:YES];
    if (!result) {
        NSLog(@" write to file failed %@",savePath);
        result = [data writeToFile:savePath atomically:NO];
        if (!result) {
            NSLog(@" write to file failed again %@",savePath);
        }
    }

    return result;
}

@end
