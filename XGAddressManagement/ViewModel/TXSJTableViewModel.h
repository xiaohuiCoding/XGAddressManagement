//
//  TXSJTableViewModel.h
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJViewModel.h"

@interface TXSJTableViewModel : TXSJViewModel
/// The data source of table view.
@property (nonatomic, strong) NSMutableArray *dataSource;

/// The list of section titles to display in section index view.
@property (nonatomic, strong) NSMutableArray *sectionIndexTitles;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger perPage;

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) RACCommand *didSelectCommand;

@property (nonatomic, assign) NSInteger count;


//- (id)fetchLocalData;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;
@end
