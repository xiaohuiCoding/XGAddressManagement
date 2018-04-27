//
//  TXSJLocationItemViewModel.m
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJCommonItemViewModel.h"
#import "TXSJAddressEngine.h"

@implementation TXSJCommonItemViewModel
- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super initWithParams:params];
    if (self) {
        self.type = [params[@"type"] unsignedIntegerValue];
    }
    return self;
}

-(void)initialize {
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^(NSIndexPath *indexPath) {
        @strongify(self)
        switch (self.type) {
            case TXSJCommonCellTypeUserLocation: {
                
                break;
            }
            default:{
                break;
            }
        }
        
        return [RACSignal empty];
    }];
}


@end
