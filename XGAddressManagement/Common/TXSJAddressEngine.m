//
//  TXSJAddressEngine.m
//  retail
//  地址管理处理
//  Created by 虞振兴 on 2017/9/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJAddressEngine.h"
#import "TXSJStoresModel.h"
#import "TXSJAddressModel.h"


@implementation TXSJAddressEngine
///获取单例
+ (instancetype)shareInstance {
    static TXSJAddressEngine *_sharedEngine = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedEngine = [[self alloc] init];
    });
    
    return _sharedEngine;
}


//是否在当前 门店范围内
-(BOOL)isInCurrentStoreRangeWithLatitude:(CGFloat)latitude  longitude:(CGFloat)longitude{
//    CLLocationCoordinate2D corItem = CLLocationCoordinate2DMake(latitude,longitude);
//    MAMapPoint point = MAMapPointForCoordinate(corItem);
//    BOOL isInRange = MAMapRectContainsPoint(TXSJCacheManager.storesModel.storeMapRect, point);
//    return isInRange;
  
  return YES;
}



@end
