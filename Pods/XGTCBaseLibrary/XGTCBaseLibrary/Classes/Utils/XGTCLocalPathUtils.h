//
//  XGOALocalPathUtils.h
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGTCLocalPathUtils : NSObject

+ (instancetype)shareInstance;

#pragma --mark class method
+ (BOOL)documentDirectoryPathIsExist:(NSString*)name;

+ (BOOL)createPathIfNecessary:(NSString*)path;

+ (NSString*)documentDirectoryPathWithName:(NSString*)name;

+ (NSString*)cacheDirectoryPathWithName:(NSString*)name;

///删除某目录下的文件
+ (void)removeFileAtPath:(NSString *)filePath error:(NSError **)error;

#pragma --mark instance method
///用户文件夹
- (NSString *)userDocumentPathWithUserId:(NSString *)userId;

///app deocument 目录
- (NSString *)filePathUnderDocumentWithFileName:(NSString *)fileName;

///最后登录用户信息存储路径
- (NSString *)getAccountsStoragePath;
//数据库时间戳
- (NSString *)timeStamp;

@end
