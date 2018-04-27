//
//  XGOALocalPathUtils.h
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XGTCLocalPathUtils.h>

@interface TXSJLocalPathUtils : XGTCLocalPathUtils
//用户的经纬度保存
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

+ (instancetype)shareInstance;

 #pragma --mark instance method
///用户文件夹
//- (NSString *)userDocumentPathWithUserId:(NSString *)userId;

///app deocument 目录
- (NSString *)filePathUnderDocumentWithFileName:(NSString *)fileName;

//首页各屏数据存储路径
- (NSString *)getHomeIndexListStoragePath;
//首页各屏数据存储路径V1.1版本
- (NSString *)getHomeIndexListStoragePathV11;
//首页各栏目数据存储路径
- (NSString *)getHomeMenuListStoragePath;
///最后登录用户信息存储路径
- (NSString *)getAccountsStoragePath;
//购物车数据存储路径
- (NSString *)getGoodsCartStoragePath;
//购物车网络数据缓存
- (NSString *)getGoodsCartNetworksStoragePath;
//数据库时间戳
- (NSString *)timeStamp;

@end
