//
//  XGTCBaseModel
//
//  Created by wangdf on 2017/4/6.
//  Copyright © 2017年 XGHL. All rights reserved.
//

#import "XGTCBaseModel.h"
#import "NSObject+YYModel.h"

@implementation XGTCBaseModel

/////子类中要想能从json只直接解析成model，那么就实现下面的这个方法，并且把属性中和服务器对不上的字段写在下面dic中
//+ (NSDictionary *)modelCustomPropertyMapper {
//    ///名字相同的可以不用出现在下面dic中，名字想同的可以不用写
//    return @{
//             };
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}
    
- (void)encodeWithCoder:(NSCoder *)aCoder {
    return [self modelEncodeWithCoder:aCoder];
}


@end
