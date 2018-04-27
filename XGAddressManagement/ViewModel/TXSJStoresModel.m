//
//  TXSJStoresModel.m
//  retail
//
//  Created by wangdf on 2017/9/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJStoresModel.h"
#import "TXSJAddressModel.h"

@implementation TXSJStoresModel

-(instancetype)init{
    if (self = [super init]) {
        //先初始化这个
        _storeMapRect = MAMapRectMake(0, 0, 0, 0);
    }
    return self;
}

-(NSArray *)poiAreaArr{
    if (!_poiAreaArr) {
        _poiAreaArr = [NSArray array];
    }
    return _poiAreaArr;
}

//门店的 范围～～ 电子围栏
-(MAMapRect)storeMapRect {
    if (_storeMapRect.size.width==0) {
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(self.poiAreaArr.count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < self.poiAreaArr.count; i++){
            TXSJPOIDataModel *poiModel = self.poiAreaArr[i];
            coords[i].latitude = poiModel.latitude;
            coords[i].longitude = poiModel.longitude;
        }
        //构造多边形
        MAPolygon *pol = [MAPolygon polygonWithCoordinates:coords count:self.poiAreaArr.count];
        _storeMapRect = pol.boundingMapRect;
        free(coords);
    }
    return _storeMapRect;
}
@end
