//
//  XGOALocalPathUtils.m
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "TXSJLocalPathUtils.h"
//#import "TXSJAPIGenerate.h"

@implementation TXSJLocalPathUtils

+ (instancetype)shareInstance {
    static TXSJLocalPathUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TXSJLocalPathUtils alloc] init];
    });

    return instance;
}

#pragma --mark instance method
///用户文件夹
//- (NSString *)userDocumentPathWithUserId:(NSString *)userId {
//    ///简单处理，缓存的信息跟环境有关系
//    NSInteger env = [TXSJAPIGenerate shareInstance].environmentType;
//    if (userId.length > 0) {
//        return [[self class] documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts_%ld/%@", (long)env, userId]];
//    }
//
//    return [[self class] documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts_%ld/%@", (long)env, @"Guest"]];
//}

///app deocument 目录
- (NSString *)filePathUnderDocumentWithFileName:(NSString *)fileName {

    NSString *filePath = [[[self class] documentDirectoryPathWithName:nil] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)differenceEnvFilePathUnderDocumentWithFileName:(NSString *)fileName {
    ///简单处理，缓存的信息跟环境有关系
//    NSInteger env = [TXSJAPIGenerate shareInstance].environmentType;
//    NSString *newFileName = [NSString stringWithFormat:@"%@_%ld", fileName, (long)env];
//    return [self filePathUnderDocumentWithFileName:newFileName];
  
  return @"xxx";
}

///最后登录用户信息存储路径
- (NSString *)getAccountsStoragePath {
    NSString *filePath = [self filePathUnderDocumentWithFileName:@"account"];
    return filePath;
}
//购物车数据存储路径
- (NSString *)getGoodsCartStoragePath {
    NSString *filePath = [self differenceEnvFilePathUnderDocumentWithFileName:@"goodsCart"];
    return filePath;
}
//购物车网络数据缓存
- (NSString *)getGoodsCartNetworksStoragePath {
    NSString *filePath = [self differenceEnvFilePathUnderDocumentWithFileName:@"goodsCartNetworks"];
    return filePath;
}
//首页各屏数据存储路径
- (NSString *)getHomeIndexListStoragePath {
    NSString *filePath = [self differenceEnvFilePathUnderDocumentWithFileName:@"homeIndexList"];
    return filePath;
}
//首页各屏数据存储路径V1.1版本
- (NSString *)getHomeIndexListStoragePathV11 {
    NSString *filePath = [self differenceEnvFilePathUnderDocumentWithFileName:@"homeIndexListV11"];
    return filePath;
}
//首页各屏数据存储路径
- (NSString *)getHomeMenuListStoragePath {
    NSString *filePath = [self differenceEnvFilePathUnderDocumentWithFileName:@"homeMenuListSavePath"];
    return filePath;
}

//数据库时间戳
- (NSString *)timeStamp {
    return [self differenceEnvFilePathUnderDocumentWithFileName:@"timeStamp"];
}
@end
