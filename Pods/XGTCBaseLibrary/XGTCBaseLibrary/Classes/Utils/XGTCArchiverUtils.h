//
//  XGTCArchiverUtils.h
//  XGOA
//
//  Created by wangdf on 2017/4/17.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGTCArchiverUtils : NSObject
/**
 加载某路径下的Archiver对象
 */
+ (id)loadUnArchiverObject:(NSString *)savePath;

/**
 用保存Archiver方式保存数据
 */
+ (BOOL)saveArchiverObject:(id) object savePath:(NSString *)savePath;

@end
