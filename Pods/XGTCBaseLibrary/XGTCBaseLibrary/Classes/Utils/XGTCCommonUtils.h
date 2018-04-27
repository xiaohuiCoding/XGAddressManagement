//
//  XGTCCommonUtils.h
//  XGOA
//
//  Created by wangdf on 2017/4/19.
//  Copyright © 2017年 XGHL. All rights reserved.
//  这个utils存放所有与界面不相关的公共方法

#import <Foundation/Foundation.h>

@interface XGTCCommonUtils : NSObject

///获取设备idfa,如果获取不到就获取idfv
+ (NSString *)getIDFA;

/**
 *  设备版本信息
 */
+ (NSString*)deviceVersion;

@end
