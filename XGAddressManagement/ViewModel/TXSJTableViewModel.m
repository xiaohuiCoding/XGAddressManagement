//
//  TXSJTableViewModel.m
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJTableViewModel.h"

@interface TXSJTableViewModel ()
 

@end


@implementation TXSJTableViewModel

- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.perPage = Per_Page_Size;
}


//- (id)fetchLocalData {
//    return nil;
//}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}



-(NSInteger)count {
    return self.dataSource.count;
}

-(NSString *)keyword {
    if (!_keyword) {
        _keyword = @"";
    }
    return _keyword;
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)sectionIndexTitles {
    if (!_sectionIndexTitles) {
        _sectionIndexTitles = [NSMutableArray array];
    }
    return _sectionIndexTitles;
}

@end
