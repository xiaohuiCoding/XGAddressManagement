//
//  TXSJAddressModel.h
//  retail
//  地址
//  Created by 虞振兴 on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <XGTCBaseModel.h>

@interface TXSJPOIDataModel : XGTCBaseModel
@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,strong) NSString *poiName;
@end

@interface TXSJAddressModel : XGTCBaseModel <NSMutableCopying>
@property (nonatomic,assign) NSInteger shippingId;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;//详情地址 （示例：486号）
@property (nonatomic,strong) NSString *street; //街道 （示例：阡陌路智慧e谷）
@property (nonatomic,strong) NSString *poidata; // 经纬度
@property (nonatomic,strong) NSString *province;//省
@property (nonatomic,strong) NSString *city;//城市
@property (nonatomic,strong) NSString *area;//区域

@property (nonatomic,strong) NSString *infoAddress;//拼接省市区及street和address
//无门牌号等信息的 地址 用于地址编辑使用
@property (nonatomic,strong) NSString *infoAddressWithNoNumber;
@end
