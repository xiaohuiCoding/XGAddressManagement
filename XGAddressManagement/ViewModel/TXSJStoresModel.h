//
//  TXSJStoresModel.h
//  retail
//
//  Created by wangdf on 2017/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//  门店信息

#import <XGTCBaseLibrary/XGTCBaseLibrary.h>
#import <MAMapKit/MAMapKit.h>

@interface TXSJStoresModel : XGTCBaseModel

///门店id
@property (nonatomic, assign) NSInteger storeId;
@property (nonatomic, assign) NSInteger storeName;
@property (nonatomic, assign) NSInteger storeLogo;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSString *poi;

//数据处理  画图使用的经纬度集合
@property (nonatomic,strong) NSArray *poiAreaArr;
@property (nonatomic,assign) MAMapRect storeMapRect;  //门店的 范围～～ 电子围栏
@end
