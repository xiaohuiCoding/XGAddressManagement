//
//  TXSJMapLocationVM.m
//  retail
//  ~~!1.1的改版 看样子似乎可以直接用TXSJSelectLocationViewModel  先这样吧  真稳定了再优化
//  Created by 虞振兴 on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJMapLocationVM.h"

//#import "TXSJLocalPathUtils.h"
//#import "TXSJCommonItemViewModel.h"
//#import "TXSJStoresModel.h"


@interface TXSJMapLocationVM()
@end


@implementation TXSJMapLocationVM

-(instancetype)initWithParams:(NSDictionary *)params {
    self = [super initWithParams:params];
    if (self) {
        self.rightTopTitleStr = params[@"rightTopTitleStr"] ;
    }
    return self;
}

-(void)initialize {
    [super initialize];
    //map页面使用  目前就是 定位成功 位置前 需要加个 [当前]
    self.isMapNeedShow = YES;
    
    //Map 分组 和 selectLoactionViewModel分组不同
    [self.sectionIndexTitles removeAllObjects];
    [self.dataSource removeAllObjects];
    
    //@"当前地址" 第一分组必有  可能是高度0  可能是 当前地址不在配送范围内，推荐您使用地址搜索
    [self.sectionIndexTitles addObject:@""];
    //定位数据源
    [self.dataSource addObject:[NSMutableArray array]];
    
    //附近地址分组 根据数据来 可能没
}
 


////重写 TXSJSelectLocationViewModel 的 locateAction
//- (RACSignal *)locateAction {
//    WEAKSELF(weakSelf);
//    RACSignal *actionSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        STRONGSELF(strongSelf);
//        //带逆地理的单次定位
//        [strongSelf.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//            STRONGSELF(strongSelf);
//            [strongSelf.dataSource[0] removeAllObjects];
//
//            TXSJCommonItemViewModel *firstModel = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":@(TXSJCommonCellTypeUserLocation)}];
//
//            firstModel.data = [[TXSJCommonModel alloc] initWithTitle:TXSJLocationFailGetPosition subContent:TXSJLocationFailRecommand latitude:0 longitude:0 province:@"" city:@"" area:@""];
//            firstModel.isInStoreRange = YES; //无法获取您的位置信息 ～～！要显示成在配送范围内的样式～～！字体黑色什么的
//
//            if (error) {
//                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//                //总之不管有没有error都要把firstModel 发送出去
//                //                if (error.code == AMapLocationErrorLocateFailed){
//                //                    return;
//                //                }
//            }
//            //定位信息
//            NSLog(@"location:%@", location);
//            //经纬度保存
//            [TXSJLocalPathUtils shareInstance].latitude = location.coordinate.latitude;
//            [TXSJLocalPathUtils shareInstance].longitude = location.coordinate.longitude;
//            //逆地理信息
//            if (regeocode) {
//                NSLog(@"reGeocode:%@", regeocode);
//                if (regeocode.POIName && ![regeocode.POIName isEmptyString]) {
//                    firstModel.data = [[TXSJCommonModel alloc] initWithTitle:[NSString stringWithFormat:@"[当前]%@",regeocode.POIName]  subContent:regeocode.formattedAddress latitude:location.coordinate.latitude longitude:location.coordinate.longitude province:regeocode.province city:regeocode.city area:regeocode.district];
//                    firstModel.isInStoreRange = [[TXSJAddressEngine shareInstance] isInCurrentStoreRangeWithLatitude:firstModel.data.latitude longitude:firstModel.data.longitude];
//                }
//            }
//            //当前地址  还是  不在范围内的 sectionTitle
//            strongSelf.sectionIndexTitles[0] = firstModel.isInStoreRange?@"":TXSJLocationNotInRangeAndRecommand;
//            [strongSelf.dataSource[0] addObject:firstModel];
//            [subscriber sendNext:firstModel];
//            [subscriber sendCompleted];
//        }];
//        return nil;
//    }];
//
//    return actionSignal;
//
//}

@end
