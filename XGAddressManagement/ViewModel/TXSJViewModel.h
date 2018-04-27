//
//  TXSJViewModel.h
//  retail
//
//  Created by 虞振兴 on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXSJViewModel : NSObject

 - (instancetype)initWithParams:(NSDictionary *)params;
/// The `params` parameter in `-initWithServices:params:` method.
@property (nonatomic, copy, readonly) NSDictionary *params;


@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

////是否 在 viewDidLoad里 就要调用网络请求
//@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

///
- (void)initialize;

@end
