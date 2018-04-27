//
//  TXSJAddressEngine.h
//  retail
//  地址管理处理
//  Created by 虞振兴 on 2017/9/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface TXSJAddressEngine : NSObject 
///获取单例
+ (instancetype)shareInstance;

//是否在当前 门店范围内
-(BOOL)isInCurrentStoreRangeWithLatitude:(CGFloat)latitude  longitude:(CGFloat)longitude;

@end
