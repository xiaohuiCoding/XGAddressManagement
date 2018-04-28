//
//  XGMapSelectLocationVC.m
//  XGAddressManagement
//
//  Created by xiaohui on 2018/4/27.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "XGMapSelectLocationVC.h"
#import "TXSJCommonSearchView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "TXSJRefreshGifHeader.h"

#define TXSJSelectedMapHeight (ceilf(kScreenWidth*200.f/375.f))

@interface XGMapSelectLocationVC () <MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,TXSJCommonSearchViewDelegate,AMapSearchDelegate>

@property (nonatomic,strong) TXSJCommonSearchView *searchTopView;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;

@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,strong)  AMapLocationManager *locationManager;
@property (nonatomic,strong) AMapSearchAPI *search;

@end

@implementation XGMapSelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"地图";
    [self setUpNavigationBar];
    [self setUpMapView];
    [self configLocationManager];
}

- (void)setUpNavigationBar {
    [self.view addSubview:self.searchTopView];
}

- (void)setUpMapView {
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.searchTopView.max_Y, kScreenWidth, TXSJSelectedMapHeight)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    //    //29.32f,120.06f 义乌市经纬度
    //    _mapView.centerCoordinate = CLLocationCoordinate2DMake(29.32f,120.06f);
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    //中心点大头针
    UIImage *pointImg = ImageNamed(@"positioning_add");
    UIImageView *centerPointIV = [[UIImageView alloc] initWithImage:pointImg];
    [self.mapView addSubview:centerPointIV];
    centerPointIV.frame = CGRectMake(0, (TXSJSelectedMapHeight - pointImg.size.height)/2, pointImg.size.width, pointImg.size.height);
    centerPointIV.centerX = self.mapView.centerX;
    
    //～～！不加这约束 莫名的 mapview下面空出一块空白  即便打印出的mapview的frame都是正常的
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.searchTopView.max_Y);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, TXSJSelectedMapHeight));
    }];
    
    
    //        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    //        r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    //        r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    //        r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    //        r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    //        r.lineWidth = 2;///精度圈 边线宽度，默认0
    //        r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
    //        r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
    //        r.image = [UIImage imageNamed:@"address_location"]; ///定位图标, 与蓝色原点互斥
    //        [self.mapView updateUserLocationRepresentation:r];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    
    //+ 按钮
    UIButton *increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [increaseBtn setImage:ImageNamed(@"increase") forState:UIControlStateNormal];
    increaseBtn.frame = CGRectMake(kScreenWidth - UIScale(53) - 10, UIScaleHeight(80), UIScale(53), UIScaleHeight(49));
    [self.mapView addSubview:increaseBtn];
    
    //- 按钮
    UIButton *decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [decreaseBtn setImage:ImageNamed(@"decrease") forState:UIControlStateNormal];
    decreaseBtn.frame = CGRectMake(increaseBtn.x, increaseBtn.max_Y + 0 , increaseBtn.width,increaseBtn.height);
    [self.mapView addSubview:decreaseBtn];
    
    WEAKSELF(weakSelf);
    [[increaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGSELF(strongSelf);
        strongSelf.mapView.zoomLevel++;
    }];
    
    [[decreaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGSELF(strongSelf);
        strongSelf.mapView.zoomLevel--;
    }];
    
    [self.view addSubview:self.tableView];
    
    [self mapDrawAction];
}

/** 画多边形区域 */
-(void)mapDrawAction{
    [_mapView removeOverlays:_mapView.overlays];
    
    //电子围栏数据
    NSArray *array = @[@{@"latitude":@30.230907,@"longitude":@120.196136},
                       @{@"latitude":@30.230684,@"longitude":@120.198733},
                       @{@"latitude":@30.229359,@"longitude":@120.198572},
                       @{@"latitude":@30.227996,@"longitude":@120.197628},
                       @{@"latitude":@29.245261,@"longitude":@120.210267},
                       @{@"latitude":@29.187790,@"longitude":@119.897832},
                       @{@"latitude":@30.227940,@"longitude":@120.195139},
                       @{@"latitude":@30.228830,@"longitude":@120.193712},
                       @{@"latitude":@30.230193,@"longitude":@120.193443},
                       @{@"latitude":@30.230823,@"longitude":@120.194484},
                       @{@"latitude":@30.243874,@"longitude":@120.197231},
                       ];
    
    //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(11 * sizeof(CLLocationCoordinate2D));
    for (NSInteger i = 0; i< 11; i++) {
        coords[i].latitude = [array[i][@"latitude"] doubleValue];
        coords[i].longitude = [array[i][@"longitude"] doubleValue];
    }
    //构造多边形
    MAPolygon *pol = [MAPolygon polygonWithCoordinates:coords count:11];
    //在地图上添加圆
    [_mapView addOverlay: pol];
    //    [_mapView setVisibleMapRect:pol.boundingMapRect edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) animated:YES];
    //    free(coords);
    CLLocationCoordinate2D touchMapCoordinate = pol.coordinate;
    MAPointAnnotation *storeAnnotation = [[MAPointAnnotation alloc] init];
    storeAnnotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:storeAnnotation];
    
    [_tableView reloadData];
}

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:8];
    
    [self.locationManager setReGeocodeTimeout:6];
    //检索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)searchAction {
//    [self showLoading];
    [self poiSearchAction];//检索
}

- (void)poiSearchAction {
//    if(self.isSearching){
        [self searchPOIKey];
//    }else{
        [self searchAround];
//    }
}

-(void)searchPOIKey{
//    //搜索模式下的 keywords为空字符串也是有数据的 处理一下
//    if(!self.keyword || [self.keyword isEmptyString]){
//        [self.searchingDataArr removeAllObjects];
//        [self.refreshCommand execute:@0];
//        return;
//    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = @"义乌";
    request.city                = @"义乌";//现在就只有义乌
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    request.page =   1;
    [self.search AMapPOIKeywordsSearch:request];
}

- (void)searchAround {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords            = @"123";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.radius              = 50000;
    request.requireExtension    = YES;
    //汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
    request.types = @"商务住宅|公司企业|政府机构及社会团体|道路附属设施|地名地址信息";
    request.page = 1;
    request.offset = 100;
    [self.search AMapPOIAroundSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    NSMutableArray *searchArr = [NSMutableArray array];
    
    ///如果结果的key与当前的key不一样结果直接丢掉
    NSString *searchKey = self.keyword;
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
//        [self.errors sendNext:nil];
        return;
    }
    //解析response获取POI信息
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    for (AMapPOI *p in response.pois){
//        @autoreleasepool{
//            TXSJCommonModel *item = [[TXSJCommonModel alloc] initWithTitle:p.name subContent:[NSString stringWithFormat:@"%@%@%@%@",p.province,p.city,p.district,p.address]  latitude:p.location.latitude longitude:p.location.longitude province:p.province city:p.city area:p.district];
//            TXSJCommonItemViewModel *itemVM = [[TXSJCommonItemViewModel alloc] initWithParams:@{@"type":[NSNumber numberWithInt:TXSJCommonCellTypeDefault]}];
//            itemVM.data = item;
//            itemVM.isInStoreRange = [[TXSJAddressEngine shareInstance] isInCurrentStoreRangeWithLatitude:item.latitude longitude:item.longitude];
//
//            //非搜索状态下 门店范围的数据 才添加 //搜索状态下 数据全部添加
//            if((!self.isSearching&&itemVM.isInStoreRange) || self.isSearching){
//                [searchArr addObject:itemVM];
//            }
//            //非搜索状态下  最多20个
//            if(!self.isSearching && searchArr.count >= SelectionSearchLocationInRangeMaxCount){
//                break;
//            }
//            NSLog(@"p.province----%@,p.city----%@,p.district----%@,p.address----%@",p.province,p.city,p.district,p.address);
//        }
//    }
//
//    if(!self.isSearching){
//        [self.nearestAddressArr  removeAllObjects];
//
//        if(searchArr.count == 0){//非搜索状态下 附近地址检索结果为0的话 要移除附近地址这组
//            if([self.sectionIndexTitles containsObject:SelectionLocationSectionNearestAddress]){
//                [self.sectionIndexTitles removeObject:SelectionLocationSectionNearestAddress];
//                [self.dataSource removeObjectAtIndex:[self indexForNearestAddressArrInDataSource]];
//            }
//        }else{
//            [self.nearestAddressArr addObjectsFromArray:searchArr];
//            //附近地址 这组 的 位置
//            NSInteger sectionNearestAddressIndex = [self indexForNearestAddressArrInDataSource];
//            //非搜索状态下 附近地址检索结果>0的话 要显示附近地址这组
//            if([self.sectionIndexTitles containsObject:SelectionLocationSectionNearestAddress]){
//                self.dataSource[sectionNearestAddressIndex] = self.nearestAddressArr;
//            }else{
//                [self.sectionIndexTitles insertObject:SelectionLocationSectionNearestAddress atIndex:sectionNearestAddressIndex];
//                [self.dataSource insertObject:self.nearestAddressArr atIndex:sectionNearestAddressIndex];
//            }
//        }
//
//    }else {
//        if(self.searchPage==1){
//            self.searchingDataArr = [NSMutableArray array];
//        }
//        //搜索模式下的 数据源
//        [self.searchingDataArr addObjectsFromArray:searchArr];
//    }
//
//    [self.refreshCommand execute:@0];
}

//附近地址组 在数据源中 的 位置 （第几组）
-(NSInteger)indexForNearestAddressArrInDataSource{
//    //有没有收货地址
//    if([self.sectionIndexTitles containsObject:SelectionLocationSectionSecond]){
//        return SelectionLocationSectionSecondIndex + 1;
//    }else{   //没有  在收货地址的预留位置
//        return SelectionLocationSectionSecondIndex;
//    }
    return 0;
}

/**第一页请求数据～～！不包含 搜索的 ， 非搜索状态 只请求第一页数据 */
//- (void)searchActionForFirstPage {
//    if (self.viewModel.isSearching) {
//        self.viewModel.searchPage = 1;
//    }
//    [self searchAction];
//}

#pragma mark --  MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    self.latitude = self.mapView.centerCoordinate.latitude;
    self.longitude = self.mapView.centerCoordinate.longitude;
    
    [self searchAction];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    //注意：5.1.0后由于定位蓝点增加了平滑移动功能，如果在开启定位的情况先添加annotation，需要在此回调方法中判断annotation是否为MAUserLocation，从而返回正确的View
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    MAAnnotationView *newAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.annotation = annotation;
    newAnnotationView.image = [UIImage imageNamed:@"positioning_shop"];   //把大头针换成别的图片 门店图片
    return newAnnotationView;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    //    if ([overlay isKindOfClass:[MAPolygon class]])
    //    {
    MAPolygonRenderer *pol = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
    pol.lineWidth = 1.f;
    pol.strokeColor = kTitleColor2;
    pol.fillColor = [UIColor colorWithHexValue:0xccaa66 alpha:0.2];
    pol.lineDash = NO;//YES表示虚线绘制，NO表示实线绘制
    return pol;
    //    }
    //    else if ([overlay isKindOfClass:[MAPolyline class]])
    //    {
    //        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
    //        polylineRenderer.lineWidth = 6.f;
    //        polylineRenderer.strokeColor = colorWithHexString(@"00acef");
    //        return polylineRenderer;
    //    }
    //    return nil;
}

#pragma mark -- scrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



- (TXSJCommonSearchView *)searchTopView {
    if (!_searchTopView) {
        _searchTopView = [[TXSJCommonSearchView alloc] initWithFrame:CGRectMake(0, 20 + (isiPhoneX?10:0), kScreenWidth, 44) withMaxLength:40 withRightBtnTitle:@""];
        _searchTopView.isTimeToSearch = YES;
        _searchTopView.delegate = self;
        _searchTopView.leftBtnTitle = @"义乌";
        UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, _searchTopView.height - 0.5f, _searchTopView.width, 0.5f)];
        seperatorLine.backgroundColor = kLineColor;
        [_searchTopView addSubview:seperatorLine];
    }
    return _searchTopView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.mapView.max_Y, kScreenWidth, (kScreenHeight - self.mapView.max_Y)) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        WEAKSELF(weakSelf);
//        _tableView.mj_header = [TXSJRefreshGifHeader headerWithRefreshingBlock:^{
//            STRONGSELF(strongSelf);
//            //搜索状态
//            [strongSelf searchActionForFirstPage];
//        }];
    }
    return _tableView;
}

- (void)dealloc {
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    NSLog(@"###WDF %s dealloc", __FUNCTION__);
}

@end
