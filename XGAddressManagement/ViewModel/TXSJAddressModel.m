//
//  TXSJAddressModel.m
//  retail
//
//  Created by 虞振兴 on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJAddressModel.h"

@implementation TXSJPOIDataModel
+ (NSDictionary *)modelCustomPropertyMapper {
    ///名字相同的可以不用出现在下面dic中
    return @{
             @"longitude":@"lng",
             @"latitude":@"lat"
             };
}


//-(CGFloat)latitude{
//    if (_latitude>0) {
//        NSString *temp = [NSString stringWithFormat:@"%03.06f",_latitude];
//        _latitude = [temp floatValue];
//    }
//    return _latitude;
//}
//
//-(CGFloat)longitude {
//    if (_longitude>0) {
//        int temp = _longitude * 1000000;
//        _longitude = ((CGFloat)temp)/1000000.0f;
//    }
//    return _longitude;
//}

@end

@implementation TXSJAddressModel

-(id)mutableCopyWithZone:(NSZone *)zone {
    TXSJAddressModel *model = [[[self class] allocWithZone:zone] init] ;
    model.shippingId = self.shippingId;
    model.mobile  = self.mobile;
    model.name  = self.name;
    model.address  = self.address;
    model.area  = self.area;
    model.street  = self.street;
    model.poidata  = self.poidata;
    model.province  = self.province;
    model.city  = self.city;
    return model;
}

-(NSString *)area{
    if (!_area) {
        _area = @"";
    }
    return _area;
}

-(NSString *)address {
    if (!_address) {
        _address = @"";
    }
    return _address;
}

-(NSString *)mobile{
    if (!_mobile) {
        _mobile = @"";
    }
    return _mobile;
}

-(NSString *)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}

-(NSString *)province{
    if (!_province) {
        _province = @"";
    }
    return _province;
}

-(NSString *)city{
    if (!_city) {
        _city = @"";
    }
    return _city;
}

-(NSString *)street{
    if (!_street) {
        _street = @"";
    }
    return _street;
}

-(NSString *)infoAddress{
    if (!_infoAddress) {
        _infoAddress = [NSString stringWithFormat:@"%@%@%@%@%@",self.province,self.city,self.area,self.street,self.address];
    }
    return _infoAddress;
}

//无门牌号等信息的 地址 用于地址编辑使用
-(NSString *)infoAddressWithNoNumber{
    if (!_infoAddressWithNoNumber) {
        _infoAddressWithNoNumber = [NSString stringWithFormat:@"%@%@%@%@",self.province,self.city,self.area,self.street];
    }
    return _infoAddressWithNoNumber;
}

@end
