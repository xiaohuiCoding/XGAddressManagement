//
//  TXSJLocationItemViewModel.h
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJViewModel.h"
#import "TXSJCommonModel.h"

@interface TXSJCommonItemViewModel : TXSJViewModel
@property (nonatomic,assign) TXSJCommonCellType type;
@property (nonatomic,strong) TXSJCommonModel *data;

@property (nonatomic,assign) BOOL isInStoreRange;//用于  是否在范围内～～ 

@property (nonatomic, strong) RACCommand *didSelectCommand;

@end
