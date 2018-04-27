//
//  TXSJMapSelectLocationVC.m
//  retail
//
//  Created by 虞振兴 on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJMapSelectLocationVC.h"
#import "TXSJCommonSearchView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "TXSJCommomCell.h"
#import "TXSJLocalPathUtils.h"
//#import "TXSJAddNewAddressVC.h"
#import "TXSJRefreshGifHeader.h"
#import "TXSJStoresModel.h"
//#import "TXSJLoginVC.h"


#define TXSJSelectedMapHeight (ceilf(kScreenWidth*200.f/375.f))

@interface TXSJMapSelectLocationVC ()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,TXSJCommonSearchViewDelegate>
@property (nonatomic, strong) TXSJMapLocationVM *viewModel;
@property (nonatomic,strong) TXSJCommonSearchView *searchTopView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) MAMapView *mapView;

@end

@implementation TXSJMapSelectLocationVC
@dynamic viewModel;

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

///隐藏navBar
- (BOOL)needNavigationBarHidden {
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
//  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self initNavigationItem];
  
  [self setDefaultImg:ImageNamed(@"no_address") defaultTitle:@"没有搜索到您当前的地址" defaultBtnTitle:nil];
}

//- (void)bindViewModel {
//  //先执行一次
//  [self updateLocationAction];
//  
//  WEAKSELF(weakSelf);
//  [[self.viewModel.refreshCommand executionSignals] subscribeNext:^(id  _Nullable x) {
//    STRONGSELF(strongSelf);
//    [strongSelf showMJFoor];
//    [strongSelf.tableView.mj_header endRefreshing];
//    [strongSelf.tableView reloadData];
//    [strongSelf showNodataInView:strongSelf.tableView isShow:strongSelf.viewModel.isSearching?strongSelf.viewModel.searchingDataArr.count==0: strongSelf.viewModel.dataSource.count==0];
//    [strongSelf hiddenLoading];
//  }];
//  
//  [[[RACObserve(self.searchTopView.searchTempBtn, hidden) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *x) {
//    STRONGSELF(strongSelf);
//    strongSelf.viewModel.isSearching = x.boolValue;
//    strongSelf.mapView.hidden = x.boolValue;
//    [strongSelf.tableView reloadData];
//    [strongSelf hiddenLoading];
//    
//    //若检测用户在非义乌地区或无法成功获取用户位置， 弹出toast提示。
//    if(!strongSelf.viewModel.isInStoreRangeCity&&strongSelf.viewModel.isSearching){
//      //城市点击事件  义乌
//      [strongSelf toastMessageTitle:TXSJLocationOnlyYiWu];
//    }
//    
//    [strongSelf showMJFoor];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//      strongSelf.mapView.size = CGSizeMake(kScreenWidth, x.boolValue?0:TXSJSelectedMapHeight);
//      strongSelf.tableView.frame = CGRectMake(0, x.boolValue?64:strongSelf.mapView.max_Y, kScreenWidth ,(kScreenHeight - strongSelf.mapView.max_Y));
//    } completion:^(BOOL finished) {
//      [strongSelf showNodataInView:strongSelf.tableView isShow:strongSelf.viewModel.isSearching?strongSelf.viewModel.searchingDataArr.count==0: strongSelf.viewModel.dataSource.count==0];
//    }];
//  }];
//  
//  //搜索框 左边返回箭头点击事件
//  [[self rac_signalForSelector:@selector(commonSearchLeftButtonClicked:) fromProtocol:@protocol(TXSJCommonSearchViewDelegate) ] subscribeNext:^(RACTuple * _Nullable x) {
//    STRONGSELF(strongSelf);
//    BOOL leftButtonClicked = [x.first boolValue];
//    if(leftButtonClicked){
//      [strongSelf backAction:nil];
//    }else{  //城市点击事件  义乌
//      [strongSelf toastMessageTitle:TXSJLocationOnlyYiWu];
//    }
//  }];
//  
//  //搜索框 右边  新增地址点击事件
//  [[self rac_signalForSelector:@selector(rightActionBtnClicked:) fromProtocol:@protocol(TXSJCommonSearchViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
//    STRONGSELF(strongSelf);
//    if([x.first boolValue]) {
//      strongSelf.searchTopView.searchTempBtn.hidden = NO;
//      strongSelf.searchTopView.searchTF.text = @"";
//      strongSelf.viewModel.keyword = @"";
//      [strongSelf.viewModel.searchingDataArr removeAllObjects];
//      if(!strongSelf.viewModel.isSearching){ //清空搜索数据
//        strongSelf.viewModel.searchPage = 1;
//      }
//      [strongSelf.tableView reloadData];
//    }else {
////      BOOL isLogin = [TXSJCacheManager loginUserToken].length > 0;
////      if(!isLogin){
////        [TXSJLoginVC login:strongSelf.navigationController success:^{
////          STRONGSELF(strongSelf);
////          [strongSelf prepareAddNewAddres];
////        }];
////        return ;
////      }
////
////      [strongSelf prepareAddNewAddres];
//    }
//  }];
//  
//  //搜索框 输入内容回调  进行搜索
//  [[self rac_signalForSelector:@selector(searchTextFieldInputAction:) fromProtocol:@protocol(TXSJCommonSearchViewDelegate) ] subscribeNext:^(RACTuple * _Nullable x) {
//    STRONGSELF(strongSelf);
//    strongSelf.viewModel.keyword = (NSString *)x.first;
//    strongSelf.viewModel.isSearching = YES;
//    [strongSelf searchActionForFirstPage];
//  }];
//  
//  
//  [self.viewModel.errors subscribeNext:^(id  _Nullable x) {
//    STRONGSELF(strongSelf);
//    [strongSelf hiddenLoading];
//  }];
//}


-(void)showMJFoor{
  if(!self.tableView.mj_footer && self.viewModel.isSearching){
    WEAKSELF(weakSelf);
    self.tableView.mj_footer = [TXSJRefreshFooter footerWithRefreshingBlock:^{
      STRONGSELF(strongSelf);
      //非搜索状态～～就是普通的选择地址了 只请求第一页数据    搜索状态分页请求
      if (strongSelf.viewModel.isSearching) {
        strongSelf.viewModel.searchPage ++;
      }
      [strongSelf searchAction];
    }];
  }else{
    self.tableView.mj_footer = nil;
  }
  //
  if(self.tableView.mj_footer){
    [self.tableView.mj_footer endRefreshing];
  }
}

- (void)setUpSubviews {
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
  
//  [self.view addSubview:self.tableView];
  
  
  [self mapDrawAction];
  
}

-(void)initNavigationItem {
  [self.view addSubview:self.searchTopView];
}

#pragma mark -- action
#pragma mark -- 检索数据
- (void)searchAction {
  [self showLoading];
  [self.viewModel poiSearchAction];//检索
}

/**第一页请求数据～～！不包含 搜索的 ， 非搜索状态 只请求第一页数据 */
- (void)searchActionForFirstPage {
  if (self.viewModel.isSearching) {
    self.viewModel.searchPage = 1;
  }
  [self searchAction];
}

///添加新地址
- (void)prepareAddNewAddres {
//  //跳转新增地址页面  这里应该是直接回调到首页去了
//  TXSJAddNewAddressVC *vc = [[TXSJAddNewAddressVC alloc] initWithViewModel:[[TXSJAddNewAddressVM alloc] initWithParams:@{@"model":[[TXSJAddressModel alloc] init]}]];
//  [self.navigationController pushViewController:vc animated:YES];
//  WEAKSELF(weakSelf);
//  vc.finishBlock = ^(TXSJAddressModel *model, BOOL isAddNewAddress) {
//    STRONGSELF(strongSelf);
//    if([strongSelf.delegate respondsToSelector:@selector(getLocationItemData:)]) {
//      TXSJPOIDataModel *poiData = [TXSJPOIDataModel modelWithJSON:model.poidata];
//      TXSJCommonModel *tempModel = [[TXSJCommonModel alloc] initWithTitle:poiData.poiName subContent:model.infoAddress latitude:poiData.latitude longitude:poiData.longitude province:model.province city:model.city area:model.area];
//      tempModel.poiName = poiData.poiName;
//      //点击事件
//      [strongSelf.delegate getLocationItemData:tempModel];
//      [strongSelf.navigationController popViewControllerAnimated:YES];
//    }
//  };
}

/** 定位 */
- (void)updateLocationAction {
  WEAKSELF(weakSelf);
  //定位  第一条数据
  [[self.viewModel.selectLocationCommand execute:nil] subscribeNext:^(TXSJCommonItemViewModel  *firstVM) {
    STRONGSELF(strongSelf);
    [strongSelf.tableView reloadData];
    if(firstVM.data.titleStr && [firstVM.data.titleStr isEqualToString:TXSJLocationFailUpdate]){
      [strongSelf toastMessageTitle:TXSJLocationFailUpdate];
      return ;
    }
    CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake([TXSJLocalPathUtils shareInstance].latitude, [TXSJLocalPathUtils shareInstance].longitude);
    
    strongSelf.viewModel.latitude = touchMapCoordinate.latitude;
    strongSelf.viewModel.longitude = touchMapCoordinate.longitude;
    [strongSelf.mapView setCenterCoordinate:touchMapCoordinate animated:YES];
    
    //        [strongSelf searchAction];
  }];
  
}


/** 画多边形区域 */
-(void)mapDrawAction{
//  [_mapView removeOverlays:_mapView.overlays];
//  //添加路径Polyline
//  CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(TXSJCacheManager.storesModel.poiAreaArr.count * sizeof(CLLocationCoordinate2D));
//  for (int i = 0; i < TXSJCacheManager.storesModel.poiAreaArr.count; i++){
//    TXSJPOIDataModel *poiModel = TXSJCacheManager.storesModel.poiAreaArr[i];
//    coords[i].latitude = poiModel.latitude;
//    coords[i].longitude = poiModel.longitude;
//  }
//  //构造多边形
//  MAPolygon *pol = [MAPolygon polygonWithCoordinates:coords count:TXSJCacheManager.storesModel.poiAreaArr.count];
//  //在地图上添加圆
//  [_mapView addOverlay: pol];
//  //    [_mapView setVisibleMapRect:pol.boundingMapRect edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) animated:YES];
//  //    free(coords);
//  CLLocationCoordinate2D touchMapCoordinate = pol.coordinate;
//  MAPointAnnotation *storeAnnotation = [[MAPointAnnotation alloc] init];
//  storeAnnotation.coordinate = touchMapCoordinate;
//  [self.mapView addAnnotation:storeAnnotation];
//
//  [_tableView reloadData];
}


#pragma mark --  MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
  
  self.viewModel.latitude = self.mapView.centerCoordinate.latitude;
  self.viewModel.longitude = self.mapView.centerCoordinate.longitude;
  
//  [self searchAction];
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


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.viewModel numberOfSectionsInselectLocationTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.viewModel selectLocationTableView:tableView numberOfRowsInSection:section];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.viewModel.sectionIndexTitles[section];
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return [self.viewModel sectionHeaderForTableView:tableView viewForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TXSJCommomCell *userCell = [self.viewModel selectLocationTableView:tableView cellForRowAtIndexPath:indexPath];
  WEAKSELF(weakSelf);
  [[userCell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    STRONGSELF(strongSelf);
    [strongSelf updateLocationAction];
  }];
  return userCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //点击事件
  TXSJCommonItemViewModel *itemVM = nil;
  if(self.viewModel.isSearching) {
    itemVM = self.viewModel.searchingDataArr[indexPath.row];
  }else {
    itemVM = self.viewModel.dataSource[indexPath.section][indexPath.row];
  }
  //非配送范围内禁止选择
  if(!itemVM.isInStoreRange) {
    [self toastMessageTitle:TXSJLocationDidSelectNoInRangeToast toastImageStr:nil];
    return;
  }
  //～～！有个特殊的  无法获取您的位置信息
  if(itemVM.type == TXSJCommonCellTypeUserLocation && [itemVM.data.titleStr isEqualToString:TXSJLocationFailGetPosition]){
    return;
  }
  
  [self.delegate getLocationItemData:itemVM.data];
  [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return [self.viewModel selectLocationTableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
}

#pragma mark -- properties
-(TXSJCommonSearchView *)searchTopView {
  if (!_searchTopView) {
    _searchTopView = [[TXSJCommonSearchView alloc] initWithFrame:CGRectMake(0, 20 + (isiPhoneX?10:0), kScreenWidth, 44) withMaxLength:40 withRightBtnTitle:self.viewModel.rightTopTitleStr];
    _searchTopView.isTimeToSearch = YES;
    _searchTopView.delegate = self;
    _searchTopView.leftBtnTitle = TXSJLocationYiWuTitle;
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, _searchTopView.height - 0.5f, _searchTopView.width, 0.5f)];
    seperatorLine.backgroundColor = kLineColor;
    [_searchTopView addSubview:seperatorLine];
  }
  return _searchTopView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.mapView.max_Y, kScreenWidth, (kScreenHeight - self.mapView.max_Y)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0.01f;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WEAKSELF(weakSelf);
    _tableView.mj_header = [TXSJRefreshGifHeader headerWithRefreshingBlock:^{
      STRONGSELF(strongSelf);
      //搜索状态
      [strongSelf searchActionForFirstPage];
    }];
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


-(BOOL)showShoppintCartButton{
  return NO;
}

@end
