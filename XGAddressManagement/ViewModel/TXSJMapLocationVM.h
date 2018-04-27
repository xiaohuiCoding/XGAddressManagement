//
//  TXSJMapLocationVM.h
//  retail
//  对应 TXSJMapSelectLocationVC
//  Created by 虞振兴 on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJTableViewModel.h"
//#import "TXSJCommomCell.h"
//#import "TXSJAddressEngine.h"
#import "TXSJSelectLocationViewModel.h"
 

@interface TXSJMapLocationVM : TXSJSelectLocationViewModel

@property (nonatomic,strong) NSString *rightTopTitleStr;//右上角 文字～～  新增地址  或者 是 空     
@end
