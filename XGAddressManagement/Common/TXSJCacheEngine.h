////
////  TXSJCacheEngine.h
////  retail
////
////  Created by wangdf on 2017/9/18.
////  Copyright © 2017年 apple. All rights reserved.
////  缓存一些信息
//
//#import <Foundation/Foundation.h>
//
//extern NSString * const TXSJCacheDialogId;
//extern NSString * const TXSJCacheDialogDate;
//
//@class TXSJUserModel;
//@class TXSJStoresModel;
//@class TXSJValueModel;
//@class TXSJCartsListItemsModel;
//@class TXSJShoppCartModel;
//@interface TXSJCacheEngine : NSObject
/////Instance
//+ (instancetype)shareInstance;
//
/////缓存manager
//@property (nonatomic, strong) YYCache *cacheManager;
/////用户信息,仅仅用来登录的时候默认填写用的
//@property (nonatomic, copy) NSString *phoneNumber;
//
//@property (nonatomic, readonly) NSInteger loginUserId;
//@property (nonatomic, strong, readonly) NSString *loginUserToken;
//
//@property (nonatomic, strong, readonly) NSString *userNameToShow;//手机号 用户名 或者 昵称 或者
//
/////登录用户信息
//@property (nonatomic, strong) TXSJUserModel *userModel;
//
/////门店信息
//@property (nonatomic , strong) TXSJStoresModel *storesModel;
//
////首页各屏列表
//@property (nonatomic, strong) NSMutableArray *homeIndexListArr;
////首页各屏列表V1.1版本
//@property (nonatomic, strong) NSMutableArray *homeIndexListArrForV11;
////首页菜单栏目列表
//@property (nonatomic, strong) NSMutableArray *homeMenuListArr;
//
/////缓存的已经弹过的弹框ids
//@property (nonatomic, copy, readonly) NSArray *cachedDialogIds;
/////保存已经弹框的id
//- (void)saveDialogId:(NSInteger)dialogId cacheDate:(NSString *)dateString;
//
////jpush seq number
//- (NSInteger)JPushSeqNumber;
//
////修改头像
//- (void)modifyPicture:(NSString *)avatar;
////修改个人信息
//- (void)updateUserInfo:(TXSJUserModel *)userModel;
/////添加本地商品
//- (void)addCartModel:(TXSJValueModel *)cartModel;
/////批量加入本地商品
//- (void)addCartArray:(NSArray *)cartArray;
/////更新本地所有的商品列表
//- (void)updateLocalCartListArr:(NSMutableArray *)cartListArr;
////获取购物车列表数据
//- (NSMutableArray *)getCartListData;
////删除更新数据
//- (void)removeDataIndex:(TXSJValueModel *)itemModel;
////获取首页各屏数据
//- (NSMutableArray *)getHomeIndexListArrData;
////获取首页各屏数据 V1.1版本
//- (NSMutableArray *)getHomeIndexListArrDataForV11;
////获取首页栏目数据
//- (NSMutableArray *)getHomeMenuListArrData;
////购物车缓存网络数据
//- (void)addShoppCartModel:(TXSJShoppCartModel *)model;
////获取购物车缓存网络数据
//- (TXSJShoppCartModel *)getShoppCartModel;
//@end

