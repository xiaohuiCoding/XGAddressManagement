//
//  TXSJCommonModel.m
//  retail
//
//  Created by 虞振兴 on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJCommonModel.h"

@implementation TXSJCommonModel
/////子类中要想能从json只直接解析成model，那么就实现下面的这个方法，并且把属性中和服务器对不上的字段写在下面dic中
//+ (NSDictionary *)modelCustomPropertyMapper {
//    ///名字相同的可以不用出现在下面dic中，名字想同的可以不用写
//    return @{
//             };
//}

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content {
    self = [super init];
    _titleStr = title;
    _subContentStr = content;
    return self;
}

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content  picUrl:(NSString *)picUrl{
    self = [super init];
    _titleStr = title;
    _subContentStr = content;
    _picUrl = picUrl;
    return self;
}

-(instancetype)initWithTitle:(NSString *)title subContent:(NSString *)content latitude:(CGFloat)latitude longitude:(CGFloat)longitude province:(NSString *)province city:(NSString *)city area:(NSString *)area{
    self = [super init];
    _titleStr = title;
    _subContentStr = content;
    _latitude = latitude;
    _longitude = longitude;
    _province = province;
    _city = city;
    _area = area;
    return self;
}

//特殊处理一下  用户的收货地址  titleStr要显示 姓名加电话
-(NSString *)titleStr {
    if (!_titleStr) {
        _titleStr = @"";
    }
    return _titleStr;
}

@end
