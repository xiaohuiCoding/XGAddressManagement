//
//  TXSJSelectLocationViewModel.m
//  retail
//
//  Created by 虞振兴 on 2017/8/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJSelectLocationViewModel.h"
//#import "TXSJCommonItemViewModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
//#import <AFNetworking.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "TXSJLocalPathUtils.h"
//#import "TXSJCommomCell.h"
#import "TXSJAddressModel.h"
//#import "TXSJUserEngine.h"
//#import "TXSJNetworkEngine.h"
#import "TXSJAddressEngine.h"
#import "TXSJStoresModel.h"


@interface TXSJSelectLocationViewModel()

@end

@implementation TXSJSelectLocationViewModel {
    NSInteger sendAddressCount;//记录请求到的地址总数
}

-(void)initialize {
    //@"当前地址" 第一分组必有
    [self.sectionIndexTitles addObject:SelectionLocationSectionUserLocation];
    [self.sectionIndexTitles addObject:@""];//～～！给 更多地址单独分个组吧  免得各种判断附近地址有没有，排版等之类的问题
    
    self.selectLocationPage = 1;
    self.searchPage = 1;
    
    //定位数据源
    [self.dataSource addObject:[NSMutableArray array]];
    
    //lastModel  最后个数据源分组 放单独的 更多地址 cell
    TXSJCommonItemViewModel *lastModel = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":@(TXSJCommonCellTypeValue2)}];
    lastModel.data = [[TXSJCommonModel alloc] initWithTitle:@"更多地址" subContent:@"" latitude:0 longitude:0 province:@"" city:@"" area:@""];
    [self.dataSource addObject:[NSArray arrayWithObject:lastModel]];
    
    [self configLocationManager];
    //默认
    self.latitude = [TXSJLocalPathUtils shareInstance].latitude;
    self.longitude = [TXSJLocalPathUtils shareInstance].longitude;
    
    
}


//-(void)urlForMyAddressList {
//    BOOL isLogin = [TXSJCacheManager loginUserToken].length > 0;
//    if(!isLogin){
//        //未登录 需要个 登录的cell~~!无解
//        TXSJCommonItemViewModel *itemVM = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":@(TXSJCommonCellTypeGoLogin)}];
//        itemVM.data = [[TXSJCommonModel alloc] initWithTitle:@"登录后使用常用收货地址" subContent:@"" latitude:0 longitude:0 province:@"" city:@"" area:@""];
//        itemVM.isInStoreRange = NO;
//        [self.sendAddressArr addObject:itemVM];
//        [self updateSendAddressArr];
//        return;
//    }
//    WEAKSELF(weakSelf);
//    //网络请求
//    [[[TXSJUserEngine shippingAddressList:self.page] execute:@0] subscribeNext:^(NSArray *arr) {
//        STRONGSELF(strongSelf);
//        sendAddressCount = arr.count;//记录
//        [strongSelf.sendAddressArr removeAllObjects];
//        if(arr.count==0){//加了个 登录cell 可能会是 未登录（有 我的收货地址分组） -> 登录后（arr没数据，但是分组原先在，得隐藏）
//            [strongSelf updateSendAddressArr];
//        }
//        for (TXSJAddressModel *tempModel in arr ) {
//            [strongSelf updateSendAddressArrWithNewAddress:tempModel];
//        }
//        [strongSelf.refreshCommand execute:@0];
//    } error:^(NSError * _Nullable error) {
//        STRONGSELF(strongSelf);
//        [strongSelf.errors sendNext:error];
//    }] ;
//}


//根据 收获地址列表  修改数据源
-(void)updateSendAddressArrWithNewAddress:(TXSJAddressModel *)addressModel {
    TXSJPOIDataModel *poiData = [TXSJPOIDataModel modelWithJSON:addressModel.poidata];
    TXSJCommonModel *item = [[TXSJCommonModel alloc] initWithTitle:[NSString stringWithFormat:@"%@  %@",addressModel.name,addressModel.mobile]  subContent: addressModel.infoAddress   latitude:poiData.latitude longitude:poiData.longitude province:addressModel.province city:addressModel.city area:addressModel.area];
    item.poiName = poiData.poiName;
    TXSJCommonItemViewModel *itemVM = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":[NSNumber numberWithInt:TXSJCommonCellTypeDefault]}];
    itemVM.data = item;
    itemVM.isInStoreRange = [[TXSJAddressEngine shareInstance] isInCurrentStoreRangeWithLatitude:itemVM.data.latitude longitude:itemVM.data.longitude];
    [self.sendAddressArr addObject:itemVM];
    [self updateSendAddressArr];
}

//根据 收获地址列表  修改数据源
-(void)updateSendAddressArr{
    //没有收货地址 理论上 进这页面也就请求一次我的地址
    if (![self.sectionIndexTitles containsObject:SelectionLocationSectionSecond]) {
        [self.sectionIndexTitles insertObject:SelectionLocationSectionSecond atIndex:SelectionLocationSectionSecondIndex];
        [self.dataSource insertObject:self.sendAddressArr atIndex:SelectionLocationSectionSecondIndex];
    }else if([self.sectionIndexTitles containsObject:SelectionLocationSectionSecond] && self.sendAddressArr.count==0){ //有分组 但是没数据 需要删除
        [self.sectionIndexTitles removeObjectAtIndex:SelectionLocationSectionSecondIndex];
        [self.dataSource removeObjectAtIndex:SelectionLocationSectionSecondIndex];
    }else if(self.sendAddressArr.count>=sendAddressCount){
            //排序 sendAddressCount~~! 新增地址的话self.sendAddressArr.count 肯定大于sendAddressCount  不过新增每次只增加一个地址 逻辑上也通 不用再写sendAddressCount+1
            NSArray *sortArr = [self.sendAddressArr sortedArrayUsingComparator:^NSComparisonResult(TXSJCommonItemViewModel  * obj1, TXSJCommonItemViewModel  * obj2) {
                if (obj1.isInStoreRange && !obj2.isInStoreRange) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                if (!obj1.isInStoreRange && obj2.isInStoreRange) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
            self.dataSource[SelectionLocationSectionSecondIndex] = sortArr;
    }
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:8];
    
    [self.locationManager setReGeocodeTimeout:6];
    //检索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}


- (void)poiSearchAction {
    if(self.isSearching){
        [self searchPOIKey];
    }else{
        [self searchAround];
    }
}


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
//                [strongSelf updateStoreData:@""];
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
//                    firstModel.data = [[TXSJCommonModel alloc] initWithTitle:strongSelf.isMapNeedShow?[NSString stringWithFormat:@"[当前]%@",regeocode.POIName] : regeocode.POIName  subContent:regeocode.formattedAddress latitude:location.coordinate.latitude longitude:location.coordinate.longitude province:regeocode.province city:regeocode.city area:regeocode.district];
//                    firstModel.isInStoreRange = [[TXSJAddressEngine shareInstance] isInCurrentStoreRangeWithLatitude:firstModel.data.latitude longitude:firstModel.data.longitude];
//                    [strongSelf updateStoreData:regeocode.citycode];
//                }else{
//                   [strongSelf updateStoreData:@""];
//                }
//            }else {
//                [strongSelf updateStoreData:@""];
//            }
//            //当前地址  还是  不在范围内的 sectionTitle
//            strongSelf.sectionIndexTitles[0] = firstModel.isInStoreRange?strongSelf.isMapNeedShow?@"":SelectionLocationSectionUserLocation:TXSJLocationNotInRangeAndRecommand;
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

//-(void)updateStoreData:(NSString *)cityCode{
//    NSString *needCityCode = (cityCode&&cityCode.length>0)?cityCode:@"";
//    //门店数据判断
//    if(!TXSJCacheManager.storesModel || TXSJCacheManager.storesModel.poiAreaArr.count == 0 ){
//        //门店列表  定位失败调用
//        WEAKSELF(weakSelf);
//        [[[TXSJUserEngine getStoreList:needCityCode] execute:@0] subscribeNext:^(id  _Nullable x) {
//            STRONGSELF(strongSelf);
//            [strongSelf.refreshCommand execute:@0];
//        }];
//    }
//}

#pragma mark -- //附近检索
- (void)searchAround {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords            = self.keyword;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.radius              = 50000;
    request.requireExtension    = YES;
    //汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
    request.types               = TXSJLocationSearchType;
    request.page =   self.isSearching?self.searchPage:self.selectLocationPage;
    request.offset = MAMapViewSearchMaxCount;
    [self.search AMapPOIAroundSearch:request];
}

#pragma mark -- //关键字检索
-(void)searchPOIKey{
    //搜索模式下的 keywords为空字符串也是有数据的 处理一下
    if(!self.keyword || [self.keyword isEmptyString]){
        [self.searchingDataArr removeAllObjects];
        [self.refreshCommand execute:@0];
        return;
    }

    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = self.keyword;
    request.city                = TXSJLocationYiWuTitle;//现在就只有义乌
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    request.page =   self.isSearching?self.searchPage:self.selectLocationPage;
    [self.search AMapPOIKeywordsSearch:request];
}


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    NSMutableArray *searchArr = [NSMutableArray array];

    ///如果结果的key与当前的key不一样结果直接丢掉
    NSString *searchKey = @"";
    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]]) {
        AMapPOIKeywordsSearchRequest * re = (AMapPOIKeywordsSearchRequest *)request;
        searchKey = re.keywords;
    }else if([request isKindOfClass:[AMapPOIAroundSearchRequest class]]){
        AMapPOIAroundSearchRequest *re = (AMapPOIAroundSearchRequest *)request;
        searchKey = re.keywords;
    }

    if (![searchKey isEqualToString:self.keyword]) {
        NSLog(@"request.keywords = %@, self.keyword = %@", searchKey, self.keyword);
        ///假装错误，发送一个刷新的信号
        [self.errors sendNext:nil];
        return;
    }
    //解析response获取POI信息
    //通过 AMapPOISearchResponse 对象处理搜索结果
    for (AMapPOI *p in response.pois){
        @autoreleasepool{
            TXSJCommonModel *item = [[TXSJCommonModel alloc] initWithTitle:p.name subContent:[NSString stringWithFormat:@"%@%@%@%@",p.province,p.city,p.district,p.address]  latitude:p.location.latitude longitude:p.location.longitude province:p.province city:p.city area:p.district];
            TXSJCommonItemViewModel *itemVM = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":[NSNumber numberWithInt:TXSJCommonCellTypeDefault]}];
            itemVM.data = item;
            itemVM.isInStoreRange = [[TXSJAddressEngine shareInstance] isInCurrentStoreRangeWithLatitude:item.latitude longitude:item.longitude];

            //非搜索状态下 门店范围的数据 才添加 //搜索状态下 数据全部添加
            if((!self.isSearching&&itemVM.isInStoreRange) || self.isSearching){
                [searchArr addObject:itemVM];
            }
            //非搜索状态下  最多20个
            if(!self.isSearching && searchArr.count >= SelectionSearchLocationInRangeMaxCount){
                break;
            }
            NSLog(@"p.province----%@,p.city----%@,p.district----%@,p.address----%@",p.province,p.city,p.district,p.address);
        }
    }
    
    if(!self.isSearching){
        [self.nearestAddressArr  removeAllObjects];
        
        if(searchArr.count == 0){//非搜索状态下 附近地址检索结果为0的话 要移除附近地址这组
            if([self.sectionIndexTitles containsObject:SelectionLocationSectionNearestAddress]){
                [self.sectionIndexTitles removeObject:SelectionLocationSectionNearestAddress];
                [self.dataSource removeObjectAtIndex:[self indexForNearestAddressArrInDataSource]];
            }
        }else{
            [self.nearestAddressArr addObjectsFromArray:searchArr];
            //附近地址 这组 的 位置
            NSInteger sectionNearestAddressIndex = [self indexForNearestAddressArrInDataSource];
            //非搜索状态下 附近地址检索结果>0的话 要显示附近地址这组
            if([self.sectionIndexTitles containsObject:SelectionLocationSectionNearestAddress]){
                self.dataSource[sectionNearestAddressIndex] = self.nearestAddressArr;
            }else{
                [self.sectionIndexTitles insertObject:SelectionLocationSectionNearestAddress atIndex:sectionNearestAddressIndex];
                [self.dataSource insertObject:self.nearestAddressArr atIndex:sectionNearestAddressIndex];
            }
        }
        
    }else {
        if(self.searchPage==1){
            self.searchingDataArr = [NSMutableArray array];
        }
        //搜索模式下的 数据源
        [self.searchingDataArr addObjectsFromArray:searchArr];
    }
    
    [self.refreshCommand execute:@0];
}

//附近地址组 在数据源中 的 位置 （第几组）
-(NSInteger)indexForNearestAddressArrInDataSource{
    //有没有收货地址
    if([self.sectionIndexTitles containsObject:SelectionLocationSectionSecond]){
        return SelectionLocationSectionSecondIndex + 1;
    }else{   //没有  在收货地址的预留位置
        return SelectionLocationSectionSecondIndex;
    }
}


#pragma mark --tableview

- (NSInteger)numberOfSectionsInselectLocationTableView:(UITableView *)tableView {
    if (self.isSearching) {
        return 1;
    }
    return self.dataSource.count;
}

-(NSInteger)selectLocationTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.searchingDataArr.count;
    }else {
        
        return [self.dataSource[section] count];
    }
}

-(CGFloat)selectLocationTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //搜索状态
    if (self.isSearching) {
        if(self.isInStoreRangeCity || self.isNeedCloseOnlyYiWuHintView){
            return 0.01f;
        }else{
            return UIScale(45);
        }
    }
    //非搜索状态时  重置self.isNeedCloseOnlyYiWuHintView
    self.isNeedCloseOnlyYiWuHintView = NO;
    //最后的 更多地址分组  ~~!少条分割线 用1.f来代替了 ~~!这里判断条件要多点～～！ 毕竟map也是用这个viewmodel
    //UI设计  当前位置 sectionTitle可能没有
    if([self.sectionIndexTitles[section] isEmptyString]){
        return 1.f;
    }
    return UIScale(35);
}

-(UIView *)sectionHeaderForTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSearching) {
        if(self.isInStoreRangeCity || self.isNeedCloseOnlyYiWuHintView){
            return [[UIView alloc] initWithFrame:CGRectZero];
        }else{
            return [self onlyYiWuHintView];
        }
    }
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, UIScaleHeight(35))];
    sectionView.backgroundColor = UIColorHex(0xf7f7f7);
    UILabel *ttLab = [[UILabel alloc] initWithFrame:CGRectMake(TXSJCommonPadding, 0, kScreenWidth - TXSJCommonPadding, sectionView.height)];
    //用户当前地址不在配送范围内
    if([self.sectionIndexTitles[section] isEqualToString:TXSJLocationNotInRangeAndRecommand]&&section==0){
        ttLab.font = FONT_13;
        ttLab.textColor = kTitleColor6;
    }else{
        ttLab.font = FONT_12;
        ttLab.textColor = kContentGrayColor;
    }
    ttLab.text = self.sectionIndexTitles[section];
    [sectionView addSubview:ttLab];
    return sectionView;
}

- (TXSJCommomCell *)selectLocationTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIDStr = @"defaultCell";
    TXSJCommonCellType cellType;
    TXSJCommonItemViewModel *cellViewModel;
    
    if(self.isSearching) {
        cellViewModel = self.searchingDataArr[indexPath.row];
    }else {
        cellViewModel = self.dataSource[indexPath.section][indexPath.row];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0 &&!self.isSearching) {
        cellIDStr = @"userLocationCell";
        cellType = TXSJCommonCellTypeUserLocation;
        
    }else if([self isLastSectionLastRow:indexPath]&&!self.isSearching&&!self.isMapNeedShow){
        //最后那个   更多地址的  cell  地图样式没有这个cell
        cellIDStr = @"moreCell";
        cellType = TXSJCommonCellTypeValue2;
    }else if(cellViewModel.type == TXSJCommonCellTypeGoLogin){
        cellIDStr = @"GoLoginCell";
        cellType = TXSJCommonCellTypeGoLogin;
        
    }else {
        cellIDStr = @"defaultCell";
        cellType = TXSJCommonCellTypeDefault;
    }
    
    TXSJCommomCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIDStr];
    if (!userCell) {
        userCell = [[TXSJCommomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDStr withType:cellType];
    }
    
    
    //更多地址 不用变灰判断处理 ~~!地图样式没有更多地址cell
    if([self isLastSectionLastRow:indexPath] &&!self.isMapNeedShow) {
        cellViewModel.isInStoreRange = YES;
    }
    userCell.titleLab.textColor = cellViewModel.isInStoreRange?kTitleColor:ksubContentColor;
    userCell.subContentLab.textColor = cellViewModel.isInStoreRange?kContentColor:ksubContentColor;
    if(cellViewModel.data.titleStr && [cellViewModel.data.titleStr containsString:@"[当前]"] && cellViewModel.isInStoreRange) {
        NSMutableAttributedString *mss = [[NSMutableAttributedString alloc] initWithString:cellViewModel.data.titleStr];
        [mss addAttribute:NSForegroundColorAttributeName value:kTitleColor2 range:NSMakeRange(0, 4)];
        userCell.titleLab.attributedText = mss;
    }else {
        userCell.titleLab.text = cellViewModel.data.titleStr;
    }

    //最后组的  最后条cell 不隐藏 非搜索状态下
    if ([self isLastSectionLastRow:indexPath]) {
        [userCell hiddenOrShowLine : NO];
        userCell.isAllwidthSeparatorLine = YES;
    }else {
        //隐藏或者显示分割线
        [userCell hiddenOrShowLine:[self isLastRowInSection:indexPath]];
        userCell.isAllwidthSeparatorLine = NO;
    }
    
    userCell.viewModel = cellViewModel;
    
    return userCell;
    
}


//是否是最后一组的最后一条cell
-(BOOL)isLastSectionLastRow:(NSIndexPath *)indexPath{
    if(self.isSearching &&  (indexPath.row + 1) == [self.searchingDataArr count]) { //搜索模式
        return YES;
    }
    //普通模式
    if(!self.isSearching && ((indexPath.section + 1) == self.count) && (indexPath.row + 1) == [self.dataSource[indexPath.section] count]){
        return YES;
    }
    return NO;
}


//是否每组的是最后一条cell
-(BOOL)isLastRowInSection:(NSIndexPath *)indexPath{
    if(self.isSearching && (indexPath.row + 1) == [self.searchingDataArr count]) { //搜索模式就直接返回NO
        return YES;
    }else if(!self.isSearching && (indexPath.row + 1) == [self.dataSource[indexPath.section] count]){
        return YES;
    }
    return NO;
}

-(void)dealloc {
    NSLog(@"###WDF %s dealloc", __FUNCTION__);
}

#pragma mark -- properties
//-(RACCommand *)selectLocationCommand{
//    if (!_selectLocationCommand) {
//        WEAKSELF(weakSelf);
//        _selectLocationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * (id  input) {
//            STRONGSELF(strongSelf);
//            return [strongSelf locateAction];
//        }];
//    }
//    return _selectLocationCommand;
//}

////若检测用户在非义乌地区或无法成功获取用户位置， 弹出toast提示。
-(BOOL)isInStoreRangeCity{
    if(self.dataSource.count>0&&[self.dataSource[0] count]>0){
        TXSJCommonItemViewModel *locaitonModel = self.dataSource[0][0];
        //if(locaitonModel.type == TXSJCommonCellTypeUserLocation&&locaitonModel.isInStoreRange){
        //~~!特殊处理  判断是否是在义乌 ~~!义乌市 反地理编码 是 distruct   city是金华市
        if(locaitonModel.type == TXSJCommonCellTypeUserLocation&&([locaitonModel.data.city containsString:TXSJLocationYiWuTitle]||[locaitonModel.data.subContentStr containsString:[NSString stringWithFormat:@"%@市",TXSJLocationYiWuTitle]])){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

//四季严选目前只开放义乌，其他城市敬请期待
-(UIView *)onlyYiWuHintView{
    UIView *onlyYiWuHintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, UIScale(45))];
    UILabel *_onlyYiWuHintLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, onlyYiWuHintView.width, onlyYiWuHintView.height)];
    _onlyYiWuHintLab.text = TXSJLocationOnlyYiWuWithDouHao;
    _onlyYiWuHintLab.font = FONT_14;
    _onlyYiWuHintLab.textAlignment = NSTextAlignmentCenter;
    _onlyYiWuHintLab.textColor = kTitleColor6;
    _onlyYiWuHintLab.backgroundColor = UIColorHex(0xFFECE5); 
    [onlyYiWuHintView addSubview:_onlyYiWuHintLab];
    [_onlyYiWuHintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(onlyYiWuHintView);
    }];

    //关闭 点击区域大些
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"Addresssearch_close") forState:UIControlStateNormal];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -8)];
    [onlyYiWuHintView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(onlyYiWuHintView);
        make.width.mas_equalTo(UIScale(40));
    }];

    [onlyYiWuHintView setNeedsUpdateConstraints];
    [onlyYiWuHintView layoutIfNeeded];
    
     WEAKSELF(weakSelf);
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGSELF(strongSelf);
        strongSelf.isNeedCloseOnlyYiWuHintView = YES;
        [strongSelf.refreshCommand execute:@0];
    }];
    
    return onlyYiWuHintView;
}

-(NSMutableArray *)searchingDataArr{
    if (!_searchingDataArr) {
        _searchingDataArr = [NSMutableArray array];
    }
    return _searchingDataArr;
}

-(NSMutableArray *)sendAddressArr {
    if (!_sendAddressArr) {
        _sendAddressArr = [NSMutableArray array];
    }
    return _sendAddressArr;
}

-(NSMutableArray *)nearestAddressArr{
    if (!_nearestAddressArr) {
        _nearestAddressArr = [NSMutableArray array];
    }
    return _nearestAddressArr;
}

-(RACCommand *)refreshCommand {
    if (!_refreshCommand) {
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal empty];
        }];
    }
    return _refreshCommand;
}



@end
