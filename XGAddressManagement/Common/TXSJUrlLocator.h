//
//  TXSJUrlLocator.h
//  aidaojia
//
//  Created by yufan on 16/7/12.
//  Copyright © 2016年 Yi Dao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TXSJUrlLocator <NSObject>

@optional

/**
 *  进入页面是否需要登录
 *
 *  @return <#return value description#>
 */
+ (BOOL)needLogin;

/**
 *  实现本方法，则使用url对应的参数构造页面
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithParams:(NSDictionary *)queryParams;


@end
