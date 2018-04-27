//
//  TXSJSelectLocationViewModel.h
//  retail
//  TXSJSelectLocationVC  选择需要的位置数据
//  Created by 虞振兴 on 2017/8/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TXSJViewModel.h"
#import "TXSJTableViewModel.h"
#import "TXSJCommonModel.h"
#import "TXSJCommomCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@class  TXSJAddressModel;

#define TXSJLocationFailUpdate @"定位失败"
#define TXSJLocationFailGetPosition @"无法获取您的位置信息"
#define TXSJLocationFailRecommand @"推荐您使用地址搜索"
#define TXSJLocationNotInRange @"当前地址不在配送范围内"
#define TXSJLocationNotInRangeAndRecommand @"当前地址不在配送范围内，推荐您使用地址搜索"
#define TXSJLocationYiWuTitle @"义乌"
#define TXSJLocationOnlyYiWu  @"四季严选目前只开放义乌\n其他城市敬请期待"
#define TXSJLocationOnlyYiWuWithDouHao  @"四季严选目前只开放义乌，其他城市敬请期待"
//汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
#define  TXSJLocationSearchType @"商务住宅|公司企业|政府机构及社会团体|道路附属设施|地名地址信息";

#define  TXSJLocationDidSelectNoInRangeToast @"您选择的地址不在配送范围内"

#define SelectionSearchLocationInRangeMaxCount 20
#define MAMapViewSearchMaxCount 100

#define SelectionLocationSectionUserLocation  @"当前地址"
#define SelectionLocationSectionSecond @"我的收货地址"
//收货地址 的 位置
#define SelectionLocationSectionSecondIndex 1
#define SelectionLocationSectionNearestAddress @"附近地址"

@interface TXSJSelectLocationViewModel : TXSJTableViewModel  <AMapSearchDelegate>


@property (nonatomic,strong)  AMapLocationManager *locationManager;
@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic, strong) RACCommand *selectLocationCommand;

@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic, strong) RACCommand *refreshCommand;

@property (nonatomic, assign) BOOL isSearching;//搜索样式

@property (nonatomic,strong) NSMutableArray *searchingDataArr;//搜索模式下的 数据源

@property (nonatomic,strong) NSMutableArray *sendAddressArr;//收获地址列表

@property (nonatomic,strong) NSMutableArray *nearestAddressArr;//附近地址列表

@property (nonatomic,assign) NSInteger selectLocationPage;//地址分页索引
@property (nonatomic,assign) NSInteger searchPage;//搜索地址分页索引

@property (nonatomic,assign) BOOL isInStoreRangeCity;//若检测用户在非义乌地区或无法成功获取用户位置， 弹出toast提示。

@property (nonatomic,assign) BOOL isNeedCloseOnlyYiWuHintView;//四季严选目前只开放义乌，其他城市敬请期待 提示section是否关闭状态
/** map页面使用  目前就是 定位成功 位置前 需要加个 [当前]  当前位置分组标题有没有 */
@property (nonatomic,assign) BOOL isMapNeedShow;

-(void)urlForMyAddressList;

- (void)poiSearchAction;

//根据 收获地址列表  修改数据源
-(void)updateSendAddressArrWithNewAddress:(TXSJAddressModel *)addressModel;

- (NSInteger)numberOfSectionsInselectLocationTableView:(UITableView *)tableView;

-(NSInteger)selectLocationTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ;

-(CGFloat)selectLocationTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

-(UIView *)sectionHeaderForTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (TXSJCommomCell *)selectLocationTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ;

//四季严选目前只开放义乌，其他城市敬请期待
-(UIView *)onlyYiWuHintView;

//是否是最后一组的最后一条cell
-(BOOL)isLastSectionLastRow:(NSIndexPath *)indexPath; 
//是否每组的是最后一条cell
-(BOOL)isLastRowInSection:(NSIndexPath *)indexPath;

@end
