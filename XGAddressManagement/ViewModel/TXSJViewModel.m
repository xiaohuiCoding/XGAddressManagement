//
//  TXSJViewModel.m
//  retail
//
//  Created by 虞振兴 on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJViewModel.h"

@interface TXSJViewModel ()
 @property (nonatomic, copy, readwrite) NSDictionary *params;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation TXSJViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    TXSJViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(initWithParams:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel)
        [viewModel initialize];
    }];
    
    return viewModel;
}


- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = params;
    }
    
    return self;
}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
        [_errors.rac_willDeallocSignal subscribeCompleted:^{
            NSLog(@"###WDF ViewModel errors dealloc");
        }];
    }

    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal){
        _willDisappearSignal = [RACSubject subject];
        [_willDisappearSignal.rac_willDeallocSignal subscribeCompleted:^{
        NSLog(@"###WDF ViewModel willDisappearSignal dealloc");
    }];
}
    return _willDisappearSignal;
}

- (void)initialize {}

- (void)dealloc {
    if(_errors){
        [self.errors sendCompleted];
    }

    if (_willDisappearSignal) {
        [self.willDisappearSignal sendCompleted];
    }
    NSLog(@"####WDF %@ dealloced!", [self class]);
}


@end
