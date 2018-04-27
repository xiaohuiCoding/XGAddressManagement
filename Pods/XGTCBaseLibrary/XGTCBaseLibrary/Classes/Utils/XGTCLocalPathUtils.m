//
//  XGOALocalPathUtils.m
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "XGTCLocalPathUtils.h"

@implementation XGTCLocalPathUtils

+ (instancetype)shareInstance {
    static XGTCLocalPathUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XGTCLocalPathUtils alloc] init];
    });

    return instance;
}

#pragma --mark class method
///判断目录是否存在
+ (BOOL)documentDirectoryPathIsExist:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];

    if(name != nil)
        path = [path stringByAppendingPathComponent:name];

    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

///创建路径文件夹
+ (BOOL)createPathIfNecessary:(NSString*)path {
    BOOL succeeded = YES;

    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }

    return succeeded;
}


///生成文档目录下路径
+ (NSString*)documentDirectoryPathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];

    if(name != nil)
        path = [path stringByAppendingPathComponent:name];

    [[self class] createPathIfNecessary:path];

    return path;
}

///缓存文件夹下文件路径
+ (NSString*)cacheDirectoryPathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachePath = [paths objectAtIndex:0];

    if(name != nil)
        cachePath = [cachePath stringByAppendingPathComponent:name];
    
    [[self class] createPathIfNecessary:cachePath];
    
    return cachePath;
}

+ (void)removeFileAtPath:(NSString *)filePath error:(NSError **)error {
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:error];
    }
}

#pragma --mark instance method
///用户文件夹
- (NSString *)userDocumentPathWithUserId:(NSString *)userId {
    if (userId.length > 0) {
        return [[self class] documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts/%@", userId]];
    }

    return [[self class] documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts/%@", @"Guest"]];
}

///app deocument 目录
- (NSString *)filePathUnderDocumentWithFileName:(NSString *)fileName {
    NSString *filePath = [[[self class] documentDirectoryPathWithName:nil] stringByAppendingPathComponent:fileName];
    return filePath;
}

///最后登录用户信息存储路径
- (NSString *)getAccountsStoragePath {
    NSString *filePath = [self filePathUnderDocumentWithFileName:@"account"];
    return filePath;
}

//数据库时间戳
- (NSString *)timeStamp {
    return [self filePathUnderDocumentWithFileName:@"timeStamp"];
}
@end
